class FeedbackModel {
  final int rating;
  final String factor;
  final String reason;
  final String gender;
  final String education;
  final DateTime date;

  FeedbackModel({
    required this.rating,
    required this.factor,
    required this.reason,
    required this.gender,
    required this.education,
    required this.date,
  });
}
