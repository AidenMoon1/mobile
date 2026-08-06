// =============================================================================
// FILE: lib/widgets/smart_image.dart
// FUNGSI: Widget Pemuat Gambar Pintar Multi-Sumber (Network, Assets, Local File)
// PATTERN: Fallback Guard & Defensive Rendering Strategy
// LEVEL KODE: Level 2-3 (Sangat Rapi & Terstruktur Untuk Mahasiswa)
// =============================================================================

import 'dart:io';
import 'package:flutter/material.dart';

/// Widget Universal Pemuat Gambar dengan Proteksi Fallback Otomatis
class SmartImage extends StatelessWidget {
  final String imagePath;      // Jalur lokasi gambar (http/https, assets/, atau path file HP)
  final double? width;         // Lebar batas kotak gambar
  final double? height;        // Tinggi batas kotak gambar
  final BoxFit fit;            // Mode pangkas/pembesaran gambar (cover, contain, fill)
  final double borderRadius;   // Radius sudut melengkung
  final IconData fallbackIcon; // Ikon pengganti jika gambar gagal dimuat
  final Color fallbackColor;   // Warna tema ikon pengganti

  const SmartImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.fallbackIcon = Icons.image_rounded,
    this.fallbackColor = const Color(0xFF123457),
  });

  @override
  Widget build(BuildContext context) {
    final String path = imagePath.trim();
    Widget imageWidget;

    // STEP 1: Deteksi Jalur Sumber Gambar Secara Otomatis
    if (path.isEmpty) {
      // A. Jika path kosong, tampilkan fallback ikon
      imageWidget = _buildFallback();
    } else if (path.startsWith('http://') || path.startsWith('https://')) {
      // B. Jika path berasal dari Internet (Network Image)
      imageWidget = Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    } else if (path.startsWith('assets/')) {
      // C. Jika path berasal dari Aset Lokal Proyek (Asset Image)
      imageWidget = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    } else {
      // D. Jika path berasal dari Penyimpanan Lokal HP (File Image)
      final file = File(path);
      if (file.existsSync()) {
        imageWidget = Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
      } else {
        imageWidget = _buildFallback();
      }
    }

    // STEP 2: Bungkus dengan Sudut Melengkung Jika Memiliki Radius
    if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  // FUNGSI HELPER: Membangun Kotak Cadangan (Fallback Box) Saat Gambar Gagal Dimuat
  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: fallbackColor.withOpacity(0.12),
      child: Center(
        child: Icon(
          fallbackIcon,
          color: fallbackColor,
          size: (width != null && width! < 40) ? 18 : 26,
        ),
      ),
    );
  }
}
