import 'package:flutter/material.dart';
import 'package:mobile/models/instansi_model.dart';
import 'package:mobile/services/opd_service.dart';
import 'package:mobile/widgets/admin_image_picker.dart';

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
      text: item?.jamOperasional ?? 'Senin - Jumat | 08.00 - 15.30 WIB',
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

      final newModel = InstansiModel(
        id: isEdit ? widget.instansi!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        kodeInstansi: _kodeController.text.trim().toLowerCase(),
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
          backgroundColor: const Color(0xFF123457),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

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
          isEdit ? 'Edit Instansi OPD' : 'Tambah Instansi OPD Baru',
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
              _buildSectionHeader('Identitas Instansi'),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _kodeController,
                label: 'Kode Instansi (Unik, e.g. disdukcapil, disnaker)',
                hint: 'Contoh: disdukcapil',
                validator: (val) => (val == null || val.isEmpty) ? 'Kode instansi wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _namaSingkatController,
                label: 'Nama Singkat (Akronim)',
                hint: 'Contoh: DISDUKCAPIL',
                validator: (val) => (val == null || val.isEmpty) ? 'Nama singkat wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _namaLengkapController,
                label: 'Nama Lengkap Instansi / Dinas',
                hint: 'Contoh: Dinas Kependudukan dan Pencatatan Sipil',
                validator: (val) => (val == null || val.isEmpty) ? 'Nama lengkap wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              _buildSectionHeader('Kontak & Operasional'),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _alamatController,
                label: 'Alamat Kantor',
                hint: 'Jl. Bhayangkara No. 202, Kota Sukabumi',
                maxLines: 2,
                validator: (val) => (val == null || val.isEmpty) ? 'Alamat wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _jamOperasionalController,
                label: 'Jam Operasional Pelayanan',
                hint: 'Senin - Jumat | 08.00 - 15.30 WIB',
                validator: (val) => (val == null || val.isEmpty) ? 'Jam operasional wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _kontakController,
                label: 'Kontak / WhatsApp / Email Resmi',
                hint: '(0266) 221122 / WA: 081122334455',
                validator: (val) => (val == null || val.isEmpty) ? 'Kontak wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              AdminImagePicker(
                label: 'Logo / Foto Instansi OPD',
                currentImagePath: _logoPathController.text,
                onImageSelected: (path) {
                  setState(() {
                    _logoPathController.text = path;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildSectionHeader('Deskripsi & Tugas Fungsi'),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _deskripsiController,
                label: 'Deskripsi Singkat Profil Instansi',
                hint: 'Jelaskan tugas utama instansi dalam mengayomi publik...',
                maxLines: 3,
                validator: (val) => (val == null || val.isEmpty) ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _tugasFungsiController,
                label: 'Tugas Utama & Fungsi (Pisahkan Tiap Poin Dengan Baris Baru / Enter)',
                hint: 'Poin 1: Penerbitan dokumen kependudukan\nPoin 2: Pencatatan perkawinan warga',
                maxLines: 4,
                validator: (val) => (val == null || val.isEmpty) ? 'Tugas & fungsi wajib diisi' : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _simpanInstansi,
                  icon: const Icon(Icons.save_rounded, color: primaryColor),
                  label: Text(
                    isEdit ? 'Simpan Perubahan Instansi' : 'Tambah Instansi Baru',
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
