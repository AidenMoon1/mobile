import 'package:flutter/material.dart';
import 'views/dashboard_screen.dart';
import 'views/report_screen.dart';
import 'views/notification_screen.dart';
import 'views/profile_screen.dart';
import 'widgets/custom_navbar.dart';

import 'services/notification_service.dart';
import 'services/feedback_service.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Service dan Database Lokal
  await UserService().init();
  await NotificationService().init();
  await FeedbackService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sukabumi One Access',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A1E33),
          primary: const Color(0xFF0A1E33),
          secondary: const Color(0xFFE8A33D),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A1E33),
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // # CATATAN: Index menu navbar yang sedang aktif (0 = Beranda, 1 = Layanan, 2 = Notifikasi, 3 = Akun)
  int _selectedIndex = 0;

  // # CATATAN: Daftar 4 Halaman yang terhubung dengan 4 Tombol Navbar Custom
  final List<Widget> _screens = [
    const DashboardScreen(), // # Halaman 1: Beranda
    const ReportScreen(),    // # Halaman 2: Layanan / Pengaduan
    const NotificationScreen(), // # Halaman 3: Notifikasi
    const ProfileScreen(),   // # Halaman 4: Akun / Profil
  ];

  // # FUNGSI SAAT SALAH SATU MENU NAVBAR DIKLIK
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      // # CATATAN: Menggunakan Widget Custom Bottom Navbar buatan teman Anda
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
