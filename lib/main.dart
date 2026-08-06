// =============================================================================
// FILE: lib/main.dart
// FUNGSI: Titik Masuk Utama (Entry Point) Aplikasi Sukabumi One Access
// =============================================================================

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// --- LAYAR / VIEWS ---
import 'package:mobile/views/berita_dan_fitur/dashboard_screen.dart';
import 'package:mobile/views/berita_dan_fitur/report_screen.dart';
import 'package:mobile/views/berita_dan_fitur/notification_screen.dart';
import 'package:mobile/views/profile/profile_screen.dart';
import 'package:mobile/widgets/custom_navbar.dart';

// --- SERVICES / KONTROLER DATA ---
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/services/feedback_service.dart';
import 'package:mobile/services/user_service.dart';

/// ----------------------------------------------------------------------------
/// FUNGSI MAIN (Pertama Kali Dijalankan Saat Aplikasi Ditingkatkan/Dimulai)
/// ----------------------------------------------------------------------------
void main() async {
  // 1. Memastikan Engine Widget Flutter Siap Sebelum Asinkronisasi Dijalankan
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inisialisasi Firebase Online (Cloud Firestore & Auth System)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 3. Inisialisasi Service Lokal (SQLite & Profil Pengguna awal)
  await UserService().init();
  await NotificationService().init();
  await FeedbackService().init();
  
  // 4. Jalankan Aplikasi Utama
  runApp(const MyApp());
}

/// ----------------------------------------------------------------------------
/// WIDGET KELAS UTAMA (Konfigurasi Tema, Warna & Halaman Pertama)
/// ----------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sukabumi One Access',
      debugShowCheckedModeBanner: false, // Menghilangkan Pita Banner Debug
      
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
      
      // Layar Awal Saat Aplikasi Dibuka: Halaman Utama Beranda (Home)
      home: const MainNavigationScreen(),
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
  // CATATAN MAHASISWA: Indeks menu aktif (0 = Beranda, 1 = Layanan, 2 = Notifikasi, 3 = Akun)
  int _selectedIndex = 0;

  // CATATAN MAHASISWA: Daftar 4 Halaman yang terhubung ke 4 Tombol Navbar
  final List<Widget> _screens = [
    const DashboardScreen(),    // Halaman 0: Beranda Utama Warga
    const ReportScreen(),       // Halaman 1: Layanan & Pengaduan
    const NotificationScreen(), // Halaman 2: Notifikasi Sistem
    const ProfileScreen(),      // Halaman 3: Profil & Pengaturan Akun
  ];

  // FUNGSI: Mengubah Halaman Aktif Saat Menu Di-Klik
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack Menjaga State Layar Agar Tidak Di-Reload Ulang Saat Perpindahan Tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      
      // Custom Navigation Bar Komponen Teman Anda
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
