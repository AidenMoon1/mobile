import 'package:flutter/material.dart';

// # Navigasi bawah custom untuk aplikasi Sukabumi One Access
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
    return Container(
      width: double.infinity,
      height: 75,
      decoration: const BoxDecoration(
        color: Color(0xFF123457), // # Warna dasar navbar biru gelap
        border: Border(
          top: BorderSide(color: Color(0xFF1E456E), width: 1.0), // # Garis pembatas atas
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // # 1. Tombol Beranda
          _buatItemMenu(
            index: 0,
            icon: Icons.home_rounded,
            label: 'Beranda',
          ),
          // # 2. Tombol Layanan
          _buatItemMenu(
            index: 1,
            icon: Icons.grid_view_rounded,
            label: 'Layanan',
          ),
          // # 3. Tombol Notifikasi
          _buatItemMenu(
            index: 2,
            icon: Icons.notifications_rounded,
            label: 'Notifikasi',
          ),
          // # 4. Tombol Akun
          _buatItemMenu(
            index: 3,
            icon: Icons.person_rounded,
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  // # Fungsi pembuat item tombol menu agar kode lebih rapi
  Widget _buatItemMenu({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isAktif = selectedIndex == index;
    final Color warnaAktif = const Color(0xFFE8A33D); // # Warna emas saat dipilih
    final Color warnaBiasa = Colors.white70; // # Warna putih redup

    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 75,
        height: 75,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // # Lengkungan mangkuk emas (hanya muncul pada menu yang sedang aktif)
            if (isAktif)
              Positioned.fill(
                child: CustomPaint(
                  painter: LengkunganEmasPainter(color: warnaAktif),
                ),
              ),

            // # Lingkaran biru bulat di tengah
            Positioned(
              top: 2,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF123457),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x55000000),
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Icon(
                  icon,
                  color: isAktif ? warnaAktif : warnaBiasa,
                  size: isAktif ? 28 : 22,
                ),
              ),
            ),

            // # Teks judul menu
            Positioned(
              bottom: 4,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isAktif ? warnaAktif : warnaBiasa,
                  fontSize: 11,
                  fontFamily: 'Poppins',
                  fontWeight: isAktif ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// # Class painter untuk melukis lengkungan mangkuk emas di belakang ikon aktif
class LengkunganEmasPainter extends CustomPainter {
  final Color color;
  LengkunganEmasPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    final double centerX = size.width / 2;

    // # Garis atas sayap kiri
    path.moveTo(0, 26);
    path.lineTo(14, 26);

    // # Lekukan dalam di belakang lingkaran
    path.quadraticBezierTo(centerX, 45, size.width - 14, 26);

    // # Garis atas sayap kanan
    path.lineTo(size.width, 26);

    // # Lekukan mangkuk bawah
    path.cubicTo(
      size.width - 10, 44,
      centerX + 18, 55,
      centerX, 55,
    );
    path.cubicTo(
      centerX - 18, 55,
      10, 44,
      0, 26,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
