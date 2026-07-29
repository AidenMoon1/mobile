import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications.reversed);

  void addNotification({
    required String title,
    required String description,
    NotificationCategory category = NotificationCategory.general,
  }) {
    final newNotification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      timestamp: DateTime.now(),
      category: category,
    );
    _notifications.add(newNotification);
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
