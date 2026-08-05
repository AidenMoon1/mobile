import 'package:flutter/material.dart';
import '../../models/sektor_model.dart';
import '../../services/opd_service.dart';
import '../../widgets/smart_image.dart';
import 'admin_dashboard_screen.dart';
import 'admin_instansi_list_screen.dart';
import 'admin_layanan_list_screen.dart';
import 'admin_form_sektor_screen.dart';
import 'admin_chat_inbox_screen.dart';

class AdminSektorListScreen extends StatefulWidget {
  const AdminSektorListScreen({super.key});

  @override
  State<AdminSektorListScreen> createState() => _AdminSektorListScreenState();
}

class _AdminSektorListScreenState extends State<AdminSektorListScreen> {
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

  void _konfirmasiHapus(BuildContext context, SektorModel sektor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 10),
            Text(
              'Hapus Sektor?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus sektor "${sektor.title}"?',
          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () {
              _opdService.deleteSektor(sektor.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sektor ${sektor.title} berhasil dihapus!'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
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
    final allList = _opdService.getSektorList();

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
                'Kelola Sektor',
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

          // MAIN CONTENT AREA (GRID CARDS LAYOUT)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CARD HEADER: TITLE & SUBTITLE & + TAMBAH SEKTOR BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kelola Sektor Fase Kehidupan',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2942),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '5 Instansi Terdaftar',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                            ),
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
                          '+ Tambah Sektor',
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
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // GRID CARD KARTU SEKTOR INTERAKTIF (3 KOLOM)
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
                        itemCount: allList.length,
                        itemBuilder: (context, index) {
                          final sektor = allList[index];
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
                                // ICON CONTAINER
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

                                // TITLE & SUBTITLE
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

                                // ACTION MENU (THREE-DOTS)
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
                                      _konfirmasiHapus(context, sektor);
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
            isSelected: false,
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            accentGold: accentGold,
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
              );
            },
          ),

          // NAV ITEM 2: KELOLA INSTANSI
          _buildSidebarNavItem(
            isSelected: false,
            icon: Icons.account_balance_rounded,
            label: 'Kelola Instansi',
            accentGold: accentGold,
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminInstansiListScreen()),
              );
            },
          ),

          // NAV ITEM 3: KELOLA LAYANAN
          _buildSidebarNavItem(
            isSelected: false,
            icon: Icons.format_list_bulleted_rounded,
            label: 'Kelola Layanan',
            accentGold: accentGold,
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminLayananListScreen()),
              );
            },
          ),

          // NAV ITEM 4: KELOLA SEKTOR (SELECTED)
          _buildSidebarNavItem(
            isSelected: true,
            icon: Icons.widgets_outlined,
            label: 'Kelola Sektor',
            accentGold: accentGold,
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
            },
          ),

          // NAV ITEM 5: LIVE CHAT WARGA
          _buildSidebarNavItem(
            isSelected: false,
            icon: Icons.mark_chat_unread_rounded,
            label: 'Live Chat Warga',
            accentGold: accentGold,
            onTap: () {
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
    required bool isSelected,
    required IconData icon,
    required String label,
    required Color accentGold,
    required VoidCallback onTap,
  }) {
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
}
