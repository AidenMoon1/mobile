import 'package:flutter/material.dart';
import 'package:mobile/services/opd_service.dart';
import 'package:mobile/views/admin/admin_instansi_list_screen.dart';
import 'package:mobile/views/admin/admin_form_instansi_screen.dart';
import 'package:mobile/views/admin/admin_layanan_list_screen.dart';
import 'package:mobile/views/admin/admin_form_layanan_screen.dart';
import 'package:mobile/views/admin/admin_sektor_list_screen.dart';
import 'package:mobile/views/admin/admin_form_sektor_screen.dart';
import 'package:mobile/views/admin/admin_chat_inbox_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final OpdService _opdService = OpdService();

  @override
  void initState() {
    super.initState();
    _opdService.addListener(_refresh);
  }

  @override
  void dispose() {
    _opdService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    final totalInstansi = _opdService.getInstansiList().length;
    final totalLayanan = _opdService.getLayananList().length;
    final totalSektor = _opdService.getSektorList().length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pusat Kontrol Admin',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
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
  // WRAPPER UNTUK KONTEN UTAMA (KONTROL SCROLLING)
  // ---------------------------------------------------------------------------
  Widget _buildMainContentWrapper(BuildContext context, Color sidebarBg, Color accentGold) {
    // Menu Chat memerlukan scrolling internal (bukan global) agar rapi
    if (_selectedNavIndex == 4) {
      return _buildActiveContentView(context, sidebarBg, accentGold);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: _buildActiveContentView(context, sidebarBg, accentGold),
    );
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
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, Color(0xFF1A4570)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: accentColor, size: 36),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panel Manajemen Terpadu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelola Instansi OPD, Layanan Publik, Form Builder, & Sektor secara fleksibel realtime.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CARD STATISTIK UTAMA
            const Text(
              'Ringkasan Data Terdaftar',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Total OPD',
                    count: '$totalInstansi',
                    icon: Icons.account_balance_rounded,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Layanan',
                    count: '$totalLayanan',
                    icon: Icons.miscellaneous_services_rounded,
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Sektor',
                    count: '$totalSektor',
                    icon: Icons.category_rounded,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // MENU MANAGEMENT CARDS
            const Text(
              'Menu Kelola Data',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),

            // 0. LIVE CHAT INBOX WARGA (TERHUBUNG LANGSUNG DARI BOT)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A1E33), Color(0xFF1E3A5F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8A33D),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mark_chat_unread_rounded, color: Color(0xFF0A1E33), size: 24),
                ),
                title: Row(
                  children: [
                    const Text(
                      'Pusat Chat Masuk Warga',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: const Text(
                        'Live Chat',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                    ),
                  ],
                ),
                subtitle: const Text(
                  'Balas obrolan langsung warga yang dialihkan oleh AI Bot.',
                  style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Poppins'),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminChatInboxScreen()),
                  );
                },
              ),
            ),

            // 1. KELOLA SEKTOR (FASE KEHIDUPAN)
            _buildAdminMenuTile(
              title: 'Kelola Sektor (Fase Kehidupan)',
              subtitle: 'Tambah, edit, atau hapus kategori sektor fase kehidupan.',
              icon: Icons.category_rounded,
              onTapList: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminSektorListScreen()),
                );
              },
              onTapAdd: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminFormSektorScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // 2. KELOLA INSTANSI (OPD)
            _buildAdminMenuTile(
              title: 'Kelola Instansi (OPD)',
              subtitle: 'Tambah, edit, atau hapus data instansi dinas.',
              icon: Icons.account_balance_rounded,
              onTapList: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminInstansiListScreen()),
                );
              },
              onTapAdd: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminFormInstansiScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

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
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminMenuTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTapList,
    required VoidCallback onTapAdd,
  }) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: primaryColor, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTapList,
                    icon: const Icon(Icons.list_alt_rounded, size: 18),
                    label: const Text('Daftar Data', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onTapAdd,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Tambah Baru (+)', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
