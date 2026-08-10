// =============================================================================
// FILE: lib/models/sektor_model.dart
// FUNGSI: Data Model untuk Sektor Fase Kehidupan (Keluarga, Usaha, Pendidikan, dll)
// PATTERN: Data Model dengan Persistensi Map & SQLite
// =============================================================================

/// Kelas Model Representasi Butir Sektor Portal Layanan Publik
class SektorModel {
  final String id;        // ID Unik Sektor
  final String title;     // Nama Sektor (misal: 'Keluarga', 'Usaha', 'Lingkungan')
  final String imagePath; // Jalur Gambar Ikon Sektor
  final String desc;      // Deskripsi Singkat Cakupan Layanan Sektor
  final String iconName;  // Nama Ikon Pemetakan Visual
  final bool isActive;    // Status Aktif / Maintenance Sektor

  SektorModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.desc,
    required this.iconName,
    this.isActive = true,
  });

  // FUNGSI 1: Mengubah Objek SektorModel Menjadi Map (Untuk Disimpan ke SQLite / Local State)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'desc': desc,
      'iconName': iconName,
      'isActive': isActive ? 1 : 0,
    };
  }

  // FUNGSI 2: Mengubah Map Database Kembali Menjadi Objek SektorModel
  factory SektorModel.fromMap(Map<String, dynamic> map) {
    return SektorModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      imagePath: map['imagePath']?.toString() ?? 'assets/icon/keluarga.png',
      desc: map['desc']?.toString() ?? '',
      iconName: map['iconName']?.toString() ?? 'category',
      isActive: map['isActive'] == null || map['isActive'] == 1 || map['isActive'] == true,
    );
  }

  // FUNGSI 3: Membuat Salinan Objek dengan Beberapa Parameter Diperbarui (Immutable State)
  SektorModel copyWith({
    String? id,
    String? title,
    String? imagePath,
    String? desc,
    String? iconName,
    bool? isActive,
  }) {
    return SektorModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      desc: desc ?? this.desc,
      iconName: iconName ?? this.iconName,
      isActive: isActive ?? this.isActive,
    );
  }
}
