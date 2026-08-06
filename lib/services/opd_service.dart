// =============================================================================
// FILE: lib/services/opd_service.dart
// FUNGSI: Service Master Pengelola Data OPD (Instansi, Layanan Publik, & Sektor)
// PATTERN: Singleton Pattern & Reactive State Management (ChangeNotifier)
// =============================================================================

import 'package:flutter/material.dart';
import '../models/instansi_model.dart';
import '../models/layanan_model.dart';
import '../models/custom_field_config.dart';
import '../models/sektor_model.dart';

/// Kelas Service Master Pengelola Katalog Instansi OPD, Layanan Publik, & Sektor
class OpdService extends ChangeNotifier {
  static final OpdService _instance = OpdService._internal();
  factory OpdService() => _instance;

  OpdService._internal() {
    _initDefaultData();
  }

  final List<InstansiModel> _instansiList = [];
  final List<LayananModel> _layananList = [];
  final List<SektorModel> _sektorList = [];

  // Getter Unmodifiable List untuk Mencegah Mutasi Tidak Sengaja dari Luar Service
  List<InstansiModel> get instansiList => List.unmodifiable(_instansiList);
  List<LayananModel> get layananList => List.unmodifiable(_layananList);
  List<SektorModel> get sektorList => List.unmodifiable(_sektorList);

  /// --------------------------------------------------------------------------
  /// FUNGSI INSIALISASI SEED DATA AWAL (SEKTOR, INSTANSI, & LAYANAN PUBLIK)
  /// --------------------------------------------------------------------------
  void _initDefaultData() {
    if (_instansiList.isNotEmpty) return;

    // 1. Seed 10 Sektor Kategori Utama (Fase Kehidupan)
    _sektorList.addAll([
      SektorModel(
        id: 's1',
        title: 'Keluarga',
        imagePath: 'assets/icon/keluarga.png',
        desc: 'Administrasi Kependudukan, Pernikahan, KK & Akta',
        iconName: 'family_restroom_rounded',
      ),
      SektorModel(
        id: 's2',
        title: 'Pendidikan',
        imagePath: 'assets/icon/pendidikan.png',
        desc: 'Beasiswa, PPDB, Pendaftaran Sekolah',
        iconName: 'school_rounded',
      ),
      SektorModel(
        id: 's3',
        title: 'Usaha',
        imagePath: 'assets/icon/usaha.png',
        desc: 'Izin Usaha, NIB, UMKM Kota Sukabumi',
        iconName: 'store_rounded',
      ),
      SektorModel(
        id: 's4',
        title: 'Lingkungan & Tempat Tinggal',
        imagePath: 'assets/icon/lingkungan.png',
        desc: 'PBB, Kebersihan, Izin Bangunan (PBG)',
        iconName: 'home_work_rounded',
      ),
      SektorModel(
        id: 's5',
        title: 'Kendaraan',
        imagePath: 'assets/icon/kendaraan.png',
        desc: 'Pajak Kendaraan, SIM, Uji KIR',
        iconName: 'directions_car_rounded',
      ),
      SektorModel(
        id: 's6',
        title: 'Kesehatan',
        imagePath: 'assets/icon/kesehatan.png',
        desc: 'BPJS, Puskesmas, Antrean RSUD',
        iconName: 'local_hospital_rounded',
      ),
      SektorModel(
        id: 's7',
        title: 'Tanggap Darurat',
        imagePath: 'assets/icon/tanggapdarurat.png',
        desc: 'BPBD, Pemadam Kebakaran, Ambulans 112',
        iconName: 'warning_amber_rounded',
      ),
      SektorModel(
        id: 's8',
        title: 'Karier',
        imagePath: 'assets/icon/karier.png',
        desc: 'Lowongan Kerja, Pelatihan Disnaker',
        iconName: 'work_rounded',
      ),
      SektorModel(
        id: 's9',
        title: 'Rekreasi',
        imagePath: 'assets/icon/rekreasi.png',
        desc: 'Wisata Kota, Fasilitas Olahraga & Taman',
        iconName: 'sports_soccer_rounded',
      ),
      SektorModel(
        id: 's10',
        title: 'Sosial & Hukum',
        imagePath: 'assets/icon/sosialhukum.png',
        desc: 'Bantuan Sosial, Konsultasi Hukum Warga',
        iconName: 'gavel_rounded',
      ),
    ]);

    // 2. Seed 5 Instansi Utama Pemkot Sukabumi
    _instansiList.addAll([
      InstansiModel(
        id: '1',
        kodeInstansi: 'disdukcapil',
        namaSingkat: 'DISDUKCAPIL',
        namaLengkap: 'Dinas Kependudukan dan Pencatatan Sipil',
        alamat: 'Jl. Bhayangkara No. 202, Kota Sukabumi, Jawa Barat 43121',
        jamOperasional: 'Senin - Jumat | 08.00 - 15.30 WIB',
        kontak: '(0266) 221122 / WA: 0811-2233-4455',
        logoPath: 'assets/images/disduk.png',
        deskripsi:
            'Dinas Kependudukan dan Pencatatan Sipil Kota Sukabumi bertanggung jawab dalam menyelenggarakan urusan pemerintahan bidang kependudukan dan pencatatan sipil secara tertib, efisien, transparan, dan berbasis teknologi digital.',
        mapsQuery: 'Disdukcapil Kota Sukabumi',
        tugasFungsi: [
          'Penerbitan dokumen kependudukan (KTP-el, KK, KIA).',
          'Pencatatan peristiwa penting (Akta Kelahiran, Kematian, Perkawinan).',
          'Pengelolaan data kependudukan skala daerah.',
          'Pelayanan pendaftaran penduduk dan verifikasi identitas warga.',
        ],
      ),
      InstansiModel(
        id: '2',
        kodeInstansi: 'diskominfo',
        namaSingkat: 'DISKOMINFO',
        namaLengkap: 'Dinas Komunikasi dan Informatika',
        alamat: 'Jl. Syamsudin S.H. No. 25, Cikole, Kota Sukabumi, Jawa Barat 43111',
        jamOperasional: 'Senin - Jumat | 08.00 - 16.00 WIB',
        kontak: '(0266) 221888 / diskominfo@sukabumikota.go.id',
        logoPath: 'assets/images/diskominfo.png',
        deskripsi:
            'Dinas Komunikasi dan Informatika Kota Sukabumi mengelola infrastruktur teknologi informasi, komunikasi publik, sistem pemerintahan berbasis elektronik (SPBE), serta pusat tanggap darurat dan keamanan informasi daerah.',
        mapsQuery: 'Diskominfo Kota Sukabumi',
        tugasFungsi: [
          'Pengembangan dan pengelolaan infrastruktur jaringan & SPBE.',
          'Pengelolaan portal resmi & media komunikasi publik Kota Sukabumi.',
          'Penyelenggaraan layanan tanggap darurat Sukabumi Siaga 112.',
          'Pengamanan informasi dan literasi digital masyarakat.',
        ],
      ),
      InstansiModel(
        id: '3',
        kodeInstansi: 'dpmpstp',
        namaSingkat: 'DPMPTSP',
        namaLengkap: 'Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu',
        alamat: 'Jl. Mayjend S. Parman No. 5, Cikole, Kota Sukabumi, Jawa Barat 43114',
        jamOperasional: 'Senin - Jumat | 08.00 - 15.30 WIB',
        kontak: '(0266) 222555 / dpmptsp@sukabumikota.go.id',
        logoPath: 'assets/images/dpmptsp.png',
        deskripsi:
            'DPMPTSP Kota Sukabumi menyelenggarakan pelayanan perizinan dan non-perizinan secara terpadu satu pintu serta memfasilitasi investasi dan kemudahan berusaha bagi UMKM hingga pelaku usaha besar.',
        mapsQuery: 'DPMPTSP Kota Sukabumi',
        tugasFungsi: [
          'Pelayanan perizinan berusaha terintegrasi secara elektronik (OSS RBA).',
          'Penerbitan Izin Persetujuan Bangunan Gedung (PBG) dan Reklame.',
          'Fasilitasi penanaman modal dan promosi investasi daerah.',
          'Pengawasan dan pengendalian pelaksanaan perizinan usaha.',
        ],
      ),
      InstansiModel(
        id: '4',
        kodeInstansi: 'bpkpd',
        namaSingkat: 'BPKPD',
        namaLengkap: 'Badan Pengelola Keuangan dan Pendapatan Daerah',
        alamat: 'Jl. R. Syamsudin S.H. No. 52, Kota Sukabumi, Jawa Barat 43113',
        jamOperasional: 'Senin - Jumat | 08.00 - 15.30 WIB',
        kontak: '(0266) 211999 / bpkpd@sukabumikota.go.id',
        logoPath: 'assets/images/bpkpd.png',
        deskripsi:
            'BPKPD Kota Sukabumi bertugas mengelola pendapatan daerah, Pajak Bumi dan Bangunan (PBB-P2), BPHTB, serta akuntansi dan perbendaharaan keuangan daerah secara akuntabel.',
        mapsQuery: 'BPKPD Kota Sukabumi',
        tugasFungsi: [
          'Pengelolaan Pajak Bumi dan Bangunan (PBB-P2) dan BPHTB.',
          'Pencekan cetak SPPT dan pembayaran pajak daerah online.',
          'Pengelolaan keuangan dan aset daerah Pemkot Sukabumi.',
          'Perumusan kebijakan pendapatan dan belanja daerah.',
        ],
      ),
      InstansiModel(
        id: '5',
        kodeInstansi: 'dkp3',
        namaSingkat: 'DKP3',
        namaLengkap: 'Dinas Ketahanan Pangan, Pertanian dan Perikanan',
        alamat: 'Jl. Raya Cisaat No. 12, Kota Sukabumi, Jawa Barat 43152',
        jamOperasional: 'Senin - Jumat | 08.00 - 15.30 WIB',
        kontak: '(0266) 234567 / dkp3@sukabumikota.go.id',
        logoPath: 'assets/images/dkp3.png',
        deskripsi:
            'DKP3 Kota Sukabumi bertanggung jawab dalam menjaga ketahanan pangan masyarakat, pelayanan kesehatan hewan/vets, bimbingan kelompok tani & pembudidaya ikan daerah.',
        mapsQuery: 'DKP3 Kota Sukabumi',
        tugasFungsi: [
          'Pelayanan kesehatan hewan, imunisasi rabies, dan Puskeswan.',
          'Pemeriksaan keamanan pangan dan pembinaan kelompok tani.',
          'Fasilitasi bantuan bibit pertanian dan perikanan darat.',
          'Pengawasan ketersediaan dan harga pangan strategis.',
        ],
      ),
    ]);

    // 3. Seed Layanan Publik Utama per OPD & Sektor
    _layananList.addAll([
      LayananModel(
        id: '101',
        kodeInstansi: 'disdukcapil',
        sektor: 'Keluarga',
        judulLayanan: 'Pelayanan KTP Elektronik (KTP-el)',
        rawTitle: 'KTP Elektronik',
        subjudul: 'Perekaman baru, penggantian KTP rusak/hilang, dan pemutakhiran data KTP.',
        deskripsi:
            'Layanan penerbitan KTP Elektronik bagi warga Kota Sukabumi yang telah berusia 17 tahun atau sudah menikah. Mencakup pendaftaran baru, penggantian fisik KTP rusak/hilang, serta pencetakan ulang.',
        persyaratan: [
          'Fotokopi Kartu Keluarga (KK) terbaru.',
          'KTP lama yang rusak (jika penggantian KTP rusak).',
          'Surat Keterangan Kehilangan dari Kepolisian (jika KTP hilang).',
          'Pasfoto ukuran 3x4 atau foto langsung di lokasi pelayanan.',
        ],
        urlPortal: 'https://disdukcapil.sukabumikota.go.id',
        iconName: 'badge_outlined',
        formFields: [
          CustomFieldConfig(id: 'f1', label: 'NIK Pemohon (16 Digit)', type: FieldType.number, hint: 'Masukkan 16 digit NIK'),
          CustomFieldConfig(id: 'f2', label: 'Nama Lengkap Pemohon', type: FieldType.shortText, hint: 'Sesuai KTP / Akta'),
          CustomFieldConfig(id: 'f3', label: 'Jenis Permohonan KTP', type: FieldType.dropdown, options: ['Perekaman Baru (Pemula 17 Th)', 'Ganti KTP Rusak', 'Ganti KTP Hilang', 'Aktivasi KTP Digital (IKD)']),
          CustomFieldConfig(id: 'f4', label: 'Nomor Kartu Keluarga (KK)', type: FieldType.number, hint: 'Masukkan 16 digit No. KK'),
          CustomFieldConfig(id: 'f5', label: 'Nomor WhatsApp / HP', type: FieldType.number, hint: 'Contoh: 081234567890'),
          CustomFieldConfig(id: 'f6', label: 'Alasan / Keterangan Tambahan', type: FieldType.longText, hint: 'Jelaskan alasan permohonan...'),
          CustomFieldConfig(id: 'f7', label: 'Unggah Lampiran Berkas Syarat', type: FieldType.fileUpload),
        ],
      ),
      LayananModel(
        id: '102',
        kodeInstansi: 'disdukcapil',
        sektor: 'Keluarga',
        judulLayanan: 'Kartu Keluarga (KK)',
        rawTitle: 'Kartu Keluarga (KK)',
        subjudul: 'Penerbitan KK baru, penambahan anggota keluarga, dan perubahan data KK.',
        deskripsi:
            'Layanan pembuatan Kartu Keluarga baru karena pernikahan, kelahiran anak, kepindahan penduduk, maupun perubahan status kependudukan warga Kota Sukabumi.',
        persyaratan: [
          'Buku Nikah / Akta Perkawinan (bagi keluarga baru).',
          'Surat Keterangan Lahir dari Bidan/Rumah Sakit (jika tambah anggota).',
          'Kartu Keluarga asli lama.',
          'Surat Pindah (SKPWNI) jika pindah datang dari luar kota.',
        ],
        urlPortal: 'https://disdukcapil.sukabumikota.go.id',
        iconName: 'family_restroom_outlined',
        formFields: [
          CustomFieldConfig(id: 'f10', label: 'NIK Kepala Keluarga', type: FieldType.number, hint: 'Masukkan 16 digit NIK'),
          CustomFieldConfig(id: 'f11', label: 'Nama Lengkap Kepala Keluarga', type: FieldType.shortText, hint: 'Sesuai KTP'),
          CustomFieldConfig(id: 'f12', label: 'Nomor Kartu Keluarga Lama', type: FieldType.number, hint: 'Masukkan 16 digit No. KK lama'),
          CustomFieldConfig(id: 'f13', label: 'Alasan Permohonan KK', type: FieldType.dropdown, options: ['Keluarga Baru (Pernikahan)', 'Penambahan Anggota (Kelahiran)', 'Perubahan Data Alamat/Pekerjaan', 'KK Rusak / Hilang']),
          CustomFieldConfig(id: 'f14', label: 'Alamat Rumah Lengkap', type: FieldType.longText, hint: 'RT/RW, Kelurahan, Kecamatan, Kota Sukabumi'),
          CustomFieldConfig(id: 'f15', label: 'Unggah Berkas Persyaratan (KK/Buku Nikah)', type: FieldType.fileUpload),
        ],
      ),
      LayananModel(
        id: '201',
        kodeInstansi: 'dpmpstp',
        sektor: 'Usaha',
        judulLayanan: 'Perizinan Berusaha OSS RBA (NIB)',
        rawTitle: 'NIB & Izin Usaha (OSS RBA)',
        subjudul: 'Penerbitan Nomor Induk Berusaha (NIB) dan izin operasional UMKM hingga usaha besar.',
        deskripsi:
            'Layanan pengurusan perizinan berusaha terintegrasi secara elektronik bagi pelaku usaha di Kota Sukabumi untuk memperoleh NIB resmi dari pemerintah.',
        persyaratan: [
          'KTP / NIK Pelaku Usaha.',
          'Nomor WhatsApp & Email Aktif.',
          'Data Alamat dan Deskripsi Kegiatan Usaha (KBLI).',
          'NPWP Badan (khusus PT/CV/Koperasi).',
        ],
        urlPortal: 'https://oss.go.id',
        iconName: 'store_rounded',
        formFields: [
          CustomFieldConfig(id: 'f20', label: 'NIK Pemilik Usaha', type: FieldType.number, hint: '16 digit NIK'),
          CustomFieldConfig(id: 'f21', label: 'Nama Lengkap Pemilik Usaha', type: FieldType.shortText, hint: 'Sesuai KTP'),
          CustomFieldConfig(id: 'f22', label: 'Nama Usaha / Toko / Perusahaan', type: FieldType.shortText, hint: 'Contoh: Toko Berkah Mandiri'),
          CustomFieldConfig(id: 'f23', label: 'Skala Usaha', type: FieldType.dropdown, options: ['Mikro (Modal <= 1 Miliar)', 'Kecil (Modal 1 - 5 Miliar)', 'Menengah (Modal 5 - 10 Miliar)', 'Besar (Modal > 10 Miliar)']),
          CustomFieldConfig(id: 'f24', label: 'Alamat Lokasi Usaha', type: FieldType.longText, hint: 'Jalan, RT/RW, Kelurahan'),
          CustomFieldConfig(id: 'f25', label: 'Tanggal Memulai Usaha', type: FieldType.datePicker, hint: 'Pilih tanggal mulai berdiri'),
          CustomFieldConfig(id: 'f26', label: 'Nomor WhatsApp Pemilik', type: FieldType.number, hint: '081234567890'),
          CustomFieldConfig(id: 'f27', label: 'Unggah Foto Lokasi / KTP', type: FieldType.fileUpload),
        ],
      ),
    ]);
  }

  // --- FUNGSI OPERASI CRUD SEKTOR ---
  List<SektorModel> getSektorList() => _sektorList;

  SektorModel? getSektorById(String id) {
    try {
      return _sektorList.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void addSektor(SektorModel item) {
    _sektorList.add(item);
    notifyListeners();
  }

  void updateSektor(SektorModel updated) {
    int idx = _sektorList.indexWhere((e) => e.id == updated.id);
    if (idx != -1) {
      _sektorList[idx] = updated;
      notifyListeners();
    }
  }

  void deleteSektor(String id) {
    _sektorList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // --- FUNGSI OPERASI CRUD INSTANSI ---
  List<InstansiModel> getInstansiList() => _instansiList;

  InstansiModel? getInstansiByKode(String kode) {
    try {
      return _instansiList.firstWhere(
        (e) => e.kodeInstansi.toLowerCase() == kode.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  void addInstansi(InstansiModel item) {
    _instansiList.add(item);
    notifyListeners();
  }

  void updateInstansi(InstansiModel updated) {
    int idx = _instansiList.indexWhere((e) => e.id == updated.id);
    if (idx != -1) {
      _instansiList[idx] = updated;
      notifyListeners();
    }
  }

  void deleteInstansi(String id) {
    _instansiList.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // --- FUNGSI OPERASI CRUD LAYANAN ---
  List<LayananModel> getLayananList() => _layananList;

  List<LayananModel> getLayananByInstansi(String kodeInstansi) {
    return _layananList
        .where((e) => e.kodeInstansi.toLowerCase() == kodeInstansi.toLowerCase())
        .toList();
  }

  List<LayananModel> getLayananBySektor(String sektor) {
    return _layananList
        .where((e) => e.sektor.toLowerCase().contains(sektor.toLowerCase()) ||
            sektor.toLowerCase().contains(e.sektor.toLowerCase()))
        .toList();
  }

  void addLayanan(LayananModel item) {
    _layananList.add(item);
    notifyListeners();
  }

  void updateLayanan(LayananModel updated) {
    int idx = _layananList.indexWhere((e) => e.id == updated.id);
    if (idx != -1) {
      _layananList[idx] = updated;
      notifyListeners();
    }
  }

  void deleteLayanan(String id) {
    _layananList.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
