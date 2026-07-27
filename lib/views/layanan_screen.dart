import 'package:flutter/material.dart';

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
        centerTitle: false,
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Fase',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' Kehidupan',
                style: TextStyle(
                  color: Color(0xFFE8A33D),
                  fontSize: 18,
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
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih sektor layanan yang Anda butuhkan sesuai kebutuhan kehidupan warga.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),

            // # GRID KATALOG 10 KARTU SEKTOR FASE KEHIDUPAN
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _faseKehidupan.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final item = _faseKehidupan[index];
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Membuka layanan ${item['title']}...'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF123457),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFA5A4A4), width: 0.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Ikon Kartu Sektor
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFFAC33), width: 1.5),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: const Color(0xFF123457),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Judul & Deskripsi
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
                                color: Colors.white70,
                                fontSize: 9,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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