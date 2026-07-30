import '../models/user_model.dart';
import 'api_service.dart';
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
  );

  UserModel get currentUser => _currentUser;

  // Load data dari Shared Preferences saat aplikasi dibuka
  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final Map<String, dynamic> data = jsonDecode(userJson);
      _currentUser = UserModel(
        name: data['name'],
        email: data['email'],
        username: data['username'],
        phoneNumber: data['phone'],
        status: data['status'],
        joinedDate: data['joined_date'],
        id: data['user_id'],
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
    };
    await prefs.setString('user_profile', jsonEncode(data));
  }

  Future<void> fetchUserProfile() async {
    final response = await ApiService.get('profile');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final updatedUser = UserModel(
        name: data['name'] ?? _currentUser.name,
        email: data['email'] ?? _currentUser.email,
        username: data['username'] ?? _currentUser.username,
        phoneNumber: data['phone'] ?? _currentUser.phoneNumber,
        status: data['status'] ?? _currentUser.status,
        joinedDate: data['joined_date'] ?? _currentUser.joinedDate,
        id: data['user_id'] ?? _currentUser.id,
      );
      _currentUser = updatedUser;
      await _saveToLocal(updatedUser);
    }
  }

  Future<bool> updateProfile(UserModel updatedUser) async {
    final payload = {
      'name': updatedUser.name,
      'email': updatedUser.email,
      'phone': updatedUser.phoneNumber,
    };

    final response = await ApiService.post('profile/update', payload);
    if (response.statusCode == 200) {
      _currentUser = updatedUser;
      await _saveToLocal(updatedUser);
      return true;
    }
    return false;
  }
}
