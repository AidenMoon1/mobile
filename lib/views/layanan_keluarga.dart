import 'package:flutter/material.dart';
import 'layanan_keluarga_ktp.dart';
import 'layanan_keluarga_kk.dart';
import 'layanan_keluarga_kia.dart';
import 'layanan_keluarga_akta.dart';
import 'layanan_keluarga_pindah.dart';
import 'layanan_keluarga_kematian.dart';

class LayananKeluargaScreen extends StatelessWidget {
  const LayananKeluargaScreen({super.key});

  final List<Map<String, dynamic>> _subLayanan = const [
    {
      'title': 'KTP',
      'desc': 'Kartu Identitas Warga',
      'icon': Icons.badge_rounded,
      'screen': LayananKeluargaKtpScreen(),
    },
    {
      'title': 'KK',
      'desc': 'Kartu Keluarga',
      'icon': Icons.family_restroom_rounded,
      'screen': LayananKeluargaKkScreen(),
    },
    {
      'title': 'KIA',
      'desc': 'Kartu Identitas Anak',
      'icon': Icons.child_care_rounded,
      'screen': LayananKeluargaKiaScreen(),
    },
    {
      'title': 'Akta Kelahiran',
      'desc': 'Akta Lahir Digital',
      'icon': Icons.child_friendly_rounded,
      'screen': LayananKeluargaAktaScreen(),
    },
    {
      'title': 'Surat Pindah',
      'desc': 'Pindah Domisili',
      'icon': Icons.move_to_inbox_rounded,
      'screen': LayananKeluargaPindahScreen(),
    },
    {
      'title': 'Akta Kematian',
      'desc': 'Bukti Sah Kematian',
      'icon': Icons.description_rounded,
      'screen': LayananKeluargaKematianScreen(),
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

                  // GRID SUB-LAYANAN KELUARGA (2-PART CARD DESIGN)
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
                      final Widget targetScreen = item['screen'] as Widget;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => targetScreen),
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

                              // BAGIAN BAWAH (ABU-ABU SILVER)
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        color: Color(0xFF123457),
                                        fontSize: 14,
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
                                        fontSize: 11,
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