import 'package:flutter/material.dart';

class LayananKeluargaKtpScreen extends StatelessWidget {
  const LayananKeluargaKtpScreen({super.key});

  final List<Map<String, dynamic>> _kategoriKtp = const [
    {
      'title': 'KTP Hilang',
      'desc': 'Wajib melampirkan surat kehilangan dari kepolisian.',
      'badge': 'PROSES ONLINE',
      'icon': Icons.search_off_rounded,
      'badgeColor': Color(0xFFFFDCDC),
    },
    {
      'title': 'KTP Rusak',
      'desc': 'Penerbitan ulang untuk kondisi fisik KTP-el sudah tidak bisa dibaca atau patah.',
      'badge': 'PROSES ONLINE',
      'icon': Icons.report_problem_rounded,
      'badgeColor': Color(0xFFFFF8BB),
    },
    {
      'title': 'Pindah Domisili',
      'desc': 'Penerbitan KTP-el bagi warga yang baru saja pindah domisili (masuk ke Kota Sukabumi).',
      'badge': 'PROSES ONLINE',
      'icon': Icons.home_work_rounded,
      'badgeColor': Color(0xFFE8FCFF),
    },
    {
      'title': 'Rubah Data KTP',
      'desc': 'Penerbitan KTP-el baru dikarenakan perubahan status, gelar, alamat atau elemen data lainnya.',
      'badge': 'PROSES ONLINE',
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
          'Permohonan KTP-el',
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
            // HERO BANNER KTP
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
                        'Permohonan ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'KTP-el',
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
                  // LIST KATEGORI KTP
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _kategoriKtp.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _kategoriKtp[index];
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
                          child: Text(
                            'Pastikan Anda sudah menyiapkan dokumen pendukung dalam format digital (Foto/Scan) sebelum memulai pengajuan. Ukuran file maksimal per dokumen adalah 2MB dalam format JPG/PNG.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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