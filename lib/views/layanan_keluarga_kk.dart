import 'package:flutter/material.dart';

class LayananKeluargaKkScreen extends StatelessWidget {
  const LayananKeluargaKkScreen({super.key});

  final List<Map<String, dynamic>> _kategoriKk = const [
    {
      'title': 'KK Hilang',
      'desc': 'Wajib melampirkan surat kehilangan dari kepolisian.',
      'badge': 'PROSES ONLINE',
      'icon': Icons.description_rounded,
      'badgeColor': Color(0xFFFFDCDC),
    },
    {
      'title': 'KK Baru',
      'desc': 'Penerbitan KK bagi pasangan atau keluarga baru.',
      'badge': 'PROSES ONLINE',
      'icon': Icons.group_add_rounded,
      'badgeColor': Color(0xFFFDE8FF),
    },
    {
      'title': 'KK Rusak',
      'desc': 'Penggantian dokumen KK yang kondisinya sudah rusak, robek, atau tidak terbaca.',
      'badge': 'PROSES ONLINE',
      'icon': Icons.difference_rounded,
      'badgeColor': Color(0xFFFFF8BB),
    },
    {
      'title': 'Pisah KK (satu alamat)',
      'desc': 'Penerbitan KK baru dikarenakan adanya anggota keluarga yang memisahkan diri dalam satu domisili.',
      'badge': 'PROSES ONLINE',
      'icon': Icons.call_split_rounded,
      'badgeColor': Color(0xFFE8FCFF),
    },
    {
      'title': 'Rubah Data KK',
      'desc': 'Pembaruan elemen data dalam KK seperti penambahan anggota keluarga, pendidikan, atau pekerjaan.',
      'badge': 'PROSES ONLINE',
      'icon': Icons.edit_note_rounded,
      'badgeColor': Color(0xFFE4FFBB),
    },
    {
      'title': 'Numpang KK',
      'desc': 'Proses penggabungan anggota keluarga baru ke dalam KK yang sudah ada.',
      'badge': 'PROSES ONLINE',
      'icon': Icons.person_add_alt_1_rounded,
      'badgeColor': Color(0xFFFFDCDC),
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
          'Layanan Kartu Keluarga',
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
            // HERO BANNER KK
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
                        'Kartu Keluarga',
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
                    'Pilih kategori permohonan yang sesuai dengan kondisi Anda saat ini untuk memulai proses pengajuan digital.',
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
                  // LIST KATEGORI KK
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _kategoriKk.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _kategoriKk[index];
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
                                            fontSize: 10,
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

                  // CONTAINER INFORMASI PERSYARATAN
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
                                'Penting: Persyaratan Digital',
                                style: TextStyle(
                                  color: Color(0xFFE8A33D),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Pastikan seluruh berkas asli di-scan atau difoto dengan pencahayaan yang cukup. Format berkas yang didukung adalah JPG/PNG dengan ukuran maksimal 2MB per file.',
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