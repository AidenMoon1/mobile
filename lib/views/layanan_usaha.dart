import 'package:flutter/material.dart';
import 'detail_layanan_usaha.dart';

class LayananUsahaScreen extends StatelessWidget {
  const LayananUsahaScreen({super.key});

  final List<Map<String, dynamic>> _subLayananUsaha = const [
    {
      'title': 'Perizinan Reklame',
      'desc': 'Layanan SAKTI – DPMPTSP',
      'icon': Icons.assignment_turned_in_rounded,
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
      'title': 'Kesehatan Hewan',
      'desc': 'Layanan DKP3 Peternakan',
      'icon': Icons.pets_rounded,
      'subjudul': 'Layanan DKP3 – Peternakan',
      'deskripsiTentang':
          'Layanan pemeriksaan kesehatan, surat keterangan kesehatan hewan (SKKH), serta vaksinasi hewan ternak dan hewan peliharaan dari DKP3 Kota Sukabumi.',
      'persyaratan': [
        'Fotokopi KTP Pemilik Hewan',
        'Buku Catatan Kesehatan Hewan',
        'Surat Pengantar dari Kelurahan',
        'Bukti Vaksinasi Terakhir',
      ],
      'urlPortal': 'https://dkp3.sukabumikota.go.id',
    },
    {
      'title': 'NIB (OSS RBA)',
      'desc': 'Izin Usaha Perorangan',
      'icon': Icons.storefront_rounded,
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
      'title': 'Sertifikasi Halal',
      'desc': 'Pendampingan PPH UMKM',
      'icon': Icons.verified_rounded,
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
    {
      'title': 'Izin PIRT',
      'desc': 'Industri Rumah Tangga',
      'icon': Icons.clean_hands_rounded,
      'subjudul': 'Izin Pangan Industri Rumah Tangga',
      'deskripsiTentang':
          'Sertifikat Produksi Pangan Industri Rumah Tangga (P-IRT) untuk izin edar produk makanan minuman olahan rumahan.',
      'persyaratan': [
        'KTP Pemilik Usaha',
        'Pas Foto 3x4 (2 Lembar)',
        'Denah Lokasi Dapur Produksi',
        'Sertifikat Penyuluhan Keamanan Pangan',
      ],
      'urlPortal': 'https://sppirt.pom.go.id',
    },
    {
      'title': 'Izin Bangunan Usaha',
      'desc': 'PBG Tempat Usaha',
      'icon': Icons.business_rounded,
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
          'Sektor Usaha',
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
            // HEADER HERO USAHA (SAMA PERSIS DENGAN KELUARGA)
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
                      Icons.storefront_rounded,
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
                          'USAHA & UMKM',
                          style: TextStyle(
                            color: Color(0xFFFFAC33),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Layanan Perizinan Usaha, NIB, Reklame, Halal & Peternakan DKP3',
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
                    'Pilih Jenis Layanan Usaha',
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

                  // GRID SUB-LAYANAN USAHA (2-PART CARD DESIGN SAMA PERSIS KELUARGA)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _subLayananUsaha.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemBuilder: (context, index) {
                      final item = _subLayananUsaha[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailLayananUsahaScreen(
                                judulLayanan: item['title'] as String,
                                subjudul: item['subjudul'] as String,
                                deskripsiTentang: item['deskripsiTentang'] as String,
                                persyaratan: List<String>.from(item['persyaratan'] as List),
                                urlMitra: item['urlPortal'] as String,
                              ),
                            ),
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

                              // BAGIAN BAWAH (ABU-ABU SILVER DENGAN TINGGI PRESISI 64PX AGAR SEJAJAR 100%)
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        color: Color(0xFF123457),
                                        fontSize: 13,
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
                                        fontSize: 10,
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
