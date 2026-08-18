import 'package:flutter/material.dart';

Widget getIframeWebWidget(String viewId, String url) {
  return Container(
    color: const Color(0xFFF4F6F9),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.language_rounded, size: 48, color: Color(0xFF0F2942)),
          const SizedBox(height: 12),
          Text(
            'Pratinjau iFrame: $url',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'Mode webview iFrame aktif di platform ini.',
            style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
          ),
        ],
      ),
    ),
  );
}

void registerIframeViewFactory(String viewId, String url) {}
