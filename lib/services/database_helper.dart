import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    // Web tidak mendukung sqflite
    if (kIsWeb) return null;
    
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database?> _initDatabase() async {
    if (kIsWeb) return null;
    
    String path = join(await getDatabasesPath(), 'sukabumi_one_access.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Tabel Notifikasi
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

    // Tabel Feedback
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

  // Generic Insert
  Future<int> insert(String table, Map<String, dynamic> data) async {
    if (kIsWeb) return 0;
    Database? db = await database;
    if (db == null) return 0;
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Generic Query
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    if (kIsWeb) return [];
    Database? db = await database;
    if (db == null) return [];
    return await db.query(table, orderBy: 'timestamp DESC');
  }
  
  // Specific Query for Feedback (uses 'date' instead of 'timestamp')
  Future<List<Map<String, dynamic>>> queryAllFeedback() async {
    if (kIsWeb) return [];
    Database? db = await database;
    if (db == null) return [];
    return await db.query('feedback', orderBy: 'date DESC');
  }

  // Generic Update
  Future<int> update(String table, Map<String, dynamic> data, String idColumn, dynamic idValue) async {
    if (kIsWeb) return 0;
    Database? db = await database;
    if (db == null) return 0;
    return await db.update(table, data, where: '$idColumn = ?', whereArgs: [idValue]);
  }

  // Generic Delete
  Future<int> delete(String table, String idColumn, dynamic idValue) async {
    if (kIsWeb) return 0;
    Database? db = await database;
    if (db == null) return 0;
    return await db.delete(table, where: '$idColumn = ?', whereArgs: [idValue]);
  }
}
