// =============================================================================
// FILE: lib/models/admin_user_model.dart
// FUNGSI: Data Model Pengelola Akun Administrator & Superadmin
// =============================================================================

class AdminUserModel {
  final String id;
  final String nama;
  final String email;
  final String nip;
  final String instansi; // Misal: "SUPERADMIN", "DISDUKCAPIL", "DISKOMINFO", dll.
  final String role; // "Super Admin" atau "Admin OPD"
  final bool isActive;
  final DateTime createdAt;

  AdminUserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.nip,
    required this.instansi,
    required this.role,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'nip': nip,
      'instansi': instansi,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AdminUserModel.fromMap(Map<String, dynamic> map) {
    return AdminUserModel(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      nip: map['nip'] ?? '',
      instansi: map['instansi'] ?? 'DISKOMINFO',
      role: map['role'] ?? 'Admin OPD',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  AdminUserModel copyWith({
    String? id,
    String? nama,
    String? email,
    String? nip,
    String? instansi,
    String? role,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return AdminUserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      nip: nip ?? this.nip,
      instansi: instansi ?? this.instansi,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
