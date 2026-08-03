import 'package:flutter/material.dart';

class TermsAndPolicyScreen extends StatelessWidget {
  const TermsAndPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    final List<String> policyItems = [
      'Dasar Hukum',
      'Data Pribadi Pengguna',
      'Data Non-Pribadi Pengguna',
      'Cookies',
      'Bagaimana Kami Menggunakan Data',
      'Perlindungan Data Pribadi Pengguna',
      'Berbagi Data Pribadi Dan Data Non-Pribadi',
      'Jangka Waktu Data',
      'Perubahan Kebijakan Privasi',
      'Mengubah, Menghapus, Dan Meminta',
      'Perangkat Lunak Dan Ekstensi Yang Digunakan',
      'Persetujuan',
    ];

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: accentColor, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'Kebijakan ', style: TextStyle(color: Colors.white)),
              TextSpan(text: 'dan Ketentuan', style: TextStyle(color: accentColor)),
            ],
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'KEBIJAKAN PRIVASI',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              // Version Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Versi 5.4.3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Update Date
              const Row(
                children: [
                  Icon(Icons.calendar_today_outlined, color: primaryColor, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Diperbarui per tanggal ',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    '23 Desember 2026',
                    style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Intro Text
              const Text(
                'Kebijakan Privasi ini menjelaskan bagaimana Sukabumi City One Access mengumpulkan, menggunakan, menyimpan, dan melindungi data pribadi Anda selama menggunakan layanan aplikasi. Informasi yang Anda berikan akan digunakan untuk mendukung penyelenggaraan layanan, meningkatkan kualitas pelayanan, serta memberikan pengalaman penggunaan aplikasi yang lebih baik sesuai dengan ketentuan yang berlaku.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Policy List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: policyItems.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      policyItems[index],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                    onTap: () {
                      // Action for each policy section
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
