// =============================================================================
// FILE: lib/services/admin_management_service.dart
// FUNGSI: Service Master Pengelola Data Administrator (SuperAdmin & Admin OPD)
// PATTERN: Singleton Pattern & Reactive State Management (ChangeNotifier)
// =============================================================================

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/admin_user_model.dart';
import 'api_service.dart';

class AdminManagementService extends ChangeNotifier {
  static final AdminManagementService _instance = AdminManagementService._internal();
  factory AdminManagementService() => _instance;

  static const String _rtdbBaseUrl = 'https://sukabumi-one-access-app-c7f15-default-rtdb.firebaseio.com/admin_users';

  AdminManagementService._internal() {
    _initDefaultAdmins();
    _loadSavedAdminsLocal();
    _fetchCloudAdmins();

    // Polling sync setiap 10 detik untuk update admin real-time (lebih efisien)
    Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchCloudAdmins();
    });
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final List<AdminUserModel> _adminList = [];

  List<AdminUserModel> get adminList => List.unmodifiable(_adminList);

  void _initDefaultAdmins() {
    _adminList.addAll([
      // --- SUPERADMIN OPERATORS ---
      AdminUserModel(
        id: 'adm-001',
        nama: 'Muhammad Dzakwan (SuperAdmin)',
        username: 'dzakwan',
        email: 'dzakwanmuh304@gmail.com',
        nip: '19950810 202203 1 001',
        whatsapp: '081234567890',
        instansi: 'SUPERADMIN',
        role: 'Super Admin',
        isActive: true,
        isOnline: false,
        createdAt: DateTime(2026, 1, 1),
      ),
      AdminUserModel(
        id: 'adm-002',
        nama: 'Admin Tobi',
        username: 'tobi',
        email: 'anisatulmahmudah38@gmail.com',
        nip: '19920415 201801 1 005',
        whatsapp: '085712345678',
        instansi: 'DISKOMINFO',
        role: 'Super Admin',
        isActive: true,
        isOnline: false,
        createdAt: DateTime(2026, 2, 10),
      ),
      AdminUserModel(
        id: 'adm-003',
        nama: 'Shelva',
        username: 'shelva',
        email: 'shelva.meriana_ti24@nusaputra.ac.id',
        nip: '19980325 202101 2 003',
        whatsapp: '081298765432',
        instansi: 'DISKOMINFO',
        role: 'Super Admin',
        isActive: true,
        isOnline: false,
        createdAt: DateTime(2026, 3, 15),
      ),
      AdminUserModel(
        id: 'adm-004',
        nama: 'Super Administrator',
        username: 'superadmin',
        email: 'ranggis8089@gmail.com',
        nip: '19871105 201204 1 008',
        whatsapp: '081345678901',
        instansi: 'SUPERADMIN',
        role: 'Super Admin',
        isActive: true,
        isOnline: false,
        createdAt: DateTime(2026, 4, 20),
      ),

      // --- ADMIN DINAS OPERATORS (EXACT MATCH SCREENSHOT) ---
      AdminUserModel(
        id: 'adm-dinas-001',
        nama: 'Admin Diskominfo',
        username: 'adminkominfo',
        email: 'admin_kominfo@soa.com',
        nip: '19910325 201801 2 003',
        whatsapp: '081234567899',
        instansi: 'Dinas Komunikasi dan Informatika',
        role: 'Admin OPD',
        isActive: true,
        isOnline: false,
        createdAt: DateTime(2026, 5, 1),
      ),
      AdminUserModel(
        id: 'adm-dinas-002',
        nama: 'Admin Disdukcapil',
        username: 'admindisdukcapil',
        email: 'admin_disdukcapil@soa.com',
        nip: '19880412 201502 1 004',
        whatsapp: '081298765433',
        instansi: 'Dinas Kependudukan dan Pencatatan Sipil',
        role: 'Admin OPD',
        isActive: true,
        isOnline: false,
        createdAt: DateTime(2026, 5, 10),
      ),
      AdminUserModel(
        id: 'adm-dinas-003',
        nama: 'Admin DPMPTSP',
        username: 'admindpmptsp',
        email: 'admin_dpmptsp@soa.com',
        nip: '19871105 201204 1 008',
        whatsapp: '081345678902',
        instansi: 'Dinas Penanaman Modal dan PTSP',
        role: 'Admin OPD',
        isActive: true,
        isOnline: false,
        createdAt: DateTime(2026, 5, 15),
      ),
    ]);
  }

  Future<void> _loadSavedAdminsLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString('saved_admin_list');
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = json.decode(jsonStr);
        _adminList.clear();
        for (var item in decoded) {
          _adminList.add(AdminUserModel.fromMap(Map<String, dynamic>.from(item)));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading local admins: $e');
    }
  }

  Future<void> _saveAdminsLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> mapList = _adminList.map((e) => e.toMap()).toList();
      await prefs.setString('saved_admin_list', json.encode(mapList));
    } catch (e) {
      debugPrint('Error saving local admins: $e');
    }
  }

  Future<void> _fetchCloudAdmins() async {
    try {
      final res = await http.get(Uri.parse('$_rtdbBaseUrl.json'));
      if (res.statusCode == 200 && res.body != 'null') {
        final dynamic decoded = json.decode(res.body);
        if (decoded is Map) {
          bool updated = false;
          decoded.forEach((key, val) {
            if (val is Map) {
              final admin = AdminUserModel.fromMap(Map<String, dynamic>.from(val));
              int idx = _adminList.indexWhere((e) => e.id == admin.id);
              if (idx != -1) {
                _adminList[idx] = admin;
              } else {
                _adminList.add(admin);
              }
              updated = true;
            }
          });
          if (updated) {
            _saveAdminsLocal();
            notifyListeners();
          }
        }
      }
    } catch (e) {
      debugPrint('RTDB fetch admins error: $e');
    }
  }

  void _syncAdminToCloud(AdminUserModel admin) async {
    try {
      final url = '$_rtdbBaseUrl/${admin.id}.json';
      await http.put(Uri.parse(url), body: json.encode(admin.toMap()));

      // Backup ke Firestore jika tersedia
      _db.collection('admin_users').doc(admin.id).set(admin.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Cloud admin sync error: $e');
    }
  }

  Future<void> updateAdminOnlineStatus(String adminId, bool isOnline) async {
    try {
      final url = '$_rtdbBaseUrl/$adminId.json';
      // Menggunakan PATCH untuk hanya mengupdate field isOnline saja
      await http.patch(
        Uri.parse(url),
        body: json.encode({'isOnline': isOnline}),
      );

      // Update state lokal agar UI langsung bereaksi
      int idx = _adminList.indexWhere((e) => e.id == adminId);
      if (idx != -1) {
        _adminList[idx] = _adminList[idx].copyWith(isOnline: isOnline);
        _saveAdminsLocal();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Update online status error: $e');
    }
  }

  void addAdmin(AdminUserModel newAdmin) {
    _adminList.add(newAdmin);
    _saveAdminsLocal();
    _syncAdminToCloud(newAdmin);
    notifyListeners();
  }

  void updateAdmin(AdminUserModel updated) {
    int idx = _adminList.indexWhere((e) => e.id == updated.id);
    if (idx != -1) {
      _adminList[idx] = updated;
      _saveAdminsLocal();
      _syncAdminToCloud(updated);
      notifyListeners();
    }
  }

  void deleteAdmin(String id) async {
    // 1. Dapatkan data admin sebelum dihapus dari list (untuk ambil email)
    final adminToDelete = _adminList.firstWhere((e) => e.id == id, orElse: () => AdminUserModel(id: '', nama: '', username: '', email: '', nip: '', instansi: '', role: '', createdAt: DateTime.now()));
    final String targetEmail = adminToDelete.email;

    // 2. Hapus dari List Lokal & Firebase RTDB
    _adminList.removeWhere((e) => e.id == id);
    _saveAdminsLocal();
    notifyListeners();

    try {
      final url = '$_rtdbBaseUrl/$id.json';
      await http.delete(Uri.parse(url));
      _db.collection('admin_users').doc(id).delete();

      // 3. SINKRONISASI: Hapus dari Database MySQL (Laptop) via API Laravel
      if (targetEmail.isNotEmpty) {
        await ApiService.delete('admin/delete?email=$targetEmail');
      }
    } catch (_) {}
  }

  void toggleAdminStatus(String id) {
    int idx = _adminList.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final current = _adminList[idx];
      final updated = current.copyWith(isActive: !current.isActive);
      _adminList[idx] = updated;
      _saveAdminsLocal();
      _syncAdminToCloud(updated);
      notifyListeners();
    }
  }
}
