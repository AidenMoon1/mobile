import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _tampilkanDetailModal(BuildContext context, String judul, String content, IconData icon) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey.shade800,
                  height: 1.6,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: accentColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tentang',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
        child: Column(
          children: [
            // KARTU 1: DESKRIPSI
            _buildAboutCard(
              context: context,
              title: 'Deskripsi',
              icon: Icons.badge_outlined,
              onTap: () {
                _tampilkanDetailModal(
                  context,
                  'Deskripsi Aplikasi',
                  'Aplikasi Sukabumi One Access (SUPERAPPS) merupakan platform layanan publik digital terpadu milik Pemerintah Kota Sukabumi. Aplikasi ini mengintegrasikan seluruh layanan masyarakat dalam satu genggaman, mulai dari pelayanan kependudukan, perizinan usaha, kesehatan, hingga pengaduan publik.',
                  Icons.badge_outlined,
                );
              },
            ),
            const SizedBox(height: 14),

            // KARTU 2: TUJUAN APLIKASI
            _buildAboutCard(
              context: context,
              title: 'Tujuan aplikasi',
              icon: Icons.inbox_rounded,
              onTap: () {
                _tampilkanDetailModal(
                  context,
                  'Tujuan Aplikasi',
                  '• Mempermudah masyarakat Kota Sukabumi mengakses layanan publik secara cepat, transparan, dan efisien.\n\n• Mewujudkan tata kelola pemerintahan digital yang berorientasi pada kemudahan warga.\n\n• Memangkas alur birokrasi dan meminimalisir penggunaan kertas (paperless).',
                  Icons.inbox_rounded,
                );
              },
            ),
            const SizedBox(height: 14),

            // KARTU 3: PENGEMBANG
            _buildAboutCard(
              context: context,
              title: 'Pengembang',
              icon: Icons.shuffle_rounded,
              onTap: () {
                _tampilkanDetailModal(
                  context,
                  'Pengembang',
                  'Tim Pengembang Mobile SuperApps Sukabumi\n\nDiskominfo Kota Sukabumi\nPemerintah Kota Sukabumi, Jawa Barat.\n\nVersi Aplikasi: 1.0.0 (Release Build)',
                  Icons.shuffle_rounded,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    const Color accentColor = Color(0xFFE8A33D);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // IKON BULAT ORANGE AMBER
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade700,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
