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

  Future<void> init() async {
    await _loadFromLocal();
  }

  UserModel _currentUser = UserModel(
    name: 'Warga Sukabumi',
    email: '-',
    username: 'Guest',
    phoneNumber: '-',
    status: 'Belum Terverifikasi',
    joinedDate: '-',
    id: 'PENDING',
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
        name: data['name'] ?? 'Warga Sukabumi',
        email: data['email'] ?? '-',
        username: data['username'] ?? 'Guest',
        phoneNumber: data['phone'] ?? '-',
        status: data['status'] ?? 'Belum Terverifikasi',
        joinedDate: data['joined_date'] ?? '-',
        id: data['user_id'] ?? _generateUniqueId(),
        profileImagePath: data['profile_image_path'] ?? '',
      );
    } else {
      // JIKA INSTALASI BARU, BUAT ID UNIK OTOMATIS
      final String newId = _generateUniqueId();
      final now = DateTime.now();
      final String dateStr = "${now.day} ${_getBulan(now.month)} ${now.year}";
      
      _currentUser = _currentUser.copyWith(
        id: newId,
        joinedDate: dateStr,
      );
      
      // Simpan identitas baru ini
      await _saveToLocal(_currentUser);
    }
  }

  String _generateUniqueId() {
    final random = Random();
    final int code = 100000 + random.nextInt(900000); // 6 Digit Angka
    return 'SOA-$code';
  }

  String _getBulan(int mon) {
    const bulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return bulan[mon - 1];
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
