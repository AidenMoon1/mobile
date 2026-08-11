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

class AdminManagementService extends ChangeNotifier {
  static final AdminManagementService _instance = AdminManagementService._internal();
  factory AdminManagementService() => _instance;

  static const String _rtdbBaseUrl = 'https://sukabumi-one-access-app-c7f15-default-rtdb.firebaseio.com/admin_users';

  AdminManagementService._internal() {
    _initDefaultAdmins();
    _loadSavedAdminsLocal();
    _fetchCloudAdmins();

    // Polling sync setiap 4 detik untuk update admin real-time
    Timer.periodic(const Duration(seconds: 4), (_) {
      _fetchCloudAdmins();
    });
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final List<AdminUserModel> _adminList = [];

  List<AdminUserModel> get adminList => List.unmodifiable(_adminList);

  void _initDefaultAdmins() {
    _adminList.addAll([
      AdminUserModel(
        id: 'adm-001',
        nama: 'Muhammad Dzakwan (SuperAdmin)',
        email: 'dzakwanmuh304@gmail.com',
        nip: '19950810 202203 1 001',
        instansi: 'SUPERADMIN',
        role: 'Super Admin',
        isActive: true,
        createdAt: DateTime(2026, 1, 1),
      ),
      AdminUserModel(
        id: 'adm-002',
        nama: 'Admin Disdukcapil Kota Sukabumi',
        email: 'admin.disdukcapil@sukabumi.go.id',
        nip: '19880412 201502 1 004',
        instansi: 'DISDUKCAPIL',
        role: 'Admin OPD',
        isActive: true,
        createdAt: DateTime(2026, 2, 10),
      ),
      AdminUserModel(
        id: 'adm-003',
        nama: 'Admin Diskominfo Kota Sukabumi',
        email: 'admin.diskominfo@sukabumi.go.id',
        nip: '19910325 201801 2 003',
        instansi: 'DISKOMINFO',
        role: 'Admin OPD',
        isActive: true,
        createdAt: DateTime(2026, 3, 15),
      ),
      AdminUserModel(
        id: 'adm-004',
        nama: 'Admin DPMPTSP Perizinan',
        email: 'admin.dpmptsp@sukabumi.go.id',
        nip: '19871105 201204 1 008',
        instansi: 'DPMPTSP',
        role: 'Admin OPD',
        isActive: true,
        createdAt: DateTime(2026, 4, 20),
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
    _adminList.removeWhere((e) => e.id == id);
    _saveAdminsLocal();
    notifyListeners();

    try {
      final url = '$_rtdbBaseUrl/$id.json';
      await http.delete(Uri.parse(url));
      _db.collection('admin_users').doc(id).delete();
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
