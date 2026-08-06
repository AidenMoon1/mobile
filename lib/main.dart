// =============================================================================
// FILE: lib/main.dart
// FUNGSI: Titik Masuk Utama (Entry Point) Aplikasi Sukabumi One Access
// =============================================================================

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// --- LAYAR / VIEWS WARGA ---
import 'package:mobile/views/berita_dan_fitur/dashboard_screen.dart';
import 'package:mobile/views/berita_dan_fitur/report_screen.dart';
import 'package:mobile/views/berita_dan_fitur/notification_screen.dart';
import 'package:mobile/views/profile/profile_screen.dart';
import 'package:mobile/widgets/custom_navbar.dart';

// --- LAYAR / VIEWS ADMIN PORTAL ---
import 'package:mobile/views/admin/admin_login_screen.dart';
import 'package:mobile/views/admin/admin_dashboard_screen.dart';

// --- SERVICES / KONTROLER DATA ---
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/services/feedback_service.dart';
import 'package:mobile/services/user_service.dart';

/// ----------------------------------------------------------------------------
/// FUNGSI MAIN (Pertama Kali Dijalankan Saat Aplikasi Ditingkatkan/Dimulai)
/// ----------------------------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Try-catch safe initializations agar Web tidak blank jika ada plugin gagal
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Graceful fallback jika Firebase Web mengalami kendala opsi
  }
  
  try {
    await UserService().init();
    await NotificationService().init();
    await FeedbackService().init();
  } catch (e) {
    // Graceful fallback jika SQLite lokal tidak didukung di browser
  }
  
  runApp(const MyApp());
}

/// ----------------------------------------------------------------------------
/// WIDGET KELAS UTAMA (Konfigurasi Tema, Warna & Routing Web Terpisah)
/// ----------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sukabumi One Access',
      debugShowCheckedModeBanner: false,
      
      // Tema Visual Terpadu (Navy #0A1E33 & Akses Emas #E8A33D)
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
      
      // ROUTING WEB TERPISAH (SEPARATED WEB ROUTES)
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigationScreen(),
        '/admin': (context) => const AdminLoginScreen(),
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
      },
    );
  }
}

/// ----------------------------------------------------------------------------
/// NAVIGASI UTAMA APPS WARGA (Bottom Navigation Bar 4 Menu)
/// ----------------------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),    // Halaman 0: Beranda Utama Warga
    const ReportScreen(),       // Halaman 1: Layanan & Pengaduan
    const NotificationScreen(), // Halaman 2: Notifikasi Sistem
    const ProfileScreen(),      // Halaman 3: Profil & Pengaturan Akun
  ];

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
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
