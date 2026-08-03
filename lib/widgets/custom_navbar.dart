import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A1E33);
    const activeColor = Color(0xFFE8A33D);
    const inactiveColor = Colors.white60;

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

class _NavBarItemData {
  final IconData icon;
  final String label;

  const _NavBarItemData({
    required this.icon,
    required this.label,
  });
}