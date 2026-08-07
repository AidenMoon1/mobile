// =============================================================================
// FILE: lib/models/news.dart
// FUNGSI: Data Model untuk Berita Publik & Pengumuman Kota Sukabumi
// PATTERN: Data Transfer Object (DTO) dengan JSON Parsing
// =============================================================================

/// Kelas Model Representasi Butir Berita Publik Sukabumi
class News {
  final int id;             // ID Unik Berita
  final String title;       // Judul Utama Berita
  final String content;     // Isi Lengkap Konten Berita
  final String? imageUrl;   // URL Gambar Ilustrasi Berita (Opsional)
  final String createdAt;  // Tanggal & Waktu Publikasi Berita

  News({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  // FUNGSI 1: Mengubah Data JSON dari Server REST API Menjadi Objek News
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  // FUNGSI 2: Mengubah Objek News Kembali Menjadi Map / JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'created_at': createdAt,
    };
  }
}
