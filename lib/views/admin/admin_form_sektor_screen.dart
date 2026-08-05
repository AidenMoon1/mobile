import 'package:flutter/material.dart';
import '../../models/sektor_model.dart';
import '../../services/opd_service.dart';
import '../../widgets/admin_image_picker.dart';
import '../../widgets/smart_image.dart';
import 'admin_dashboard_screen.dart';
import 'admin_instansi_list_screen.dart';
import 'admin_layanan_list_screen.dart';
import 'admin_sektor_list_screen.dart';
import 'admin_chat_inbox_screen.dart';

class AdminFormSektorScreen extends StatefulWidget {
  final SektorModel? sektor;

  const AdminFormSektorScreen({super.key, this.sektor});

  @override
  State<AdminFormSektorScreen> createState() => _AdminFormSektorScreenState();
}

class _AdminFormSektorScreenState extends State<AdminFormSektorScreen> {
  final _formKey = GlobalKey<FormState>();
  final OpdService _opdService = OpdService();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _imagePathController;

  bool get isEdit => widget.sektor != null;

  @override
  void initState() {
    super.initState();
    final item = widget.sektor;
    _titleController = TextEditingController(text: item?.title ?? '');
    _descController = TextEditingController(text: item?.desc ?? '');
    _imagePathController = TextEditingController(
      text: item?.imagePath ?? 'assets/icon/keluarga.png',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  void _simpanSektor() {
    if (_formKey.currentState!.validate()) {
      final newModel = SektorModel(
        id: isEdit ? widget.sektor!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        desc: _descController.text.trim(),
        imagePath: _imagePathController.text.trim(),
        iconName: 'category_rounded',
      );

      if (isEdit) {
        _opdService.updateSektor(newModel);
      } else {
        _opdService.addSektor(newModel);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Sektor "${newModel.title}" berhasil diperbarui!'
                : 'Sektor baru "${newModel.title}" berhasil ditambahkan!',
          ),
          backgroundColor: const Color(0xFF0F2942),
        ),
      );
    }
  }

  void _bukaPilihIcon() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdminImagePicker(
        currentImagePath: _imagePathController.text,
        label: 'Gambar Icon Sektor Kategori',
        onImageSelected: (newPath) {
          setState(() {
            _imagePathController.text = newPath;
          });
        },
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
                isEdit ? 'Edit Sektor Kategori' : 'Tambah Sektor Kategori Baru',
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
          // SIDEBAR UNTUK LAYAR MONITOR PC / TABLET
          if (isWideScreen) SizedBox(width: 250, child: _buildSidebar(context, sidebarBg, accentGold)),

          // MAIN CONTENT AREA FORM
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BREADCRUMB & PAGE TITLE
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F2942)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Kelola Sektor',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontFamily: 'Poppins'),
                                ),
                                const Icon(Icons.chevron_right_rounded, size: 14, color: Colors.grey),
                                Text(
                                  isEdit ? 'Edit Sektor' : 'Tambah Sektor',
                                  style: const TextStyle(color: Color(0xFF0F2942), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                            Text(
                              isEdit ? 'Edit Sektor Kategori' : 'Tambah Sektor Kategori Baru',
                              style: const TextStyle(
                                fontSize: 22,
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

                    // CARD 1: NAMA & DESKRIPSI SEKTOR
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama / Judul Sektor',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2942),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _titleController,
                            style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              hintText: 'Contoh: Pariwisata & Kebudayaan',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12.5, fontFamily: 'Poppins'),
                              fillColor: const Color(0xFFF8FAFC),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF0F2942), width: 1.5),
                              ),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Judul sektor wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Deskripsi Singkat Sektor',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2942),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _descController,
                            maxLines: 4,
                            style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              hintText: 'Contoh: Wisata Kota, Sanggar Seni ...',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12.5, fontFamily: 'Poppins'),
                              fillColor: const Color(0xFFF8FAFC),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF0F2942), width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // CARD 2: GAMBAR ICON SEKTOR KATEGORI
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gambar Icon Sektor Kategori',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2942),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SmartImage(
                                      imagePath: _imagePathController.text,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.contain,
                                      fallbackIcon: Icons.widgets_rounded,
                                      fallbackColor: accentGold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _imagePathController.text.isNotEmpty
                                            ? _imagePathController.text.split('/').last
                                            : '[nama image]',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F2942),
                                          fontFamily: 'Poppins',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Klik tombol di kanan untuk memilih atau mengunggah logo baru',
                                        style: TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Poppins'),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _bukaPilihIcon,
                                  icon: const Icon(Icons.file_upload_outlined, size: 16),
                                  label: const Text(
                                    'Unggah / Pilih',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: sidebarBg,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // BOTTOM SUBMIT BUTTON (GOLD #E8A33D "Simpan")
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _simpanSektor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentGold,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                  ],
                ),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminSektorListScreen()),
              );
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
