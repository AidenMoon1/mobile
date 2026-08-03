class LayananModel {
  final String id;
  final String kodeInstansi; // e.g. 'disdukcapil', 'diskominfo', 'dpmpstp', 'bpkpd', 'dkp3'
  final String sektor; // e.g. 'Keluarga', 'Usaha', 'Lingkungan', 'Pendidikan', 'Kendaraan', 'Kesehatan', etc.
  final String judulLayanan;
  final String rawTitle; // short name e.g. 'KTP Elektronik'
  final String subjudul;
  final String deskripsi;
  final List<String> persyaratan;
  final String urlPortal;
  final String iconName; // asset path or icon identifier

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
  });

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
    };
  }

  factory LayananModel.fromMap(Map<String, dynamic> map) {
    List<String> reqList = [];
    if (map['persyaratanJson'] != null && map['persyaratanJson'].toString().isNotEmpty) {
      reqList = map['persyaratanJson'].toString().split('|||');
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
    );
  }

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
    );
  }
}
