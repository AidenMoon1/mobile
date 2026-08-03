class InstansiModel {
  final String id;
  final String kodeInstansi;
  final String namaSingkat;
  final String namaLengkap;
  final String alamat;
  final String jamOperasional;
  final String kontak;
  final String logoPath;
  final String deskripsi;
  final String mapsQuery;
  final List<String> tugasFungsi;

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
