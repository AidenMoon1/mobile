import 'package:flutter/material.dart';
import 'layanan_keluarga.dart';
import 'layanan_usaha.dart';
import 'layanan_lingkungan.dart';
import 'form_pengajuan_screen.dart';

class LayananScreen extends StatelessWidget {
  const LayananScreen({super.key});

  final List<Map<String, dynamic>> _faseKehidupan = const [
    {
      'title': 'Keluarga',
      'imagePath': 'assets/icon/keluarga.png',
      'fallbackIcon': Icons.family_restroom_rounded,
      'desc': 'Administrasi Kependudukan, Pernikahan, KK & Akta',
    },
    {
      'title': 'Pendidikan',
      'imagePath': 'assets/icon/pendidikan.png',
      'fallbackIcon': Icons.school_rounded,
      'desc': 'Beasiswa, PPDB, Pendaftaran Sekolah',
    },
    {
      'title': 'Usaha',
      'imagePath': 'assets/icon/usaha.png',
      'fallbackIcon': Icons.store_rounded,
      'desc': 'Izin Usaha, NIB, UMKM Kota Sukabumi',
    },
    {
      'title': 'Lingkungan & Tempat Tinggal',
      'imagePath': 'assets/icon/lingkungan.png',
      'fallbackIcon': Icons.home_work_rounded,
      'desc': 'PBB, Kebersihan, Izin Bangunan (PBG)',
    },
    {
      'title': 'Kendaraan',
      'imagePath': 'assets/icon/kendaraan.png',
      'fallbackIcon': Icons.directions_car_rounded,
      'desc': 'Pajak Kendaraan, SIM, Uji KIR',
    },
    {
      'title': 'Kesehatan',
      'imagePath': 'assets/icon/kesehatan.png',
      'fallbackIcon': Icons.local_hospital_rounded,
      'desc': 'BPJS, Puskesmas, Antrean RSUD',
    },
    {
      'title': 'Tanggap Darurat',
      'imagePath': 'assets/icon/tanggapdarurat.png',
      'fallbackIcon': Icons.warning_amber_rounded,
      'desc': 'BPBD, Pemadam Kebakaran, Ambulans 112',
    },
    {
      'title': 'Karier',
      'imagePath': 'assets/icon/karier.png',
      'fallbackIcon': Icons.work_rounded,
      'desc': 'Lowongan Kerja, Pelatihan Disnaker',
    },
    {
      'title': 'Rekreasi',
      'imagePath': 'assets/icon/rekreasi.png',
      'fallbackIcon': Icons.sports_soccer_rounded,
      'desc': 'Wisata Kota, Fasilitas Olahraga & Taman',
    },
    {
      'title': 'Sosial & Hukum',
      'imagePath': 'assets/icon/sosialhukum.png',
      'fallbackIcon': Icons.gavel_rounded,
      'desc': 'Bantuan Sosial, Konsultasi Hukum Warga',
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
        centerTitle: false,
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Fase',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' Kehidupan',
                style: TextStyle(
                  color: Color(0xFFE8A33D),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // # JUDUL KATALOG FASE KEHIDUPAN
            const Text(
              'Kategori Layanan Sektor',
              style: TextStyle(
                color: Color(0xFF123457),
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih sektor layanan yang Anda butuhkan sesuai kebutuhan kehidupan warga.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 14),

            // # GRID KATALOG 10 KARTU SEKTOR FASE KEHIDUPAN
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _faseKehidupan.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (context, index) {
                final item = _faseKehidupan[index];
                final String? imagePath = item['imagePath'] as String?;
                final IconData fallbackIcon = item['fallbackIcon'] as IconData;

                return GestureDetector(
                  onTap: () {
                    if (item['title'] == 'Keluarga') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LayananKeluargaScreen()),
                      );
                    } else if (item['title'] == 'Usaha') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LayananUsahaScreen()),
                      );
                    } else if (item['title'] == 'Lingkungan & Tempat Tinggal') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LayananLingkunganScreen()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormPengajuanScreen(
                            judulLayanan: 'Layanan ${item['title']}',
                            deskripsi: item['desc'] as String,
                            icon: fallbackIcon,
                          ),
                        ),
                      );
                    }
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
                        // # BAGIAN ATAS (BAGIAN BIRU NAVY DENGAN IKON/GAMBAR DI TENGAH)
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
                              child: imagePath != null
                                  ? Image.asset(
                                      imagePath,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        fallbackIcon,
                                        color: const Color(0xFFE8A33D),
                                        size: 44,
                                      ),
                                    )
                                  : Icon(
                                      fallbackIcon,
                                      color: const Color(0xFFE8A33D),
                                      size: 44,
                                    ),
                            ),
                          ),
                        ),

                        // # BAGIAN BAWAH (BAGIAN ABU-ABU DENGAN TINGGI PRESISI 64PX AGAR SEJAJAR 100%)
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Judul & Deskripsi Sektor dari layanan_screen.dart
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        color: Color(0xFF123457),
                                        fontSize: 13.5,
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
                                        fontSize: 10.5,
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
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}