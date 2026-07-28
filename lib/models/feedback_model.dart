class FeedbackModel {
  final int rating;
  final String factor;
  final String reason;
  final DateTime date;

  FeedbackModel({
    required this.rating,
    required this.factor,
    required this.reason,
    required this.date,
  });
}
