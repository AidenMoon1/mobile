import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  
  factory UserService() {
    return _instance;
  }

  UserService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // REGISTRASI USER BARU (REAL FIREBASE)
  Future<bool> registerAccount({
    required String name,
    required String email,
    required String password,
    String? nikOrPhone,
  }) async {
    try {
      // 1. Create account in Firebase
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Update display name in Firebase
        await firebaseUser.updateDisplayName(name);

        final now = DateTime.now();
        final String dateStr = "${now.day} ${_getBulan(now.month)} ${now.year}";

        _currentUser = UserModel(
          name: name.trim(),
          email: email.trim().toLowerCase(),
          username: (nikOrPhone ?? email).split('@').first,
          phoneNumber: nikOrPhone ?? '-',
          status: 'Menunggu Verifikasi OTP',
          joinedDate: dateStr,
          id: _generateUniqueId(),
          profileImagePath: '',
        );

        await _saveToLocal(_currentUser);

        // 2. Trigger OTP sending via Laravel
        await ApiService.post('auth/otp/email/send', {'email': email});
        
        return true;
      }
    } catch (e) {
      print("Registration error: $e");
      rethrow;
    }
    return false;
  }

  // LOGIN USER (REAL FIREBASE)
  Future<bool> loginWithEmailPassword(String email, String password) async {
    try {
      // 1. Sign in with Firebase
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final now = DateTime.now();
        final String dateStr = "${now.day} ${_getBulan(now.month)} ${now.year}";

        _currentUser = UserModel(
          name: firebaseUser.displayName ?? 'Warga Sukabumi',
          email: firebaseUser.email ?? email,
          username: (firebaseUser.email ?? email).split('@').first,
          phoneNumber: '-',
          status: 'Menunggu Verifikasi OTP',
          joinedDate: dateStr,
          id: _generateUniqueId(),
          profileImagePath: firebaseUser.photoURL ?? '',
        );

        await _saveToLocal(_currentUser);

        // 2. Trigger OTP sending via Laravel
        await ApiService.post('auth/otp/email/send', {'email': email});
        
        return true;
      }
    } catch (e) {
      print("Login error: $e");
      rethrow;
    }
    return false;
  }

  // FINALIZE LOGIN AFTER OTP
  Future<void> finalizeLogin() async {
    _isLoggedIn = true;
    _currentUser = _currentUser.copyWith(status: 'Terverifikasi (Email + OTP)');
    await _saveToLocal(_currentUser);
  }

  // LOGIN VIA GOOGLE OAUTH (REAL FIREBASE INTEGRATION)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled the sign-in

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        _isLoggedIn = true;
        final now = DateTime.now();
        final String dateStr = "${now.day} ${_getBulan(now.month)} ${now.year}";

        _currentUser = UserModel(
          name: firebaseUser.displayName ?? 'User Google',
          email: firebaseUser.email ?? '-',
          username: (firebaseUser.email ?? 'user').split('@').first,
          phoneNumber: firebaseUser.phoneNumber ?? '-',
          status: 'Terverifikasi (Google Auth Resmi)',
          joinedDate: dateStr,
          id: _generateUniqueId(),
          profileImagePath: firebaseUser.photoURL ?? '',
        );

        await _saveToLocal(_currentUser);
      }

      return userCredential;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      rethrow;
    }
  }

  // LOGIN VIA GOOGLE OAUTH (OLD SIMULATION)
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

  // FORGOT PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
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
