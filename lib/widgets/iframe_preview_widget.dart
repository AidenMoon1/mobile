import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'iframe_helper.dart';

/// Widget Pratinjau iFrame Web Portal Terintegrasi Langsung pada Body Aplikasi
class IframePreviewWidget extends StatefulWidget {
  final String url;
  final String title;
  final double height;
  final bool showControls;

  const IframePreviewWidget({
    super.key,
    required this.url,
    this.title = 'Pratinjau iFrame Web Dinas Resmi',
    this.height = 550,
    this.showControls = true,
  });

  @override
  State<IframePreviewWidget> createState() => _IframePreviewWidgetState();
}

class _IframePreviewWidgetState extends State<IframePreviewWidget> {
  int _reloadKey = 0;

  String get _cleanUrl {
    final raw = widget.url.trim();
    if (raw.isEmpty) return '';
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    return 'https://$raw';
  }

  Future<void> _openExternalUrl() async {
    final urlStr = _cleanUrl;
    if (urlStr.isEmpty) return;
    final uri = Uri.parse(urlStr);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Tidak dapat membuka URL: $e');
    }
  }

  void _showFullscreenModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F2942),
            leading: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                const Icon(Icons.language_rounded, color: Color(0xFFE8A33D), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
                tooltip: 'Buka di Tab Baru',
                onPressed: _openExternalUrl,
              ),
            ],
          ),
          body: IframePreviewWidget(
            url: widget.url,
            title: widget.title,
            height: double.infinity,
            showControls: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F2942);
    const accentGold = Color(0xFFE8A33D);
    final targetUrl = _cleanUrl;

    if (targetUrl.isEmpty) {
      return Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.code_off_rounded, color: Colors.grey, size: 28),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pratinjau iFrame Web Belum Aktif',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 4),
            const Text(
              'Masukkan Tautan URL Web Portal/Formulir Dinas di atas untuk menampilkan halaman web live di sini.',
              style: TextStyle(fontSize: 11.5, color: Colors.grey, fontFamily: 'Poppins'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final String viewId = 'iframe-${targetUrl.hashCode}-$_reloadKey';

    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0F2942).withOpacity(0.2), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // BROWSER FRAME HEADER BAR
            if (widget.showControls)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F2942),
                ),
                child: Row(
                  children: [
                    // MAC-STYLE WINDOW CONTROL DOTS
                    Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // URL ADDRESS DISPLAY BAR
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_rounded, color: Color(0xFF81C784), size: 13),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                targetUrl,
                                style: const TextStyle(fontSize: 11.5, color: Colors.white, fontFamily: 'Poppins'),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // REFRESH BUTTON
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                      tooltip: 'Muat Ulang Tampilan iFrame',
                      onPressed: () => setState(() => _reloadKey++),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),

                    // OPEN EXTERNAL BUTTON
                    IconButton(
                      icon: const Icon(Icons.open_in_new_rounded, color: accentGold, size: 18),
                      tooltip: 'Buka di Tab Baru Browser',
                      onPressed: _openExternalUrl,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),

                    // FULLSCREEN PREVIEW BUTTON
                    IconButton(
                      icon: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 20),
                      tooltip: 'Tampilan Penuh (Fullscreen)',
                      onPressed: () => _showFullscreenModal(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ),

            // LIVE EMBEDDED IFRAME BODY
            Expanded(
              child: Stack(
                children: [
                  kIsWeb
                      ? KeyedSubtree(
                          key: ValueKey(viewId),
                          child: getIframeWebWidget(viewId, targetUrl),
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color(0xFFF8FAFC),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.language_rounded, size: 54, color: primaryColor),
                              const SizedBox(height: 12),
                              Text(
                                'Integrasi Web iFrame Resmi:\n$targetUrl',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _openExternalUrl,
                                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                                label: const Text('Buka Web Resmi', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
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
