import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://nectar-refinish-console.ngrok-free.dev/api';

  // SET KE 'true' UNTUK MODE OFFLINE/SIMULASI TANPA SERVER LARAVEL
  static const bool useMockData = false;

  // In-memory list untuk simulasi riwayat pengaduan warga
  static final List<Map<String, dynamic>> _mockReports = [
    {
      'id': 101,
      'title': 'Jalan Rusak di Cikole',
      'category': 'Infrastruktur',
      'description': 'Ada lubang besar di jalan utama Cikole, sangat membahayakan pengendara motor saat malam hari.',
      'status': 'Diproses',
      'created_at': DateTime.now().subtract(const Duration(days: 3)).toString(),
    },
    {
      'id': 102,
      'title': 'Sampah Menumpuk di Pasar Pelita',
      'category': 'Kebersihan',
      'description': 'Sampah menumpuk di dekat gerbang masuk pasar dan menimbulkan aroma menyengat.',
      'status': 'Menunggu',
      'created_at': DateTime.now().subtract(const Duration(days: 1)).toString(),
    }
  ];

  static Map<String, String> _headers(String? token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // HTTP GET
  static Future<http.Response> get(String endpoint, {String? token}) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));

      if (endpoint == 'berita') {
        final mockNewsList = [
          {
            'id': 1,
            'title': 'Diskominfo Meluncurkan Aplikasi Baru',
            'content': 'Dalam rangka meningkatkan pelayanan publik, Dinas Komunikasi dan Informatika Sukabumi meluncurkan aplikasi pelayanan terpadu hari ini.',
            'image_url': null,
            'created_at': DateTime.now().toString(),
          },
          {
            'id': 2,
            'title': 'Sosialisasi Keamanan Informasi',
            'content': 'Diskominfo Sukabumi menyelenggarakan sosialisasi mengenai pentingnya menjaga keamanan data pribadi dan informasi penting di era digital.',
            'image_url': null,
            'created_at': DateTime.now().subtract(const Duration(days: 1)).toString(),
          },
          {
            'id': 3,
            'title': 'Pelatihan Literasi Digital Masyarakat',
            'content': 'Sebanyak 100 peserta dari berbagai kalangan mengikuti pelatihan literasi digital di Sukabumi guna meningkatkan kecerdasan bermedia sosial.',
            'image_url': null,
            'created_at': DateTime.now().subtract(const Duration(days: 2)).toString(),
          }
        ];
        return http.Response(jsonEncode(mockNewsList), 200);
      }

      if (endpoint == 'aduan') {
        // Return daftar pengaduan warga
        return http.Response(jsonEncode(_mockReports), 200);
      }
    }

    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(url, headers: _headers(token));
  }

  // HTTP POST
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));

      if (endpoint == 'aduan') {
        // Masukkan data baru ke list
        final newReport = {
          'id': _mockReports.length + 101,
          'title': data['title'] ?? 'Laporan Tanpa Judul',
          'category': data['category'] ?? 'Umum',
          'description': data['description'] ?? '',
          'status': 'Menunggu',
          'created_at': DateTime.now().toString(),
        };
        _mockReports.insert(0, newReport); // Masukkan di baris paling atas
        return http.Response(jsonEncode({'status': 'success', 'data': newReport}), 200);
      }

      return http.Response(jsonEncode({'status': 'success', 'message': 'Simulasi berhasil'}), 200);
    }

    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(data),
    );
  }

  // HTTP POST Multipart (untuk upload form-data beserta file)
  static Future<http.Response> postMultipart(
    String endpoint,
    Map<String, String> fields,
    Map<String, String> files,
    {String? token}
  ) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 1000));
      return http.Response(jsonEncode({
        'status': 'success',
        'message': 'Simulasi berhasil dikirim!'
      }), 200);
    }

    final url = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', url);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Accept'] = 'application/json';

    // Tambahkan fields teks
    request.fields.addAll(fields);

    // Tambahkan berkas gambar/file
    for (var entry in files.entries) {
      if (entry.value.isNotEmpty) {
        try {
          request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
        } catch (_) {
          // Abaikan error upload file di platform web agar tidak crash
        }
      }
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
