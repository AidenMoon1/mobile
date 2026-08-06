import '../models/user_model.dart';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  
  factory UserService() {
    return _instance;
  }

  UserService._internal();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  UserModel _currentUser = UserModel(
    name: 'Tamu Sukabumi',
    email: 'guest@sukabumi.go.id',
    username: 'Guest',
    phoneNumber: '-',
    status: 'Mode Tamu (Belum Login)',
    joinedDate: '-',
    id: 'GUEST-001',
    profileImagePath: '',
  );

  UserModel get currentUser => _currentUser;

  // Daftar akun terdaftar (Simulasi Database User)
  final List<Map<String, String>> _registeredUsers = [
    {
      'usernameOrEmail': 'warga@sukabumikota.go.id',
      'nikOrPhone': '3272012508980002',
      'password': 'password123',
      'name': 'Ahmad Subagja',
      'email': 'warga@sukabumikota.go.id',
    },
    {
      'usernameOrEmail': 'dzakwan@gmail.com',
      'nikOrPhone': '081234567890',
      'password': 'password123',
      'name': 'Muhammad Dzakwan',
      'email': 'dzakwan@gmail.com',
    },
  ];

  Future<void> init() async {
    await _loadFromLocal();
  }

  // Load data dari Shared Preferences saat aplikasi dibuka
  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    // Load registered users jika ada
    final String? regUsersJson = prefs.getString('registered_users_db');
    if (regUsersJson != null) {
      final List<dynamic> list = jsonDecode(regUsersJson);
      for (var item in list) {
        final map = Map<String, String>.from(item);
        if (!_registeredUsers.any((u) => u['email'] == map['email'])) {
          _registeredUsers.add(map);
        }
      }
    }

    final String? userJson = prefs.getString('user_profile');
    if (userJson != null && _isLoggedIn) {
      final Map<String, dynamic> data = jsonDecode(userJson);
      _currentUser = UserModel(
        name: data['name'] ?? 'Warga Sukabumi',
        email: data['email'] ?? '-',
        username: data['username'] ?? 'User',
        phoneNumber: data['phone'] ?? '-',
        status: data['status'] ?? 'Terverifikasi Akun Warga',
        joinedDate: data['joined_date'] ?? '-',
        id: data['user_id'] ?? _generateUniqueId(),
        profileImagePath: data['profile_image_path'] ?? '',
      );
    } else {
      _setGuestMode();
    }
  }

  void _setGuestMode() {
    _isLoggedIn = false;
    _currentUser = UserModel(
      name: 'Tamu Sukabumi',
      email: 'guest@sukabumi.go.id',
      username: 'Guest',
      phoneNumber: '-',
      status: 'Mode Tamu (Belum Login)',
      joinedDate: 'Hari ini',
      id: 'GUEST-001',
      profileImagePath: '',
    );
  }

  // AUTENTIKASI USER: Memeriksa apakah username/email dan password terdaftar
  Future<bool> authenticateAccount(String usernameOrEmail, String password) async {
    final input = usernameOrEmail.trim().toLowerCase();
    final pass = password.trim();

    final found = _registeredUsers.firstWhere(
      (user) =>
          (user['usernameOrEmail']!.toLowerCase() == input ||
           user['email']!.toLowerCase() == input ||
           user['nikOrPhone'] == input) &&
          user['password'] == pass,
      orElse: () => {},
    );

    if (found.isNotEmpty) {
      _isLoggedIn = true;
      final now = DateTime.now();
      final String dateStr = "${now.day} ${_getBulan(now.month)} ${now.year}";

      _currentUser = UserModel(
        name: found['name'] ?? 'Warga Terdaftar',
        email: found['email'] ?? input,
        username: found['nikOrPhone'] ?? input,
        phoneNumber: found['nikOrPhone'] ?? '-',
        status: 'Terverifikasi (Akun Warga)',
        joinedDate: dateStr,
        id: _generateUniqueId(),
        profileImagePath: '',
      );

      await _saveToLocal(_currentUser);
      return true;
    }

    return false;
  }

  // REGISTRASI USER BARU
  Future<bool> registerAccount({
    required String name,
    required String email,
    required String nikOrPhone,
    required String password,
  }) async {
    final newAccount = {
      'usernameOrEmail': email.trim().toLowerCase(),
      'nikOrPhone': nikOrPhone.trim(),
      'password': password.trim(),
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
    };

    _registeredUsers.add(newAccount);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_users_db', jsonEncode(_registeredUsers));

    // Otomatis login akun baru yang terdaftar
    _isLoggedIn = true;
    final now = DateTime.now();
    final String dateStr = "${now.day} ${_getBulan(now.month)} ${now.year}";

    _currentUser = UserModel(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      username: nikOrPhone.trim(),
      phoneNumber: nikOrPhone.trim(),
      status: 'Terverifikasi Akun Baru',
      joinedDate: dateStr,
      id: _generateUniqueId(),
      profileImagePath: '',
    );

    await _saveToLocal(_currentUser);
    return true;
  }

  // LOGIN VIA GOOGLE OAUTH
  Future<void> loginWithGoogleAccount(String googleName, String googleEmail) async {
    _isLoggedIn = true;
    final now = DateTime.now();
    final String dateStr = "${now.day} ${_getBulan(now.month)} ${now.year}";

    _currentUser = UserModel(
      name: googleName,
      email: googleEmail,
      username: googleEmail.split('@').first,
      phoneNumber: '-',
      status: 'Terverifikasi (Google OAuth API)',
      joinedDate: dateStr,
      id: _generateUniqueId(),
      profileImagePath: '',
    );

    await _saveToLocal(_currentUser);
  }

  // LOGIN DENGAN SSO
  Future<void> loginWithSSO(String ssoUsername) async {
    _isLoggedIn = true;
    final now = DateTime.now();
    final String dateStr = "${now.day} ${_getBulan(now.month)} ${now.year}";

    _currentUser = UserModel(
      name: '$ssoUsername (SSO)',
      email: '$ssoUsername@sukabumikota.go.id',
      username: ssoUsername,
      phoneNumber: '-',
      status: 'Terverifikasi (SSO Identity Provider)',
      joinedDate: dateStr,
      id: _generateUniqueId(),
      profileImagePath: '',
    );

    await _saveToLocal(_currentUser);
  }

  // MASUK DALAM MODE TAMU
  Future<void> loginAsGuest() async {
    _setGuestMode();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
  }

  // LOGOUT
  Future<void> logout() async {
    _setGuestMode();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
  }

  String _generateUniqueId() {
    final random = Random();
    final int code = 100000 + random.nextInt(900000);
    return 'SOA-$code';
  }

  String _getBulan(int mon) {
    const bulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return bulan[mon - 1];
  }

  // Simpan data ke Shared Preferences
  Future<void> _saveToLocal(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', _isLoggedIn);
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

  Future<bool> updateProfile(UserModel updatedUser) async {
    _currentUser = updatedUser;
    await _saveToLocal(updatedUser);
    return true;
  }

  Future<void> removeProfileImage() async {
    _currentUser = _currentUser.copyWith(profileImagePath: '');
    await _saveToLocal(_currentUser);
  }
}
