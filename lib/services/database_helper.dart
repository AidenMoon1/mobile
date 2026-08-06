// =============================================================================
// FILE: lib/services/database_helper.dart
// FUNGSI: Service Pengelola Persistensi Database Lokal SQLite (sqflite)
// PATTERN: Singleton Pattern & SQLite Storage Architecture
// =============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Kelas Helper Pengelola Database Lokal SQLite `sukabumi_one_access.db`
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // FUNGSI 1: Getter Asinkronous Database (Aman untuk Perangkat Android, iOS, maupun Browser Web)
  Future<Database?> get database async {
    // Catatan: Browser Web menggunakan LocalMemory / Service Fallback karena tidak mendukung sqflite C-binary
    if (kIsWeb) return null;
    
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // FUNGSI 2: Inisialisasi & Pembukaan Berkas Database SQLite di Storage HP
  Future<Database?> _initDatabase() async {
    if (kIsWeb) return null;
    
    String path = join(await getDatabasesPath(), 'sukabumi_one_access.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // FUNGSI 3: Skema Pembuatan Tabel Pertama Kali (Notifications & Feedback)
  Future _onCreate(Database db, int version) async {
    // 1. Tabel Persistensi Notifikasi
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        timestamp TEXT,
        category TEXT,
        isRead INTEGER
      )
    ''');

    // 2. Tabel Persistensi Ulasan Feedback
    await db.execute('''
      CREATE TABLE feedback (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rating INTEGER,
        factor TEXT,
        reason TEXT,
        date TEXT
      )
    ''');
  }

  // FUNGSI 4: Generic Insert Data ke Tabel SQLite
  Future<int> insert(String table, Map<String, dynamic> data) async {
    if (kIsWeb) return 0;
    Database? db = await database;
    if (db == null) return 0;
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // FUNGSI 5: Generic Query Ambil Seluruh Baris Data (Sorting Terbaru)
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    if (kIsWeb) return [];
    Database? db = await database;
    if (db == null) return [];
    return await db.query(table, orderBy: 'timestamp DESC');
  }
  
  // FUNGSI 6: Query Khusus Tabel Feedback
  Future<List<Map<String, dynamic>>> queryAllFeedback() async {
    if (kIsWeb) return [];
    Database? db = await database;
    if (db == null) return [];
    return await db.query('feedback', orderBy: 'date DESC');
  }

  // FUNGSI 7: Generic Update Data di Tabel SQLite
  Future<int> update(String table, Map<String, dynamic> data, String idColumn, dynamic idValue) async {
    if (kIsWeb) return 0;
    Database? db = await database;
    if (db == null) return 0;
    return await db.update(table, data, where: '$idColumn = ?', whereArgs: [idValue]);
  }

  // FUNGSI 8: Generic Delete Data dari Tabel SQLite
  Future<int> delete(String table, String idColumn, dynamic idValue) async {
    if (kIsWeb) return 0;
    Database? db = await database;
    if (db == null) return 0;
    return await db.delete(table, where: '$idColumn = ?', whereArgs: [idValue]);
  }
}
