import '../models/user_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  
  factory UserService() {
    return _instance;
  }

  UserService._internal();

  Future<void> init() async {
    await _loadFromLocal();
  }

  UserModel _currentUser = UserModel(
    name: 'mrn',
    email: 'mrn@gmail.com',
    username: 'mrn',
    phoneNumber: '081234567890',
    status: 'Kota Sukabumi',
    joinedDate: '16 Jul 2026',
    id: 'ID-1003',
    profileImagePath: '',
  );

  UserModel get currentUser => _currentUser;

  // Load data dari Shared Preferences saat aplikasi dibuka
  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final Map<String, dynamic> data = jsonDecode(userJson);
      _currentUser = UserModel(
        name: data['name'] ?? 'mrn',
        email: data['email'] ?? 'mrn@gmail.com',
        username: data['username'] ?? 'mrn',
        phoneNumber: data['phone'] ?? '081234567890',
        status: data['status'] ?? 'Kota Sukabumi',
        joinedDate: data['joined_date'] ?? '16 Jul 2026',
        id: data['user_id'] ?? 'ID-1003',
        profileImagePath: data['profile_image_path'] ?? '',
      );
    }
  }

  // Simpan data ke Shared Preferences
  Future<void> _saveToLocal(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'name': user.name,
      'email': user.email,
      'username': user.username,
      'phone': user.phoneNumber,
      'status': user.status,
      'joined_date': user.joinedDate,
      'user_id': user.id,
      'profile_image_path': user.profileImagePath,
    };
    await prefs.setString('user_profile', jsonEncode(data));
  }

  // Fungsi untuk memperbarui profil di memori lokal dan backend API
  Future<bool> updateProfile(UserModel updatedUser) async {
    // 1. Update state lokal di memori
    _currentUser = updatedUser;
    
    // 2. Simpan ke SharedPreferences HP
    await _saveToLocal(updatedUser);

    return true;
  }

  // Fungsi Hapus Foto Profil
  Future<void> removeProfileImage() async {
    _currentUser = _currentUser.copyWith(profileImagePath: '');
    await _saveToLocal(_currentUser);
  }
}
