import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'activity_log_screen.dart';
import 'terms_and_policy_screen.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Ambil instance UserService
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    // Ambil data user terbaru dari Service
    final UserModel user = _userService.currentUser;

    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);
    const Color backgroundColor = Color(0xFFF5F8FB);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER SECTION
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              child: Column(
                children: [
                  // Edit Profil Button Row
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        // Navigasi ke Edit Profil dan refresh saat kembali
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        ).then((_) {
                          // REFRESH UI: Memanggil setState agar widget menggambar ulang dengan data baru
                          setState(() {});
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Edit Profil',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Profile Picture
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  // Badge Warga
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Text(
                      'Warga',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Name (DINAMIS DARI SERVICE)
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ID (DINAMIS DARI SERVICE)
                  Text(
                    user.id,
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 16),
                  // Completing data banner
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.description, color: accentColor, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Lengkapi Data Diri Anda',
                        style: TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // MENU LIST SECTION
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Log Aktivitas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ActivityLogScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Kebijakan dan Ketentuan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsAndPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.face,
                    title: 'Pusat Bantuan',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.rate_review_outlined,
                    title: 'Kritik dan Saran',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.layers_outlined,
                    title: 'Versi Aplikasi',
                    trailing: const Text(
                      '5.4.3',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  // LOGOUT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Keluar Akun',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.logout),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFFDF4E7),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFE8A33D), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.black54),
        onTap: onTap,
      ),
    );
  }
}
