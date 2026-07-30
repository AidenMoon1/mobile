import 'package:flutter/material.dart';

class InfoDpmpstp extends StatelessWidget {
  const InfoDpmpstp({super.key});

  final List<Map<String, dynamic>> _layananTersedia = const [
    {
      'title': 'Izin Usaha (OSS)',
      'desc': 'NIB & Izin Berusaha',
      'icon': Icons.assignment_rounded,
    },
    {
      'title': 'Izin Bangunan (PBG)',
      'desc': 'Persetujuan Bangunan',
      'icon': Icons.apartment_rounded,
    },
    {
      'title': 'Izin Reklame',
      'desc': 'Pemasangan Reklame',
      'icon': Icons.featured_video_rounded,
    },
    {
      'title': 'Izin Kesehatan',
      'desc': 'SIP Tenaga Medis',
      'icon': Icons.medical_services_rounded,
    },
    {
      'title': 'Konsultasi Modal',
      'desc': 'Kemitraan Investasi',
      'icon': Icons.trending_up_rounded,
    },
    {
      'title': 'Aduan Perizinan',
      'desc': 'Layanan Pengaduan',
      'icon': Icons.report_problem_rounded,
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
          'Instansi',
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
            // # 1. HEADER HERO KARTU DPMPTSP (NAVY)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: const Color(0xFF123457),
              child: Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFAC33), width: 1.5),
                    ),
                    child: Image.asset(
                      'assets/images/dpmptsp.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.assignment_rounded,
                        color: Color(0xFF123457),
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DPMPTSP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.5,
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
                  // # 2. INFORMASI INSTANSI (KARTU DETAIL ALAMAT, JAM, KONTAK)
                  const Text(
                    'Informasi Instansi',
                    style: TextStyle(
                      color: Color(0xFF123457),
                      fontSize: 16.5,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF123457).withOpacity(0.15), width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x15000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Alamat
                        _buildInfoRow(
                          icon: Icons.location_on_rounded,
                          label: 'ALAMAT',
                          value: 'Jl. Mayjend. A. Yani No. 227, Kebonjati, Cikole, Kota Sukabumi, Jawa Barat 43111',
                        ),
                        const Divider(height: 20),

                        // Jam Operasional
                        _buildInfoRow(
                          icon: Icons.access_time_filled_rounded,
                          label: 'JAM OPERASIONAL',
                          value: 'Senin-Jum’at, 08:00 - 15:30 WIB',
                        ),
                        const Divider(height: 20),

                        // Kontak
                        _buildInfoRow(
                          icon: Icons.phone_rounded,
                          label: 'KONTAK',
                          value: '(0266) 222567 / dpmptsp@sukabumikota.go.id',
                        ),
                        const SizedBox(height: 14),

                        // Tombol Buka di Maps
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Membuka petunjuk arah di Google Maps...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5083B8).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF5083B8), width: 1),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map_rounded, color: Color(0xFF5083B8), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Buka di Maps',
                                  style: TextStyle(
                                    color: Color(0xFF5083B8),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // # 3. LAYANAN TERSEDIA (GRID KARTU KECIL)
                  const Text(
                    'Layanan Tersedia',
                    style: TextStyle(
                      color: Color(0xFF123457),
                      fontSize: 16.5,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _layananTersedia.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final item = _layananTersedia[index];
                      return GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Membuka layanan ${item['title']} DPMPTSP...'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF123457),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFFAC33), width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x20000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                color: const Color(0xFFE8A33D),
                                size: 32,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['title'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 22),

                  // # 4. TENTANG INSTANSI (KARTU DESKRIPSI LENGKAP)
                  const Text(
                    'Tentang Instansi',
                    style: TextStyle(
                      color: Color(0xFF123457),
                      fontSize: 16.5,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF123457).withOpacity(0.15), width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x15000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DPMPTSP Kota Sukabumi memiliki tugas perumusan kebijakan teknis serta penyelenggaraan urusan pemerintahan di bidang penanaman modal dan pelayanan perizinan terpadu satu pintu demi kemudahan berusaha masyarakat.',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13.5,
                            fontFamily: 'Poppins',
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Tugas dan Fungsi Utama :',
                          style: TextStyle(
                            color: Color(0xFF123457),
                            fontSize: 13.5,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        BuildBulletPoint(
                          title: 'Penanaman Modal',
                          desc: 'Promosi investasi, fasilitasi kemudahan berinvestasi, serta pengawasan realisasi penanaman modal daerah.',
                        ),
                        SizedBox(height: 6),
                        BuildBulletPoint(
                          title: 'Perizinan Berusaha (OSS)',
                          desc: 'Penyelenggaraan penerbitan izin usaha terintegrasi secara elektronik serta pendampingan pelaku UMKM.',
                        ),
                        SizedBox(height: 6),
                        BuildBulletPoint(
                          title: 'Non-Perizinan & PBG',
                          desc: 'Pelayanan persetujuan bangunan gedung, izin operasional tenaga kesehatan, serta verifikasi kelayakan perizinan.',
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

  // # HELPER WIDGET BARIS INFORMASI
  static Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF123457), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFA5A4A4),
                  fontSize: 11,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13.5,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// # HELPER WIDGET BULLET POINT
class BuildBulletPoint extends StatelessWidget {
  final String title;
  final String desc;

  const BuildBulletPoint({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            color: Color(0xFF123457),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(
                    color: Color(0xFF123457),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: desc,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
