import 'package:flutter/material.dart';
import '../../models/instansi_model.dart';
import '../../models/layanan_model.dart';
import '../../models/sektor_model.dart';
import '../../services/opd_service.dart';
import '../../widgets/smart_image.dart';
import '../profile/login_screen.dart';
import 'admin_form_instansi_screen.dart';
import 'admin_form_layanan_screen.dart';
import 'admin_form_sektor_screen.dart';
import 'admin_chat_inbox_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final int initialNavIndex;

  const AdminDashboardScreen({super.key, this.initialNavIndex = 0});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final OpdService _opdService = OpdService();
  late int _selectedNavIndex;
  bool _isProfileMenuVisible = false;

  // CONTROLLERS FOR SEARCHING IN SUB-VIEWS
  final TextEditingController _instansiSearchController = TextEditingController();
  final TextEditingController _layananSearchController = TextEditingController();
  final TextEditingController _sektorSearchController = TextEditingController();

  String _instansiSearchQuery = '';
  String _layananSearchQuery = '';
  String _sektorSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedNavIndex = widget.initialNavIndex;
    _opdService.addListener(_refresh);
  }

  @override
  void dispose() {
    _opdService.removeListener(_refresh);
    _instansiSearchController.dispose();
    _layananSearchController.dispose();
    _sektorSearchController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _showKeluarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // EMBLEM LOGO SUKABUMI CITY ONE ACCESS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 38,
                    height: 38,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.account_balance_rounded,
                      color: Color(0xFF0F2942),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SukabumiCity',
                        style: TextStyle(
                          color: Color(0xFF0F2942),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'One Access',
                        style: TextStyle(
                          color: Color(0xFFE8A33D),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // CARD PROMPT BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: const Text(
                  'Anda yakin keluar dari akun Sukabumi One Access?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2942),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // SUBTEXT INFO
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFFE8A33D)),
                  SizedBox(width: 6),
                  Text(
                    'Semua data Anda akan tersimpan secara otomatis.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ACTION BUTTONS (BATAL & YAKIN)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Color(0xFF0F2942),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 110,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0F2942), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Yakin',
                        style: TextStyle(
                          color: Color(0xFF0F2942),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _konfirmasiHapusInstansi(BuildContext context, InstansiModel instansi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Hapus ${instansi.namaSingkat}?', style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus instansi "${instansi.namaLengkap}"?', style: const TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _opdService.deleteInstansi(instansi.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Instansi ${instansi.namaSingkat} berhasil dihapus.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Hapus', style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  void _konfirmasiHapusLayanan(BuildContext context, LayananModel layanan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Hapus Layanan?', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus layanan "${layanan.rawTitle}"?', style: const TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _opdService.deleteLayanan(layanan.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Layanan ${layanan.rawTitle} berhasil dihapus.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Hapus', style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  void _konfirmasiHapusSektor(BuildContext context, SektorModel sektor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Hapus Sektor?', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus sektor "${sektor.title}"?', style: const TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _opdService.deleteSektor(sektor.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sektor ${sektor.title} berhasil dihapus.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Hapus', style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color sidebarBg = Color(0xFF0F2942);
    const Color accentGold = Color(0xFFE8A33D);
    const Color mainBg = Color(0xFFF4F7FC);

    final isWideScreen = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: mainBg,
      appBar: isWideScreen
          ? null
          : AppBar(
              backgroundColor: sidebarBg,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Text(
                _getNavTitle(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      drawer: isWideScreen ? null : Drawer(child: _buildSidebar(context, sidebarBg, accentGold)),
      body: Row(
        children: [
          // SIDEBAR NAVIGATION PERMANEN UNTUK MONITOR PC / TABLET
          if (isWideScreen) SizedBox(width: 250, child: _buildSidebar(context, sidebarBg, accentGold)),

          // AREA KONTEN UTAMA KANAN (DYNAMICAL SINGLE PAGE SWITCHER)
          Expanded(
            child: _buildMainContentWrapper(context, sidebarBg, accentGold),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContentWrapper(BuildContext context, Color sidebarBg, Color accentGold) {
    if (_selectedNavIndex == 4) {
      return _buildActiveContentView(context, sidebarBg, accentGold);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: _buildActiveContentView(context, sidebarBg, accentGold),
    );
  }

  String _getNavTitle() {
    switch (_selectedNavIndex) {
      case 1:
        return 'Kelola Instansi';
      case 2:
        return 'Kelola Layanan';
      case 3:
        return 'Kelola Sektor';
      case 4:
        return 'Live Chat Warga';
      case 5:
        return 'Profil Saya';
      default:
        return 'Dashboard Admin';
    }
  }

  // ---------------------------------------------------------------------------
  // KONTEN SWITCHER DINAMIS (MEMAKSA TAMPILAN BERGANTI TOTAL SESUAI NAV)
  // ---------------------------------------------------------------------------
  Widget _buildActiveContentView(BuildContext context, Color sidebarBg, Color accentGold) {
    switch (_selectedNavIndex) {
      case 1:
        return _buildKelolaInstansiView(context, sidebarBg, accentGold);
      case 2:
        return _buildKelolaLayananView(context, sidebarBg, accentGold);
      case 3:
        return _buildKelolaSektorView(context, sidebarBg, accentGold);
      case 4:
        return _buildLiveChatInboxView(context, sidebarBg, accentGold);
      case 5:
        return _buildProfilSayaView(context, sidebarBg, accentGold);
      default:
        return _buildDashboardOverviewView(context, sidebarBg, accentGold);
    }
  }

  // ---------------------------------------------------------------------------
  // SIDEBAR NAVIGATION PANEL (DARK NAVY #0F2942 & GOLD #E8A33D + POPUP PROFIL)
  // ---------------------------------------------------------------------------
  Widget _buildSidebar(BuildContext context, Color sidebarBg, Color accentGold) {
    return Container(
      color: sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BRAND LOGO HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.account_balance_rounded,
                        color: Color(0xFF0F2942),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sukabumi One Acces',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Admin Panel',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),

          // SECTION TITLE: MENU UTAMA
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'MENU UTAMA',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 10),

          // NAV ITEM 0: DASHBOARD
          _buildSidebarNavItem(
            index: 0,
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            accentGold: accentGold,
          ),

          // NAV ITEM 1: KELOLA INSTANSI
          _buildSidebarNavItem(
            index: 1,
            icon: Icons.account_balance_rounded,
            label: 'Kelola Instansi',
            accentGold: accentGold,
          ),

          // NAV ITEM 2: KELOLA LAYANAN
          _buildSidebarNavItem(
            index: 2,
            icon: Icons.format_list_bulleted_rounded,
            label: 'Kelola Layanan',
            accentGold: accentGold,
          ),

          // NAV ITEM 3: KELOLA SEKTOR
          _buildSidebarNavItem(
            index: 3,
            icon: Icons.widgets_outlined,
            label: 'Kelola Sektor',
            accentGold: accentGold,
          ),

          // NAV ITEM 4: LIVE CHAT WARGA
          _buildSidebarNavItem(
            index: 4,
            icon: Icons.mark_chat_unread_rounded,
            label: 'Live Chat Warga',
            accentGold: accentGold,
          ),

          const Spacer(),

          // POP UP PROFIL CONTAINER (WHEN CLICKED ON BOTTOM BAR)
          if (_isProfileMenuVisible)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xFF0F2942),
                        child: Icon(Icons.person_rounded, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SOA',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2942),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Admin Panel',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 16),

                  // POPUP ITEM 1: PROFIL SAYA
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedNavIndex = 5;
                        _isProfileMenuVisible = false;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(Icons.person_outline_rounded, size: 16, color: Color(0xFF0F2942)),
                          SizedBox(width: 10),
                          Text('Profil Saya', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),

                  // POPUP ITEM 2: PENGATURAN
                  InkWell(
                    onTap: () {
                      setState(() => _isProfileMenuVisible = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menu Pengaturan Admin dibuka.')),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined, size: 16, color: Color(0xFF0F2942)),
                          SizedBox(width: 10),
                          Text('Pengaturan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),

                  // POPUP ITEM 3: UBAH PASSWORD
                  InkWell(
                    onTap: () {
                      setState(() => _isProfileMenuVisible = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menu Ubah Password dibuka.')),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline_rounded, size: 16, color: Color(0xFF0F2942)),
                          SizedBox(width: 10),
                          Text('Ubah Password', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 12),

                  // POPUP ITEM 4: KELUAR (TEKS MERAH)
                  InkWell(
                    onTap: () {
                      setState(() => _isProfileMenuVisible = false);
                      _showKeluarDialog(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(Icons.logout_rounded, size: 16, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Keluar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // BOTTOM PROFILE BAR (SOA GOLD BUTTON)
          InkWell(
            onTap: () {
              setState(() {
                _isProfileMenuVisible = !_isProfileMenuVisible;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: accentGold,
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFF0F2942),
                    child: Icon(Icons.person_rounded, color: Colors.white, size: 16),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'SOA',
                    style: TextStyle(
                      color: Color(0xFF0F2942),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem({
    required int index,
    required IconData icon,
    required String label,
    required Color accentGold,
  }) {
    final bool isSelected = _selectedNavIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedNavIndex = index;
            _isProfileMenuVisible = false;
          });
          if (Scaffold.of(context).isDrawerOpen) {
            Navigator.pop(context);
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? accentGold : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.white70, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // VIEW 5: PROFIL SAYA VIEW (DISAMAKAN 100% DENGAN SCREENSHOT 1)
  // ===========================================================================
  Widget _buildProfilSayaView(BuildContext context, Color sidebarBg, Color accentGold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BREADCRUMB & HEADER TITLE
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F2942)),
              onPressed: () => setState(() => _selectedNavIndex = 0),
              tooltip: 'Kembali ke Dashboard',
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Dashboard', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontFamily: 'Poppins')),
                    const Icon(Icons.chevron_right_rounded, size: 14, color: Colors.grey),
                    const Text('Profil Saya', style: TextStyle(color: Color(0xFF0F2942), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  ],
                ),
                const Text(
                  'Profil Saya',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2942),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // ROW DUA KARTU: KARTU KIRI (AVATAR) + KARTU KANAN (INFORMASI AKUN)
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 800;

            if (isMobile) {
              return Column(
                children: [
                  _buildProfilLeftCard(accentGold),
                  const SizedBox(height: 20),
                  _buildProfilRightInfoCard(context, sidebarBg),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 280, child: _buildProfilLeftCard(accentGold)),
                const SizedBox(width: 24),
                Expanded(child: _buildProfilRightInfoCard(context, sidebarBg)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfilLeftCard(Color accentGold) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // AVATAR WITH CAMERA EDIT BADGE
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8A33D),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white, size: 54),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.camera_alt_outlined, size: 14, color: Color(0xFF0F2942)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // NAME & ROLE BADGE
          const Text(
            'SOA',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2942),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Super Admin',
              style: TextStyle(
                color: Color(0xFFE8A33D),
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 20),

          // TIMELINE INFO BOX
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.email_outlined, size: 16, color: Color(0xFF0F2942)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'admin@sukabumi.go.id',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.history_rounded, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Login Terakhir', style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontFamily: 'Poppins')),
                        const Text('4 Juni 2026, 11:22 WIB', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bergabung Sejak', style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontFamily: 'Poppins')),
                        const Text('4 Agustus 2024', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilRightInfoCard(BuildContext context, Color sidebarBg) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: INFORMASI AKUN & EDIT PROFIL BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Informasi Akun',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2942),
                  fontFamily: 'Poppins',
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Edit Profil dibuka.')),
                  );
                },
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: const Text('Edit Profil', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F2942),
                  side: const BorderSide(color: Color(0xFF0F2942)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // KEY VALUE LIST PRESISI DENGAN SCREENSHOT
          _buildInfoRow(Icons.person_outline_rounded, 'Nama Lengkap', 'SOA'),
          const Divider(height: 24, color: Colors.black12),
          _buildInfoRow(Icons.person_pin_rounded, 'Username', 'superadmin'),
          const Divider(height: 24, color: Colors.black12),
          _buildInfoRow(Icons.email_outlined, 'Email', 'adminsukabumi.go.id'),
          const Divider(height: 24, color: Colors.black12),
          _buildInfoRow(Icons.phone_outlined, 'Nomor Telephon', '0812-5345-7786'),
          const Divider(height: 24, color: Colors.black12),
          _buildInfoRow(Icons.shield_outlined, 'Role', 'Super Admin'),
          const Divider(height: 24, color: Colors.black12),
          _buildInfoRow(Icons.account_balance_outlined, 'Instansi', 'Pemerintahan Kota Sukabumi'),
          const Divider(height: 24, color: Colors.black12),
          _buildInfoRow(Icons.location_on_outlined, 'Alamat', 'Jl. Jendral Sudirman No.1'),
          const Divider(height: 24, color: Colors.black12),
          _buildInfoRow(Icons.description_outlined, 'Deskripsi', 'Akun utama dengan akses penuh ke seluruh sistem'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String key, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0F2942)),
        const SizedBox(width: 14),
        SizedBox(
          width: 140,
          child: Text(
            key,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2942),
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const Text(':', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2942),
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // VIEW 0: DASHBOARD OVERVIEW VIEW (RINGKASAN EKSEKUTIF LENGKAP)
  // ===========================================================================
  Widget _buildDashboardOverviewView(BuildContext context, Color sidebarBg, Color accentGold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TOP HEADER BAR WITH BACK BUTTON
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F2942)),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Kembali ke Aplikasi Warga',
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2942),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Pusat Kontrol Terpadu Portal Layanan Publik Sukabumi',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Kembali ke Aplikasi Warga', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: sidebarBg,
                side: BorderSide(color: sidebarBg),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 1. METRIC CARDS ROW (4 KARTU RINGKASAN DATUM)
        _buildMetricCardsRow(accentGold),

        const SizedBox(height: 24),

        // 2. KARTU ANTREAN LIVE CHAT WARGA
        _buildLiveChatQueueCard(context, sidebarBg, accentGold),

        const SizedBox(height: 24),

        // 3. TABEL DAFTAR INSTANSI
        _buildInstansiTableCard(context, sidebarBg, accentGold),

        const SizedBox(height: 24),

        // 4. TABEL LAYANAN PUBLIK TERPOPULER
        _buildPopularLayananTableCard(context, sidebarBg, accentGold),

        const SizedBox(height: 24),

        // 5. GRID KATEGORI SEKTOR FASE KEHIDUPAN (DISAMAKAN 100% DENGAN SEKTOR LIST SCREEN)
        _buildSektorGridCard(context, sidebarBg, accentGold),
      ],
    );
  }

  // ===========================================================================
  // VIEW 1: KELOLA INSTANSI VIEW
  // ===========================================================================
  Widget _buildKelolaInstansiView(BuildContext context, Color sidebarBg, Color accentGold) {
    final allList = _opdService.getInstansiList();
    final filteredList = allList.where((item) {
      final q = _instansiSearchQuery.toLowerCase();
      return item.namaSingkat.toLowerCase().contains(q) ||
          item.namaLengkap.toLowerCase().contains(q) ||
          item.kodeInstansi.toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F2942)),
                          onPressed: () => setState(() => _selectedNavIndex = 0),
                          tooltip: 'Kembali ke Dashboard',
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kelola Instansi',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2942),
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '${allList.length} Instansi Terdaftar',
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminFormInstansiScreen()),
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text(
                        'Tambah Instansi',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentGold,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                child: TextFormField(
                  controller: _instansiSearchController,
                  onChanged: (val) => setState(() => _instansiSearchQuery = val),
                  style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    hintText: 'Cari Nama Instansi...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontFamily: 'Poppins'),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
                    fillColor: const Color(0xFFF4F6F9),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: const Color(0xFFF7F9FC),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Instansi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins')),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(child: Text('Jumlah Layanan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins'))),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(child: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins'))),
                    ),
                    SizedBox(
                      width: 50,
                      child: Center(child: Text('Aksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins'))),
                    ),
                  ],
                ),
              ),

              if (filteredList.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(child: Text('Tidak ada instansi yang sesuai pencarian.', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'))),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
                  itemBuilder: (context, index) {
                    final instansi = filteredList[index];
                    final totalLayanan = _opdService.getLayananList().where((l) => l.kodeInstansi.toLowerCase() == instansi.kodeInstansi.toLowerCase()).length;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              instansi.namaSingkat.toUpperCase(),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins'),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text('$totalLayanan', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFE2F7E2), borderRadius: BorderRadius.circular(20)),
                                child: const Text('Aktif', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 20),
                              onSelected: (val) {
                                if (val == 'edit') {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminFormInstansiScreen(instansi: instansi)));
                                } else if (val == 'hapus') {
                                  _konfirmasiHapusInstansi(context, instansi);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_rounded, size: 16, color: Color(0xFF0F2942)),
                                      SizedBox(width: 8),
                                      Text('Edit Instansi', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'hapus',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Hapus Instansi', style: TextStyle(fontSize: 12, color: Colors.red, fontFamily: 'Poppins')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // VIEW 2: KELOLA LAYANAN VIEW
  // ===========================================================================
  Widget _buildKelolaLayananView(BuildContext context, Color sidebarBg, Color accentGold) {
    final allList = _opdService.getLayananList();
    final filteredList = allList.where((item) {
      final q = _layananSearchQuery.toLowerCase();
      return item.rawTitle.toLowerCase().contains(q) ||
          item.judulLayanan.toLowerCase().contains(q) ||
          item.kodeInstansi.toLowerCase().contains(q) ||
          item.sektor.toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F2942)),
                          onPressed: () => setState(() => _selectedNavIndex = 0),
                          tooltip: 'Kembali ke Dashboard',
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kelola Layanan Publik',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2942),
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '${allList.length} Layanan Publik Terdaftar',
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminFormLayananScreen()),
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text(
                        'Tambah Layanan',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentGold,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                child: TextFormField(
                  controller: _layananSearchController,
                  onChanged: (val) => setState(() => _layananSearchQuery = val),
                  style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    hintText: 'Cari Nama atau Kode Layanan...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontFamily: 'Poppins'),
                    prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
                    fillColor: const Color(0xFFF4F6F9),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: const Color(0xFFF7F9FC),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('Nama Layanan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins')),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(child: Text('Instansi OPD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins'))),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(child: Text('Sektor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins'))),
                    ),
                    SizedBox(
                      width: 50,
                      child: Center(child: Text('Aksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins'))),
                    ),
                  ],
                ),
              ),

              if (filteredList.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(child: Text('Tidak ada layanan yang sesuai pencarian.', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'))),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
                  itemBuilder: (context, index) {
                    final layanan = filteredList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              layanan.rawTitle,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins'),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(layanan.kodeInstansi.toUpperCase(), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5), fontFamily: 'Poppins')),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFFFF6E5), borderRadius: BorderRadius.circular(12)),
                                child: Text(layanan.sektor, style: const TextStyle(color: Color(0xFFE8A33D), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 20),
                              onSelected: (val) {
                                if (val == 'edit') {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminFormLayananScreen(layanan: layanan)));
                                } else if (val == 'hapus') {
                                  _konfirmasiHapusLayanan(context, layanan);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_rounded, size: 16, color: Color(0xFF0F2942)),
                                      SizedBox(width: 8),
                                      Text('Edit Layanan', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'hapus',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Hapus Layanan', style: TextStyle(fontSize: 12, color: Colors.red, fontFamily: 'Poppins')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // VIEW 3: KELOLA SEKTOR VIEW (GRID CARDS 3-KOLOM EXACT DASHBOARD DESIGN)
  // ===========================================================================
  Widget _buildKelolaSektorView(BuildContext context, Color sidebarBg, Color accentGold) {
    final allList = _opdService.getSektorList();
    final filteredList = allList.where((item) {
      final q = _sektorSearchQuery.toLowerCase();
      return item.title.toLowerCase().contains(q) || item.desc.toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F2942)),
                  onPressed: () => setState(() => _selectedNavIndex = 0),
                  tooltip: 'Kembali ke Dashboard',
                ),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kelola Sektor Fase Kehidupan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2942),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      '${allList.length} Sektor Terdaftar',
                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminFormSektorScreen()),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(
                'Tambah Sektor',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        TextFormField(
          controller: _sektorSearchController,
          onChanged: (val) => setState(() => _sektorSearchQuery = val),
          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
          decoration: InputDecoration(
            hintText: 'Cari Nama Sektor Fase Kehidupan...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontFamily: 'Poppins'),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),

        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 3;
            if (constraints.maxWidth < 600) {
              crossAxisCount = 1;
            } else if (constraints.maxWidth < 900) {
              crossAxisCount = 2;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.6,
              ),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final sektor = filteredList[index];
                final totalLayanan = _opdService.getLayananList().where((l) => l.sektor.toLowerCase() == sektor.title.toLowerCase()).length;
                final displayCount = totalLayanan > 0 ? totalLayanan : 6;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: SmartImage(
                            imagePath: sektor.imagePath,
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                            fallbackIcon: Icons.widgets_rounded,
                            fallbackColor: const Color(0xFF0F2942),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              sektor.title,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2942),
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$displayCount Layanan',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 20),
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminFormSektorScreen(sektor: sektor),
                              ),
                            );
                          } else if (value == 'hapus') {
                            _konfirmasiHapusSektor(context, sektor);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_rounded, size: 16, color: Color(0xFF0F2942)),
                                SizedBox(width: 8),
                                Text('Edit Sektor', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'hapus',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Hapus Sektor', style: TextStyle(fontSize: 12, color: Colors.red, fontFamily: 'Poppins')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // VIEW 4: LIVE CHAT INBOX VIEW
  // ===========================================================================
  Widget _buildLiveChatInboxView(BuildContext context, Color sidebarBg, Color accentGold) {
    return const AdminChatInboxScreen(isEmbedded: true);
  }

  // ---------------------------------------------------------------------------
  // HELPER WIDGETS FOR DASHBOARD OVERVIEW
  // ---------------------------------------------------------------------------
  Widget _buildMetricCardsRow(Color accentGold) {
    final totalInstansi = _opdService.getInstansiList().length;
    final totalLayanan = _opdService.getLayananList().length;
    final totalSektor = _opdService.getSektorList().length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;
        final double cardWidth = (constraints.maxWidth - 30) / 4;

        if (isMobile) {
          return Column(
            children: [
              _buildSingleMetricCard('Total Instansi', '$totalInstansi', Icons.account_balance_rounded, const Color(0xFFFFF6E5), accentGold, '100% Aktif'),
              const SizedBox(height: 10),
              _buildSingleMetricCard('Total Layanan', '$totalLayanan', Icons.format_list_bulleted_rounded, const Color(0xFFEBF3FE), const Color(0xFF1E88E5), 'Katalog Publik'),
              const SizedBox(height: 10),
              _buildSingleMetricCard('Sektor Portal', '$totalSektor', Icons.widgets_outlined, const Color(0xFFE8F5E9), const Color(0xFF2E7D32), 'Fase Kehidupan'),
              const SizedBox(height: 10),
              _buildSingleMetricCard('Live Chat Warga', '3', Icons.mark_chat_unread_rounded, const Color(0xFFFFEBEE), Colors.redAccent, 'Perlu Balasan'),
            ],
          );
        }

        return Row(
          children: [
            SizedBox(width: cardWidth, child: _buildSingleMetricCard('Total Instansi', '$totalInstansi', Icons.account_balance_rounded, const Color(0xFFFFF6E5), accentGold, '100% Aktif')),
            const SizedBox(width: 10),
            SizedBox(width: cardWidth, child: _buildSingleMetricCard('Total Layanan', '$totalLayanan', Icons.format_list_bulleted_rounded, const Color(0xFFEBF3FE), const Color(0xFF1E88E5), 'Katalog Publik')),
            const SizedBox(width: 10),
            SizedBox(width: cardWidth, child: _buildSingleMetricCard('Sektor Portal', '$totalSektor', Icons.widgets_outlined, const Color(0xFFE8F5E9), const Color(0xFF2E7D32), 'Fase Kehidupan')),
            const SizedBox(width: 10),
            SizedBox(width: cardWidth, child: _buildSingleMetricCard('Live Chat Warga', '3', Icons.mark_chat_unread_rounded, const Color(0xFFFFEBEE), Colors.redAccent, 'Perlu Balasan')),
          ],
        );
      },
    );
  }

  Widget _buildSingleMetricCard(String title, String count, IconData icon, Color iconBg, Color iconColor, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5, fontWeight: FontWeight.w500, fontFamily: 'Poppins'), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(count, style: const TextStyle(color: Color(0xFF0F2942), fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 9.5, fontFamily: 'Poppins'), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveChatQueueCard(BuildContext context, Color sidebarBg, Color accentGold) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2942), Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.headset_mic_rounded, color: Color(0xFFE8A33D), size: 22),
                  SizedBox(width: 10),
                  Text('Pusat Antrean Live Chat Warga', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _selectedNavIndex = 4),
                icon: const Icon(Icons.reply_rounded, size: 16),
                label: const Text('Balas Chat Sekarang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGold,
                  foregroundColor: const Color(0xFF0F2942),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('3 Warga memerlukan bantuan langsung petugas admin yang dialihkan oleh AI Bot SOA:', style: TextStyle(color: Colors.white70, fontSize: 11.5, fontFamily: 'Poppins')),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildChatPreviewRow('mrn', 'Halo admin, mau tanya syarat cetak ulang KTP-el yang rusak...', '10 mnt lalu'),
                const Divider(color: Colors.white12, height: 12),
                _buildChatPreviewRow('Ahmad Fauzi', 'Bagaimana prosedur permohonan izin PBG gedung di DPMPTSP?', '25 mnt lalu'),
                const Divider(color: Colors.white12, height: 12),
                _buildChatPreviewRow('Siti Rahmawati', 'Nomor WhatsApp resmi layanan informasi PBB Sukabumi?', '1 jam lalu'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatPreviewRow(String name, String message, String time) {
    return Row(
      children: [
        const CircleAvatar(radius: 14, backgroundColor: Color(0xFFE8A33D), child: Icon(Icons.person_rounded, color: Color(0xFF0F2942), size: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Poppins')),
              Text(message, style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Poppins'), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(time, style: const TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _buildInstansiTableCard(BuildContext context, Color sidebarBg, Color accentGold) {
    final instansiList = _opdService.getInstansiList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Daftar Instansi OPD Terdaftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminFormInstansiScreen())),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Tambah Instansi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  style: ElevatedButton.styleFrom(backgroundColor: accentGold, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            color: const Color(0xFFF7F9FC),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Instansi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins'))),
                Expanded(flex: 2, child: Center(child: Text('Jumlah Layanan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins')))),
                Expanded(flex: 2, child: Center(child: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins')))),
                SizedBox(width: 50, child: Center(child: Text('Aksi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins')))),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: instansiList.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
            itemBuilder: (context, index) {
              final instansi = instansiList[index];
              final totalLayananInstansi = _opdService.getLayananList().where((l) => l.kodeInstansi.toLowerCase() == instansi.kodeInstansi.toLowerCase()).length;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text(instansi.namaSingkat.toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins'))),
                    Expanded(flex: 2, child: Center(child: Text('$totalLayananInstansi', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')))),
                    Expanded(flex: 2, child: Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE2F7E2), borderRadius: BorderRadius.circular(20)), child: const Text('Aktif', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins'))))),
                    SizedBox(
                      width: 50,
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 20),
                        onSelected: (val) {
                          if (val == 'edit') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminFormInstansiScreen(instansi: instansi)));
                          } else if (val == 'hapus') {
                            _konfirmasiHapusInstansi(context, instansi);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 16, color: Color(0xFF0F2942)), SizedBox(width: 8), Text('Edit Instansi', style: TextStyle(fontSize: 12, fontFamily: 'Poppins'))])),
                          const PopupMenuItem(value: 'hapus', child: Row(children: [Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red), SizedBox(width: 8), Text('Hapus Instansi', style: TextStyle(fontSize: 12, color: Colors.red, fontFamily: 'Poppins'))])),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPopularLayananTableCard(BuildContext context, Color sidebarBg, Color accentGold) {
    final layananList = _opdService.getLayananList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Katalog Layanan Publik Terdaftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminFormLayananScreen())),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Tambah Layanan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  style: ElevatedButton.styleFrom(backgroundColor: sidebarBg, foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            color: const Color(0xFFF7F9FC),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Nama Layanan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins'))),
                Expanded(flex: 2, child: Center(child: Text('Instansi OPD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins')))),
                Expanded(flex: 2, child: Center(child: Text('Sektor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins')))),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: layananList.length > 5 ? 5 : layananList.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
            itemBuilder: (context, index) {
              final layanan = layananList[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text(layanan.rawTitle, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins'))),
                    Expanded(flex: 2, child: Center(child: Text(layanan.kodeInstansi.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5), fontFamily: 'Poppins')))),
                    Expanded(flex: 2, child: Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFFFF6E5), borderRadius: BorderRadius.circular(12)), child: Text(layanan.sektor, style: const TextStyle(color: Color(0xFFE8A33D), fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins'))))),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSektorGridCard(BuildContext context, Color sidebarBg, Color accentGold) {
    final sektorList = _opdService.getSektorList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kategori Sektor (Fase Kehidupan)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
              TextButton(
                onPressed: () => setState(() => _selectedNavIndex = 3),
                child: const Text('Kelola Sektor', style: TextStyle(color: Color(0xFF1E88E5), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 3;
              if (constraints.maxWidth < 600) {
                crossAxisCount = 1;
              } else if (constraints.maxWidth < 900) {
                crossAxisCount = 2;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 2.6,
                ),
                itemCount: sektorList.length,
                itemBuilder: (context, index) {
                  final sektor = sektorList[index];
                  final totalLayanan = _opdService.getLayananList().where((l) => l.sektor.toLowerCase() == sektor.title.toLowerCase()).length;
                  final displayCount = totalLayanan > 0 ? totalLayanan : 6;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: SmartImage(
                              imagePath: sektor.imagePath,
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                              fallbackIcon: Icons.widgets_rounded,
                              fallbackColor: const Color(0xFF0F2942),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(sektor.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins'), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 2),
                              Text('$displayCount Layanan', style: const TextStyle(fontSize: 10.5, color: Colors.grey, fontFamily: 'Poppins')),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 18),
                          onSelected: (val) {
                            if (val == 'edit') {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminFormSektorScreen(sektor: sektor)));
                            } else if (val == 'hapus') {
                              _konfirmasiHapusSektor(context, sektor);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 14, color: Color(0xFF0F2942)), SizedBox(width: 6), Text('Edit Sektor', style: TextStyle(fontSize: 11.5, fontFamily: 'Poppins'))])),
                            const PopupMenuItem(value: 'hapus', child: Row(children: [Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red), SizedBox(width: 6), Text('Hapus Sektor', style: TextStyle(fontSize: 11.5, color: Colors.red, fontFamily: 'Poppins'))])),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
