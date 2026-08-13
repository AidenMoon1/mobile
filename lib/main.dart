// =============================================================================
// FILE: lib/main.dart
// FUNGSI: Titik Masuk Utama (Entry Point) Aplikasi Sukabumi One Access
// =============================================================================

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
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
import 'package:mobile/services/admin_auth_service.dart';

/// ----------------------------------------------------------------------------
/// FUNGSI MAIN (Pertama Kali Dijalankan Saat Aplikasi Ditingkatkan/Dimulai)
/// ----------------------------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await initializeDateFormatting('id_ID', null);
  } catch (_) {}

  // Safe initializations agar Web tidak blank jika ada plugin gagal
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('Firebase Web init fallback: $e');
  }
  
  try {
    await UserService().init();
    await NotificationService().init();
    await FeedbackService().init();
  } catch (e) {
    debugPrint('Local Services init fallback: $e');
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
      
      // ROUTING WEB TERPISAH (SEPARATED WEB ROUTES WITH QUERY PARAM & SESSION GUARD)
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');

        if (uri.path == '/admin/dashboard') {
          final tab = uri.queryParameters['tab'] ?? 'overview';
          return MaterialPageRoute(
            builder: (context) => FutureBuilder<bool>(
              future: AdminAuthService().isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    backgroundColor: Color(0xFF0F2942),
                    body: Center(
                      child: CircularProgressIndicator(color: Color(0xFFE8A33D)),
                    ),
                  );
                }
                final isLoggedIn = snapshot.data ?? false;
                if (!isLoggedIn) {
                  return const AdminLoginScreen();
                }
                return AdminDashboardScreen(initialTab: tab);
              },
            ),
            settings: settings,
          );
        }

        if (uri.path == '/admin') {
          return MaterialPageRoute(
            builder: (context) => FutureBuilder<bool>(
              future: AdminAuthService().isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    backgroundColor: Color(0xFF0F2942),
                    body: Center(
                      child: CircularProgressIndicator(color: Color(0xFFE8A33D)),
                    ),
                  );
                }
                final isLoggedIn = snapshot.data ?? false;
                if (isLoggedIn) {
                  return const AdminDashboardScreen(initialTab: 'overview');
                }
                return const AdminLoginScreen();
              },
            ),
            settings: settings,
          );
        }

        return MaterialPageRoute(
          builder: (context) => const MainNavigationScreen(),
          settings: settings,
        );
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
