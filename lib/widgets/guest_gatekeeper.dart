import 'package:flutter/material.dart';
import 'package:mobile/services/user_service.dart';
import 'package:mobile/views/profile/login_screen.dart';

class GuestGatekeeper {
  /// Gatekeeper Keamanan Aplikasi Sukabumi One Access.
  /// Memeriksa status otentikasi akun pengguna.
  /// - Pengguna Logged-In: Akses diberikan langsung (onGranted).
  /// - Pengguna Mode Tamu: Tampilkan dialog Pop-Up Keamanan "Harus Login Terlebih Dahulu".
  static bool checkAccess(BuildContext context, {required VoidCallback onGranted}) {
    if (UserService().isLoggedIn) {
      onGranted();
      return true;
    }

    _tampilkanDialogAksesTamu(context);
    return false;
  }

  static void _tampilkanDialogAksesTamu(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(22.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IKON PROTEKSI KEAMANAN DENGAN WADAH NAVY
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor.withOpacity(0.15), width: 1.5),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_rounded,
                  color: primaryColor,
                  size: 46,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Akses Terbatas Mode Tamu',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor),
                ),
                child: const Text(
                  '🔒 Demi keamanan sistem & perlindungan data warga Kota Sukabumi, fitur ini hanya dapat diakses oleh akun terverifikasi.\n\nSilakan Masuk (Login) atau Mendaftar Akun terlebih dahulu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: primaryColor,
                    height: 1.45,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Nanti Saja',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext); // Tutup dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      icon: const Icon(Icons.login_rounded, size: 16, color: primaryColor),
                      label: const Text(
                        'Login / Daftar',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
