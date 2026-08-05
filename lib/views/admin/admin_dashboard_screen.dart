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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BANNER PERNYATAAN KONTROL ADMIN
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

            // 3. KELOLA LAYANAN PUBLIK
            _buildAdminMenuTile(
              title: 'Kelola Layanan Publik',
              subtitle: 'Tambah, edit, atau hapus layanan & konfigurasi Form Builder.',
              icon: Icons.design_services_rounded,
              onTapList: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminLayananListScreen()),
                );
              },
              onTapAdd: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminFormLayananScreen()),
                );
              },
            ),
            const SizedBox(height: 30),
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
