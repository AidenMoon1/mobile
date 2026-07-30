import 'package:flutter/material.dart';
import 'form_pengajuan_screen.dart';

class DetailLayananUsahaScreen extends StatelessWidget {
  final String judulLayanan;
  final String subjudul;
  final String deskripsiTentang;
  final List<String> persyaratan;
  final String urlMitra;

  const DetailLayananUsahaScreen({
    super.key,
    required this.judulLayanan,
    required this.subjudul,
    required this.deskripsiTentang,
    required this.persyaratan,
    required this.urlMitra,
  });

  void _tampilkanDialogRedireksi(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IKON PANAH EXTERNAL LINK ORANYE/EMAS
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.open_in_new_rounded,
                  color: accentColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              // JUDUL DIARAHKAN KE LAYANAN MITRA
              const Text(
                'Diarahkan Ke Layanan Mitra',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),

              // DESKRIPSI LAYANAN MITRA
              Text(
                'Untuk pengajuan $judulLayanan, Anda akan dilayani melalui portal SAKTI dari DPMPTSP.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12.5,
                  fontFamily: 'Poppins',
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // TOMBOL LANJUTKAN NAVY
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup Dialog

                    // NAVIGASI KE FORMULIR DIGITAL NATIVE INTEGRATED
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPengajuanScreen(
                          judulLayanan: 'Pengajuan $judulLayanan',
                          deskripsi: 'Formulir Resmi SAKTI Terpadu Kota Sukabumi',
                          icon: Icons.assignment_turned_in_rounded,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          'USAHA',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER CARD (NAVY CONTAINER WITH ICON & TITLE)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  color: primaryColor,
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in_rounded,
                          color: primaryColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              judulLayanan,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subjudul,
                              style: const TextStyle(
                                color: Colors.white70,
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

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. SEKSI TENTANG SAKTI
                      const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: accentColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Tentang SAKTI',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          deskripsiTentang,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            height: 1.5,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 3. SEKSI ALUR PELAYANAN
                      const Row(
                        children: [
                          Icon(Icons.account_tree_outlined, color: accentColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Alur Pelayanan',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // HORIZONTAL STEPPER CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStepItem(icon: Icons.edit_note_rounded, label: 'Permohonan'),
                            _buildArrowDivider(),
                            _buildStepItem(icon: Icons.cloud_upload_outlined, label: 'Upload Dokumen'),
                            _buildArrowDivider(),
                            _buildStepItem(icon: Icons.fact_check_outlined, label: 'Verifikasi'),
                            _buildArrowDivider(),
                            _buildStepItem(icon: Icons.verified_outlined, label: 'Terbit SK'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 4. SEKSI PERSYARATAN UMUM
                      const Row(
                        children: [
                          Icon(Icons.description_outlined, color: accentColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Persyaratan Umum',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: persyaratan.map((syarat) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      syarat,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 5. FIXED BOTTOM BAR (TOMBOL EMAS / ORANYE AJUKAN PERIZINAN REKLAME)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 8,
                    offset: Offset(0, -3),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _tampilkanDialogRedireksi(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ajukan $judulLayanan',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Anda akan diarahkan ke portal SAKTI',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.5,
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

  Widget _buildStepItem({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF123457).withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF123457), size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            color: Color(0xFF123457),
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildArrowDivider() {
    return const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 16);
  }
}
