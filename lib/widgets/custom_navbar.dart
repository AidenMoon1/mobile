import 'package:flutter/material.dart';

// # ============================================================================
// # CUSTOM BOTTOM NAVBAR (FLOATING ACTIVE BUTTON DENGAN U-DIP & TRANSPARAN)
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
    // # 4 Menu navigasi utama (Beranda, Layanan, Informasi, Profil)
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_rounded, 'label': 'Beranda'},
      {'icon': Icons.grid_view_rounded, 'label': 'Layanan'},
      {'icon': Icons.notifications_rounded, 'label': 'Informasi'},
      {'icon': Icons.person_rounded, 'label': 'Profil'},
    ];

    const Color navColor = Color(0xFF123457); // # Warna navy utama (#123457)
    const Color activeColor = Color(0xFFE8A33D); // # Warna emas/oranye (#E8A33D)
    const Color inactiveColor = Colors.white; // # Warna putih

    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.transparent, // 👈 Transparan tanpa warna putih
      child: Stack(
        clipBehavior: Clip.none, // 👈 Memungkinkan tombol mengambang keluar navbar
        children: [
          // # 1. Background Navy Melukis U-DIP Menjorok ke Dalam (Flat Lurus di Samping)
          Positioned.fill(
            child: CustomPaint(
              painter: FloatingUDipNavbarPainter(
                color: navColor,
                itemCount: items.length,
                selectedIndex: selectedIndex,
              ),
            ),
          ),

          // # 2. Baris Item Menu Navigasi
          Row(
            children: List.generate(items.length, (index) {
              final isSelected = selectedIndex == index;
              final item = items[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => onItemTapped(index),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // # IKON NAVIGASI (MENGAMBANG NAIK KE ATAS SAAT AKTIF)
                      Positioned(
                        top: isSelected ? -14 : 22, // 👈 Tombol mengambang menonjol keluar ke atas
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutBack,
                          width: isSelected ? 52 : 36,
                          height: isSelected ? 52 : 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: navColor,
                            // # Bayangan mengambang (Floating Shadow)
                            boxShadow: isSelected
                                ? const [
                                    BoxShadow(
                                      color: Color(0x50000000),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    )
                                  ]
                                : null,
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: isSelected ? activeColor : inactiveColor,
                            size: isSelected ? 28 : 20,
                          ),
                        ),
                      ),

                      // # TEKS LABEL MENU (Beranda, Layanan, Informasi, Profil)
                      Positioned(
                        bottom: 4,
                        child: Text(
                          item['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? activeColor : inactiveColor,
                            fontSize: 10.5,
                            fontFamily: 'Poppins',
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// # ============================================================================
// # PAINTER U-DIP MENJOROK KE DALAM TANPA STRIP PUTIH DENGAN ATAS RATA
// # ============================================================================
class FloatingUDipNavbarPainter extends CustomPainter {
  final Color color;
  final int itemCount;
  final int selectedIndex;

  FloatingUDipNavbarPainter({
    required this.color,
    required this.itemCount,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    const double barTop = 18.0; // 👈 Garis lurus navy (Area atas transparan murni)

    // Mulai dari pojok kiri bawah
    path.moveTo(0, size.height);
    path.lineTo(0, barTop);

    final double itemWidth = size.width / itemCount;

    for (int i = 0; i < itemCount; i++) {
      final double cx = (i + 0.5) * itemWidth;

      if (i == selectedIndex) {
        // # Tab AKTIF: U-DIP Menjorok Lengkung ke Dalam
        final double startX = cx - 70;
        final double endX = cx + 70;

        path.lineTo(startX, barTop);

        path.cubicTo(
          cx - 25, barTop,
          cx - 25, barTop + 28, // Kedalaman U-Dip ke bawah
          cx, barTop + 28,
        );
        path.cubicTo(
          cx + 25, barTop + 28,
          cx + 25, barTop,
          endX, barTop,
        );
      } else {
        // # Tab BIASA: Garis lurus navy rata
        path.lineTo(cx + itemWidth / 2, barTop);
      }
    }

    path.lineTo(size.width, barTop);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FloatingUDipNavbarPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex || oldDelegate.color != color;
  }
}
