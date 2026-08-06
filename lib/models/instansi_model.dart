// =============================================================================
// FILE: lib/models/instansi_model.dart
// FUNGSI: Data Model untuk Instansi OPD (Organisasi Perangkat Daerah) Kota Sukabumi
// PATTERN: Data Model dengan toMap() & fromMap() untuk Persistensi SQLite
// =============================================================================

/// Kelas Model Representasi Data Instansi OPD (Disdukcapil, DPMPTSP, Diskominfo, dll)
class InstansiModel {
  final String id;              // ID unik instansi
  final String kodeInstansi;    // Kode singkatan instansi (misal: 'disdukcapil')
  final String namaSingkat;     // Nama singkat OPD (misal: 'DISDUKCAPIL')
  final String namaLengkap;     // Nama resmi lengkap OPD
  final String alamat;          // Alamat fisik kantor OPD
  final String jamOperasional;  // Jam & hari layanan operasional
  final String kontak;          // Nomor telepon / WhatsApp resmi
  final String logoPath;        // Jalur gambar logo instansi
  final String deskripsi;       // Deskripsi profil instansi
  final String mapsQuery;       // Query pencarian lokasi di Google Maps
  final List<String> tugasFungsi;// Daftar rincian tugas & fungsi OPD

  InstansiModel({
    required this.id,
    required this.kodeInstansi,
    required this.namaSingkat,
    required this.namaLengkap,
    required this.alamat,
    required this.jamOperasional,
    required this.kontak,
    required this.logoPath,
    required this.deskripsi,
    required this.mapsQuery,
    required this.tugasFungsi,
  });

  // FUNGSI 1: Mengubah Objek InstansiModel Menjadi Map (Untuk Disimpan ke Database SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kodeInstansi': kodeInstansi,
      'namaSingkat': namaSingkat,
      'namaLengkap': namaLengkap,
      'alamat': alamat,
      'jamOperasional': jamOperasional,
      'kontak': kontak,
      'logoPath': logoPath,
      'deskripsi': deskripsi,
      'mapsQuery': mapsQuery,
      'tugasFungsiJson': tugasFungsi.join('|||'),
    };
  }

  // FUNGSI 2: Mengubah Map Database SQLite Kembali Menjadi Objek InstansiModel
  factory InstansiModel.fromMap(Map<String, dynamic> map) {
    List<String> tfList = [];
    if (map['tugasFungsiJson'] != null && map['tugasFungsiJson'].toString().isNotEmpty) {
      tfList = map['tugasFungsiJson'].toString().split('|||');
    }
    return InstansiModel(
      id: map['id'] ?? '',
      kodeInstansi: map['kodeInstansi'] ?? '',
      namaSingkat: map['namaSingkat'] ?? '',
      namaLengkap: map['namaLengkap'] ?? '',
      alamat: map['alamat'] ?? '',
      jamOperasional: map['jamOperasional'] ?? '',
      kontak: map['kontak'] ?? '',
      logoPath: map['logoPath'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      mapsQuery: map['mapsQuery'] ?? '',
      tugasFungsi: tfList,
    );
  }

  // FUNGSI 3: Membuat Salinan Objek dengan Beberapa Parameter Diperbarui (Immutable State)
  InstansiModel copyWith({
    String? id,
    String? kodeInstansi,
    String? namaSingkat,
    String? namaLengkap,
    String? alamat,
    String? jamOperasional,
    String? kontak,
    String? logoPath,
    String? deskripsi,
    String? mapsQuery,
    List<String>? tugasFungsi,
  }) {
    return InstansiModel(
      id: id ?? this.id,
      kodeInstansi: kodeInstansi ?? this.kodeInstansi,
      namaSingkat: namaSingkat ?? this.namaSingkat,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      alamat: alamat ?? this.alamat,
      jamOperasional: jamOperasional ?? this.jamOperasional,
      kontak: kontak ?? this.kontak,
      logoPath: logoPath ?? this.logoPath,
      deskripsi: deskripsi ?? this.deskripsi,
      mapsQuery: mapsQuery ?? this.mapsQuery,
      tugasFungsi: tugasFungsi ?? this.tugasFungsi,
    );
  }
}
