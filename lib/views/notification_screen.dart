import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    final notifications = _notificationService.notifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FB),
      body: Column(
        children: [
          _buildHeader(primaryColor, accentColor),
          Expanded(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationList(notifications, primaryColor, accentColor),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primaryColor, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF123457),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.notifications_none_rounded, color: Colors.white70, size: 32),
              const Text(
                'Notifikasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Cari Notifikasi...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Filter Tabs
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Semua Notifikasi',
                  style: TextStyle(
                    color: Color(0xFF123457),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.tune, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              const Icon(Icons.more_vert, color: Colors.white70, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'Belum ada notifikasi baru',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications, Color primaryColor, Color accentColor) {
    // Group notifications by date
    final Map<String, List<NotificationModel>> grouped = {};
    for (var n in notifications) {
      String groupKey = _getGroupKey(n.timestamp);
      if (!grouped.containsKey(groupKey)) {
        grouped[groupKey] = [];
      }
      grouped[groupKey]!.add(n);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: grouped.keys.length,
      itemBuilder: (context, index) {
        String groupTitle = grouped.keys.elementAt(index);
        List<NotificationModel> items = grouped[groupTitle]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 8),
              child: Text(
                groupTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            ...items.map((n) => _buildNotificationCard(n, primaryColor, accentColor)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  String _getGroupKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) return 'Hari Ini';
    if (notificationDate == yesterday) return 'Kemarin';
    
    // For older, just use Month Year or specific Logic
    return DateFormat('MMMM yyyy').format(date);
  }

  Widget _buildNotificationCard(NotificationModel notification, Color primaryColor, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryIcon(notification.category, primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Text(
                          DateFormat('HH.mm').format(notification.timestamp),
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.description,
                      style: const TextStyle(color: Colors.black54, fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(NotificationCategory category, Color primaryColor) {
    IconData iconData;
    switch (category) {
      case NotificationCategory.feedback:
        iconData = Icons.rate_review_outlined;
        break;
      case NotificationCategory.service:
        iconData = Icons.description_outlined;
        break;
      case NotificationCategory.news:
        iconData = Icons.wb_sunny_outlined;
        break;
      default:
        iconData = Icons.notifications_none_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, size: 20, color: primaryColor),
    );
  }
}
