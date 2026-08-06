// =============================================================================
// FILE: lib/models/layanan_model.dart
// FUNGSI: Data Model untuk Katalog Layanan Publik & Formulir Pengajuan Digital
// PATTERN: Data Transfer Object (DTO) dengan Mesin Custom Dynamic Form Fields & Mode iFrame
// LEVEL KODE: Level 2-3 (Sangat Rapi & Terstruktur Untuk Mahasiswa)
// =============================================================================

import 'custom_field_config.dart';

/// Kelas Model Representasi Butir Layanan Publik (KTP, PBB, Perizinan PBG, dll)
class LayananModel {
  final String id;           // ID Unik Layanan
  final String kodeInstansi; // Kode OPD Pemilik (misal: 'disdukcapil', 'dpmptsp')
  final String sektor;       // Kategori Sektor Fase Kehidupan (misal: 'Keluarga', 'Usaha')
  final String judulLayanan; // Judul lengkap layanan publik
  final String rawTitle;     // Nama singkat layanan (misal: 'KTP Elektronik')
  final String subjudul;     // Subjudul ringkas layanan
  final String deskripsi;    // Deskripsi rincian prosedur layanan
  final List<String> persyaratan; // Syarat dokumen yang dibutuhkan
  final String urlPortal;    // Tautan web resmi instansi
  final String iconName;     // Nama ikon pemetakan visual
  final bool isIframeMode;   // Flag apakah pengeditan formulir menggunakan iFrame Web Dinas
  final String iframeUrl;    // Link URL / HTML iFrame Web Dinas

  // MESIN FORM BUILDER: Daftar Element Form Dinamis Yang Dibuat Admin
  final List<CustomFieldConfig> formFields;

  LayananModel({
    required this.id,
    required this.kodeInstansi,
    required this.sektor,
    required this.judulLayanan,
    required this.rawTitle,
    required this.subjudul,
    required this.deskripsi,
    required this.persyaratan,
    required this.urlPortal,
    required this.iconName,
    this.isIframeMode = false,
    this.iframeUrl = '',
    this.formFields = const [],
  });

  // FUNGSI 1: Mengubah Objek LayananModel Menjadi Map (Untuk Disimpan ke Database SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kodeInstansi': kodeInstansi,
      'sektor': sektor,
      'judulLayanan': judulLayanan,
      'rawTitle': rawTitle,
      'subjudul': subjudul,
      'deskripsi': deskripsi,
      'persyaratanJson': persyaratan.join('|||'),
      'urlPortal': urlPortal,
      'iconName': iconName,
      'isIframeMode': isIframeMode ? 1 : 0,
      'iframeUrl': iframeUrl,
      'formFieldsJson': formFields.map((f) => f.toMap()).toList(),
    };
  }

  // FUNGSI 2: Mengubah Map Database SQLite Kembali Menjadi Objek LayananModel
  factory LayananModel.fromMap(Map<String, dynamic> map) {
    List<String> reqList = [];
    if (map['persyaratanJson'] != null && map['persyaratanJson'].toString().isNotEmpty) {
      reqList = map['persyaratanJson'].toString().split('|||');
    }

    List<CustomFieldConfig> fieldsList = [];
    if (map['formFieldsJson'] != null) {
      if (map['formFieldsJson'] is List) {
        fieldsList = (map['formFieldsJson'] as List)
            .map((e) => CustomFieldConfig.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    return LayananModel(
      id: map['id'] ?? '',
      kodeInstansi: map['kodeInstansi'] ?? '',
      sektor: map['sektor'] ?? '',
      judulLayanan: map['judulLayanan'] ?? '',
      rawTitle: map['rawTitle'] ?? '',
      subjudul: map['subjudul'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      persyaratan: reqList,
      urlPortal: map['urlPortal'] ?? '',
      iconName: map['iconName'] ?? '',
      isIframeMode: map['isIframeMode'] == 1 || map['isIframeMode'] == true,
      iframeUrl: map['iframeUrl'] ?? '',
      formFields: fieldsList,
    );
  }

  // FUNGSI 3: Membuat Salinan Objek dengan Beberapa Parameter Diperbarui (Immutable State)
  LayananModel copyWith({
    String? id,
    String? kodeInstansi,
    String? sektor,
    String? judulLayanan,
    String? rawTitle,
    String? subjudul,
    String? deskripsi,
    List<String>? persyaratan,
    String? urlPortal,
    String? iconName,
    bool? isIframeMode,
    String? iframeUrl,
    List<CustomFieldConfig>? formFields,
  }) {
    return LayananModel(
      id: id ?? this.id,
      kodeInstansi: kodeInstansi ?? this.kodeInstansi,
      sektor: sektor ?? this.sektor,
      judulLayanan: judulLayanan ?? this.judulLayanan,
      rawTitle: rawTitle ?? this.rawTitle,
      subjudul: subjudul ?? this.subjudul,
      deskripsi: deskripsi ?? this.deskripsi,
      persyaratan: persyaratan ?? this.persyaratan,
      urlPortal: urlPortal ?? this.urlPortal,
      iconName: iconName ?? this.iconName,
      isIframeMode: isIframeMode ?? this.isIframeMode,
      iframeUrl: iframeUrl ?? this.iframeUrl,
      formFields: formFields ?? this.formFields,
    );
  }
}
