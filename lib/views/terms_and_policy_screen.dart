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
      body: const Center(
        child: Text(
          'Konten belum tersedia.',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
