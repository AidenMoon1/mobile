import 'package:flutter/material.dart';

// # ============================================================================
// # CUSTOM BOTTOM NAVBAR (FIGMA NAVY BUBBLE BAR - RESPONSIF & INTERAKTIF)
// # ============================================================================
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const Color navyColor = Color(0xFF123457);
    const Color goldColor = Color(0xFFE8A33D);
    const Color whiteColor = Colors.white;

    final List<Map<String, dynamic>> menuItems = [
      {
        'label': 'Beranda',
        'icon': Icons.home_rounded,
      },
      {
        'label': 'Layanan',
        'icon': Icons.grid_view_rounded,
      },
      {
        'label': 'Informasi',
        'icon': Icons.notifications_active_rounded,
      },
      {
        'label': 'Profil',
        'icon': Icons.person_rounded,
      },
    ];

    return Container(
      width: double.infinity,
      height: 86,
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // BANNER BILAH BIRU NAVY BAGIAN BAWAH (HEIGHT 56)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 56,
            child: Container(
              color: navyColor,
            ),
          ),

          // LIST 4 TOMBOL MENU DENGAN IKON LINGKARAN FIGMA (40x40) & TEKS JUDUL
          Positioned.fill(
            child: Row(
              children: List.generate(menuItems.length, (index) {
                final bool isAktif = selectedIndex == index;
                final item = menuItems[index];

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onItemTapped(index),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // LINGKARAN BUBBLE IKON FIGMA (OVAL BORDER / 40x40 CIRCLE)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: navyColor,
                            shape: BoxShape.circle,
                            border: isAktif
                                ? Border.all(color: goldColor, width: 2.0)
                                : Border.all(color: Colors.white24, width: 1.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: isAktif ? goldColor : whiteColor,
                            size: isAktif ? 24 : 20,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // TEKS JUDUL MENU (EMAS JIKA AKTIF, PUTIH JIKA INAKTIF)
                        Text(
                          item['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isAktif ? goldColor : whiteColor,
                            fontSize: 11.5,
                            fontFamily: 'Poppins',
                            fontWeight: isAktif ? FontWeight.bold : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}