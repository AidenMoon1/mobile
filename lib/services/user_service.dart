// =============================================================================
// FILE: lib/services/user_service.dart
// FUNGSI: Service Pengelola Sesi & Profil Akun Pengguna (SharedPreferences Storage)
// PATTERN: Singleton Pattern & Key-Value Local Storage
// =============================================================================

import '../models/user_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Kelas Service Pengelola State Sesi Akun Pengguna Terlogin
class UserService {
  static final UserService _instance = UserService._internal();
  
  factory UserService() {
    return _instance;
  }

  UserService._internal();

  // FUNGSI 1: Inisialisasi Service & Memuat Profil Pengguna dari Storage HP
  Future<void> init() async {
    await _loadFromLocal();
  }

  // State Pengguna Aktif Default (Fallback Memori)
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

  // Getter Profil Pengguna Aktif
  UserModel get currentUser => _currentUser;

  // FUNGSI 2: Memuat Profil dari Shared Preferences HP Saat Aplikasi Dibuka
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

  // FUNGSI 3: Menyimpan Profil ke Shared Preferences HP
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

  // FUNGSI 4: Memperbarui Profil di Memori Lokal & Persistent Storage HP
  Future<bool> updateProfile(UserModel updatedUser) async {
    _currentUser = updatedUser;
    await _saveToLocal(updatedUser);
    return true;
  }

  // FUNGSI 5: Menghapus Foto Profil Pengguna
  Future<void> removeProfileImage() async {
    _currentUser = _currentUser.copyWith(profileImagePath: '');
    await _saveToLocal(_currentUser);
  }
}
