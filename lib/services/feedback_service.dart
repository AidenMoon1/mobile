import '../models/feedback_model.dart';
import 'api_service.dart';
import 'user_service.dart';
import 'database_helper.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  Future<void> init() async {
    await _loadFromDatabase();
  }

  final List<FeedbackModel> _history = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<FeedbackModel> get history => List.unmodifiable(_history.reversed);

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
    
    // Opsional: Tarik juga riwayat dari server untuk user ini saja
    try {
      final user = UserService().currentUser;
      final response = await ApiService.get('feedback?user_id=${user.id}');
      if (response.statusCode == 200) {
        // Gabungkan atau update riwayat lokal jika diperlukan
      }
    } catch (_) {}
  }

  Future<bool> addFeedback(FeedbackModel feedback) async {
    // 1. Simpan ke Local Memory
    _history.add(feedback);

    // 2. Simpan ke Database Lokal (SQLite)
    await _dbHelper.insert('feedback', {
      'rating': feedback.rating,
      'factor': feedback.factor,
      'reason': feedback.reason,
      'date': feedback.date.toIso8601String(),
    });

    // 3. Kirim ke Server
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
