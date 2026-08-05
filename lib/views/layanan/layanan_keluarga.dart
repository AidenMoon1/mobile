import 'package:flutter/material.dart';
import 'package:mobile/views/layanan/detail_layanan_keluarga.dart';

class LayananKeluargaScreen extends StatelessWidget {
  const LayananKeluargaScreen({super.key});

  final List<Map<String, dynamic>> _subLayanan = const [
    {
      'title': 'KTP',
      'desc': 'Kartu Identitas Warga',
      'icon': Icons.badge_rounded,
      'subjudul': 'Layanan Disdukcapil Kota Sukabumi',
      'deskripsiTentang':
          'Layanan pencetakan ulang KTP-el karena rusak/hilang, pembaharuan data elemen KTP, dan registrasi Identitas Kependudukan Digital (IKD).',
      'persyaratan': [
        'Fotokopi Kartu Keluarga (KK) Terbaru',
        'KTP Lama (Jika Rusak / Ganti Elemen)',
        'Surat Keterangan Kehilangan dari Kepolisian (Jika KTP Hilang)',
        'Foto Bukti Fisik KTP Rusak (Jika Rusak)',
      ],
    },
    {
      'title': 'KK',
      'desc': 'Kartu Keluarga',
      'icon': Icons.family_restroom_rounded,
      'subjudul': 'Layanan Disdukcapil Kota Sukabumi',
      'deskripsiTentang':
          'Layanan penerbitan Kartu Keluarga (KK) baru untuk keluarga baru, penambahan anggota keluarga (kelahiran), atau pengurangan anggota keluarga.',
      'persyaratan': [
        'Surat Pengantar RT / RW / Kelurahan',
        'Buku Nikah / Kutipan Akta Perkawinan (Orang Tua)',
        'Surat Keterangan Lahir (Untuk Penambahan Anggota)',
        'KK Lama (Jika ada pembaharuan data)',
      ],
    },
    {
      'title': 'KIA',
      'desc': 'Kartu Identitas Anak',
      'icon': Icons.child_care_rounded,
      'subjudul': 'Layanan Disdukcapil Kota Sukabumi',
      'deskripsiTentang':
          'Kartu Identitas Anak (KIA) merupakan identitas resmi anak usia 0 hingga kurang dari 17 tahun untuk memenuhi hak kependudukan anak.',
      'persyaratan': [
        'Fotokopi Akta Kelahiran Anak',
        'Fotokopi Kartu Keluarga (KK) Orang Tua',
        'Fotokopi KTP Kedua Orang Tua',
        'Pas Foto Anak Ukuran 2x3 (Untuk Anak Usia > 5 Tahun)',
      ],
    },
    {
      'title': 'Akta Kelahiran',
      'desc': 'Akta Lahir Digital',
      'icon': Icons.child_friendly_rounded,
      'subjudul': 'Layanan Disdukcapil Kota Sukabumi',
      'deskripsiTentang':
          'Penerbitan Akta Kelahiran resmi dari Disdukcapil sebagai bukti sah status hukum kependudukan anak di Kota Sukabumi.',
      'persyaratan': [
        'Surat Keterangan Lahir dari Bidan / Rumah Sakit',
        'Fotokopi Buku Nikah / Akta Perkawinan Orang Tua',
        'Fotokopi Kartu Keluarga (KK)',
        'Fotokopi KTP Orang Tua & 2 Orang Saksi',
      ],
    },
    {
      'title': 'Surat Pindah',
      'desc': 'Pindah Domisili',
      'icon': Icons.move_to_inbox_rounded,
      'subjudul': 'Layanan Disdukcapil Kota Sukabumi',
      'deskripsiTentang':
          'Layanan pengurusan Surat Keterangan Pindah Datang WNI (SKPWNI) untuk kepindahan antar kelurahan, kecamatan, kota, maupun provinsi.',
      'persyaratan': [
        'Kartu Keluarga (KK) Asli & Fotokopi',
        'KTP-el Asli yang Berpindah',
        'Alamat Lengkap Tujuan Pindah (RT/RW, Desa, Kec, Kab/Kota)',
      ],
    },
    {
      'title': 'Akta Kematian',
      'desc': 'Bukti Sah Kematian',
      'icon': Icons.description_rounded,
      'subjudul': 'Layanan Disdukcapil Kota Sukabumi',
      'deskripsiTentang':
          'Penerbitan Akta Kematian sebagai bukti sah kematian warga untuk kepengurusan ahli waris, perbankan, dan pemutakhiran data KK.',
      'persyaratan': [
        'Surat Keterangan Kematian dari Dokter / Rumah Sakit / Kelurahan',
        'Kartu Keluarga (KK) Asli Almarhum/Almarhumah',
        'KTP-el Asli Almarhum/Almarhumah',
        'Fotokopi KTP Pelapor & 2 Saksi Kematian',
      ],
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailLayananKeluargaScreen(
                                judulLayanan: item['title'] as String,
                                subjudul: item['subjudul'] as String,
                                deskripsiTentang: item['deskripsiTentang'] as String,
                                persyaratan: List<String>.from(item['persyaratan'] as List),
                              ),
                            ),
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
                                      size: 44,
                                    ),
                                  ),
                                ),
                              ),

                              // BAGIAN BAWAH (ABU-ABU SILVER DENGAN TINGGI PRESISI 64PX)
                              Container(
                                width: double.infinity,
                                height: 64,
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
                                        fontSize: 13,
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