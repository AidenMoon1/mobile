import 'package:flutter/material.dart';

class GuestGatekeeper {
  /// Memeriksa apakah pengguna memiliki akses.
  /// FITUR TERBARU: Selalu mengizinkan seluruh warga (Tamu maupun Logged In)
  /// untuk bebas menjelajah dan mengklik semua sektor layanan, berita, fitur,
  /// dan informasi publik Kota Sukabumi tanpa terhalang dialog kunci.
  static bool checkAccess(BuildContext context, {required VoidCallback onGranted}) {
    onGranted();
    return true;
  }
}
