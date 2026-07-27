class UserModel {
  String name;
  String email;
  String username;
  String phoneNumber;
  String status;
  String joinedDate;
  String id;

  UserModel({
    required this.name,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.status,
    required this.joinedDate,
    required this.id,
  });

  // Salinan model untuk menghindari referensi yang sama saat editing
  UserModel copyWith({
    String? name,
    String? email,
    String? username,
    String? phoneNumber,
    String? status,
    String? joinedDate,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      joinedDate: joinedDate ?? this.joinedDate,
      id: id ?? this.id,
    );
  }
}
