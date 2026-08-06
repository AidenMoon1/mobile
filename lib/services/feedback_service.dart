// =============================================================================
// FILE: lib/services/feedback_service.dart
// FUNGSI: Service Pengelola Ulasan & Survei Kepuasan Masyarakat (SKM)
// PATTERN: Singleton Pattern dengan Triple Persistence (Local, SQLite, REST API)
// LEVEL KODE: Level 2-3 (Sangat Rapi & Mudah Dipahami Mahasiswa)
// =============================================================================

import '../models/feedback_model.dart';
import 'api_service.dart';
import 'user_service.dart';
import 'database_helper.dart';

/// Kelas Service Pengelola Ulasan Feedback Masyarakat
class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  // FUNGSI 1: Inisialisasi Service & Memuat Riwayat dari SQLite
  Future<void> init() async {
    await _loadFromDatabase();
  }

  final List<FeedbackModel> _history = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Getter Riwayat Ulasan
  List<FeedbackModel> get history => List.unmodifiable(_history.reversed);

  // FUNGSI 2: Memuat Ulasan Tersimpan dari SQLite
  Future<void> _loadFromDatabase() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAllFeedback();
    _history.clear();
    for (var map in maps) {
      _history.add(FeedbackModel(
        rating: map['rating'],
        factor: map['factor'],
        reason: map['reason'],
        date: DateTime.parse(map['date']),
      ));
    }
    
    try {
      final user = UserService().currentUser;
      final response = await ApiService.get('feedback?user_id=${user.id}');
      if (response.statusCode == 200) {
        // Sinkronisasi data server jika diperlukan
      }
    } catch (_) {}
  }

  // FUNGSI 3: Menambahkan Ulasan Baru (Tersimpan ke Memori, SQLite, dan REST API)
  Future<bool> addFeedback(FeedbackModel feedback) async {
    // Step A: Simpan ke Memori Lokal
    _history.add(feedback);

    // Step B: Simpan ke Database Lokal (SQLite)
    await _dbHelper.insert('feedback', {
      'rating': feedback.rating,
      'factor': feedback.factor,
      'reason': feedback.reason,
      'date': feedback.date.toIso8601String(),
    });

    // Step C: Kirim ke Backend REST API Server
    final user = UserService().currentUser;
    final payload = {
      'user_id': user.id,
      'rating': feedback.rating,
      'factor': feedback.factor,
      'reason': feedback.reason,
      'date': feedback.date.toIso8601String(),
    };

    final response = await ApiService.post('feedback', payload);
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
