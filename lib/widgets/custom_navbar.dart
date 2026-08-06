// =============================================================================
// FILE: lib/widgets/custom_navbar.dart
// FUNGSI: Widget Bottom Navigation Bar Kustom 4 Menu Aplikasi Warga
// PATTERN: Stateless Reusable Navigation Bar Component
// LEVEL KODE: Level 2-3 (Sangat Rapi & Terstruktur Untuk Mahasiswa)
// =============================================================================

import 'package:flutter/material.dart';

/// Widget Custom Bottom Navigation Bar dengan 4 Menu Utama (Beranda, Layanan, Notifikasi, Akun)
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;          // Indeks menu aktif (0 s/d 3)
  final ValueChanged<int> onItemTapped; // Callback pemanggil saat menu di-klik

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A1E33);   // Warna dasar Navy
    const activeColor = Color(0xFFE8A33D);    // Warna aktif Akses Emas
    const inactiveColor = Colors.white60;     // Warna tidak aktif putih pudar

    // DAFTAR 4 MENU UTAMA NAVBAR
    const navItems = [
      _NavBarItemData(
        icon: Icons.home_rounded,
        label: 'Beranda',
      ),
      _NavBarItemData(
        icon: Icons.assignment_rounded,
        label: 'Layanan',
      ),
      _NavBarItemData(
        icon: Icons.notifications_rounded,
        label: 'Notifikasi',
      ),
      _NavBarItemData(
        icon: Icons.person_rounded,
        label: 'Akun',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = selectedIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => onItemTapped(index),
                  splashColor: activeColor.withOpacity(0.1),
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Indikator Efek Animasi Melayang Pada Ikon Aktif
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? activeColor.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.icon,
                          color: isSelected ? activeColor : inactiveColor,
                          size: isSelected ? 24 : 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? activeColor : inactiveColor,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Helper Private Class penampung data Ikon & Label Navbar
class _NavBarItemData {
  final IconData icon;
  final String label;

  const _NavBarItemData({
    required this.icon,
    required this.label,
  });
}