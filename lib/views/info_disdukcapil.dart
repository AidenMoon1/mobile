import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detail_layanan_keluarga.dart';

class InfoDisdukcapil extends StatefulWidget {
  const InfoDisdukcapil({super.key});

  @override
  State<InfoDisdukcapil> createState() => _InfoDisdukcapilState();
}

class _InfoDisdukcapilState extends State<InfoDisdukcapil> {
  bool _isTentangExpanded = true;

  final List<Map<String, dynamic>> _layananTersedia = const [
    {
      'title': 'KTP',
      'icon': Icons.badge_outlined,
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
      'icon': Icons.groups_outlined,
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
      'icon': Icons.child_care_outlined,
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
      'title': 'Akta\nKelahiran',
      'rawTitle': 'Akta Kelahiran',
      'icon': Icons.card_membership_outlined,
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
      'title': 'Surat\nPindah',
      'rawTitle': 'Surat Pindah',
      'icon': Icons.local_shipping_outlined,
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
      'title': 'Akta\nKematian',
      'rawTitle': 'Akta Kematian',
      'icon': Icons.assignment_outlined,
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

  Future<void> _bukaGoogleMaps() async {
    final Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=Dinas+Kependudukan+dan+Pencatatan+Sipil+Kota+Sukabumi');
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
            // 1. HEADER HERO DENGAN LOGO BESAR & JELAS UNTUK ORANG TUA
            Container(
              width: double.infinity,
              height: 124,
              color: primaryColor,
              child: ClipRect(
                child: Stack(
                  children: [
                    // LOGO WATERMARK BESAR & LEBIH JELAS DI BACKGROUND
                    Positioned.fill(
                      child: Align(
                        alignment: const Alignment(0.4, 0.0),
                        child: Opacity(
                          opacity: 0.22,
                          child: Image.asset(
                            'assets/images/disduk.png',
                            width: 320,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          ),
                        ),
                      ),
                    ),

                    // KARTU LOGO BESAR DEPAN & NAMA INSTANSI
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
                              'assets/images/disduk.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.account_balance_rounded,
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
                                  'DISDUKCAPIL',
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
                                  'Dinas Kependudukan dan Pencatatan Sipil',
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
                  // 2. KARTU INFORMASI INSTANSI (TEKS RAMAH LANSIA)
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
                          content: 'Jl. Bhayangkara No. 224/84, Kota Sukabumi, Jawa Barat',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                        _buildInfoItem(
                          icon: Icons.access_time_rounded,
                          label: 'JAM OPERASIONAL',
                          content: 'Senin–Jum\'at, 08:00 – 15:00 WIB',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                        _buildInfoItem(
                          icon: Icons.phone_outlined,
                          label: 'KONTAK',
                          content: '(0266) 218268',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. KARTU GOOGLE MAPS PREVIEW
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
                                painter: MapPatternPainter(),
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
                                      'Dinas Kependudukan dan Pencatatan Sipil',
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

                  // 4. SEKSI LAYANAN TERSEDIA (KARTU LEBIH BESAR & TEKS JELAS DILIHAT)
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
                                builder: (context) => DetailLayananKeluargaScreen(
                                  judulLayanan: rawTitle,
                                  subjudul: item['subjudul'] as String,
                                  deskripsiTentang: item['deskripsiTentang'] as String,
                                  persyaratan: List<String>.from(item['persyaratan'] as List),
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

                  // 5. KARTU EXPANDABLE ACCORDION: "Tentang Instansi"
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
                                  'Disdukcapil Kota Sukabumi adalah singkatan dari Dinas Kependudukan dan Pencatatan Sipil Kota Sukabumi. Instansi pemerintah daerah ini bertanggung jawab penuh dalam mengelola dan menyelenggarakan urusan administrasi kependudukan serta pencatatan sipil di wilayah Kota Sukabumi.',
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
                                  title: 'Pencatatan Sipil',
                                  desc:
                                      'Menerbitkan dokumen penting seperti Akta Kelahiran, Akta Kematian, Akta Perkawinan, dan Akta Perceraian.',
                                ),
                                _buildBulletPoint(
                                  title: 'Pendaftaran Penduduk',
                                  desc:
                                      'Mengurus dokumen identitas warga berupa Kartu Tanda Penduduk (KTP-el), Kartu Keluarga (KK), Kartu Identitas Anak (KIA), serta surat keterangan pindah/datang.',
                                ),
                                _buildBulletPoint(
                                  title: 'Pengelolaan Data Kependudukan',
                                  desc:
                                      'Menyusun, memvalidasi, dan memanfaatkan data kependudukan secara digital untuk menunjang perencanaan pembangunan dan pelayanan publik lainnya.',
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

class MapPatternPainter extends CustomPainter {
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

    final secondaryRoadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.4);
    path1.cubicTo(size.width * 0.3, size.height * 0.2, size.width * 0.6, size.height * 0.7, size.width, size.height * 0.5);
    canvas.drawPath(path1, mainRoadPaint);

    final path2 = Path();
    path2.moveTo(size.width * 0.4, 0);
    path2.cubicTo(size.width * 0.45, size.height * 0.4, size.width * 0.55, size.height * 0.6, size.width * 0.5, size.height);
    canvas.drawPath(path2, roadPaint);

    final path3 = Path();
    path3.moveTo(0, size.height * 0.8);
    path3.lineTo(size.width, size.height * 0.85);
    canvas.drawPath(path3, secondaryRoadPaint);

    final path4 = Path();
    path4.moveTo(size.width * 0.8, 0);
    path4.lineTo(size.width * 0.75, size.height);
    canvas.drawPath(path4, secondaryRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
