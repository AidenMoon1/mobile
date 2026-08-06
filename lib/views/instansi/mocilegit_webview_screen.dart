import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MocilegitWebviewScreen extends StatefulWidget {
  final String title;
  final String url;

  const MocilegitWebviewScreen({
    super.key,
    this.title = 'Mocilegit Disdukcapil',
    this.url = 'https://mocilegit.sukabumikota.go.id/dashboard',
  });

  @override
  State<MocilegitWebviewScreen> createState() => _MocilegitWebviewScreenState();
}

class _MocilegitWebviewScreenState extends State<MocilegitWebviewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFFF4F6F9))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _loadingProgress = progress;
                });
              }
            },
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  Future<void> _bukaUrlExternal() async {
    final Uri uri = Uri.parse(widget.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka halaman web.')),
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
          onPressed: () async {
            if (_controller != null && await _controller!.canGoBack()) {
              await _controller!.goBack();
            } else {
              if (context.mounted) Navigator.pop(context);
            }
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (_controller != null)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              tooltip: 'Muat Ulang',
              onPressed: () => _controller!.reload(),
            ),
          IconButton(
            icon: const Icon(Icons.open_in_browser_rounded, color: accentColor),
            tooltip: 'Buka di Browser',
            onPressed: _bukaUrlExternal,
          ),
        ],
      ),
      body: kIsWeb
          ? _buildWebFallback(primaryColor, accentColor)
          : Stack(
              children: [
                if (_controller != null) WebViewWidget(controller: _controller!),
                if (_isLoading)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: _loadingProgress > 0 ? (_loadingProgress / 100.0) : null,
                      backgroundColor: Colors.grey.shade200,
                      color: accentColor,
                      minHeight: 4,
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildWebFallback(Color primaryColor, Color accentColor) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.language_rounded, color: primaryColor, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Aplikasi saat ini dijalankan di mode Browser Web (Chrome). WebView native berjalan optimal pada Android/iOS.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontFamily: 'Poppins',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _bukaUrlExternal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 20),
                label: const Text(
                  'Buka Portal Mocilegit',
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
    );
  }
}
