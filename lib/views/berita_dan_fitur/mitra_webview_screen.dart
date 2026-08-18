import 'package:flutter/material.dart';
import 'package:mobile/widgets/iframe_preview_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MitraWebviewScreen extends StatelessWidget {
  final String judulLayanan;
  final String urlPortal;

  const MitraWebviewScreen({
    super.key,
    required this.judulLayanan,
    required this.urlPortal,
  });

  Future<void> _bukaBrowserExternal() async {
    final Uri uri = Uri.parse(urlPortal);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
          'Pengajuan $judulLayanan',
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
            tooltip: 'Buka di Browser Eksternal',
            onPressed: _bukaBrowserExternal,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IframePreviewWidget(
          url: urlPortal,
          title: 'Portal Web iFrame: $judulLayanan',
          height: double.infinity,
        ),
      ),
    );
  }
}
