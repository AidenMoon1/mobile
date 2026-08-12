// =============================================================================
// FILE: lib/services/admin_auth_service.dart
// FUNGSI: Service Manajemen Sesi & Autentikasi Admin (Web Safe LocalStorage Persistence)
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAuthService {
  static final AdminAuthService _instance = AdminAuthService._internal();
  factory AdminAuthService() => _instance;
  AdminAuthService._internal();

  static const String _keyIsLoggedIn = 'is_admin_logged_in';
  static const String _keyAdminEmail = 'admin_email';

  bool _isLoggedInMemory = false;
  String _adminEmailMemory = 'dzakwanmuh304@gmail.com';

  /// Menyimpan sesi login admin di LocalStorage / SharedPreferences & Memori
  Future<void> saveSession(String email) async {
    _isLoggedInMemory = true;
    _adminEmailMemory = email;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyAdminEmail, email);
    } catch (e) {
      debugPrint('Web SharedPreferences fallback: $e');
    }
  }

  /// Menghapus sesi login admin (Logout)
  Future<void> logout() async {
    _isLoggedInMemory = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, false);
      await prefs.remove(_keyAdminEmail);
    } catch (e) {
      debugPrint('Web SharedPreferences logout fallback: $e');
    }
  }

  /// Mengecek apakah admin sedang dalam kondisi terautentikasi (Logged in)
  Future<bool> isLoggedIn() async {
    if (_isLoggedInMemory) return true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final loggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      if (loggedIn) _isLoggedInMemory = true;
      return loggedIn;
    } catch (e) {
      debugPrint('Web SharedPreferences isLoggedIn fallback: $e');
      return _isLoggedInMemory;
    }
  }

  /// Mengambil alamat email admin yang terdaftar di sesi
  Future<String> getAdminEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyAdminEmail) ?? _adminEmailMemory;
    } catch (e) {
      return _adminEmailMemory;
    }
  }
}
