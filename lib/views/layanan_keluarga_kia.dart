import 'package:flutter/material.dart';

class LayananKeluargaKiaScreen extends StatelessWidget {
  const LayananKeluargaKiaScreen({super.key});

  final List<Map<String, dynamic>> _kategoriKia = const [
    {
      'title': 'KIA Baru',
      'desc': 'Pencatatan kelahiran untuk anak yang baru lahir atau warga yang belum pernah memiliki KIA sebelumnya.',
      'badge': 'VERIFIKASI DIGITAL',
      'icon': Icons.child_care_rounded,
      'badgeColor': Color(0xFFFDE8FF),
    },
    {
      'title': 'KIA Hilang',
      'desc': 'Wajib melampirkan Surat Tanda Laporan Kehilangan dari Kepolisian.',
      'badge': 'VERIFIKASI DIGITAL',
      'icon': Icons.search_off_rounded,
      'badgeColor': Color(0xFFFFDCDC),
    },
    {
      'title': 'KIA Rusak',
      'desc': 'Penggantian fisik kartu KIA yang patah, terkelupas, atau elemen datanya sudah tidak bisa terbaca jelas.',
      'badge': 'VERIFIKASI DIGITAL',
      'icon': Icons.report_problem_rounded,
      'badgeColor': Color(0xFFFFF8BB),
    },
    {
      'title': 'Perubahan Data KIA',
      'desc': 'Penerbitan KIA karena adanya perubahan data identitas anak atau alasan administrasi lainnya.',
      'badge': 'VERIFIKASI DIGITAL',
      'icon': Icons.edit_note_rounded,
      'badgeColor': Color(0xFFE4FFBB),
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
          'Kartu Identitas Anak',
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
            // HERO BANNER KIA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: const Color(0xFF123457),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Layanan ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Kartu Identitas Anak',
                        style: TextStyle(
                          color: Color(0xFFE8A33D),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Penerbitan identitas resmi untuk penduduk berusia di bawah 17 tahun.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontFamily: 'Poppins',
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
                  // LIST KATEGORI KIA
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _kategoriKia.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _kategoriKia[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFEBEBEB)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: item['badgeColor'] as Color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: const Color(0xFF0A1E33),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'] as String,
                                          style: const TextStyle(
                                            color: Color(0xFF0A1E33),
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEBEBEB),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item['badge'] as String,
                                          style: const TextStyle(
                                            color: Color(0xFF494949),
                                            fontSize: 9.5,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['desc'] as String,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12.5,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Pengajuan ${item['title']} sedang disiapkan.'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF123457),
                                        foregroundColor: const Color(0xFFE8A33D),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                                      label: const Text(
                                        'Ajukan',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // PERSYARATAN UMUM KIA
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF123457),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, color: Color(0xFFE8A33D), size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Persyaratan Umum KIA',
                                style: TextStyle(
                                  color: Color(0xFFE8A33D),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Anak harus terdaftar dalam Kartu Keluarga (KK) Kota Sukabumi. Untuk anak usia di atas 5 tahun, wajib melampirkan pas foto anak. Format dokumen JPG/PNG maksimal 2MB.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
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
}