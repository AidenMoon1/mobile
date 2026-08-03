import 'package:flutter/material.dart';
import '../models/instansi_model.dart';
import '../models/layanan_model.dart';

class OpdService extends ChangeNotifier {
  static final OpdService _instance = OpdService._internal();
  factory OpdService() => _instance;

  OpdService._internal() {
    _initDefaultData();
  }

  final List<InstansiModel> _instansiList = [];
  final List<LayananModel> _layananList = [];

  List<InstansiModel> get instansiList => List.unmodifiable(_instansiList);
  List<LayananModel> get layananList => List.unmodifiable(_layananList);

  void _initDefaultData() {
    if (_instansiList.isNotEmpty) return;

    // Seed 5 Instansi Utama Pemkot Sukabumi
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

    // Seed Layanan Publik Utama per OPD & Sektor
    _layananList.addAll([
      // Disdukcapil (Keluarga)
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
      ),
      LayananModel(
        id: '103',
        kodeInstansi: 'disdukcapil',
        sektor: 'Keluarga',
        judulLayanan: 'Akta Kelahiran & Akta Kematian',
        rawTitle: 'Akta Kelahiran / Kematian',
        subjudul: 'Pencatatan kelahiran bayi baru lahir serta penerbitan akta kematian resmi.',
        deskripsi:
            'Layanan pencatatan sipil untuk penerbitan Akta Kelahiran anak baru lahir dan Akta Kematian warga Kota Sukabumi guna tertib administrasi kependudukan.',
        persyaratan: [
          'Surat Keterangan Lahir dari Dokter/Bidan/Rumah Sakit.',
          'Fotokopi KTP kedua orang tua & KTP 2 orang saksi.',
          'Buku Nikah / Akta Perkawinan Orang Tua.',
          'Kartu Keluarga (KK) Asli.',
        ],
        urlPortal: 'https://disdukcapil.sukabumikota.go.id',
        iconName: 'child_care_rounded',
      ),
      LayananModel(
        id: '104',
        kodeInstansi: 'disdukcapil',
        sektor: 'Keluarga',
        judulLayanan: 'Kartu Identitas Anak (KIA)',
        rawTitle: 'Kartu Identitas Anak (KIA)',
        subjudul: 'Penerbitan kartu identitas resmi bagi anak usia 0 hingga 17 tahun kurang satu hari.',
        deskripsi:
            'Layanan penerbitan Kartu Identitas Anak (KIA) yang berfungsi sebagai identitas resmi anak untuk keperluan penerbangan, sekolah, perbankan, dan medis.',
        persyaratan: [
          'Fotokopi Akta Kelahiran Anak.',
          'Fotokopi Kartu Keluarga (KK) Orang Tua.',
          'Pasfoto anak ukuran 2x3 sebanyak 2 lembar (untuk anak usia 5-17 tahun).',
        ],
        urlPortal: 'https://disdukcapil.sukabumikota.go.id',
        iconName: 'face_rounded',
      ),

      // DPMPTSP (Usaha & Lingkungan)
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
      ),
      LayananModel(
        id: '202',
        kodeInstansi: 'dpmpstp',
        sektor: 'Lingkungan & Tempat Tinggal',
        judulLayanan: 'Persetujuan Bangunan Gedung (PBG)',
        rawTitle: 'Izin Bangunan Gedung (PBG)',
        subjudul: 'Permohonan persetujuan teknis dan izin konstruksi renovasi/pembangunan gedung.',
        deskripsi:
            'Penerbitan dokumen resmi Persetujuan Bangunan Gedung (pengganti IMB) untuk memastikan keandalan bangunan gedung di Kota Sukabumi.',
        persyaratan: [
          'Sertifikat Tanah / Bukti Kepemilikan Lahan.',
          'Gambar Rencana Teknis Arsitektur & Struktur.',
          'Dokumen Lingkungan (SPPL/UKL-UPL jika dipersyaratkan).',
          'KTP Pemilik Bangunan.',
        ],
        urlPortal: 'https://simbg.pu.go.id',
        iconName: 'home_work_rounded',
      ),

      // Diskominfo (Tanggap Darurat & Rekreasi)
      LayananModel(
        id: '301',
        kodeInstansi: 'diskominfo',
        sektor: 'Tanggap Darurat',
        judulLayanan: 'Sukabumi Siaga 112',
        rawTitle: 'Panggilan Darurat 112',
        subjudul: 'Layanan bebas pulsa 24 jam untuk kondisi darurat kebakaran, bencana, dan medis.',
        deskripsi:
            'Pusat bantuan darurat terpadu Kota Sukabumi untuk menangani laporan kebakaran, kecelakaan lalu lintas, bencana alam, serta permintaan ambulans gratis.',
        persyaratan: [
          'Telepon langsung ke nomor 112 (Bebas Pulsa / Bebas Kuota).',
          'Sampaikan lokasi kejadian dan nama pelapor secara jelas.',
        ],
        urlPortal: 'tel:112',
        iconName: 'warning_amber_rounded',
      ),

      // BPKPD (Lingkungan & Keuangan)
      LayananModel(
        id: '401',
        kodeInstansi: 'bpkpd',
        sektor: 'Lingkungan & Tempat Tinggal',
        judulLayanan: 'Pelayanan Pajak Bumi dan Bangunan (PBB-P2)',
        rawTitle: 'Layanan PBB-P2 Sukabumi',
        subjudul: 'Pengecekan tagihan, cetak SPPT PBB, pemutakhiran nama wajib pajak, dan konsultasi.',
        deskripsi:
            'Layanan pengelolaan Pajak Bumi dan Bangunan Perdesaan dan Perkotaan Kota Sukabumi secara transparan dan mudah dilakukan dari mana saja.',
        persyaratan: [
          'Nomor Objek Pajak (NOP) PBB.',
          'Fotokopi KTP Wajib Pajak.',
          'Fotokopi Sertifikat Tanah / Akta Jual Beli.',
          'Bukti Pelunasan PBB Tahun Sebelumnya.',
        ],
        urlPortal: 'https://bpkpd.sukabumikota.go.id',
        iconName: 'receipt_long_rounded',
      ),

      // DKP3 (Kesehatan & Lingkungan)
      LayananModel(
        id: '501',
        kodeInstansi: 'dkp3',
        sektor: 'Kesehatan',
        judulLayanan: 'Pelayanan Kesehatan Hewan & Puskeswan',
        rawTitle: 'Puskeswan & Kesehatan Hewan',
        subjudul: 'Pemeriksaan kesehatan hewan peliharaan, imunisasi rabies, dan pengobatan ternak.',
        deskripsi:
            'Layanan medik veteriner gratis / terjangkau bagi hewan peliharaan dan hewan ternak milik warga Kota Sukabumi oleh dokter hewan resmi DKP3.',
        persyaratan: [
          'KTP Pemilik / Pemegang Hewan Kota Sukabumi.',
          'Buku Kesehatan Hewan (jika ada).',
          'Membawa hewan langsung ke lokasi Puskeswan.',
        ],
        urlPortal: 'https://dkp3.sukabumikota.go.id',
        iconName: 'pets_rounded',
      ),
    ]);
  }

  // --- CRUD INSTANSI ---
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

  // --- CRUD LAYANAN ---
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
