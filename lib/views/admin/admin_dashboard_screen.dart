// =============================================================================
// FILE: lib/views/admin/admin_dashboard_screen.dart
// FUNGSI: Panel Dashboard Terpadu Administrator (Single Page Shell Architecture)
// LEVEL KODE: Level 2-3 (Modular, Clean, dan Mudah Dipahami Mahasiswa)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/instansi_model.dart';
import '../../models/layanan_model.dart';
import '../../models/sektor_model.dart';
import '../../models/admin_user_model.dart';
import '../../services/opd_service.dart';
import '../../services/feedback_service.dart';
import '../../services/admin_auth_service.dart';
import '../../services/admin_management_service.dart';
import '../../widgets/smart_image.dart';
import 'admin_form_instansi_screen.dart';
import 'admin_form_layanan_screen.dart';
import 'admin_form_sektor_screen.dart';
import 'admin_chat_inbox_screen.dart';

/// ----------------------------------------------------------------------------
/// WIDGET DASHBOARD ADMIN (Single-Page Switcher untuk Perangkat PC & Mobile)
/// ----------------------------------------------------------------------------
class AdminDashboardScreen extends StatefulWidget {
  final int initialNavIndex;
  final String? initialTab;

  const AdminDashboardScreen({
    super.key,
    this.initialNavIndex = 0,
    this.initialTab,
  });

  static int tabNameToIndex(String? tabName) {
    switch (tabName?.toLowerCase()) {
      case 'instansi':
        return 1;
      case 'layanan':
        return 2;
      case 'sektor':
        return 3;
      case 'chat':
        return 4;
      case 'feedback':
        return 5;
      case 'profil':
        return 6;
      case 'admin':
      case 'kelola-admin':
        return 7;
      case 'overview':
      default:
        return 0;
    }
  }

  static String indexToTabName(int index) {
    switch (index) {
      case 1:
        return 'instansi';
      case 2:
        return 'layanan';
      case 3:
        return 'sektor';
      case 4:
        return 'chat';
      case 5:
        return 'feedback';
      case 6:
        return 'profil';
      case 7:
        return 'admin';
      case 0:
      default:
        return 'overview';
    }
  }

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final OpdService _opdService = OpdService();
  final AdminManagementService _adminService = AdminManagementService();
  late int _selectedNavIndex;
  bool _isProfileMenuVisible = false;

  // CONTROLLERS PENCARIAN PADA SUB-VIEW KELOLA
  final TextEditingController _instansiSearchController = TextEditingController();
  final TextEditingController _layananSearchController = TextEditingController();
  final TextEditingController _sektorSearchController = TextEditingController();
  final TextEditingController _adminSearchController = TextEditingController();

  String _instansiSearchQuery = '';
  String _layananSearchQuery = '';
  String _sektorSearchQuery = '';
  String _adminSearchQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialTab != null && widget.initialTab!.isNotEmpty) {
      _selectedNavIndex = AdminDashboardScreen.tabNameToIndex(widget.initialTab);
    } else {
      _selectedNavIndex = widget.initialNavIndex;
    }
    _opdService.addListener(_refresh);
    _adminService.addListener(_refresh);
  }

  void _onTabSelected(int index) {
    if (_selectedNavIndex == index) return;
    setState(() {
      _selectedNavIndex = index;
      _isProfileMenuVisible = false;
    });
    final tabName = AdminDashboardScreen.indexToTabName(index);
    Navigator.pushReplacementNamed(
      context,
      '/admin/dashboard?tab=$tabName',
    );
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

  // ---------------------------------------------------------------------------
  // DIALOG KONFIRMASI KELUAR AKUN ADMIN (LOGOUT)
  // ---------------------------------------------------------------------------
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
                      onPressed: () async {
                        Navigator.pop(context);
                        await AdminAuthService().logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/admin',
                            (route) => false,
                          );
                        }
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

  Widget _buildInstansiStatusCell(InstansiModel instansi) {
    return Center(
      child: InkWell(
        onTap: () {
          _opdService.toggleInstansiStatus(instansi.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                !instansi.isActive
                    ? '✅ Instansi ${instansi.namaSingkat} diaktifkan kembali!'
                    : '⚠️ Instansi ${instansi.namaSingkat} diubah ke status Pemeliharaan (Maintenance)!',
              ),
              backgroundColor: !instansi.isActive ? const Color(0xFF0F2942) : Colors.orange.shade900,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: instansi.isActive,
                  activeColor: const Color(0xFFE8A33D),
                  activeTrackColor: const Color(0xFF0F2942),
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade200,
                  onChanged: (val) {
                    _opdService.toggleInstansiStatus(instansi.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? '✅ Instansi ${instansi.namaSingkat} diaktifkan kembali!'
                              : '⚠️ Instansi ${instansi.namaSingkat} diubah ke status Pemeliharaan (Maintenance)!',
                        ),
                        backgroundColor: val ? const Color(0xFF0F2942) : Colors.orange.shade900,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: instansi.isActive ? const Color(0xFFE2F7E2) : const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: instansi.isActive ? const Color(0xFF81C784) : const Color(0xFFFFB74D),
                  ),
                ),
                child: Text(
                  instansi.isActive ? 'Aktif' : 'Pemeliharaan',
                  style: TextStyle(
                    color: instansi.isActive ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayananStatusCell(LayananModel layanan) {
    return Center(
      child: InkWell(
        onTap: () {
          _opdService.toggleLayananStatus(layanan.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                !layanan.isActive
                    ? '✅ Layanan ${layanan.rawTitle} diaktifkan kembali!'
                    : '⚠️ Layanan ${layanan.rawTitle} diubah ke status Pemeliharaan (Maintenance)!',
              ),
              backgroundColor: !layanan.isActive ? const Color(0xFF0F2942) : Colors.orange.shade900,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: layanan.isActive,
                  activeColor: const Color(0xFFE8A33D),
                  activeTrackColor: const Color(0xFF0F2942),
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade200,
                  onChanged: (val) {
                    _opdService.toggleLayananStatus(layanan.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? '✅ Layanan ${layanan.rawTitle} diaktifkan kembali!'
                              : '⚠️ Layanan ${layanan.rawTitle} diubah ke status Pemeliharaan (Maintenance)!',
                        ),
                        backgroundColor: val ? const Color(0xFF0F2942) : Colors.orange.shade900,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: layanan.isActive ? const Color(0xFFE2F7E2) : const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: layanan.isActive ? const Color(0xFF81C784) : const Color(0xFFFFB74D),
                  ),
                ),
                child: Text(
                  layanan.isActive ? 'Aktif' : 'Pemeliharaan',
                  style: TextStyle(
                    color: layanan.isActive ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color sidebarBg = Color(0xFF0F2942);
    const Color accentGold = Color(0xFFE8A33D);
    const Color mainBg = Color(0xFFF4F7FC);

    return Scaffold(
      backgroundColor: mainBg,
      body: Row(
        children: [
          // SIDEBAR NAVIGATION PERMANEN KHUSUS MONITOR PC / DESKTOP (260px)
          SizedBox(
            width: 260,
            child: _buildSidebar(context, sidebarBg, accentGold),
          ),

          // KONTEN UTAMA DESKTOP
          Expanded(
            child: Column(
              children: [
                // TOP HEADER BAR DESKTOP MONITOR
                _buildTopHeaderBar(sidebarBg, accentGold),

                // AREA KONTEN SWITCHER
                Expanded(
                  child: _buildMainContentWrapper(context, sidebarBg, accentGold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeaderBar(Color sidebarBg, Color accentGold) {
    String nowTimeStr;
    String nowDateStr;
    try {
      nowTimeStr = DateFormat('HH.mm.ss').format(DateTime.now());
      nowDateStr = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()).toUpperCase();
    } catch (_) {
      nowTimeStr = DateFormat('HH.mm.ss').format(DateTime.now());
      nowDateStr = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()).toUpperCase();
    }

    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF9F6),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Row(
        children: [
          // OTORITAS AKSES HEADER BADGE
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF3FE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD0E2FF)),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Color(0xFF0A1E33),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Otoritas Akses',
                style: TextStyle(
                  color: Color(0xFF0A1E33),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Kelola akun & pantau aktivitas operator portal.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11.5,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const Spacer(),

          // TIME PILL BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 15, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '$nowTimeStr WIB\n$nowDateStr',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A1E33),
                    fontFamily: 'Poppins',
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // SYSTEM OPERATIONAL BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4EA),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFCEEAD6)),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: Color(0xFF1E8E3E),
                ),
                SizedBox(width: 8),
                Text(
                  'SYSTEM OPERATIONAL',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF137333),
                    letterSpacing: 0.5,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // NOTIFICATION BUTTON
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0A1E33), size: 18),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tidak ada notifikasi baru.')),
                );
              },
              tooltip: 'Notifikasi',
            ),
          ),
          const SizedBox(width: 8),

          // POWER / LOGOUT BUTTON
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE8E6),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFAD2CF)),
            ),
            child: IconButton(
              icon: const Icon(Icons.power_settings_new_rounded, color: Color(0xFFC5221F), size: 18),
              onPressed: () => _showKeluarDialog(context),
              tooltip: 'Keluar Akses Portal',
            ),
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
        return 'Kritik & Saran Warga';
      case 6:
        return 'Profil Saya';
      case 7:
        return 'Kelola Administrator (SuperAdmin)';
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
        return _buildLaporanKritikSaranView(context, sidebarBg, accentGold);
      case 6:
        return _buildProfilSayaView(context, sidebarBg, accentGold);
      case 7:
        return _buildKelolaAdminView(context, sidebarBg, accentGold);
      default:
        return _buildDashboardOverviewView(context, sidebarBg, accentGold);
    }
  }

  // ---------------------------------------------------------------------------
  // SIDEBAR NAVIGATION PANEL (DARK NAVY #0F2942 & GOLD #E8A33D + POPUP PROFIL)
  // ---------------------------------------------------------------------------
  Widget _buildSidebar(BuildContext context, Color sidebarBg, Color accentGold) {
    return Container(
      color: const Color(0xFF0A1E33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BRAND LOGO HEADER (SUKABUMI ONE ACCESS ADMIN)
          Container(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: accentGold.withOpacity(0.4)),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.account_balance_rounded,
                        color: Color(0xFFE8A33D),
                        size: 22,
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
                        'SUKABUMI',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 0.8,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'ONE ACCESS ADMIN',
                        style: TextStyle(
                          color: Color(0xFFE8A33D),
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 14),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MAIN MENU CATEGORY
                  _buildSidebarCategoryHeader('MAIN MENU'),
                  _buildSidebarNavItem(
                    index: 0,
                    icon: Icons.space_dashboard_outlined,
                    label: 'Dashboard',
                    accentGold: accentGold,
                  ),
                  _buildSidebarNavItem(
                    index: 7,
                    icon: Icons.people_alt_outlined,
                    label: 'Kelola Super Admin',
                    accentGold: accentGold,
                  ),

                  const SizedBox(height: 14),

                  // USER MANAGEMENT CATEGORY
                  _buildSidebarCategoryHeader('USER MANAGEMENT'),
                  _buildSidebarNavItem(
                    index: 1,
                    icon: Icons.badge_outlined,
                    label: 'Kelola Admin Dinas',
                    accentGold: accentGold,
                  ),
                  _buildSidebarNavItem(
                    index: 3,
                    icon: Icons.person_search_outlined,
                    label: 'Kelola Pengguna',
                    accentGold: accentGold,
                  ),

                  const SizedBox(height: 14),

                  // PORTAL CONFIGURATION CATEGORY
                  _buildSidebarCategoryHeader('PORTAL CONFIGURATION'),
                  _buildSidebarNavItem(
                    index: 9,
                    icon: Icons.business_outlined,
                    label: 'Profil Instansi',
                    accentGold: accentGold,
                  ),
                  _buildSidebarNavItem(
                    index: 2,
                    icon: Icons.link_outlined,
                    label: 'Daftar Layanan',
                    accentGold: accentGold,
                  ),

                  const SizedBox(height: 14),

                  // SUPPORT CATEGORY
                  _buildSidebarCategoryHeader('SUPPORT'),
                  _buildSidebarNavItem(
                    index: 5,
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Pengaduan Warga',
                    accentGold: accentGold,
                  ),
                ],
              ),
            ),
          ),

          // POP UP PROFIL CONTAINER (WHEN CLICKED ON BOTTOM BAR)
          if (_isProfileMenuVisible)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                        backgroundColor: Color(0xFF0A1E33),
                        child: Text('AD', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Administrator',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A1E33),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'DISKOMINFO',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 16),

                  InkWell(
                    onTap: () {
                      _onTabSelected(6);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(Icons.person_outline_rounded, size: 16, color: Color(0xFF0A1E33)),
                          SizedBox(width: 10),
                          Text('Profil Saya', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0A1E33), fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),

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
                          Text('Keluar Portal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // BOTTOM PROFILE CARD WIDGET (EXACT MATCH USER SCREENSHOT)
          InkWell(
            onTap: () {
              setState(() {
                _isProfileMenuVisible = !_isProfileMenuVisible;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF13283E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: accentGold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'AD',
                        style: TextStyle(
                          color: Color(0xFF0A1E33),
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          fontFamily: 'Poppins',
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
                          'Administrator',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'DISKOMINFO',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isProfileMenuVisible ? Icons.keyboard_arrow_down_rounded : Icons.unfold_more_rounded,
                    color: Colors.white54,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontFamily: 'Poppins',
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: () => _onTabSelected(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B324D) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // YELLOW LEFT INDICATOR BAR (EXACT MATCH SCREENSHOT)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 4,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected ? accentGold : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white60,
                size: 19,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12.5,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // VIEW 5: LAPORAN KRITIK & SARAN WARGA (FEEDBACK MONITORING)
  // ===========================================================================
  Widget _buildLaporanKritikSaranView(BuildContext context, Color sidebarBg, Color accentGold) {
    final feedbackList = FeedbackService().history;
    final double avgRating = feedbackList.isEmpty
        ? 5.0
        : feedbackList.map((e) => e.rating).reduce((a, b) => a + b) / feedbackList.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BREADCRUMB & HEADER
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
                    const Text('Laporan Kritik & Saran', style: TextStyle(color: Color(0xFF0F2942), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  ],
                ),
                const Text(
                  'Kritik & Saran Warga',
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

        const SizedBox(height: 20),

        // STATS CARDS (SUMMARY METRICS)
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2942).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.rate_review_rounded, color: Color(0xFF0F2942), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Masukan', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontFamily: 'Poppins')),
                        Text('${feedbackList.length} Laporan', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6E5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.star_rounded, color: Color(0xFFE8A33D), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rata-Rata Kepuasan', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontFamily: 'Poppins')),
                        Text('${avgRating.toStringAsFixed(1)} / 5.0 ⭐', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F2942), fontFamily: 'Poppins')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // DAFTAR ULASAN & MASUKAN WARGA
        if (feedbackList.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                const Text('Belum ada laporan kritik dan saran baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Poppins')),
                Text('Ulasan warga yang dikirimkan via halaman Kritik & Saran akan tampil di sini.', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontFamily: 'Poppins')),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feedbackList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final fb = feedbackList[index];
              final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(fb.date);

              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(0xFF0F2942),
                              child: Icon(Icons.person, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Warga Kota Sukabumi',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F2942),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  dateStr,
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // BADGE RATING STAR
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF6E5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE8A33D)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFE8A33D), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${fb.rating}.0 / 5',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF0F2942),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // FAKTOR PENILAIAN BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2942).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Kategori: ${fb.factor}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F2942),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ISI PESAN KRITIK & SARAN
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        fb.reason.isNotEmpty ? '"${fb.reason}"' : '"(Tidak ada pesan tambahan)"',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                          fontFamily: 'Poppins',
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ACTION BUTTONS ADMIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tanggapan resmi berhasil dikirim ke warga!'),
                                backgroundColor: Color(0xFF0F2942),
                              ),
                            );
                          },
                          icon: const Icon(Icons.reply_rounded, size: 16, color: Color(0xFF0F2942)),
                          label: const Text(
                            'Tanggapi Laporan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2942),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0F2942)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // ===========================================================================
  // VIEW 6: PROFIL SAYA VIEW
  // ===========================================================================
  Widget _buildProfilSayaView(BuildContext context, Color sidebarBg, Color accentGold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
  // VIEW 0: DASHBOARD OVERVIEW VIEW
  // ===========================================================================
  Widget _buildDashboardOverviewView(BuildContext context, Color sidebarBg, Color accentGold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        _buildMetricCardsRow(accentGold),
        const SizedBox(height: 24),
        _buildLiveChatQueueCard(context, sidebarBg, accentGold),
        const SizedBox(height: 24),
        _buildInstansiTableCard(context, sidebarBg, accentGold),
        const SizedBox(height: 24),
        _buildPopularLayananTableCard(context, sidebarBg, accentGold),
        const SizedBox(height: 24),
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
                            child: _buildInstansiStatusCell(instansi),
                          ),
                          SizedBox(
                            width: 50,
                            child: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 20),
                              onSelected: (val) {
                                if (val == 'edit') {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminFormInstansiScreen(instansi: instansi)));
                                } else if (val == 'toggle') {
                                  _opdService.toggleInstansiStatus(instansi.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        !instansi.isActive
                                            ? '✅ Instansi ${instansi.namaSingkat} diaktifkan kembali!'
                                            : '⚠️ Instansi ${instansi.namaSingkat} diubah ke status Pemeliharaan (Maintenance)!',
                                      ),
                                      backgroundColor: !instansi.isActive ? const Color(0xFF0F2942) : Colors.orange.shade900,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else if (val == 'hapus') {
                                  _konfirmasiHapusInstansi(context, instansi);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: Row(
                                    children: [
                                      Icon(
                                        instansi.isActive ? Icons.power_settings_new_rounded : Icons.check_circle_outline_rounded,
                                        size: 16,
                                        color: instansi.isActive ? Colors.orange.shade800 : Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        instansi.isActive ? 'Set Pemeliharaan' : 'Aktifkan Kembali',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: instansi.isActive ? Colors.orange.shade800 : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                    Expanded(
                      flex: 2,
                      child: Center(child: Text('Status Maintenance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5A6A85), fontFamily: 'Poppins'))),
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
                          Expanded(
                            flex: 2,
                            child: _buildLayananStatusCell(layanan),
                          ),
                          SizedBox(
                            width: 50,
                            child: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 20),
                              onSelected: (val) {
                                if (val == 'edit') {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminFormLayananScreen(layanan: layanan)));
                                } else if (val == 'toggle') {
                                  _opdService.toggleLayananStatus(layanan.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        !layanan.isActive
                                            ? '✅ Layanan ${layanan.rawTitle} diaktifkan kembali!'
                                            : '⚠️ Layanan ${layanan.rawTitle} diubah ke status Pemeliharaan (Maintenance)!',
                                      ),
                                      backgroundColor: !layanan.isActive ? const Color(0xFF0F2942) : Colors.orange.shade900,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else if (val == 'hapus') {
                                  _konfirmasiHapusLayanan(context, layanan);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: Row(
                                    children: [
                                      Icon(
                                        layanan.isActive ? Icons.power_settings_new_rounded : Icons.check_circle_outline_rounded,
                                        size: 16,
                                        color: layanan.isActive ? Colors.orange.shade800 : Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        layanan.isActive ? 'Set Pemeliharaan' : 'Aktifkan Kembali',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: layanan.isActive ? Colors.orange.shade800 : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
  // VIEW 3: KELOLA SEKTOR VIEW
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
                final totalLayanan = _opdService.getLayananList().where((l) => l.sektor.toLowerCase().contains(sektor.title.toLowerCase()) || sektor.title.toLowerCase().contains(l.sektor.toLowerCase())).length;
                final displayCount = totalLayanan;

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
                      Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          value: sektor.isActive,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            _opdService.toggleSektorStatus(sektor.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  val
                                      ? 'Sektor "${sektor.title}" diaktifkan kembali!'
                                      : 'Sektor "${sektor.title}" diubah ke status Pemeliharaan (Maintenance)!',
                                ),
                                backgroundColor: val ? Colors.green : Colors.orange,
                              ),
                            );
                          },
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 20),
                        onSelected: (value) {
                          if (value == 'toggle') {
                            _opdService.toggleSektorStatus(sektor.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  !sektor.isActive
                                      ? 'Sektor "${sektor.title}" diaktifkan kembali!'
                                      : 'Sektor "${sektor.title}" diubah ke status Pemeliharaan (Maintenance)!',
                                ),
                                backgroundColor: !sektor.isActive ? Colors.green : Colors.orange,
                              ),
                            );
                          } else if (value == 'edit') {
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
                          PopupMenuItem(
                            value: 'toggle',
                            child: Row(
                              children: [
                                Icon(
                                  sektor.isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                                  size: 16,
                                  color: sektor.isActive ? Colors.orange : Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  sektor.isActive ? 'Set Pemeliharaan' : 'Aktifkan Kembali',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: sektor.isActive ? Colors.orange : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                    Expanded(
                      flex: 2,
                      child: _buildInstansiStatusCell(instansi),
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
                  final totalLayanan = _opdService.getLayananList().where((l) => l.sektor.toLowerCase().contains(sektor.title.toLowerCase()) || sektor.title.toLowerCase().contains(l.sektor.toLowerCase())).length;
                  final displayCount = totalLayanan;

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

  // ---------------------------------------------------------------------------
  // SUB-VIEW KELOLA ADMIN & SUPERADMIN MANAGEMENT (EXACT MATCH USER SCREENSHOT)
  // ---------------------------------------------------------------------------
  Widget _buildKelolaAdminView(BuildContext context, Color sidebarBg, Color accentGold) {
    final allAdmins = _adminService.adminList;
    final filteredAdmins = allAdmins.where((admin) {
      final query = _adminSearchQuery.toLowerCase();
      return admin.nama.toLowerCase().contains(query) ||
          admin.email.toLowerCase().contains(query) ||
          admin.username.toLowerCase().contains(query) ||
          admin.nip.toLowerCase().contains(query) ||
          admin.instansi.toLowerCase().contains(query) ||
          admin.role.toLowerCase().contains(query);
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 16, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CARD TOP HEADER ROW
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Manajemen Operator',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A1E33),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${allAdmins.length} SUPER ADMIN TERDAFTAR',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.8,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // SEARCH INPUT BOX
                SizedBox(
                  width: 220,
                  height: 42,
                  child: TextField(
                    controller: _adminSearchController,
                    onChanged: (val) => setState(() => _adminSearchQuery = val),
                    style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      hintText: 'Cari nama...',
                      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                      prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 18),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // + TAMBAH BUTTON (EXACT MATCH SCREENSHOT)
                ElevatedButton.icon(
                  onPressed: () => _showFormTambahAdminDialog(context),
                  icon: const Icon(Icons.person_add_rounded, size: 16),
                  label: const Text(
                    '+ TAMBAH',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A1E33),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // LIST OPERATOR CARDS (EXACT MATCH USER SCREENSHOT 1)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: filteredAdmins.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'Tidak ada operator admin yang cocok dengan pencarian.',
                        style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredAdmins.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final admin = filteredAdmins[index];

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFEFEFEF)),
                        ),
                        child: Row(
                          children: [
                            // CIRCLE AVATAR WITH INITIALS
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0A1E33),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  admin.initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // COLUMN 1: NAME & HANDLE TAG
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    admin.nama,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A1E33),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    admin.handleTag,
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                      fontFamily: 'Poppins',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // COLUMN 2: EMAIL KERJA
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'EMAIL KERJA',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      letterSpacing: 0.5,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    admin.email,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF334155),
                                      fontFamily: 'Poppins',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // COLUMN 3: STATUS BADGE (ONLINE / OFFLINE)
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 3.5,
                                    backgroundColor: admin.isOnline ? const Color(0xFF10B981) : Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 6),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        admin.isOnline ? 'ONLINE' : 'OFFLINE',
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: admin.isOnline ? const Color(0xFF10B981) : Colors.grey.shade600,
                                          letterSpacing: 0.5,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      if (!admin.isOnline)
                                        const Text(
                                          'BELUM LOGIN',
                                          style: TextStyle(
                                            fontSize: 8.5,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // COLUMN 4: ACTION BUTTONS (EDIT & HAPUS)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, color: Color(0xFF0A1E33), size: 18),
                                  onPressed: () => _showFormTambahAdminDialog(context, adminToEdit: admin),
                                  tooltip: 'Edit Operator',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                                  onPressed: () => _konfirmasiHapusAdmin(context, admin),
                                  tooltip: 'Hapus Operator',
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FORM REGISTRASI ADMIN BARU DIALOG (EXACT MATCH SCREENSHOT 2 & 3)
  // ---------------------------------------------------------------------------
  void _showFormTambahAdminDialog(BuildContext context, {AdminUserModel? adminToEdit}) {
    final isEdit = adminToEdit != null;
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: adminToEdit?.nama ?? '');
    final usernameController = TextEditingController(text: adminToEdit?.username ?? '');
    final emailController = TextEditingController(text: adminToEdit?.email ?? '');
    final whatsappController = TextEditingController(text: adminToEdit?.whatsapp ?? '');
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    String selectedInstansi = adminToEdit?.instansi ?? 'DISKOMINFO';
    String selectedRole = adminToEdit?.role ?? 'Super Admin';
    bool isVerified = isEdit;
    bool obscurePassword = true;
    bool obscureConfirm = true;

    final instansiList = [
      'DISKOMINFO',
      'DISDUKCAPIL',
      'DPMPTSP',
      'BPKPD',
      'DKP3',
      'DINAS KESEHATAN',
      'DINAS PENDIDIKAN',
      'SUPERADMIN',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 650,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // DARK NAVY HEADER BANNER (EXACT MATCH SCREENSHOT 2)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        color: const Color(0xFF0A1E33),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isEdit ? 'Edit Data Admin' : 'Registrasi Admin Baru',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Otoritas ini memiliki kendali penuh terhadap manajemen layanan pada instansi terkait.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11.5,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E3A5F),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE8A33D).withOpacity(0.4)),
                              ),
                              child: const Icon(
                                Icons.shield_rounded,
                                color: Color(0xFFE8A33D),
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // FORM BODY CONTENT
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // FIELD 1: NAMA LENGKAP & GELAR
                              const Text(
                                'NAMA LENGKAP & GELAR SESUAI SK',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A1E33),
                                  letterSpacing: 0.5,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: namaController,
                                validator: (val) => val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
                                decoration: InputDecoration(
                                  hintText: 'Contoh: Syarif Hidayatullah, M.Kom',
                                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                                  prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey, size: 20),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // FIELD 2: ID USERNAME
                              const Text(
                                'ID USERNAME',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A1E33),
                                  letterSpacing: 0.5,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: usernameController,
                                validator: (val) => val == null || val.trim().isEmpty ? 'Username wajib diisi' : null,
                                decoration: InputDecoration(
                                  hintText: '@ admin_diskominfo',
                                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                                  prefixIcon: const Icon(Icons.alternate_email_rounded, color: Colors.grey, size: 18),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // FIELD 3: EMAIL KEDINASAN (WITH VERIFIKASI BUTTON)
                              const Text(
                                'EMAIL KEDINASAN (WAJIB VERIFIKASI)',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A1E33),
                                  letterSpacing: 0.5,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: emailController,
                                      validator: (val) => val == null || !val.contains('@') ? 'Email tidak valid' : null,
                                      decoration: InputDecoration(
                                        hintText: 'official@sukabumikota.go.id',
                                        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey, size: 20),
                                        filled: true,
                                        fillColor: const Color(0xFFF8FAFC),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (emailController.text.trim().isNotEmpty) {
                                        setDialogState(() => isVerified = true);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('✅ Email kedinasan terverifikasi! Detail operator terbuka.')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Masukkan email kedinasan terlebih dahulu.')),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      isVerified ? Icons.verified_user_rounded : Icons.security_rounded,
                                      size: 16,
                                    ),
                                    label: Text(
                                      isVerified ? 'TERVERIFIKASI' : 'VERIFIKASI',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isVerified ? const Color(0xFF10B981) : const Color(0xFF0A1E33),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // SECTION HEADER: DETAIL OPERATOR [🔒 TERKUNCI / TERVERIFIKASI]
                              Row(
                                children: [
                                  const Text(
                                    'DETAIL OPERATOR',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A1E33),
                                      letterSpacing: 0.8,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isVerified ? const Color(0xFFE6F4EA) : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isVerified ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                                          size: 12,
                                          color: isVerified ? const Color(0xFF10B981) : Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isVerified ? 'TERBUKA' : 'TERKUNCI',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.bold,
                                            color: isVerified ? const Color(0xFF10B981) : Colors.grey,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // TWO COLUMN ROW: WHATSAPP & INSTANSI
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'NOMOR WHATSAPP AKTIF',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0A1E33),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: whatsappController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: '812-345-678',
                                            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                              child: Text('+62', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0A1E33), fontFamily: 'Poppins')),
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFF8FAFC),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'INSTANSI / UNIT KERJA',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0A1E33),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          value: selectedInstansi,
                                          items: instansiList
                                              .map((inst) => DropdownMenuItem(value: inst, child: Text(inst, style: const TextStyle(fontSize: 12, fontFamily: 'Poppins'))))
                                              .toList(),
                                          onChanged: (val) {
                                            if (val != null) setDialogState(() => selectedInstansi = val);
                                          },
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(Icons.business_rounded, color: Colors.grey, size: 20),
                                            filled: true,
                                            fillColor: const Color(0xFFF8FAFC),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // TWO COLUMN ROW: KATA SANDI & KONFIRMASI SANDI
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'KATA SANDI',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0A1E33),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: passwordController,
                                          obscureText: obscurePassword,
                                          decoration: InputDecoration(
                                            hintText: '••••••••',
                                            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.grey, size: 18),
                                            suffixIcon: IconButton(
                                              icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: Colors.grey),
                                              onPressed: () => setDialogState(() => obscurePassword = !obscurePassword),
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFF8FAFC),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'KONFIRMASI SANDI',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0A1E33),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: confirmPasswordController,
                                          obscureText: obscureConfirm,
                                          decoration: InputDecoration(
                                            hintText: '••••••••',
                                            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                                            prefixIcon: const Icon(Icons.security_outlined, color: Colors.grey, size: 18),
                                            suffixIcon: IconButton(
                                              icon: Icon(obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: Colors.grey),
                                              onPressed: () => setDialogState(() => obscureConfirm = !obscureConfirm),
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFF8FAFC),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),

                              // BOTTOM FORM ACTIONS (BATALKAN & SIMPAN & BERI OTORITAS)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.grey.shade700,
                                      side: BorderSide(color: Colors.grey.shade300),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text(
                                      'Batalkan',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (!formKey.currentState!.validate()) return;
                                      final newAdmin = AdminUserModel(
                                        id: isEdit ? adminToEdit.id : 'adm-${DateTime.now().millisecondsSinceEpoch}',
                                        nama: namaController.text.trim(),
                                        username: usernameController.text.trim().replaceAll('@', '').trim(),
                                        email: emailController.text.trim(),
                                        nip: adminToEdit?.nip ?? '19950810 202203 1 001',
                                        whatsapp: whatsappController.text.trim(),
                                        instansi: selectedInstansi,
                                        role: selectedRole,
                                        isActive: true,
                                        isOnline: isEdit ? adminToEdit.isOnline : false,
                                        createdAt: isEdit ? adminToEdit.createdAt : DateTime.now(),
                                      );

                                      if (isEdit) {
                                        _adminService.updateAdmin(newAdmin);
                                      } else {
                                        _adminService.addAdmin(newAdmin);
                                      }

                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('✅ Administrator "${newAdmin.nama}" berhasil ${isEdit ? "perbarui" : "didaftarkan"}!'),
                                          backgroundColor: const Color(0xFF0A1E33),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0A1E33),
                                      foregroundColor: const Color(0xFFE8A33D),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Text(
                                      isEdit ? 'SIMPAN PERUBAHAN' : 'SIMPAN & BERI OTORITAS',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _konfirmasiHapusAdmin(BuildContext context, AdminUserModel admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Hapus Admin?', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus administrator "${admin.nama}"?', style: const TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _adminService.deleteAdmin(admin.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Admin ${admin.nama} berhasil dihapus.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Hapus', style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }
}
