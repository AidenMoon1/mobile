import 'package:flutter/material.dart';
import '../../models/instansi_model.dart';
import '../../services/opd_service.dart';
import '../../widgets/admin_image_picker.dart';
import '../../widgets/smart_image.dart';
import 'admin_dashboard_screen.dart';
import 'admin_instansi_list_screen.dart';
import 'admin_layanan_list_screen.dart';
import 'admin_sektor_list_screen.dart';
import 'admin_chat_inbox_screen.dart';

class AdminFormInstansiScreen extends StatefulWidget {
  final InstansiModel? instansi;

  const AdminFormInstansiScreen({super.key, this.instansi});

  @override
  State<AdminFormInstansiScreen> createState() => _AdminFormInstansiScreenState();
}

class _AdminFormInstansiScreenState extends State<AdminFormInstansiScreen> {
  final _formKey = GlobalKey<FormState>();
  final OpdService _opdService = OpdService();

  late TextEditingController _kodeController;
  late TextEditingController _namaSingkatController;
  late TextEditingController _namaLengkapController;
  late TextEditingController _alamatController;
  late TextEditingController _jamOperasionalController;
  late TextEditingController _kontakController;
  late TextEditingController _logoPathController;
  late TextEditingController _deskripsiController;
  late TextEditingController _tugasFungsiController;

  bool get isEdit => widget.instansi != null;

  @override
  void initState() {
    super.initState();
    final item = widget.instansi;
    _kodeController = TextEditingController(text: item?.kodeInstansi ?? '');
    _namaSingkatController = TextEditingController(text: item?.namaSingkat ?? '');
    _namaLengkapController = TextEditingController(text: item?.namaLengkap ?? '');
    _alamatController = TextEditingController(text: item?.alamat ?? '');
    _jamOperasionalController = TextEditingController(
      text: item?.jamOperasional ?? 'Senin - Jumat 08:00 - 15:30 WIB',
    );
    _kontakController = TextEditingController(text: item?.kontak ?? '');
    _logoPathController = TextEditingController(
      text: item?.logoPath ?? 'assets/images/disduk.png',
    );
    _deskripsiController = TextEditingController(text: item?.deskripsi ?? '');
    _tugasFungsiController = TextEditingController(
      text: item?.tugasFungsi.join('\n') ?? '',
    );
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaSingkatController.dispose();
    _namaLengkapController.dispose();
    _alamatController.dispose();
    _jamOperasionalController.dispose();
    _kontakController.dispose();
    _logoPathController.dispose();
    _deskripsiController.dispose();
    _tugasFungsiController.dispose();
    super.dispose();
  }

  void _simpanInstansi() {
    if (_formKey.currentState!.validate()) {
      final tfList = _tugasFungsiController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final kode = _kodeController.text.trim().isNotEmpty
          ? _kodeController.text.trim().toLowerCase()
          : _namaSingkatController.text.trim().toLowerCase();

      final newModel = InstansiModel(
        id: isEdit ? widget.instansi!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        kodeInstansi: kode,
        namaSingkat: _namaSingkatController.text.trim(),
        namaLengkap: _namaLengkapController.text.trim(),
        alamat: _alamatController.text.trim(),
        jamOperasional: _jamOperasionalController.text.trim(),
        kontak: _kontakController.text.trim(),
        logoPath: _logoPathController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        mapsQuery: '${_namaLengkapController.text.trim()} Kota Sukabumi',
        tugasFungsi: tfList,
      );

      if (isEdit) {
        _opdService.updateInstansi(newModel);
      } else {
        _opdService.addInstansi(newModel);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Instansi ${newModel.namaSingkat} berhasil diperbarui!'
                : 'Instansi baru ${newModel.namaSingkat} berhasil ditambahkan!',
          ),
          backgroundColor: const Color(0xFF0F2942),
        ),
      );
    }
  }

  void _bukaPilihLogo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdminImagePicker(
        currentImagePath: _logoPathController.text,
        label: 'Logo / Foto Instansi',
        onImageSelected: (newPath) {
          setState(() {
            _logoPathController.text = newPath;
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
                isEdit ? 'Edit Instansi' : 'Tambah Instansi Baru',
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
                                  'Kelola Instansi',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontFamily: 'Poppins'),
                                ),
                                const Icon(Icons.chevron_right_rounded, size: 14, color: Colors.grey),
                                Text(
                                  isEdit ? 'Edit Instansi' : 'Tambah Instansi',
                                  style: const TextStyle(color: Color(0xFF0F2942), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                            Text(
                              isEdit ? 'Edit Data Instansi' : 'Tambah Instansi Baru',
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

                    // CARD 1: IDENTITAS INSTANSI
                    _buildFormCard(
                      title: 'Identitas Instansi',
                      accentGold: accentGold,
                      children: [
                        _buildInputField(
                          controller: _namaSingkatController,
                          label: 'Nama Singkat (Akronim)',
                          hint: 'Contoh: DISDUKCAPIL',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Nama singkat wajib diisi' : null,
                        ),
                        const SizedBox(height: 14),
                        _buildInputField(
                          controller: _namaLengkapController,
                          label: 'Nama Lengkap Instansi / Dinas',
                          hint: 'Contoh: Dinas Kependudukan dan Pencatatan Sipil',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Nama lengkap wajib diisi' : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // CARD 2: KONTAK & OPERASIONAL
                    _buildFormCard(
                      title: 'Kontak & Operasional',
                      accentGold: accentGold,
                      children: [
                        _buildInputField(
                          controller: _alamatController,
                          label: 'Alamat Kantor',
                          hint: 'Jl. Bhayangkara No. 202, Kota Sukabumi',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Alamat kantor wajib diisi' : null,
                        ),
                        const SizedBox(height: 14),
                        _buildInputField(
                          controller: _jamOperasionalController,
                          label: 'Jam Operasional Pelayanan',
                          hint: 'Senin - Jumat 08:00 - 15:30 WIB',
                        ),
                        const SizedBox(height: 14),
                        _buildInputField(
                          controller: _kontakController,
                          label: 'Kontak / WhatsApp / Email Resmi',
                          hint: '(0266) 222123 / admin@gmail.com',
                        ),
                        const SizedBox(height: 14),

                        // LOGO / FOTO INSTANSI PICKER
                        const Text(
                          'Logo / Foto Instansi',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F2942),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(12),
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
                                    imagePath: _logoPathController.text,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.contain,
                                    fallbackIcon: Icons.account_balance_rounded,
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
                                      _logoPathController.text.isNotEmpty
                                          ? _logoPathController.text.split('/').last
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
                                onPressed: _bukaPilihLogo,
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
                    const SizedBox(height: 20),

                    // CARD 3: DESKRIPSI & TUGAS FUNGSI
                    _buildFormCard(
                      title: 'Deskripsi & Tugas Fungsi',
                      accentGold: accentGold,
                      children: [
                        _buildInputField(
                          controller: _deskripsiController,
                          label: 'Deskripsi Singkat Profil Instansi',
                          hint: 'Jelaskan tugas utama instansi dalam mengayomi publik...',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 14),
                        _buildInputField(
                          controller: _tugasFungsiController,
                          label: 'Tugas Utama & Fungsi (Pisahkan Tiap Poin Dengan Baris Baru / Enter)',
                          hint: 'Poin 1: Penerbitan Dokumen kependudukan\nPoin 2: Pencatatan perkawinan Warga',
                          maxLines: 4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // BOTTOM SUBMIT BUTTON (GOLD #E8A33D)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _simpanInstansi,
                        icon: Icon(isEdit ? Icons.save_rounded : Icons.check_circle_rounded, size: 20),
                        label: Text(
                          isEdit ? 'Perbarui Data Instansi' : 'Simpan Instansi Baru',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentGold,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildFormCard({required String title, required Color accentGold, required List<Widget> children}) {
    return Container(
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
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: accentGold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F2942),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
          decoration: InputDecoration(
            hintText: hint,
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
          validator: validator,
        ),
      ],
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

          // NAV ITEM 2: KELOLA INSTANSI (SELECTED)
          _buildSidebarNavItem(
            isSelected: true,
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

          // NAV ITEM 4: KELOLA SEKTOR
          _buildSidebarNavItem(
            isSelected: false,
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
