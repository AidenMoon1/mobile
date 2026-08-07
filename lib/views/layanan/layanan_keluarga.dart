import 'package:flutter/material.dart';
import 'package:mobile/views/instansi/mocilegit_webview_screen.dart';
import 'package:mobile/widgets/guest_gatekeeper.dart';

class LayananKeluargaScreen extends StatelessWidget {
  const LayananKeluargaScreen({super.key});

  void _tampilkanDialogRedireksi(BuildContext context, String judulLayanan, String urlPortal) {
    const Color primaryColor = Color(0xFF123457);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: primaryColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Layanan Digital Resmi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Anda akan diarahkan ke Formulir Permohonan Digital "$judulLayanan" resmi terpadu.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.black87,
                  height: 1.45,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),

              // TOMBOL LANJUTKAN NAVY
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup Dialog

                    // NAVIGASI LANGSUNG KE FORMULIR DIGITAL IN-APP WEBVIEW MOCILEGIT
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MocilegitWebviewScreen(
                          title: 'Pengajuan $judulLayanan',
                          url: urlPortal,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _subLayanan = const [
    {
      'title': 'KTP-el',
      'desc': 'Layanan Kado Terindah',
      'icon': Icons.badge_rounded,
      'subjudul': 'Layanan Kado Terindah - Disdukcapil',
      'deskripsiTentang':
          'Layanan Kado Terindah (Penerbitan KTP-el) untuk pencetakan ulang KTP-el karena rusak/hilang, pembaharuan data elemen KTP, dan registrasi Identitas Kependudukan Digital (IKD).',
      'persyaratan': [
        'Fotokopi Kartu Keluarga (KK) Terbaru',
        'KTP Lama (Jika Rusak / Ganti Elemen)',
        'Surat Keterangan Kehilangan dari Kepolisian (Jika KTP Hilang)',
        'Foto Bukti Fisik KTP Rusak (Jika Rusak)',
      ],
      'urlPortal': 'https://mocilegit.sukabumikota.go.id/pengajuan/ktp',
    },
    {
      'title': 'Kartu Keluarga (KK)',
      'desc': 'Layanan Kami Hebat',
      'icon': Icons.family_restroom_rounded,
      'subjudul': 'Layanan Kami Hebat - Disdukcapil',
      'deskripsiTentang':
          'Layanan Kami Hebat (Penerbitan KK) untuk keluarga baru, penambahan anggota keluarga (kelahiran), atau pengurangan anggota keluarga.',
      'persyaratan': [
        'Surat Pengantar RT / RW / Kelurahan',
        'Buku Nikah / Kutipan Akta Perkawinan (Orang Tua)',
        'Surat Keterangan Lahir (Untuk Penambahan Anggota)',
        'KK Lama (Jika ada pembaharuan data)',
      ],
      'urlPortal': 'https://mocilegit.sukabumikota.go.id/pengajuan/kk',
    },
    {
      'title': 'Kartu Identitas Anak (KIA)',
      'desc': 'Layanan Kita Cerdas',
      'icon': Icons.child_care_rounded,
      'subjudul': 'Layanan Kita Cerdas - Disdukcapil',
      'deskripsiTentang':
          'Layanan Kita Cerdas (Penerbitan KIA) merupakan identitas resmi anak usia 0 hingga kurang dari 17 tahun untuk memenuhi hak kependudukan anak.',
      'persyaratan': [
        'Fotokopi Akta Kelahiran Anak',
        'Fotokopi Kartu Keluarga (KK) Orang Tua',
        'Fotokopi KTP Kedua Orang Tua',
        'Pas Foto Anak Ukuran 2x3 (Untuk Anak Usia > 5 Tahun)',
      ],
      'urlPortal': 'https://mocilegit.sukabumikota.go.id/pengajuan/kia',
    },
    {
      'title': 'Pindah Datang',
      'desc': 'Patepang Sono',
      'icon': Icons.move_to_inbox_rounded,
      'subjudul': 'Patepang Sono - Disdukcapil',
      'deskripsiTentang':
          'Layanan Patepang Sono (Pengurusan Surat Keterangan Pindah Datang WNI / SKPWNI) untuk kepindahan domisili antar kelurahan, kecamatan, kota, maupun provinsi.',
      'persyaratan': [
        'Kartu Keluarga (KK) Asli & Fotokopi',
        'KTP-el Asli yang Berpindah',
        'Alamat Lengkap Tujuan Pindah (RT/RW, Desa, Kec, Kab/Kota)',
      ],
      'urlPortal': 'https://mocilegit.sukabumikota.go.id/pengajuan/pindah',
    },
    {
      'title': 'Akta Kelahiran',
      'desc': 'Layanan Ananda Sehat',
      'icon': Icons.child_friendly_rounded,
      'subjudul': 'Layanan Ananda Sehat - Disdukcapil',
      'deskripsiTentang':
          'Layanan Ananda Sehat (Penerbitan Akta Kelahiran) resmi dari Disdukcapil sebagai bukti sah status hukum kependudukan anak di Kota Sukabumi.',
      'persyaratan': [
        'Surat Keterangan Lahir dari Bidan / Rumah Sakit',
        'Fotokopi Buku Nikah / Akta Perkawinan Orang Tua',
        'Fotokopi Kartu Keluarga (KK)',
        'Fotokopi KTP Orang Tua & 2 Orang Saksi',
      ],
      'urlPortal': 'https://mocilegit.sukabumikota.go.id/pengajuan/kelahiran',
    },
    {
      'title': 'Akta Kematian',
      'desc': 'Layanan Kemboja Sari',
      'icon': Icons.description_rounded,
      'subjudul': 'Layanan Kemboja Sari - Disdukcapil',
      'deskripsiTentang':
          'Layanan Kemboja Sari (Penerbitan Akta Kematian) sebagai bukti sah kematian warga untuk kepengurusan ahli waris, perbankan, dan pemutakhiran data KK.',
      'persyaratan': [
        'Surat Keterangan Kematian dari Dokter / Rumah Sakit / Kelurahan',
        'Kartu Keluarga (KK) Asli Almarhum/Almarhumah',
        'KTP-el Asli Almarhum/Almarhumah',
        'Fotokopi KTP Pelapor & 2 Saksi Kematian',
      ],
      'urlPortal': 'https://mocilegit.sukabumikota.go.id/dashboard',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF123457),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sektor Keluarga',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER HERO KELUARGA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: const Color(0xFF123457),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFAC33), width: 1.5),
                    ),
                    child: const Icon(
                      Icons.family_restroom_rounded,
                      color: Color(0xFF123457),
                      size: 38,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KELUARGA',
                          style: TextStyle(
                            color: Color(0xFFFFAC33),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Layanan Administrasi Kependudukan, Pernikahan, KK, KTP & Akta Sipil',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Jenis Layanan Keluarga',
                    style: TextStyle(
                      color: Color(0xFF123457),
                      fontSize: 16.5,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Setiap pengajuan dapat dipantau statusnya secara real-time melalui sistem digital.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // GRID SUB-LAYANAN KELUARGA (2-PART CARD DESIGN DENGAN SEJAJAR 64PX)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _subLayanan.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemBuilder: (context, index) {
                      final item = _subLayanan[index];

                      return GestureDetector(
                        onTap: () {
                          GuestGatekeeper.checkAccess(
                            context,
                            onGranted: () {
                              _tampilkanDialogRedireksi(
                                context,
                                item['title'] as String,
                                item['urlPortal'] as String,
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF123457), width: 1.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x20000000),
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              // BAGIAN ATAS (NAVY DENGAN IKON EMAS)
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF123457),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      item['icon'] as IconData,
                                      color: const Color(0xFFE8A33D),
                                      size: 58,
                                    ),
                                  ),
                                ),
                              ),

                              // BAGIAN BAWAH (ABU-ABU SILVER DENGAN TINGGI PRESISI 68PX)
                              Container(
                                width: double.infinity,
                                height: 68,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        color: Color(0xFF123457),
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['desc'] as String,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // CATATAN PENTING CONTAINER
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF123457),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: Color(0xFFE8A33D), size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Setiap pengajuan dapat dipantau statusnya secara real-time melalui menu riwayat.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TOMBOL JELAJAHI SEMUA LAYANAN MOCILEGIT
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        GuestGatekeeper.checkAccess(
                          context,
                          onGranted: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MocilegitWebviewScreen(
                                  title: 'Katalog Layanan Mocilegit',
                                  url: 'https://mocilegit.sukabumikota.go.id/pengajuan',
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8A33D),
                        foregroundColor: const Color(0xFF123457),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.explore_outlined, size: 20),
                      label: const Text(
                        'Jelajahi Semua Layanan (Mocilegit)',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}