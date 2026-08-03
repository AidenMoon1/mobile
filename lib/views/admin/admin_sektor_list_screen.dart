import 'package:flutter/material.dart';
import '../../models/sektor_model.dart';
import '../../services/opd_service.dart';
import 'admin_form_sektor_screen.dart';

class AdminSektorListScreen extends StatefulWidget {
  const AdminSektorListScreen({super.key});

  @override
  State<AdminSektorListScreen> createState() => _AdminSektorListScreenState();
}

class _AdminSektorListScreenState extends State<AdminSektorListScreen> {
  final OpdService _opdService = OpdService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _opdService.addListener(_refresh);
  }

  @override
  void dispose() {
    _opdService.removeListener(_refresh);
    _searchController.dispose();
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
        title: Row(
          children: [
            const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 28),
            const SizedBox(width: 10),
            Text(
              'Hapus Sektor ${sektor.title}?',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus sektor "${sektor.title}"? Sektor ini tidak akan ditampilkan lagi pada katalog warga.',
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
                  content: Text('Sektor "${sektor.title}" berhasil dihapus!'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus Sektor', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    final allSektor = _opdService.getSektorList();
    final filteredList = allSektor.where((item) {
      final q = _searchQuery.toLowerCase();
      return item.title.toLowerCase().contains(q) || item.desc.toLowerCase().contains(q);
    }).toList();

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
          'Kelola Sektor (Fase Kehidupan)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: accentColor, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminFormSektorScreen()),
              );
            },
            tooltip: 'Tambah Sektor Baru',
          ),
        ],
      ),
      body: Column(
        children: [
          // BAR PENCARIAN SEKTOR
          Container(
            color: primaryColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
              decoration: InputDecoration(
                hintText: 'Cari sektor (e.g. Keluarga, Usaha, Kesehatan)...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.5, fontFamily: 'Poppins'),
                prefixIcon: const Icon(Icons.search_rounded, color: primaryColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // DAFTAR KARTU SEKTOR
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada sektor ditemukan.',
                      style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade300, width: 1.2),
                          boxShadow: const [
                            BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                item.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.category_rounded,
                                  color: accentColor,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.desc,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.grey.shade700,
                                      fontFamily: 'Poppins',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, color: primaryColor, size: 22),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdminFormSektorScreen(sektor: item),
                                      ),
                                    );
                                  },
                                  tooltip: 'Edit Sektor',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                                  onPressed: () => _konfirmasiHapus(context, item),
                                  tooltip: 'Hapus Sektor',
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminFormSektorScreen()),
          );
        },
        backgroundColor: accentColor,
        icon: const Icon(Icons.add_rounded, color: primaryColor),
        label: const Text(
          'Tambah Sektor',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: primaryColor),
        ),
      ),
    );
  }
}
