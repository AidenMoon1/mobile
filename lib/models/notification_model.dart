// =============================================================================
// FILE: lib/models/notification_model.dart
// FUNGSI: Data Model untuk Notifikasi Sistem Sukabumi One Access
// PATTERN: Data Transfer Object (DTO)
// =============================================================================

/// Enum Kategori Notifikasi (Informasi Umum, Layanan, Feedback, Berita, Kebencanaan)
enum NotificationCategory { general, service, feedback, news, disaster }

/// Kelas Model Representasi 1 Butir Pesan Notifikasi Sistem
class NotificationModel {
  final String id;                    // ID Unik Notifikasi
  final String title;                 // Judul Pesan Notifikasi
  final String description;           // Rincian Deskripsi Notifikasi
  final DateTime timestamp;           // Waktu Stempel Notifikasi Masuk
  final NotificationCategory category;// Kategori Jenis Notifikasi
  bool isRead;                        // Status Apakah Sudah Dibaca Pengguna

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.category = NotificationCategory.general,
    this.isRead = false,
  });
}
