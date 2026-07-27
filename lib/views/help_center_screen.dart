import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. TOPMOST LOGO BAR (White Bar)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 45, 16, 8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App Logo Placeholder
                Row(
                  children: [
                    Image.network(
                      'https://via.placeholder.com/30x30', // Logo placeholder
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'SukabumiCity',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                // Weather Temperature
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Sukabumi, ',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                      const Text(
                        '28°C',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.wb_cloudy, color: Colors.blueAccent, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. MAIN HEADER (Potensi Cuaca & Profile)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Weather Alert Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Potensi Cuaca',
                            style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Ekstrem',
                            style: TextStyle(color: Colors.black, fontSize: 8),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.info_outline, color: Colors.green, size: 12),
                    ],
                  ),
                ),
                // User Info
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Sampurasun, mrn',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Jum\'at, 17 Juli 2026',
                          style: TextStyle(color: accentColor, fontSize: 9),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 3. HERO SECTION (Building with Laurel Icons)
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const NetworkImage('https://via.placeholder.com/600x400'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Laurel Icons and Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.eco_outlined, color: accentColor, size: 20), // Left Laurel
                            const SizedBox(width: 8),
                            const Text(
                              'SUKABUMI ONE ACCESS',
                              style: TextStyle(color: accentColor, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.eco_outlined, color: accentColor, size: 20), // Right Laurel
                          ],
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: 'Pusat Layanan ', style: TextStyle(color: Colors.white)),
                              TextSpan(text: 'Kota Sukabumi.', style: TextStyle(color: accentColor)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Temukan kemudahan mengakses berbagai layanan informasi dari seluruh Instansi Pemerintah Kota Sukabumi dalam satu pintu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4. CHAT NAV BAR
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      border: Border(bottom: BorderSide(color: accentColor, width: 2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.chevron_left, color: accentColor, size: 28),
                            ),
                            const SizedBox(width: 8),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(text: 'Pusat ', style: TextStyle(color: Colors.white)),
                                  TextSpan(text: 'Bantuan', style: TextStyle(color: accentColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.more_vert, color: accentColor),
                      ],
                    ),
                  ),

                  // 5. FAQ & CHAT AREA
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // FAQ Card
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EEF3),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ada yang bisa kami bantu?',
                                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 12),
                              _buildFAQItem('Bagaimana cara membuat pengaduan?'),
                              _buildFAQItem('Bagaimana cara melihat status pengaduan saya?'),
                              _buildFAQItem('Berapa lama pengaduan diproses?'),
                              _buildFAQItem('Apa saja layanan yang tersedia?'),
                              _buildFAQItem('Di mana lokasi kantor pelayanan?'),
                              _buildFAQItem('Mengapa pengaduan saya belum ditindaklanjuti?', showDivider: false),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // User Chat Bubble (Orange Box)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 240,
                            height: 65,
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Bot Response Prompt
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Lanjutkan chat dengan SOA?',
                              style: TextStyle(color: Colors.black87, fontSize: 13),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. CHAT INPUT BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 0.8),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.grey, size: 24),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Kami siap membantu',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        Icon(Icons.attach_file, color: Colors.grey, size: 22),
                        SizedBox(width: 12),
                        Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 22),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.send, color: Colors.grey, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String text, {bool showDivider = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF3B5B80), fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ),
        if (showDivider) const Divider(color: Colors.white, height: 1, thickness: 1.5),
      ],
    );
  }
}
