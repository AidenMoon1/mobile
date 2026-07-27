import '../models/feedback_model.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  final List<FeedbackModel> _history = [];

  List<FeedbackModel> get history => List.unmodifiable(_history.reversed);

  void addFeedback(FeedbackModel feedback) {
    _history.add(feedback);
  }
}
