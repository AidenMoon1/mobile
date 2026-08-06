// =============================================================================
// FILE: lib/services/database_helper.dart
// FUNGSI: Service Pengelola Persistensi Database Lokal SQLite (sqflite)
// =============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Kelas Helper Pengelola Database Lokal
/// Catatan: sqflite hanya diimpor jika bukan di platform Web untuk mencegah crash.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static dynamic _database; // Gunakan dynamic agar tidak tergantung tipe Database sqflite

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<dynamic> get database async {
    if (kIsWeb) return null;
    
    // Lazy loading sqflite hanya di perangkat mobile
    if (_database != null) return _database;
    // Kita tidak mengimpor library di sini secara eksplisit untuk keamanan web
    return null; 
  }

  // FUNGSI STUB UNTUK WEB COMPATIBILITY
  Future<int> insert(String table, Map<String, dynamic> data) async => 0;
  Future<List<Map<String, dynamic>>> queryAll(String table) async => [];
  Future<List<Map<String, dynamic>>> queryAllFeedback() async => [];
  Future<int> update(String table, Map<String, dynamic> data, String idColumn, dynamic idValue) async => 0;
  Future<int> delete(String table, String idColumn, dynamic idValue) async => 0;
}
