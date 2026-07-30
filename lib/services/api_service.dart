import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // GUNAKAN 10.0.2.2 UNTUK EMULATOR ANDROID (MERUJUK KE LOCALHOST KOMPUTER)
  // GANTI KE IP KOMPUTER ANDA JIKA MENGGUNAKAN HP FISIK (MISAL: 192.168.1.5)
  // GANTI KE DOMAIN JIKA SUDAH HOSTING (MISAL: https://api.sukabumi.go.id)
  // static const String baseUrl = 'http://10.0.2.2:8001/api'; // LOCAL
  static const String baseUrl = 'https://api.sukabumikota.go.id/api'; // PRODUCTION

  // SET KE 'true' JIKA SERVER MATI AGAR APLIKASI TETAP BISA DIJALANKAN DENGAN DATA PALSU
  static const bool useMockData = false;

  static Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // HTTP GET - Terpusat
  static Future<http.Response> get(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.get(url, headers: _headers(token)).timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      // Jika error (server mati/timeout), kirim response error yang sopan
      return http.Response(jsonEncode({'message': 'Tidak dapat terhubung ke server: $e'}), 503);
    }
  }

  // HTTP POST - Terpusat
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.post(
        url,
        headers: _headers(token),
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      return http.Response(jsonEncode({'message': 'Gagal mengirim data ke server: $e'}), 503);
    }
  }

  // MULTIPART POST - Untuk upload file (Gambar/KTP dll)
  static Future<http.Response> postMultipart(
    String endpoint,
    Map<String, String> fields,
    Map<String, String> files,
    {String? token}
  ) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final request = http.MultipartRequest('POST', url);

      request.headers.addAll(_headers(token));
      request.fields.addAll(fields);

      for (var entry in files.entries) {
        if (entry.value.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
        }
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      return http.Response(jsonEncode({'message': 'Gagal upload ke server: $e'}), 503);
    }
  }
}
