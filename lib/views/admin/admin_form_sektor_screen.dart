import 'package:flutter/material.dart';
import '../../models/sektor_model.dart';
import '../../services/opd_service.dart';

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
          isEdit ? 'Edit Sektor Kategori' : 'Tambah Sektor Kategori Baru',
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
              _buildSectionHeader('Informasi Sektor Kategori'),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _titleController,
                label: 'Nama / Judul Sektor',
                hint: 'Contoh: Pariwisata & Kebudayaan',
                validator: (val) => (val == null || val.isEmpty) ? 'Judul sektor wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _descController,
                label: 'Deskripsi Singkat Sektor',
                hint: 'Contoh: Wisata Kota, Sanggar Seni, Kebudayaan Daerah...',
                maxLines: 2,
                validator: (val) => (val == null || val.isEmpty) ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildInputField(
                controller: _imagePathController,
                label: 'Jalur File Gambar Ikon Aset (.png)',
                hint: 'assets/icon/keluarga.png',
                validator: (val) => (val == null || val.isEmpty) ? 'Path gambar wajib diisi' : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _simpanSektor,
                  icon: const Icon(Icons.save_rounded, color: primaryColor),
                  label: Text(
                    isEdit ? 'Simpan Perubahan Sektor' : 'Tambah Sektor Baru',
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
