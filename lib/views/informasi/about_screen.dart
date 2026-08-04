import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailTentangScreen(
                      appBarTitle: 'Deskripsi',
                      pageTitle: 'Deskripsi Aplikasi',
                      paragraph1:
                          'Sukabumi City One Access adalah aplikasi resmi Pemerintah Kota Sukabumi yang menyediakan berbagai layanan publik dalam satu aplikasi. Melalui aplikasi ini, masyarakat dapat mengakses informasi resmi, menggunakan layanan pemerintah, menyampaikan pengaduan, serta memperoleh informasi dan pengumuman terbaru dengan lebih mudah.',
                      paragraph2:
                          'Aplikasi ini dirancang dengan tampilan yang sederhana dan mudah digunakan oleh semua kalangan. Dengan menggabungkan berbagai layanan dalam satu platform, masyarakat tidak perlu lagi berpindah-pindah aplikasi untuk mendapatkan layanan yang dibutuhkan.',
                    ),
                  ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailTentangScreen(
                      appBarTitle: 'Tentang',
                      pageTitle: 'Tentang Aplikasi',
                      paragraph1:
                          'Sukabumi City One Access hadir sebagai bagian dari upaya Pemerintah Kota Sukabumi dalam meningkatkan kualitas pelayanan publik melalui pemanfaatan teknologi digital. Aplikasi ini dibuat agar masyarakat dapat mengakses berbagai layanan pemerintah dengan lebih mudah, cepat, dan praktis melalui satu aplikasi yang terintegrasi.',
                      paragraph2:
                          'Melalui Sukabumi City One Access, masyarakat dapat memperoleh layanan secara lebih efisien tanpa harus datang langsung ke kantor untuk setiap kebutuhan tertentu. Aplikasi ini juga menjadi sarana untuk memperkuat komunikasi antara pemerintah dan masyarakat, sehingga penyampaian informasi maupun pelayanan publik dapat dilakukan dengan lebih baik.',
                    ),
                  ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailTentangScreen(
                      appBarTitle: 'Pengembang',
                      pageTitle: 'Pengembang Aplikasi',
                      paragraph1:
                          'Sukabumi City One Access dikembangkan oleh Dinas Komunikasi dan Informatika (Diskominfo) Kota Sukabumi sebagai aplikasi resmi Pemerintah Kota Sukabumi. Pengembangan aplikasi ini merupakan bagian dari komitmen pemerintah daerah dalam mendukung transformasi digital dan meningkatkan kualitas pelayanan kepada masyarakat.',
                      paragraph2:
                          'Aplikasi ini akan terus dikembangkan dan disempurnakan secara berkala sesuai dengan kebutuhan masyarakat serta perkembangan teknologi. Pemerintah Kota Sukabumi berkomitmen untuk menghadirkan layanan yang aman, mudah digunakan, dan mampu memberikan manfaat bagi seluruh masyarakat Kota Sukabumi.',
                    ),
                  ),
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

class DetailTentangScreen extends StatelessWidget {
  final String appBarTitle;
  final String pageTitle;
  final String paragraph1;
  final String paragraph2;

  const DetailTentangScreen({
    super.key,
    required this.appBarTitle,
    required this.pageTitle,
    required this.paragraph1,
    required this.paragraph2,
  });

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
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              pageTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paragraph1,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      height: 1.6,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    paragraph2,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      height: 1.6,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
