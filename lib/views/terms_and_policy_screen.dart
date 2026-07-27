import 'package:flutter/material.dart';

class TermsAndPolicyScreen extends StatelessWidget {
  const TermsAndPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Syarat dan Ketentuan Penggunaan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selamat datang di aplikasi Native Sukabumi One Access. Dengan mengakses dan menggunakan aplikasi ini, Anda setuju untuk terikat oleh syarat dan ketentuan berikut:\n\n'
              '1. Penggunaan Layanan: Anda setuju untuk menggunakan layanan ini hanya untuk tujuan yang sah dan sesuai dengan hukum yang berlaku di Indonesia.\n\n'
              '2. Privasi Data: Kami menghargai privasi Anda. Data yang dikumpulkan akan digunakan sesuai dengan Kebijakan Privasi kami untuk meningkatkan layanan publik di Kota Sukabumi.\n\n'
              '3. Akun Pengguna: Anda bertanggung jawab untuk menjaga kerahasiaan informasi akun dan kata sandi Anda.\n\n'
              '4. Perubahan Ketentuan: Kami berhak untuk mengubah syarat dan ketentuan ini sewaktu-waktu. Perubahan akan berlaku segera setelah dipublikasikan di aplikasi.',
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 32),
            const Text(
              'Kebijakan Privasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kami berkomitmen untuk melindungi data pribadi Anda. Kebijakan ini menjelaskan bagaimana kami mengelola informasi Anda:\n\n'
              '- Pengumpulan Data: Kami mengumpulkan NIK, Nama, dan Nomor Kontak untuk keperluan verifikasi layanan publik.\n'
              '- Keamanan: Kami menggunakan standar keamanan industri untuk melindungi data Anda dari akses yang tidak sah.\n'
              '- Penggunaan Pihak Ketiga: Kami tidak akan menjual atau menyewakan data pribadi Anda kepada pihak ketiga untuk tujuan komersial.',
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
