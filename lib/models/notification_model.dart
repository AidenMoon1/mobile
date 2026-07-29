enum NotificationCategory { general, service, feedback, news }

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final NotificationCategory category;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.category = NotificationCategory.general,
    this.isRead = false,
  });
}
