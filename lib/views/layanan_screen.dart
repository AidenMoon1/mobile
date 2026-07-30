import 'package:flutter/material.dart';
import 'layanan_keluarga.dart';

class LayananScreen extends StatelessWidget {
  const LayananScreen({super.key});

  final List<Map<String, dynamic>> _faseKehidupan = const [
    {
      'title': 'Keluarga',
      'icon': Icons.family_restroom_rounded,
      'desc': 'Administrasi Kependudukan, Pernikahan, KK & Akta',
    },
    {
      'title': 'Pendidikan',
      'icon': Icons.school_rounded,
      'desc': 'Beasiswa, PPDB, Pendaftaran Sekolah',
    },
    {
      'title': 'Usaha',
      'icon': Icons.store_rounded,
      'desc': 'Izin Usaha, NIB, UMKM Kota Sukabumi',
    },
    {
      'title': 'Lingkungan & Tempat Tinggal',
      'icon': Icons.home_work_rounded,
      'desc': 'PBB, Kebersihan, Izin Bangunan (PBG)',
    },
    {
      'title': 'Kendaraan',
      'icon': Icons.directions_car_rounded,
      'desc': 'Pajak Kendaraan, SIM, Uji KIR',
    },
    {
      'title': 'Kesehatan',
      'icon': Icons.local_hospital_rounded,
      'desc': 'BPJS, Puskesmas, Antrean RSUD',
    },
    {
      'title': 'Tanggap Darurat',
      'icon': Icons.warning_amber_rounded,
      'desc': 'BPBD, Pemadam Kebakaran, Ambulans 112',
    },
    {
      'title': 'Karier',
      'icon': Icons.work_rounded,
      'desc': 'Lowongan Kerja, Pelatihan Disnaker',
    },
    {
      'title': 'Rekreasi',
      'icon': Icons.sports_soccer_rounded,
      'desc': 'Wisata Kota, Fasilitas Olahraga & Taman',
    },
    {
      'title': 'Sosial & Hukum',
      'icon': Icons.gavel_rounded,
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
                return GestureDetector(
                  onTap: () {
                    if (item['title'] == 'Keluarga') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LayananKeluargaScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Membuka layanan ${item['title']}...'),
                          duration: const Duration(seconds: 1),
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
                        // # BAGIAN ATAS (BAGIAN BIRU NAVY DENGAN IKON DI TENGAH)
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

                        // # BAGIAN BAWAH (BAGIAN ABU-ABU DENGAN JUDUL, DESKRIPSI & PANAH DROPDOWN)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                                  mainAxisSize: MainAxisSize.min,
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