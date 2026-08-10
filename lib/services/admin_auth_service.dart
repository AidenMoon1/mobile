// =============================================================================
// FILE: lib/services/admin_auth_service.dart
// FUNGSI: Service Manajemen Sesi & Autentikasi Admin (Web LocalStorage Persistence)
// =============================================================================

import 'package:shared_preferences/shared_preferences.dart';

class AdminAuthService {
  static final AdminAuthService _instance = AdminAuthService._internal();
  factory AdminAuthService() => _instance;
  AdminAuthService._internal();

  static const String _keyIsLoggedIn = 'is_admin_logged_in';
  static const String _keyAdminEmail = 'admin_email';

  /// Menyimpan sesi login admin di LocalStorage / SharedPreferences
  Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyAdminEmail, email);
  }

  /// Menghapus sesi login admin (Logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyAdminEmail);
  }

  /// Mengecek apakah admin sedang dalam kondisi terautentikasi (Logged in)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Mengambil alamat email admin yang terdaftar di sesi
  Future<String> getAdminEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAdminEmail) ?? 'admin@sukabumi.go.id';
  }
}
