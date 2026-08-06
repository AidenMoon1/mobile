// =============================================================================
// FILE: lib/models/feedback_model.dart
// FUNGSI: Data Model Ulasan Kepuasan Masyarakat (SKM)
// PATTERN: Data Transfer Object (DTO)
// LEVEL KODE: Level 2-3 (Sederhana & Rapi Untuk Mahasiswa)
// =============================================================================

/// Kelas Model Representasi 1 Butir Ulasan / Feedback Kepuasan Warga
class FeedbackModel {
  final int rating;    // Skor Penilaian Bintang (1 - 5)
  final String factor; // Faktor Utama (Kecepatan, Kemudahan, Keramahan, dll)
  final String reason; // Ulasan / Alasan Masukan Warga
  final DateTime date; // Tanggal Ulasan Dikirim

  FeedbackModel({
    required this.rating,
    required this.factor,
    required this.reason,
    required this.date,
  });
}
