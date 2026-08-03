import 'package:flutter/material.dart';
import '../../models/layanan_model.dart';
import '../../services/opd_service.dart';

class AdminFormLayananScreen extends StatefulWidget {
  final LayananModel? layanan;

  const AdminFormLayananScreen({super.key, this.layanan});

  @override
  State<AdminFormLayananScreen> createState() => _AdminFormLayananScreenState();
}

class _AdminFormLayananScreenState extends State<AdminFormLayananScreen> {
  final _formKey = GlobalKey<FormState>();
  final OpdService _opdService = OpdService();

  late String _selectedKodeInstansi;
  late String _selectedSektor;
  late TextEditingController _judulLayananController;
  late TextEditingController _rawTitleController;
  late TextEditingController _subjudulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _urlPortalController;

  final List<TextEditingController> _persyaratanControllers = [];

  final List<String> _sektorOptions = const [
    'Keluarga',
    'Usaha',
    'Lingkungan & Tempat Tinggal',
    'Pendidikan',
    'Kendaraan',
    'Kesehatan',
    'Tanggap Darurat',
    'Karier',
    'Rekreasi',
    'Sosial & Hukum',
  ];

  bool get isEdit => widget.layanan != null;

  @override
  void initState() {
    super.initState();
    final item = widget.layanan;

    final allInstansi = _opdService.getInstansiList();
    _selectedKodeInstansi = item?.kodeInstansi ?? (allInstansi.isNotEmpty ? allInstansi.first.kodeInstansi : 'disdukcapil');
    _selectedSektor = item?.sektor ?? _sektorOptions.first;

    _judulLayananController = TextEditingController(text: item?.judulLayanan ?? '');
    _rawTitleController = TextEditingController(text: item?.rawTitle ?? '');
    _subjudulController = TextEditingController(text: item?.subjudul ?? '');
    _deskripsiController = TextEditingController(text: item?.deskripsi ?? '');
    _urlPortalController = TextEditingController(
      text: item?.urlPortal ?? 'https://disdukcapil.sukabumikota.go.id',
    );

    if (item != null && item.persyaratan.isNotEmpty) {
      for (var req in item.persyaratan) {
        _persyaratanControllers.add(TextEditingController(text: req));
      }
    } else {
      _persyaratanControllers.add(TextEditingController(text: 'Fotokopi Kartu Keluarga (KK) terbaru.'));
      _persyaratanControllers.add(TextEditingController(text: 'Fotokopi KTP Pemohon.'));
    }
  }

  @override
  void dispose() {
    _judulLayananController.dispose();
    _rawTitleController.dispose();
    _subjudulController.dispose();
    _deskripsiController.dispose();
    _urlPortalController.dispose();
    for (var c in _persyaratanControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _tambahPersyaratanRow() {
    setState(() {
      _persyaratanControllers.add(TextEditingController());
    });
  }

  void _hapusPersyaratanRow(int index) {
    if (_persyaratanControllers.length > 1) {
      setState(() {
        _persyaratanControllers[index].dispose();
        _persyaratanControllers.removeAt(index);
      });
    }
  }

  void _simpanLayanan() {
    if (_formKey.currentState!.validate()) {
      final reqList = _persyaratanControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final newModel = LayananModel(
        id: isEdit ? widget.layanan!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        kodeInstansi: _selectedKodeInstansi,
        sektor: _selectedSektor,
        judulLayanan: _judulLayananController.text.trim(),
        rawTitle: _rawTitleController.text.trim().isNotEmpty
            ? _rawTitleController.text.trim()
            : _judulLayananController.text.trim(),
        subjudul: _subjudulController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        persyaratan: reqList,
        urlPortal: _urlPortalController.text.trim(),
        iconName: 'description_outlined',
      );

      if (isEdit) {
        _opdService.updateLayanan(newModel);
      } else {
        _opdService.addLayanan(newModel);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Layanan "${newModel.rawTitle}" berhasil diperbarui!'
                : 'Layanan baru "${newModel.rawTitle}" berhasil ditambahkan!',
          ),
          backgroundColor: const Color(0xFF123457),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    final allInstansi = _opdService.getInstansiList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Layanan Publik' : 'Tambah Layanan Publik Baru',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Pengelompokan Instansi & Sektor'),
              const SizedBox(height: 12),

              // DROPDOWN INSTANSI
              const Text(
                'Instansi OPD Pengelola',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedKodeInstansi,
                    isExpanded: true,
                    style: const TextStyle(fontSize: 13, color: primaryColor, fontFamily: 'Poppins'),
                    items: allInstansi.map((opd) {
                      return DropdownMenuItem(
                        value: opd.kodeInstansi,
                        child: Text('${opd.namaSingkat} - ${opd.namaLengkap}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedKodeInstansi = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // DROPDOWN SEKTOR FASE KEHIDUPAN
              const Text(
                'Sektor Kategori Layanan',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSektor,
                    isExpanded: true,
                    style: const TextStyle(fontSize: 13, color: primaryColor, fontFamily: 'Poppins'),
                    items: _sektorOptions.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text('Sektor $s'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSektor = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildSectionHeader('Detail Layanan'),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _judulLayananController,
                label: 'Judul Lengkap Layanan',
                hint: 'Contoh: Pelayanan KTP Elektronik (KTP-el)',
                validator: (val) => (val == null || val.isEmpty) ? 'Judul layanan wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _rawTitleController,
                label: 'Nama Ringkas / Singkatan Layanan',
                hint: 'Contoh: KTP Elektronik',
                validator: (val) => (val == null || val.isEmpty) ? 'Nama ringkas wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _subjudulController,
                label: 'Subjudul / Ringkasan Singkat',
                hint: 'Contoh: Perekaman baru, penggantian KTP rusak/hilang...',
                maxLines: 2,
                validator: (val) => (val == null || val.isEmpty) ? 'Subjudul wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _deskripsiController,
                label: 'Deskripsi Lengkap Layanan Publik',
                hint: 'Jelaskan cakupan layanan, sasaran warga, dan manfaat...',
                maxLines: 3,
                validator: (val) => (val == null || val.isEmpty) ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _urlPortalController,
                label: 'Link Web Portal Resmi / Pengajuan Online',
                hint: 'https://disdukcapil.sukabumikota.go.id',
                validator: (val) => (val == null || val.isEmpty) ? 'Link portal wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // SEKSI SYARAT & DOKUMEN DINAMIS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Persyaratan & Dokumen Syarat',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _tambahPersyaratanRow,
                    icon: const Icon(Icons.add_circle_outline_rounded, color: primaryColor, size: 18),
                    label: const Text(
                      'Tambah Syarat',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 4),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _persyaratanControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _persyaratanControllers[index],
                            style: const TextStyle(fontSize: 12.5, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              hintText: 'Contoh: Fotokopi Kartu Keluarga terbaru',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins'),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                        ),
                        if (_persyaratanControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline_rounded, color: Colors.redAccent, size: 22),
                            onPressed: () => _hapusPersyaratanRow(index),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _simpanLayanan,
                  icon: const Icon(Icons.save_rounded, color: primaryColor),
                  label: Text(
                    isEdit ? 'Simpan Perubahan Layanan' : 'Tambah Layanan Publik Baru',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: primaryColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF123457),
            fontFamily: 'Poppins',
          ),
        ),
        const Divider(height: 8),
      ],
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
            fontWeight: FontWeight.w600,
            color: Color(0xFF123457),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins'),
            filled: true,
            fillColor: Colors.white,
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
              borderSide: const BorderSide(color: Color(0xFF123457), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
