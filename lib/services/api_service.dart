import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiService {
  // Alamat Ngrok (Publik) - Ganti jika ngrok direstart
  static const String _ngrokUrl = 'https://nectar-refinish-console.ngrok-free.dev';
  static const String _port = '8001';

  // Otomatis memilih localhost jika di browser, atau Ngrok jika di HP
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$_port/api';
    }
    return '$_ngrokUrl/api';
  }

  // SET KE 'true' JIKA SERVER MATI AGAR APLIKASI TETAP BISA DIJALANKAN DENGAN DATA PALSU
  static const bool useMockData = false;

  static Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true', // Untuk bypass halaman peringatan ngrok
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // HTTP GET
  static Future<http.Response> get(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.get(url, headers: _headers(token)).timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      return http.Response(jsonEncode({'message': 'Tidak dapat terhubung ke server: $e'}), 503);
    }
  }

  // HTTP POST
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

  // HTTP DELETE
  static Future<http.Response> delete(String endpoint, {String? token}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.delete(
        url,
        headers: _headers(token),
      ).timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      return http.Response(jsonEncode({'message': 'Gagal menghapus data di server: $e'}), 503);
    }
  }

  // MULTIPART POST
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
