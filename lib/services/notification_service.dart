import '../models/notification_model.dart';
import 'database_helper.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    await _loadFromDatabase();
    await addMockNotifications();
  }

  final List<NotificationModel> _notifications = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<NotificationModel> get notifications => List.unmodifiable(_notifications.reversed);

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
  }

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

    // Simpan ke Memori
    _notifications.add(newNotification);

    // Simpan ke Database Lokal
    await _dbHelper.insert('notifications', {
      'id': newNotification.id,
      'title': newNotification.title,
      'description': newNotification.description,
      'timestamp': newNotification.timestamp.toIso8601String(),
      'category': newNotification.category.toString(),
      'isRead': newNotification.isRead ? 1 : 0,
    });
  }

  // MOCK DATA UNTUK TESTING
  Future<void> addMockNotifications() async {
    if (_notifications.isNotEmpty) return;
    
    await addNotification(
      title: 'Selamat Hari Raya Idu Adha 1447 H! ✨',
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

  Future<void> markAllAsRead() async {
    for (var notification in _notifications) {
      notification.isRead = true;
      await _dbHelper.update('notifications', {'isRead': 1}, 'id', notification.id);
    }
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
