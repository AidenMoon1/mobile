import '../models/user_model.dart';

class UserService {
  // Singleton instance
  static final UserService _instance = UserService._internal();
  
  factory UserService() {
    return _instance;
  }

  UserService._internal();

  // Data user yang disimpan di memori
  UserModel _currentUser = UserModel(
    name: 'mrn',
    email: 'mrn@gmail.com',
    username: 'mrn',
    phoneNumber: '081234567890',
    status: 'Kota Sukabumi',
    joinedDate: '16 Jul 2026',
    id: 'ID-1003',
  );

  UserModel get currentUser => _currentUser;

  // Fungsi untuk memperbarui data user
  void updateProfile(UserModel updatedUser) {
    _currentUser = updatedUser;
  }
}
