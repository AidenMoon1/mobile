import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../layanan/detail_layanan_usaha.dart';

class InfoDpmpstp extends StatefulWidget {
  const InfoDpmpstp({super.key});

  @override
  State<InfoDpmpstp> createState() => _InfoDpmpstpState();
}

class _InfoDpmpstpState extends State<InfoDpmpstp> {
  bool _isTentangExpanded = true;

  final List<Map<String, dynamic>> _layananTersedia = const [
    {
      'title': 'Izin\nReklame',
      'rawTitle': 'Perizinan Reklame',
      'icon': Icons.assignment_turned_in_outlined,
      'subjudul': 'Layanan SAKTI – DPMPTSP',
      'deskripsiTentang':
          'PBG & Reklame adalah izin dan retribusi yang harus dikeluarkan atas keberadaan media reklame atau bangunan yang memberi nilai ekonomi di Kota Sukabumi.',
      'persyaratan': [
        'Fotokopi KTP Pemohon',
        'Jenis Reklame & Desain/Konstruksi',
        'Nomor Induk Berusaha (NIB)',
        'Surat Kuasa (Jika dikuasakan)',
        'Foto Lokasi Penempatan Reklame',
        'Bukti Pelunasan PBB Terakhir',
        'Dokumen Perjanjian Sewa Lahan',
      ],
      'urlPortal': 'https://dpmptsp.sukabumikota.go.id',
    },
    {
      'title': 'PBG\nBangunan',
      'rawTitle': 'Izin Bangunan Usaha',
      'icon': Icons.business_outlined,
      'subjudul': 'Persetujuan Bangunan Gedung (PBG)',
      'deskripsiTentang':
          'Perizinan yang diberikan kepada pemilik bangunan gedung untuk membangun, mengubah, memelihara, atau membongkar bangunan gedung tempat usaha.',
      'persyaratan': [
        'KTP Pemohon',
        'Sertifikat Hak Atas Tanah',
        'Gambar Rencana Teknis Bangunan',
        'Dokumen Lingkungan (SPPL/UKL-UPL)',
      ],
      'urlPortal': 'https://simbg.pu.go.id',
    },
    {
      'title': 'NIB\nOSS',
      'rawTitle': 'NIB (OSS RBA)',
      'icon': Icons.storefront_outlined,
      'subjudul': 'Nomor Induk Berusaha Perorangan',
      'deskripsiTentang':
          'Penerbitan NIB untuk usahawan perorangan dan UMKM secara mudah dan instan terintegrasi dengan OSS Nasional.',
      'persyaratan': [
        'KTP Pemohon',
        'NPWP Pemohon (Jika ada)',
        'Alamat Email & No HP Aktif',
      ],
      'urlPortal': 'https://oss.go.id',
    },
    {
      'title': 'Sertifikat\nHalal',
      'rawTitle': 'Sertifikasi Halal',
      'icon': Icons.verified_outlined,
      'subjudul': 'Fasilitasi Sertifikat Halal UMKM',
      'deskripsiTentang':
          'Layanan pendampingan proses produk halal (PPH) bagi pelaku usaha makanan dan minuman skala mikro dan kecil di Kota Sukabumi.',
      'persyaratan': [
        'KTP Pemilik Usaha',
        'NIB Terbitan OSS',
        'Daftar Bahan & Komposisi Produk',
      ],
      'urlPortal': 'https://halal.go.id',
    },
  ];

  Future<void> _bukaGoogleMaps() async {
    final Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=DPMPTSP+Kota+Sukabumi');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: primaryColor,
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
            Container(
              width: double.infinity,
              height: 124,
              color: primaryColor,
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: const Alignment(0.4, 0.0),
                        child: Opacity(
                          opacity: 0.22,
                          child: Image.asset(
                            'assets/images/dpmptsp.png',
                            width: 320,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 86,
                            height: 86,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x25000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/dpmptsp.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.store_rounded,
                                color: primaryColor,
                                size: 48,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DPMPTSP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    height: 1.3,
                                  ),
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
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: accentColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Informasi Instansi',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(
                          icon: Icons.location_on_outlined,
                          label: 'ALAMAT',
                          content: 'Jl. Mayjend S. Parman No. 6, Kota Sukabumi, Jawa Barat',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                        _buildInfoItem(
                          icon: Icons.access_time_rounded,
                          label: 'JAM OPERASIONAL',
                          content: 'Senin–Jum\'at, 08:00 – 15:30 WIB',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                        _buildInfoItem(
                          icon: Icons.phone_outlined,
                          label: 'KONTAK',
                          content: '(0266) 221764',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  GestureDetector(
                    onTap: _bukaGoogleMaps,
                    child: Container(
                      width: double.infinity,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300, width: 1.2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: const Color(0xFFE8ECEF),
                              child: CustomPaint(
                                painter: MapPatternPainterDPMPTSP(),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'DPMPTSP Kota Sukabumi',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.redAccent,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Buka di Maps',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.open_in_new_rounded,
                                      color: primaryColor,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Layanan Tersedia',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 17.5,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 108,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _layananTersedia.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = _layananTersedia[index];
                        final String displayTitle = item['title'] as String;
                        final String rawTitle = (item['rawTitle'] ?? item['title']) as String;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailLayananUsahaScreen(
                                  judulLayanan: rawTitle,
                                  subjudul: item['subjudul'] as String,
                                  deskripsiTentang: item['deskripsiTentang'] as String,
                                  persyaratan: List<String>.from(item['persyaratan'] as List),
                                  urlMitra: item['urlPortal'] as String,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 92,
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300, width: 1.3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0C000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item['icon'] as IconData,
                                  color: primaryColor,
                                  size: 38,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  displayTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    height: 1.15,
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
                  ),

                  const SizedBox(height: 22),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isTentangExpanded = !_isTentangExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tentang Instansi',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Icon(
                                  _isTentangExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: Colors.black87,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isTentangExpanded)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                                const SizedBox(height: 14),
                                Text(
                                  'DPMPTSP Kota Sukabumi adalah instansi pemerintah yang menyelenggarakan pelayanan perizinan non-perizinan secara terpadu satu pintu serta memfasilitasi penanaman modal dan investasi daerah.',
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 13,
                                    height: 1.5,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Tugas dan Fungsi Utama :',
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildBulletPoint(
                                  title: 'Pelayanan Perizinan Terpadu',
                                  desc:
                                      'Menerbitkan izin usaha, NIB (OSS RBA), Izin Reklame, PBG Bangunan, serta izin tenaga medis secara cepat dan transparan.',
                                ),
                                _buildBulletPoint(
                                  title: 'Fasilitasi Penanaman Modal',
                                  desc:
                                      'Mendorong pertumbuhan investasi daerah dan mendampingi kemitraan usaha mikro, kecil, hingga skala besar.',
                                ),
                                _buildBulletPoint(
                                  title: 'Pengawasan & Pengaduan',
                                  desc:
                                      'Melakukan pengendalian perizinan usaha dan mengelola pengaduan perizinan warga Kota Sukabumi.',
                                ),
                              ],
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

  Widget _buildBulletPoint({required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: Colors.grey.shade800,
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
                    style: TextStyle(
                      color: Colors.grey.shade900,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                    text: desc,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 12.5,
                      height: 1.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MapPatternPainterDPMPTSP extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final mainRoadPaint = Paint()
      ..color = const Color(0xFF4A90E2).withOpacity(0.5)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.5);
    path1.lineTo(size.width, size.height * 0.4);
    canvas.drawPath(path1, mainRoadPaint);

    final path2 = Path();
    path2.moveTo(size.width * 0.5, 0);
    path2.lineTo(size.width * 0.5, size.height);
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
