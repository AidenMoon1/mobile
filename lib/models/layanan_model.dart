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
  final String iconName;

  // KONFIGURASI FIELD FORMULIR PERMOHONAN OLEH ADMIN
  final bool requiresNik;
  final bool requiresNama;
  final bool requiresNoKk;
  final bool requiresNoHp;
  final bool requiresKeterangan;
  final bool requiresUploadDokumen;
  final List<String> customFields;

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
    this.requiresNik = true,
    this.requiresNama = true,
    this.requiresNoKk = true,
    this.requiresNoHp = true,
    this.requiresKeterangan = true,
    this.requiresUploadDokumen = true,
    this.customFields = const [],
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
      'requiresNik': requiresNik ? 1 : 0,
      'requiresNama': requiresNama ? 1 : 0,
      'requiresNoKk': requiresNoKk ? 1 : 0,
      'requiresNoHp': requiresNoHp ? 1 : 0,
      'requiresKeterangan': requiresKeterangan ? 1 : 0,
      'requiresUploadDokumen': requiresUploadDokumen ? 1 : 0,
      'customFieldsJson': customFields.join('|||'),
    };
  }

  factory LayananModel.fromMap(Map<String, dynamic> map) {
    List<String> reqList = [];
    if (map['persyaratanJson'] != null && map['persyaratanJson'].toString().isNotEmpty) {
      reqList = map['persyaratanJson'].toString().split('|||');
    }

    List<String> cfList = [];
    if (map['customFieldsJson'] != null && map['customFieldsJson'].toString().isNotEmpty) {
      cfList = map['customFieldsJson'].toString().split('|||');
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
      requiresNik: map['requiresNik'] == 1 || map['requiresNik'] == true || map['requiresNik'] == null,
      requiresNama: map['requiresNama'] == 1 || map['requiresNama'] == true || map['requiresNama'] == null,
      requiresNoKk: map['requiresNoKk'] == 1 || map['requiresNoKk'] == true || map['requiresNoKk'] == null,
      requiresNoHp: map['requiresNoHp'] == 1 || map['requiresNoHp'] == true || map['requiresNoHp'] == null,
      requiresKeterangan: map['requiresKeterangan'] == 1 || map['requiresKeterangan'] == true || map['requiresKeterangan'] == null,
      requiresUploadDokumen: map['requiresUploadDokumen'] == 1 || map['requiresUploadDokumen'] == true || map['requiresUploadDokumen'] == null,
      customFields: cfList,
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
    bool? requiresNik,
    bool? requiresNama,
    bool? requiresNoKk,
    bool? requiresNoHp,
    bool? requiresKeterangan,
    bool? requiresUploadDokumen,
    List<String>? customFields,
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
      requiresNik: requiresNik ?? this.requiresNik,
      requiresNama: requiresNama ?? this.requiresNama,
      requiresNoKk: requiresNoKk ?? this.requiresNoKk,
      requiresNoHp: requiresNoHp ?? this.requiresNoHp,
      requiresKeterangan: requiresKeterangan ?? this.requiresKeterangan,
      requiresUploadDokumen: requiresUploadDokumen ?? this.requiresUploadDokumen,
      customFields: customFields ?? this.customFields,
    );
  }
}
