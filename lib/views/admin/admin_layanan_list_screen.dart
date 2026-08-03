import 'package:flutter/material.dart';
import '../../models/layanan_model.dart';
import '../../services/opd_service.dart';
import 'admin_form_layanan_screen.dart';

class AdminLayananListScreen extends StatefulWidget {
  const AdminLayananListScreen({super.key});

  @override
  State<AdminLayananListScreen> createState() => _AdminLayananListScreenState();
}

class _AdminLayananListScreenState extends State<AdminLayananListScreen> {
  final OpdService _opdService = OpdService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedInstansiFilter = 'Semua';

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

  void _konfirmasiHapus(BuildContext context, LayananModel layanan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 10),
            Text(
              'Hapus Layanan?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus layanan "${layanan.judulLayanan}"? Layanan ini tidak akan muncul lagi pada aplikasi warga.',
          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () {
              _opdService.deleteLayanan(layanan.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Layanan "${layanan.rawTitle}" berhasil dihapus!'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus Layanan', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    final allInstansi = _opdService.getInstansiList();
    final allLayanan = _opdService.getLayananList();

    final filteredList = allLayanan.where((item) {
      final matchesSearch = item.judulLayanan.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.sektor.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.kodeInstansi.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesFilter = _selectedInstansiFilter == 'Semua' ||
          item.kodeInstansi.toLowerCase() == _selectedInstansiFilter.toLowerCase();

      return matchesSearch && matchesFilter;
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
          'Kelola Layanan Publik',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add_rounded, color: accentColor, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminFormLayananScreen()),
              );
            },
            tooltip: 'Tambah Layanan Baru',
          ),
        ],
      ),
      body: Column(
        children: [
          // BAR FILTER & PENCARIAN
          Container(
            color: primaryColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    hintText: 'Cari layanan (e.g. KTP, KK, NIB, PBB)...',
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
                const SizedBox(height: 10),

                // FILTER DROPDOWN PER OPD INSTANSI
                Row(
                  children: [
                    const Text(
                      'Filter OPD:',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Poppins'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedInstansiFilter,
                            isExpanded: true,
                            style: const TextStyle(fontSize: 12.5, color: primaryColor, fontFamily: 'Poppins'),
                            items: [
                              const DropdownMenuItem(value: 'Semua', child: Text('Semua OPD Instansi')),
                              ...allInstansi.map(
                                (opd) => DropdownMenuItem(
                                  value: opd.kodeInstansi,
                                  child: Text('${opd.namaSingkat} (${opd.namaLengkap})'),
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedInstansiFilter = val);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // DAFTAR KARTU LAYANAN
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada layanan ditemukan.',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.description_outlined, color: primaryColor, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          item.kodeInstansi.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: accentColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Sektor ${item.sektor}',
                                          style: const TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.judulLayanan,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.subjudul,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade700,
                                      fontFamily: 'Poppins',
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${item.persyaratan.length} Syarat Dokumen Ditentukan',
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, color: primaryColor, size: 22),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdminFormLayananScreen(layanan: item),
                                      ),
                                    );
                                  },
                                  tooltip: 'Edit Layanan',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                                  onPressed: () => _konfirmasiHapus(context, item),
                                  tooltip: 'Hapus Layanan',
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
            MaterialPageRoute(builder: (context) => const AdminFormLayananScreen()),
          );
        },
        backgroundColor: accentColor,
        icon: const Icon(Icons.add_rounded, color: primaryColor),
        label: const Text(
          'Tambah Layanan',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: primaryColor),
        ),
      ),
    );
  }
}
