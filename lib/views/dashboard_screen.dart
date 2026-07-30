
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import '../services/api_service.dart';
import 'package:mobile/views/instansi_screen.dart';

import 'info_diskominfo.dart';
import 'info_dpmpstp.dart';
import 'info_dkp3.dart';
import 'layanan_screen.dart';
import 'layanan_keluarga.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _currentDate = "";
  String _temperature = "26°C";
  String _feelsLike = "Terasa seperti 28°C";

  List<dynamic> _daftarBerita = [
    {
      'judul': 'KDM Ajak Orang Tua Batasi Penggunaan Gawai pada Anak Demi Kesehatan',
      'kategori': 'Kesehatan',
      'created_at': 'Kamis 16 Juli 2026',
      'gambar': 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400',
    },
    {
      'judul': 'Diskominfo Kota Sukabumi Gelar Pelatihan Literasi Digital Warga',
      'kategori': 'Teknologi',
      'created_at': '2 Hari Lalu',
      'gambar': 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400',
    },
    {
      'judul': 'Peningkatan Pelayanan Publik melalui Sistem Pengaduan Online Terpadu',
      'kategori': 'Pelayanan',
      'created_at': '3 Hari Lalu',
      'gambar': 'https://images.unsplash.com/photo-1572949645841-094f3a9c4c94?w=400',
    },
    {
      'judul': 'Kota Sukabumi Raih Penghargaan Transparansi Publik 2026',
      'kategori': 'Prestasi',
      'created_at': '4 Hari Lalu',
      'gambar': 'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=400',
    },
  ];

  int _currentNewsIndex = 0;
  Timer? _newsTimer;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _startClock();
    _fetchRealtimeWeather();
    _fetchBeritaTerbaru();
    _startNewsAutoSlide();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _newsTimer?.cancel();
    _clockTimer?.cancel();
    super.dispose();
  }

  void _startClock() {
    _updateFormattedDate();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateFormattedDate();
    });
  }

  void _updateFormattedDate() {
    final now = DateTime.now();
    final hariMap = {1: 'Senin', 2: 'Selasa', 3: 'Rabu', 4: 'Kamis', 5: 'Jum’at', 6: 'Sabtu', 7: 'Minggu'};
    final bulanMap = {
      1: 'Januari', 2: 'Februari', 3: 'Maret', 4: 'April', 5: 'Mei', 6: 'Juni',
      7: 'Juli', 8: 'Agustus', 9: 'September', 10: 'Oktober', 11: 'November', 12: 'Desember'
    };
    final String hari = hariMap[now.weekday] ?? '';
    final String bulan = bulanMap[now.month] ?? '';
    if (mounted) {
      setState(() {
        _currentDate = "$hari, ${now.day} $bulan ${now.year}";
      });
    }
  }

  Future<void> _fetchRealtimeWeather() async {
    try {
      final response = await ApiService.get('weather'); // Assume endpoint mapped in ApiService or handle specialized logic here
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['current_weather'] != null) {
          final temp = data['current_weather']['temperature'];
          if (mounted) {
            setState(() {
              _temperature = "${temp.round()}°C";
              _feelsLike = "Terasa seperti ${(temp + 2).round()}°C";
            });
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchBeritaTerbaru() async {
    try {
      final response = await ApiService.get('berita');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && (data['data'] as List).isNotEmpty) {
          final list = (data['data'] as List).take(5).map((item) {
            return {
              'judul': item['title'] ?? 'Berita Terbaru Kota Sukabumi',
              'kategori': item['category'] ?? 'Umum',
              'created_at': item['date'] ?? 'Baru Saja',
              'gambar': item['image'] ?? 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400',
            };
          }).toList();
          if (mounted) {
            setState(() {
              _daftarBerita = list;
            });
          }
        }
      }
    } catch (_) {}
  }

  void _startNewsAutoSlide() {
    _newsTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _daftarBerita.isNotEmpty) {
        setState(() {
          _currentNewsIndex = (_currentNewsIndex + 1) % _daftarBerita.length;
        });
      }
    });
  }

  Future<void> _handleRefresh() async {
    await _fetchRealtimeWeather();
    await _fetchBeritaTerbaru();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: const Color(0xFF0A1E33),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================================================
                // 1. TOP WHITE HEADER (LOGO SUKABUMI & WEATHER BADGE)
                // =========================================================
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LOGO SUKABUMI ONE ACCESS
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 38,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.account_balance_rounded,
                              color: Color(0xFF0A1E33),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sukabumi',
                                style: TextStyle(
                                  color: Color(0xFF0A1E33),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                'ONE ACCESS',
                                style: TextStyle(
                                  color: Color(0xFFE8A33D),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // NAVY BLUE WEATHER PILL BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1E33),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'SUKABUMI',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  _temperature,
                                  style: const TextStyle(
                                    color: Color(0xFFE8A33D),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  _feelsLike,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.wb_sunny_rounded,
                              color: Color(0xFFE8A33D),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================================================
                // 2. NAVY BANNER (POTENSI CUACA EKSTREAM & USER GREETING)
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: const Color(0xFF0A1E33),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // KARTU POTENSI CUACA EKSTREAM
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.notifications_active_rounded, color: Colors.redAccent, size: 22),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Potensi Cuaca',
                                  style: TextStyle(
                                    color: Color(0xFF0A1E33),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  'Ekstream',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 10,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // GREETING & TANGGAL & FOTO PROFIL
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Sampurasun, mrn',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                _currentDate.isEmpty ? 'Rabu, 29 Juli 2026' : _currentDate,
                                style: const TextStyle(
                                  color: Color(0xFFE8A33D),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Color(0xFF0A1E33), size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // =========================================================
                // 3. HERO IMAGE BANNER & FLOATING SEARCH BAR
                // =========================================================
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    // BACKGROUND HERO IMAGE BANNER
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0A1E33).withOpacity(0.85),
                              const Color(0xFF0A1E33).withOpacity(0.92),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'SUKABUMI ONE ACCESS',
                              style: TextStyle(
                                color: Color(0xFFE8A33D),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 6),
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Pusat Layanan ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Kota Sukabumi.',
                                    style: TextStyle(
                                      color: Color(0xFFE8A33D),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Temukan kemudahan mengakses berbagai layanan informasi dari seluruh instansi Pemerintah Kota Sukabumi dalam satu pintu.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11.5,
                                height: 1.4,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),

                    // FLOATING SEARCH BAR (Cari Layanan...)
                    Positioned(
                      bottom: -22,
                      left: 16,
                      right: 16,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE8A33D), width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x20000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                          decoration: InputDecoration(
                            hintText: 'Cari Layanan...',
                            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontFamily: 'Poppins'),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            suffixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0A1E33), size: 24),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LayananScreen()),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 38),

                // =========================================================
                // 4. SEKSI LAYANAN FAVORIT (HEADER NAVY & CARD KELUARGA)
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: const Color(0xFF0A1E33),
                  child: const Row(
                    children: [
                      Icon(Icons.thumb_up_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Layanan ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: 'Favorit',
                              style: TextStyle(
                                color: Color(0xFFE8A33D),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KARTU LAYANAN KELUARGA (BLUE OUTLINE CONTAINER)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LayananKeluargaScreen()),
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 95,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF00A3FF), width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1500A3FF),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.family_restroom_rounded,
                                color: Color(0xFF0A1E33),
                                size: 36,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Keluarga',
                                style: TextStyle(
                                  color: Color(0xFF0A1E33),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // BANNER SLIDESHOW LAYANAN UTAMA (DARK NAVY CARD WITH DOTS)
                      Container(
                        width: double.infinity,
                        height: 150,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A1E33),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'Layanan Informasi Utama Kota Sukabumi',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8A33D),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================================================
                // 5. SEKSI FASE KEHIDUPAN (DARK NAVY BOX WITH 10 SEKTOR & 7 CARDS)
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: const Color(0xFF0A1E33),
                  child: const Row(
                    children: [
                      Icon(Icons.assignment_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Fase ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: 'Kehidupan',
                              style: TextStyle(
                                color: Color(0xFFE8A33D),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1E33),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BADGE 10 SEKTOR
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8A33D),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '10 Sektor',
                              style: TextStyle(
                                color: Color(0xFF0A1E33),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),

                        // GRID 7 KARTU FASE KEHIDUPAN (MATCH SCREENSHOT 2)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.92,
                            children: [
                              _buildLifePhaseCard(
                                context: context,
                                title: 'Keluarga',
                                icon: Icons.family_restroom_rounded,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LayananKeluargaScreen()));
                                },
                              ),
                              _buildLifePhaseCard(
                                context: context,
                                title: 'Pendidikan',
                                icon: Icons.school_rounded,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LayananScreen()));
                                },
                              ),
                              _buildLifePhaseCard(
                                context: context,
                                title: 'Usaha',
                                icon: Icons.storefront_rounded,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoDpmpstp()));
                                },
                              ),
                              _buildLifePhaseCard(
                                context: context,
                                title: 'Lingkungan & Tempat ...',
                                icon: Icons.home_work_rounded,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LayananScreen()));
                                },
                              ),
                              _buildLifePhaseCard(
                                context: context,
                                title: 'Kendaraan',
                                icon: Icons.directions_car_rounded,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LayananScreen()));
                                },
                              ),
                              _buildLifePhaseCard(
                                context: context,
                                title: 'Kesehatan',
                                icon: Icons.add_box_rounded,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LayananScreen()));
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // TOMBOL KUNING LIHAT SEMUA SEKTOR
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const LayananScreen()));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8A33D),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Lihat Semua Sektor',
                                style: TextStyle(
                                  color: Color(0xFF0A1E33),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =========================================================
                // 6. SEKSI INSTANSI (OPD DINAS)
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: const Color(0xFF0A1E33),
                  child: const Row(
                    children: [
                      Icon(Icons.account_balance_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Instansi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      _buildInstansiItem(
                        context: context,
                        title: 'Diskominfo',
                        imagePath: 'assets/images/diskominfo.png',
                        fallbackIcon: Icons.computer_rounded,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoDiskominfo()));
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildInstansiItem(
                        context: context,
                        title: 'DPMPTSP',
                        imagePath: 'assets/images/dpmptsp.png',
                        fallbackIcon: Icons.store_rounded,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoDpmpstp()));
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildInstansiItem(
                        context: context,
                        title: 'DKP3',
                        imagePath: 'assets/images/dkp3.png',
                        fallbackIcon: Icons.grass_rounded,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoDkp3()));
                        },
                      ),
                      const SizedBox(width: 6),
                      _buildInstansiItem(
                        context: context,
                        title: 'Lainnya',
                        fallbackIcon: Icons.grid_view_rounded,
                        width: 48,
                        height: 32,
                        isExpanded: false,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const InstansiScreen()));
                        },
                      ),
                    ],
                  ),
                ),

                // =========================================================
                // 7. SEKSI SUKABUMI HARI INI (BERITA UPDATE & SLIDER)
                // =========================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: const Color(0xFF0A1E33),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Sukabumi ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: 'Hari Ini',
                              style: TextStyle(
                                color: Color(0xFFE8A33D),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // FEATURED NEWS SLIDER CARD (MATCH SCREENSHOT 3)
                      if (_daftarBerita.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoDiskominfo()));
                          },
                          child: Container(
                            height: 190,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              image: DecorationImage(
                                image: NetworkImage(_daftarBerita[_currentNewsIndex]['gambar'].toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                  colors: [Colors.transparent, Colors.black87],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8A33D),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'Topik Hangat',
                                          style: TextStyle(
                                            color: Color(0xFF0A1E33),
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${_daftarBerita[_currentNewsIndex]['kategori']} • ${_daftarBerita[_currentNewsIndex]['created_at']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _daftarBerita[_currentNewsIndex]['judul'].toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(_daftarBerita.length, (index) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 3),
                                            width: 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              color: index == _currentNewsIndex
                                                  ? const Color(0xFFE8A33D)
                                                  : Colors.white.withOpacity(0.4),
                                              shape: BoxShape.circle,
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 14),

                      // DAFTAR 3 KARTU BERITA DARK NAVY (MATCH SCREENSHOT 3)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = _daftarBerita[index % _daftarBerita.length];
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoDiskominfo()));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A1E33),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item['gambar'].toString(),
                                      width: 64,
                                      height: 54,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 64,
                                        height: 54,
                                        color: Colors.blueGrey,
                                        child: const Icon(Icons.newspaper, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['judul'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item['kategori']} • ${item['created_at']}',
                                          style: const TextStyle(
                                            color: Color(0xFFE8A33D),
                                            fontSize: 10,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // =========================================================
                // 8. CALL TO ACTION KUNING (BANER PERTANYAAN SUKABUMI ONE ACCESS)
                // =========================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8A33D),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0A1E33),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Sampaikan pertanyaan terkait Sukabumi One Access atau layanan publik di Kota Sukabumi',
                            style: TextStyle(
                              color: Color(0xFF0A1E33),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: Color(0xFF0A1E33), size: 24),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // =========================================================
                // 9. TOMBOL KEMBALI KE ATAS (DARK NAVY BUTTON)
                // =========================================================
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _scrollToTop,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A1E33),
                      foregroundColor: const Color(0xFFE8A33D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.unfold_less_rounded, size: 18),
                    label: const Text(
                      'Kembali ke atas',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLifePhaseCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  icon,
                  color: const Color(0xFF0A1E33),
                  size: 38,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF123457).withOpacity(0.12),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8A33D),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstansiItem({
    required BuildContext context,
    required String title,
    String? imagePath,
    required IconData fallbackIcon,
    required VoidCallback onTap,
    double? width,
    double? height,
    bool isExpanded = true,
  }) {
    final Widget content = GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: width,
            height: height ?? 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF0A1E33), width: 1.2),
            ),
            child: Center(
              child: imagePath != null
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        fallbackIcon,
                        color: const Color(0xFF0A1E33),
                        size: height != null ? (height * 0.55) : 24,
                      ),
                    )
                  : Icon(
                      fallbackIcon,
                      color: const Color(0xFF0A1E33),
                      size: height != null ? (height * 0.55) : 24,
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return isExpanded ? Expanded(child: content) : content;
  }
}