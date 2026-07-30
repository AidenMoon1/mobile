import '../models/feedback_model.dart';
import 'api_service.dart';
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
    final payload = {
      'rating': feedback.rating,
      'factor': feedback.factor,
      'reason': feedback.reason,
      'date': feedback.date.toIso8601String(),
    };

    final response = await ApiService.post('feedback', payload);
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
