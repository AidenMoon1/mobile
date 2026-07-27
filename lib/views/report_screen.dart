import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Infrastruktur';
  bool _hasPhoto = false;

  // List of reports
  List<dynamic> _reports = [];
  bool _isLoadingHistory = true;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Infrastruktur',
    'Kebersihan',
    'Ketertiban Umum',
    'Kesehatan',
    'Lainnya'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoadingHistory = true;
    });

    try {
      final response = await ApiService.get('aduan');
      if (response.statusCode == 200) {
        setState(() {
          _reports = jsonDecode(response.body);
          _isLoadingHistory = false;
        });
      }
    } catch (_) {
      setState(() {
        _isLoadingHistory = false;
      });
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final payload = {
      'title': _titleController.text,
      'category': _selectedCategory,
      'description': _descController.text,
    };

    try {
      final response = await ApiService.post('aduan', payload);
      if (response.statusCode == 200) {
        // Hapus input form
        _titleController.clear();
        _descController.clear();
        setState(() {
          _hasPhoto = false;
          _isSubmitting = false;
        });

        // Tampilkan notifikasi sukses
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pengaduan berhasil terkirim secara simulasi!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Ambil data riwayat baru dan pindah ke tab riwayat
        await _fetchHistory();
        _tabController.animateTo(1);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim aduan: $e')),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Diproses':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Layanan Pengaduan Warga',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.edit_note), text: 'Aduan Baru'),
            Tab(icon: Icon(Icons.history), text: 'Riwayat Aduan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: FORM PENGADUAN BARU
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tulis Keluhan Anda',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Laporan Anda akan kami simulasikan masuk ke dashboard Diskominfo Sukabumi.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  // Input Judul
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Judul Laporan',
                      hintText: 'Misal: Jalan Berlubang di Sukaraja',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Judul laporan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Kategori
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Kategori Keluhan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Input Deskripsi
                  TextFormField(
                    controller: _descController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi Keluhan secara Detail',
                      hintText: 'Tuliskan kronologi kejadian, lokasi lengkap, dan keluhan Anda...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deskripsi laporan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Simulasi Unggah Foto
                  InkWell(
                    onTap: () {
                      setState(() {
                        _hasPhoto = !_hasPhoto;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400, style: BorderStyle.values[1]), // Dashed effect
                        borderRadius: BorderRadius.circular(10),
                        color: _hasPhoto ? Colors.green.shade50 : Colors.grey.shade50,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _hasPhoto ? Icons.check_circle : Icons.camera_alt,
                            color: _hasPhoto ? Colors.green : Colors.grey,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _hasPhoto ? 'Foto Dipilih (Simulasi)' : 'Ambil Foto Keluhan (Opsional)',
                            style: TextStyle(
                              color: _hasPhoto ? Colors.green.shade700 : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_hasPhoto)
                            const Text(
                              'Klik lagi untuk menghapus foto',
                              style: TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol Kirim
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Kirim Pengaduan',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TAB 2: RIWAYAT PENGADUAN
          _isLoadingHistory
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _fetchHistory,
                  child: _reports.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 100),
                            Center(child: Text('Belum ada riwayat pengaduan.')),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _reports.length,
                          itemBuilder: (context, index) {
                            final report = _reports[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Kategori Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            report['category'],
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        // Status Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(report['status']).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            report['status'],
                                            style: TextStyle(
                                              color: _getStatusColor(report['status']),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Judul
                                    Text(
                                      report['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Deskripsi
                                    Text(
                                      report['description'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ID Aduan: #${report['id']}',
                                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                                        ),
                                        Text(
                                          report['created_at'].toString().substring(0, 10),
                                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
