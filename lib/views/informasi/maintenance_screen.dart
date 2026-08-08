import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:mobile/views/informasi/help_center_screen.dart';

class MaintenanceScreen extends StatelessWidget {
  final String title;
  final String category;
  final String? customMessage;

  const MaintenanceScreen({
    super.key,
    required this.title,
    this.category = 'Layanan Publik',
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A1E33);
    const accentColor = Color(0xFFE8A33D);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pemeliharaan Sistem',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ANIMATED/STYLISH MAINTENANCE ICON CONTAINER
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6E5),
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1AE8A33D),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.construction_rounded,
                      color: accentColor,
                      size: 56,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // BADGE MAINTENANCE STATUS
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFEEBA)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.build_circle_rounded, color: Color(0xFF856404), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'PERBAIKAN SERVER ROUTINE',
                        style: TextStyle(
                          color: Color(0xFF856404),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // JUDUL LAYANAN/INSTANSI YANG DIMAINTENANCE
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Status: Nonaktif Sementara ($category)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 20),

                // CARD PENJELASAN
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: primaryColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Pemberitahuan Sistem',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        customMessage ??
                            'Sistem $title saat ini sedang dalam peningkatan kualitas & pemeliharaan server rutin oleh Tim IT Pemkot Sukabumi.\n\nLayanan akan kembali aktif secara otomatis setelah perbaikan selesai. Mohon maaf atas ketidaknyamanannya.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade800,
                          height: 1.5,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // TOMBOL NAVIGASI ACTION
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home_rounded, size: 18, color: Colors.white),
                    label: const Text(
                      'Kembali ke Beranda Utama',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.88,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          child: const ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            child: HelpCenterScreen(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.smart_toy_rounded, size: 18, color: primaryColor),
                    label: const Text(
                      'Konsultasi via AI Bot SOA',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: primaryColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor.withOpacity(0.3), width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
