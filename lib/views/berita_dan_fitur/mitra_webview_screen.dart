import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MitraWebviewScreen extends StatefulWidget {
  final String judulLayanan;
  final String urlPortal;

  const MitraWebviewScreen({
    super.key,
    required this.judulLayanan,
    required this.urlPortal,
  });

  @override
  State<MitraWebviewScreen> createState() => _MitraWebviewScreenState();
}

class _MitraWebviewScreenState extends State<MitraWebviewScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // SKELETON LOADING 2.5 DETIK KEMUDIAN OTOMATIS BUKA LAYANAN WEB
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _bukaBrowserExternal();
      }
    });
  }

  Future<void> _bukaBrowserExternal() async {
    final Uri uri = Uri.parse(widget.urlPortal);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak dapat membuka portal web: ${widget.urlPortal}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
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
        title: Text(
          'Pengajuan ${widget.judulLayanan}',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser_rounded, color: accentColor),
            tooltip: 'Buka di Browser',
            onPressed: _bukaBrowserExternal,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState(primaryColor, accentColor)
          : _buildLoadedContentState(primaryColor, accentColor),
    );
  }

  // SCREEN 2: SKELETON LOADING "Memuat Halaman SAKTI..."
  Widget _buildLoadingState(Color primaryColor, Color accentColor) {
    return Column(
      children: [
        // SKELETON CARD HEADER
        Container(
          width: double.infinity,
          height: 120,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        const Spacer(),

        // 3 DOTS LOADING ORANYE DENGAN TEKS
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(accentColor, 10),
                const SizedBox(width: 8),
                _buildDot(accentColor.withOpacity(0.6), 10),
                const SizedBox(width: 8),
                _buildDot(accentColor.withOpacity(0.3), 10),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Memuat Halaman SAKTI...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),

        const Spacer(),
      ],
    );
  }

  // SCREEN 1: KONTEN DIMUAT (PORTAL WEB MASUK SEGERA)
  Widget _buildLoadedContentState(Color primaryColor, Color accentColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // CARD PORTAL SAKTI - DPMPTSP
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x26123457)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BADGE PORTAL MITRA
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x14123457),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance_rounded, color: primaryColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'SAKTI - Portal DPMPTSP',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Portal Layanan Web Resmi SAKTI - DPMPTSP',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Layanan siap diakses. Silakan tekan tombol di bawah jika portal web tidak terbuka secara otomatis.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12.5,
                    fontFamily: 'Poppins',
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                // TOMBOL MASUK KE LAYANAN WEB
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _bukaBrowserExternal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.open_in_browser_rounded, size: 20),
                    label: const Text(
                      'Masuk Ke Layanan Web',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // INFORMASI HELPER PENGALIHAN WEB
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: accentColor, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Layanan terhubung langsung dengan server resmi DPMPTSP Kota Sukabumi.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
