import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// # ============================================================================
// # HALAMAN UTAMA / BERANDA (DASHBOARD SCREEN / FIGMA HOME)
// # ============================================================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  // # CATATAN: Variabel State untuk menyimpan data waktu dan cuaca realtime
  String _currentDate = "";
  String _temperature = "28°C";
  String _feelsLike = "Terasa seperti 31°C";

  // # CATATAN: Variabel State untuk menyimpan data berita update (dengan data default Sukabumi & gambar)
  List<dynamic> _daftarBerita = [
    {
      'judul': 'KDM Ajak Orang Tua Batasi Penggunaan Gawai pada Anak Demi Kesehatan',
      'kategori': 'Kesehatan',
      'created_at': 'Kamis 16 Juli 2026',
      'gambar': 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=150',
    },
    {
      'judul': 'KDM Ajak Orang Tua Batasi Penggunaan Gawai pada Anak Demi Kesehatan',
      'kategori': 'Kesehatan',
      'created_at': '2 Hari Lalu',
      'gambar': 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=150',
    },
    {
      'judul': 'KDM Ajak Orang Tua Batasi Penggunaan Gawai pada Anak Demi Kesehatan',
      'kategori': 'Kesehatan',
      'created_at': '2 Hari Lalu',
      'gambar': 'https://images.unsplash.com/photo-1572949645841-094f3a9c4c94?w=150',
    },
    {
      'judul': 'KDM Ajak Orang Tua Batasi Penggunaan Gawai pada Anak Demi Kesehatan',
      'kategori': 'Kesehatan',
      'created_at': '2 Hari Lalu',
      'gambar': 'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=150',
    },
  ];

  String _getJudulBerita(int index) {
    if (_daftarBerita.length > index && _daftarBerita[index]['judul'] != null) {
      return _daftarBerita[index]['judul'].toString();
    }
    return 'KDM Ajak Orang Tua Batasi Penggunaan Gawai pada Anak Demi Kesehatan';
  }

  String _getKategoriBerita(int index) {
    if (_daftarBerita.length > index && _daftarBerita[index]['kategori'] != null) {
      return _daftarBerita[index]['kategori'].toString();
    }
    return 'Kesehatan';
  }

  String _getWaktuBerita(int index) {
    if (_daftarBerita.length > index && _daftarBerita[index]['created_at'] != null) {
      return _daftarBerita[index]['created_at'].toString();
    }
    return '2 Hari Lalu';
  }

  String _getGambarBerita(int index) {
    if (_daftarBerita.length > index && _daftarBerita[index]['gambar'] != null) {
      return _daftarBerita[index]['gambar'].toString();
    }
    final defaultImages = [
      "https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=150",
      "https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=150",
      "https://images.unsplash.com/photo-1572949645841-094f3a9c4c94?w=150",
      "https://images.unsplash.com/photo-1495020689067-958852a7765e?w=150",
    ];
    return defaultImages[index % defaultImages.length];
  }

  // # CATATAN: State & Timer untuk Slide Show Berita (Topik Hangat)
  int _currentNewsPageIndex = 0;
  Timer? _newsTimer;

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
    _newsTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // # CATATAN: Fungsi untuk memutar slide berita otomatis
  void _startNewsAutoSlide() {
    _newsTimer?.cancel();
    _newsTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentNewsPageIndex = (_currentNewsPageIndex + 1) % 3;
        });
      }
    });
  }

  // # CATATAN: Memanggil API Berita Backend Laravel
  Future<void> _fetchBeritaTerbaru() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/berita');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final listBerita = data['data'] as List<dynamic>;
        if (mounted && listBerita.isNotEmpty) {
          setState(() {
            _daftarBerita = listBerita;
          });
        }
      }
    } catch (e) {
      debugPrint("Eror berita API Laravel: $e (Aplikasi menggunakan berita update bawaan)");
    }
  }

  // # CATATAN: Timer Tanggal dan Jam Realtime
  void _startClock() {
    _updateDate();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateDate();
      }
    });
  }

  void _updateDate() {
    final now = DateTime.now();
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];

    setState(() {
      _currentDate = "${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}";
    });
  }

  // # CATATAN: Memanggil API Cuaca Realtime Kota Sukabumi
  Future<void> _fetchRealtimeWeather() async {
    final url = Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=-6.9222&longitude=106.9267&current_weather=true");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final temp = (data['current_weather']['temperature'] as num).round();
        if (mounted) {
          setState(() {
            _temperature = "$temp°C";
            _feelsLike = "Terasa seperti ${temp + 2}°C";
          });
        }
      }
    } catch (e) {
      debugPrint("Eror cuaca: $e");
    }
  }

  // # CATATAN: Pull to refresh handler
  Future<void> _handleRefresh() async {
    _fetchRealtimeWeather();
    await _fetchBeritaTerbaru();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berita dan Cuaca berhasil diperbarui!'),
          backgroundColor: Color(0xFF123457),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
    return RefreshIndicator(
      color: const Color(0xFFE8A33D),
      backgroundColor: const Color(0xFF123457),
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // # 1. BARIS ATAS PUTIH (LOGO SUKABUMI & WIDGET CUACA KANAN)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // LOGO SUKABUMI CITY ONE ACCESS (SEJAJAR DENGAN KARTU CUACA)
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 44,
                          height: 40,
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.location_city, color: Color(0xFF123457), size: 36);
                          },
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Sukabumi',
                              style: TextStyle(
                                color: Color(0xFF0A1E33),
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ONE ACCESS',
                              style: TextStyle(
                                color: Color(0xFFE8A33D),
                                fontSize: 8,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // KARTU CUACA BIRU & TEKS SUKABUMI
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'SUKABUMI',
                          style: TextStyle(
                            color: Color(0xFF0A1E33),
                            fontSize: 8,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF123457),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _temperature,
                                    style: const TextStyle(
                                      color: Color(0xFFE8A33D),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    _feelsLike,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 6.5,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.wb_sunny_rounded,
                                color: Color(0xFFE8A33D),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // # 2. BARIS KEDUA NAVY GELAP (POTENSI CUACA & GREETING)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: const Color(0xFF0A1E33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // KARTU POTENSI CUACA EKSTREAM
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.notifications_active_rounded, color: Colors.redAccent, size: 18),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Potensi Cuaca',
                                style: TextStyle(color: Colors.black87, fontSize: 7.5, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Ekstream',
                                style: TextStyle(color: Colors.black87, fontSize: 7.5),
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
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              _currentDate.isEmpty ? 'Jum’at, 17 Juli 2026' : _currentDate,
                              style: const TextStyle(
                                color: Color(0xFFE8A33D),
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Color(0xFF123457), size: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // # 3. BANNER UTAMA HERO & KOLOM PENCARIAN
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 190,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A6572),
                      image: DecorationImage(
                        image: NetworkImage("https://images.unsplash.com/photo-1572949645841-094f3a9c4c94?w=600"),
                        fit: BoxFit.cover,
                        opacity: 0.35,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'SUKABUMI ONE ACCESS',
                            style: TextStyle(
                              color: Color(0xFFE8A33D),
                              fontSize: 9,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text.rich(
                            TextSpan(
                              children: const [
                                TextSpan(
                                  text: 'Pusat Layanan ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Kota Sukabumi.',
                                  style: TextStyle(
                                    color: Color(0xFFE8A33D),
                                    fontSize: 19,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Temukan kemudahan mengakses berbagai layanan informasi dari seluruh instansi Pemerintah Kota Sukabumi dalam satu pintu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 8.5,
                              fontFamily: 'Inter',
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // # SEARCH BAR (CARI LAYANAN)
              Transform.translate(
                offset: const Offset(0, -18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE8A33D), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: const [
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Cari Layanan...',
                            style: TextStyle(
                              color: Color(0xFF123457),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Icon(Icons.search, color: Color(0xFF123457), size: 18),
                        SizedBox(width: 14),
                      ],
                    ),
                  ),
                ),
              ),

              // # 4. BILAH NAVY - LAYANAN FAVORIT
              _buildSectionHeader(
                icon: Icons.thumb_up_rounded,
                titleNormal: 'Layanan ',
                titleHighlight: 'Favorit',
              ),
              const SizedBox(height: 12),

              // KOTAK KELUARGA (LAYANAN FAVORIT) DENGAN CYAN/BLUE BORDER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 76,
                    height: 54,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFF00A3FF), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x38000000),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.family_restroom_rounded, color: Color(0xFF123457), size: 24),
                        SizedBox(height: 2),
                        Text(
                          'Keluarga',
                          style: TextStyle(
                            color: Color(0xFF123457),
                            fontSize: 7.5,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // SLIDER BANNER LAYANAN FAVORIT (DARK NAVY CONTAINER WITH DOTS)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1E33),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Text(
                          'Layanan Informasi Utama Kota Sukabumi',
                          style: TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'Poppins'),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDot(true),
                            _buildDot(false),
                            _buildDot(false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // # 5. BILAH NAVY - FASE KEHIDUPAN (DENGAN GREEN BORDER OUTER CONTAINER)
              _buildSectionHeader(
                icon: Icons.receipt_long_rounded,
                titleNormal: 'Fase ',
                titleHighlight: 'Kehidupan',
              ),
              const SizedBox(height: 12),

              // SEKTOR KATEGORI (Fase Kehidupan) DENGAN GREEN OUTLINE `#00A859`
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1E33),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF00A859), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8A33D),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              child: const Text(
                                '10 Sektor',
                                style: TextStyle(
                                  color: Color(0xFF123457),
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // GRID 6 KARTU WHITE (Keluarga, Pendidikan, Usaha, Lingkungan, Kendaraan, Tanggap Darurat)
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              childAspectRatio: 1.45,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              children: [
                                _buildSectorCard('Keluarga', Icons.family_restroom_rounded, hasDropdown: true),
                                _buildSectorCard('Pendidikan', Icons.school_rounded),
                                _buildSectorCard('Usaha', Icons.store_rounded),
                                _buildSectorCard('Lingkungan & Tempat Tinggal', Icons.home_work_rounded),
                                _buildSectorCard('Kendaraan', Icons.directions_car_rounded),
                                _buildSectorCard('Tanggap Darurat', Icons.shield_rounded),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // BOTTOM BAR ORANGE "Lihat Semua Sektor"
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8A33D),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Lihat Semua Sektor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // # 6. BILAH NAVY - INSTANSI
              _buildSectionHeader(
                icon: Icons.account_balance_rounded,
                titleNormal: 'Instansi',
                titleHighlight: '',
              ),
              const SizedBox(height: 12),

              // 5 KOTAK KARTU INSTANSI (Diskominfo, DPMPTSP, DKP3, Lainnya)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInstansiCard('Diskominfo', 'assets/images/diskominfo.png', Icons.hub_rounded),
                    _buildInstansiCard('DPMPTSP', 'assets/images/dpmptsp.png', Icons.assignment_rounded),
                    _buildInstansiCard('DKP3', 'assets/images/dkp3.png', Icons.eco_rounded),
                    _buildInstansiCard('Lainnya', null, Icons.grid_view_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // # 7. BILAH NAVY - SUKABUMI HARI INI (BERITA & TOPIK HANGAT)
              _buildSectionHeader(
                icon: Icons.newspaper_rounded,
                titleNormal: 'Sukabumi ',
                titleHighlight: 'Hari Ini',
              ),
              const SizedBox(height: 12),

              // TOPIK HANGAT SLIDE SHOW & LIST BERITA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1E33),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // BANNER SLIDE SHOW BERITA (TOPIK HANGAT)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        child: SizedBox(
                          height: 140,
                          child: Stack(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: Image.network(
                                  _getGambarBerita(_currentNewsPageIndex),
                                  key: ValueKey<String>(_getGambarBerita(_currentNewsPageIndex)),
                                  width: double.infinity,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFF123457),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF0B1621).withOpacity(0.92),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8A33D),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Topik Hangat',
                                    style: TextStyle(
                                      color: Color(0xFF123457),
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Text(
                                  '${_getKategoriBerita(_currentNewsPageIndex)} • ${_getWaktuBerita(_currentNewsPageIndex)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 12,
                                bottom: 20,
                                right: 12,
                                child: Text(
                                  _getJudulBerita(_currentNewsPageIndex),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentNewsPageIndex == index
                                            ? const Color(0xFFE8A33D)
                                            : Colors.white30,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // LIST BERITA BAWAH (CARDS)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            _buildNewsCard(1),
                            const SizedBox(height: 8),
                            _buildNewsCard(2),
                            const SizedBox(height: 8),
                            _buildNewsCard(3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // # 8. BANNER PERTANYAAN & KEMBALI KE ATAS (FOOTER)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8A33D),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFF123457),
                        child: Icon(Icons.question_answer_rounded, color: Color(0xFFE8A33D), size: 16),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Sampaikan pertanyaan terkait Sukabumi One Access atau layanan publik di Kota Sukabumi',
                          style: TextStyle(
                            color: Color(0xFF123457),
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Color(0xFF123457), size: 24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // TOMBOL KEMBALI KE ATAS
              GestureDetector(
                onTap: _scrollToTop,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1E33),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.unfold_less_rounded, color: Color(0xFFE8A33D), size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Kembali ke atas',
                        style: TextStyle(
                          color: Color(0xFFE8A33D),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // # WIDGET HELPER: BUILDER BILAH JUDUL NAVY
  Widget _buildSectionHeader({
    required IconData icon,
    required String titleNormal,
    required String titleHighlight,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF0A1E33),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: titleNormal,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (titleHighlight.isNotEmpty)
                  TextSpan(
                    text: titleHighlight,
                    style: const TextStyle(
                      color: Color(0xFFE8A33D),
                      fontSize: 11,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // # WIDGET HELPER: DOT INDICATOR
  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFFE8A33D) : Colors.white30,
      ),
    );
  }

  // # WIDGET HELPER: KARTU SEKTOR WHITE (DENGAN ARROW ATAS/KANAN)
  Widget _buildSectorCard(String title, IconData icon, {bool hasDropdown = false}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF123457), size: 20),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF123457),
                    fontSize: 6.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 2),
              CircleAvatar(
                radius: 6,
                backgroundColor: const Color(0xFFE8A33D),
                child: Icon(
                  hasDropdown ? Icons.arrow_drop_down : Icons.arrow_forward_rounded,
                  color: Colors.black,
                  size: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // # WIDGET HELPER: KARTU INSTANSI
  Widget _buildInstansiCard(String title, String? assetPath, IconData fallbackIcon) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 40,
          padding: const EdgeInsets.all(5),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFF123457), width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x38000000),
                blurRadius: 4,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: assetPath != null
              ? Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(fallbackIcon, color: const Color(0xFF123457)),
                )
              : Icon(fallbackIcon, color: const Color(0xFF123457), size: 22),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF0A1E33),
            fontSize: 7.5,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // # WIDGET HELPER: KARTU BERITA BAWAH
  Widget _buildNewsCard(int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF123457),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              _getGambarBerita(index),
              width: 62,
              height: 42,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 62,
                height: 42,
                color: Colors.blueGrey,
                child: const Icon(Icons.newspaper, color: Colors.white, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getJudulBerita(index),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_getKategoriBerita(index)} • ${_getWaktuBerita(index)}',
                  style: const TextStyle(
                    color: Color(0xFFE8A33D),
                    fontSize: 7.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}