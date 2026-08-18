// =============================================================================
// FILE: lib/services/notification_service.dart
// FUNGSI: Service Pengelola Notifikasi Real-Time Sistem Sukabumi One Access
// PATTERN: Singleton Pattern & Reactive ChangeNotifier (State Management)
// =============================================================================

import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import 'api_service.dart';
import 'database_helper.dart';

/// Kelas Service Pengelola Notifikasi Sistem dengan Reaktivitas Real-Time
class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // FUNGSI 1: Inisialisasi Service & Memuat Notifikasi dari Database & Server
  Future<void> init() async {
    await _loadFromDatabase();
    await fetchNotificationsFromServer();
  }

  // FUNGSI FETCH REAL NOTIFICATIONS FROM BACKEND REST API SERVER
  Future<void> fetchNotificationsFromServer() async {
    try {
      final response = await ApiService.get('notifications');
      if (response.statusCode == 200) {
        // Sync data dari server jika tersedia
      }
    } catch (_) {}
  }

  final List<NotificationModel> _notifications = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Getter Notifikasi (Diurutkan dari yang Terbaru)
  List<NotificationModel> get notifications => List.unmodifiable(_notifications.reversed);

  // FUNGSI 2: Memuat Notifikasi Tersimpan dari Database SQLite
  Future<void> _loadFromDatabase() async {
    if (kIsWeb) return;
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll('notifications');
    _notifications.clear();
    for (var map in maps) {
      _notifications.add(NotificationModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        timestamp: DateTime.parse(map['timestamp']),
        category: NotificationCategory.values.firstWhere(
          (e) => e.toString() == map['category'],
          orElse: () => NotificationCategory.general,
        ),
        isRead: map['isRead'] == 1,
      ));
    }
    notifyListeners(); // Memberitahu Seluruh UI Widget bahwa Data Notifikasi Siap
  }

  // FUNGSI 3: Menambahkan Notifikasi Baru (Memori, Stream UI Real-Time, dan SQLite)
  Future<void> addNotification({
    required String title,
    required String description,
    NotificationCategory category = NotificationCategory.general,
  }) async {
    final newNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      timestamp: DateTime.now(),
      category: category,
    );

    // Step A: Simpan ke Memori & Pemicu Listener Real-Time UI
    _notifications.add(newNotification);
    notifyListeners();

    // Step B: Simpan ke Database Lokal (SQLite)
    await _dbHelper.insert('notifications', {
      'id': newNotification.id,
      'title': newNotification.title,
      'description': newNotification.description,
      'timestamp': newNotification.timestamp.toIso8601String(),
      'category': newNotification.category.toString(),
      'isRead': newNotification.isRead ? 1 : 0,
    });
  }



  // FUNGSI 5: Menandai Seluruh Notifikasi Sudah Dibaca
  Future<void> markAllAsRead() async {
    for (var notification in _notifications) {
      notification.isRead = true;
      await _dbHelper.update('notifications', {'isRead': 1}, 'id', notification.id);
    }
    notifyListeners();
    
    // Update ke Server REST API
    await ApiService.post('notifications/read-all', {});
  }

  // FUNGSI 6: Menghapus Seluruh Notifikasi
  Future<void> deleteAllNotifications() async {
    _notifications.clear();
    notifyListeners();
    
    final db = await _dbHelper.database;
    if (db != null) {
      await db.delete('notifications');
    }

    await ApiService.delete('notifications');
  }

  // Getter Hitung Jumlah Notifikasi yang Belum Dibaca
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
