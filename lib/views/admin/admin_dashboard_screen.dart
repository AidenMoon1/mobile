import 'package:flutter/material.dart';
import '../../services/opd_service.dart';
import 'admin_instansi_list_screen.dart';
import 'admin_form_instansi_screen.dart';
import 'admin_layanan_list_screen.dart';
import 'admin_sektor_list_screen.dart';
import 'admin_chat_inbox_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final OpdService _opdService = OpdService();
  int _selectedNavIndex = 0; // 0: Dashboard, 1: Kelola Instansi, 2: Kelola Layanan, 3: Kelola Sektor, 4: Live Chat

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
    const Color sidebarBg = Color(0xFF0F2942);
    const Color accentGold = Color(0xFFE8A33D);
    const Color mainBg = Color(0xFFF4F7FC);

    final isWideScreen = MediaQuery.of(context).size.width >= 800;

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
              title: const Text(
                'Sukabumi One Access Admin',
                style: TextStyle(
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
          // SIDEBAR UNTUK LAYAR MONITOR PC / TABLET
          if (isWideScreen) SizedBox(width: 250, child: _buildSidebar(context, sidebarBg, accentGold)),

          // MAIN CONTENT AREA
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP HEADER TITLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F2942),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      if (isWideScreen)
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded, size: 16),
                          label: const Text('Kembali ke Aplikasi Warga', style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: sidebarBg,
                            side: const BorderSide(color: sidebarBg),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // METRIC CARDS ROW (TOTAL INSTANSI, TOTAL LAYANAN, LAYANAN AKTIF)
                  _buildMetricCardsRow(accentGold),

                  const SizedBox(height: 24),

                  // DAFTAR INSTANSI DATA TABLE CARD
                  _buildInstansiTableCard(context, sidebarBg, accentGold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SIDEBAR NAVIGATION PANEL (DARK NAVY #0F2942 & GOLD #E8A33D)
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

          // NAV ITEM 1: DASHBOARD
          _buildSidebarNavItem(
            index: 0,
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            accentGold: accentGold,
            onTap: () {
              setState(() => _selectedNavIndex = 0);
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
            },
          ),

          // NAV ITEM 2: KELOLA INSTANSI
          _buildSidebarNavItem(
            index: 1,
            icon: Icons.account_balance_rounded,
            label: 'Kelola Instansi',
            accentGold: accentGold,
            onTap: () {
              setState(() => _selectedNavIndex = 1);
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminInstansiListScreen()),
              );
            },
          ),

          // NAV ITEM 3: KELOLA LAYANAN
          _buildSidebarNavItem(
            index: 2,
            icon: Icons.format_list_bulleted_rounded,
            label: 'Kelola Layanan',
            accentGold: accentGold,
            onTap: () {
              setState(() => _selectedNavIndex = 2);
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLayananListScreen()),
              );
            },
          ),

          // NAV ITEM 4: KELOLA SEKTOR
          _buildSidebarNavItem(
            index: 3,
            icon: Icons.widgets_outlined,
            label: 'Kelola Sektor',
            accentGold: accentGold,
            onTap: () {
              setState(() => _selectedNavIndex = 3);
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminSektorListScreen()),
              );
            },
          ),

          // NAV ITEM 5: LIVE CHAT WARGA
          _buildSidebarNavItem(
            index: 4,
            icon: Icons.mark_chat_unread_rounded,
            label: 'Live Chat Warga',
            accentGold: accentGold,
            onTap: () {
              setState(() => _selectedNavIndex = 4);
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminChatInboxScreen()),
              );
            },
          ),

          const Spacer(),

          // BOTTOM PROFILE BAR (SOA GOLD)
          Container(
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
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem({
    required int index,
    required IconData icon,
    required String label,
    required Color accentGold,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedNavIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: InkWell(
        onTap: onTap,
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

  // ---------------------------------------------------------------------------
  // METRIC CARDS ROW (TOTAL INSTANSI, TOTAL LAYANAN, LAYANAN AKTIF)
  // ---------------------------------------------------------------------------
  Widget _buildMetricCardsRow(Color accentGold) {
    final totalInstansi = _opdService.getInstansiList().length;
    final totalLayanan = _opdService.getLayananList().length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth - 20) / 3;
        final bool isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            children: [
              _buildSingleMetricCard('Total Instansi', '$totalInstansi', Icons.account_balance_rounded, const Color(0xFFFFF6E5), accentGold),
              const SizedBox(height: 10),
              _buildSingleMetricCard('Total Layanan', '$totalLayanan', Icons.format_list_bulleted_rounded, const Color(0xFFFFF6E5), accentGold),
              const SizedBox(height: 10),
              _buildSingleMetricCard('Layanan Aktif', '$totalLayanan', Icons.check_circle_outline_rounded, const Color(0xFFFFF6E5), accentGold),
            ],
          );
        }

        return Row(
          children: [
            SizedBox(
              width: cardWidth,
              child: _buildSingleMetricCard('Total Instansi', '$totalInstansi', Icons.account_balance_rounded, const Color(0xFFFFF6E5), accentGold),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: cardWidth,
              child: _buildSingleMetricCard('Total Layanan', '$totalLayanan', Icons.format_list_bulleted_rounded, const Color(0xFFFFF6E5), accentGold),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: cardWidth,
              child: _buildSingleMetricCard('Layanan Aktif', '$totalLayanan', Icons.check_circle_outline_rounded, const Color(0xFFFFF6E5), accentGold),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSingleMetricCard(String title, String count, IconData icon, Color iconBg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                count,
                style: const TextStyle(
                  color: Color(0xFF0F2942),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TABEL "DAFTAR INSTANSI" CARD
  // ---------------------------------------------------------------------------
  Widget _buildInstansiTableCard(BuildContext context, Color sidebarBg, Color accentGold) {
    final instansiList = _opdService.getInstansiList();

    return Container(
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
          // CARD HEADER: TITLE & + TAMBAH INSTANSI BUTTON
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Instansi',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2942),
                    fontFamily: 'Poppins',
                  ),
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
                    '+ Tambah Instansi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentGold,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),

          // TABLE HEADER (GREY BG)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            color: const Color(0xFFF7F9FC),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Instansi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A6A85),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Jumlah Layanan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A6A85),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A6A85),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Center(
                    child: Text(
                      'Aksi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A6A85),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // TABLE ROWS LIST
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
                    // COLUMN 1: INSTANSI NAME
                    Expanded(
                      flex: 3,
                      child: Text(
                        instansi.namaSingkat.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F2942),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                    // COLUMN 2: JUMLAH LAYANAN
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          '$totalLayananInstansi',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F2942),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),

                    // COLUMN 3: STATUS BADGE (GREEN PILL AKTIF)
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2F7E2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Aktif',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),

                    // COLUMN 4: AKSI (THREE-DOT MENUS)
                    SizedBox(
                      width: 50,
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded, color: Colors.grey, size: 20),
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminFormInstansiScreen(instansi: instansi),
                              ),
                            );
                          } else if (value == 'hapus') {
                            _konfirmasiHapus(context, instansi.id, instansi.namaSingkat);
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _konfirmasiHapus(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus $name?', style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin menghapus data instansi ini?', style: TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _opdService.deleteInstansi(id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Instansi $name berhasil dihapus.')),
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
