// =============================================================================
// FILE: lib/services/notification_service.dart
// FUNGSI: Service Pengelola Notifikasi Real-Time Sistem Sukabumi One Access
// PATTERN: Singleton Pattern & Reactive ChangeNotifier (State Management)
// LEVEL KODE: Level 2-3 (Sangat Rapi & Mudah Dipahami Mahasiswa)
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

  // FUNGSI 1: Inisialisasi Service & Memuat Notifikasi dari SQLite
  Future<void> init() async {
    await _loadFromDatabase();
    await addMockNotifications();
  }

  final List<NotificationModel> _notifications = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Getter Notifikasi (Diurutkan dari yang Terbaru)
  List<NotificationModel> get notifications => List.unmodifiable(_notifications.reversed);

  // FUNGSI 2: Memuat Notifikasi Tersimpan dari Database SQLite
  Future<void> _loadFromDatabase() async {
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

  // FUNGSI 4: Menambahkan Notifikasi Awal (Untuk Pengujian)
  Future<void> addMockNotifications() async {
    if (_notifications.isNotEmpty) return;
    
    await addNotification(
      title: 'Selamat Hari Raya Idul Adha 1447 H! ✨',
      description: 'Mari jadikan momen kurban tahun ini untuk mempererat kebersamaan dan kepedulian terhadap sesama.',
      category: NotificationCategory.news,
    );
    
    await addNotification(
      title: 'Waspada Ada Potensi Cuaca Ekstrem di Daerah Anda!',
      description: 'Peringatan Dini Cuaca Jawa Barat, Tanggal 22 Juli 2026 berpotensi hujan dengan intensitas sedang hingga lebat...',
      category: NotificationCategory.disaster,
    );
    
    await addNotification(
      title: 'Layanan Anda Telah Selesai di Proses',
      description: 'Layanan yang Anda ajukan telah selesai di proses. Silahkan lihat hasil atau informasi lebih lanjut melalui website resmi instansi terkait.',
      category: NotificationCategory.service,
    );
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
