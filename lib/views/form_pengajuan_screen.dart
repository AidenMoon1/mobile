import 'package:flutter/material.dart';
import '../models/custom_field_config.dart';
import '../models/layanan_model.dart';
import 'activity_log_screen.dart';

class FormPengajuanScreen extends StatefulWidget {
  final String judulLayanan;
  final String deskripsi;
  final IconData icon;
  final LayananModel? layananModel;

  const FormPengajuanScreen({
    super.key,
    required this.judulLayanan,
    required this.deskripsi,
    required this.icon,
    this.layananModel,
  });

  @override
  State<FormPengajuanScreen> createState() => _FormPengajuanScreenState();
}

class _FormPengajuanScreenState extends State<FormPengajuanScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _fieldControllers = {};
  final Map<String, String> _dropdownValues = {};
  final Map<String, DateTime> _dateValues = {};

  String? _selectedFileName;
  String? _selectedFileExtension;
  bool _fileTerunggah = false;
  bool _isSubmitting = false;

  final List<String> _allowedExtensions = const ['jpg', 'png', 'jpeg'];

  List<CustomFieldConfig> get _effectiveFields {
    if (widget.layananModel != null && widget.layananModel!.formFields.isNotEmpty) {
      return widget.layananModel!.formFields;
    }
    // Fallback default form fields jika tidak ada model kustom
    return [
      CustomFieldConfig(id: '1', label: 'NIK Pemohon (16 Digit)', type: FieldType.number, hint: 'Masukkan 16 angka NIK'),
      CustomFieldConfig(id: '2', label: 'Nama Lengkap', type: FieldType.shortText, hint: 'Sesuai KTP / Akta'),
      CustomFieldConfig(id: '3', label: 'Nomor Kartu Keluarga (KK)', type: FieldType.number, hint: 'Masukkan 16 angka No. KK'),
      CustomFieldConfig(id: '4', label: 'Nomor WhatsApp / HP', type: FieldType.number, hint: 'Contoh: 081234567890'),
      CustomFieldConfig(id: '5', label: 'Keterangan / Alasan Permohonan', type: FieldType.longText, hint: 'Jelaskan keperluan permohonan Anda...'),
      CustomFieldConfig(id: '6', label: 'Unggah Dokumen Syarat (JPG, PNG, JPEG)', type: FieldType.fileUpload),
    ];
  }

  @override
  void initState() {
    super.initState();
    for (var f in _effectiveFields) {
      if (f.type != FieldType.fileUpload && f.type != FieldType.dropdown && f.type != FieldType.datePicker) {
        _fieldControllers[f.id] = TextEditingController();
      }
      if (f.type == FieldType.dropdown && f.options.isNotEmpty) {
        _dropdownValues[f.id] = f.options.first;
      }
    }
  }

  @override
  void dispose() {
    for (var c in _fieldControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _bukaModalPilihDokumen() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih File Dokumen Syarat',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123457),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8A33D).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE8A33D)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Color(0xFF123457), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Format yang didukung: JPG, PNG, JPEG (Maks. 2MB)',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF123457),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildFileOptionTile(
                fileName: 'dokumen_persyaratan.jpg',
                fileExtension: 'jpg',
                icon: Icons.image_rounded,
                isSupported: true,
              ),
              _buildFileOptionTile(
                fileName: 'scan_ktp_kk.png',
                fileExtension: 'png',
                icon: Icons.image_outlined,
                isSupported: true,
              ),
              _buildFileOptionTile(
                fileName: 'lampiran_berkas.jpeg',
                fileExtension: 'jpeg',
                icon: Icons.photo_library_rounded,
                isSupported: true,
              ),
              _buildFileOptionTile(
                fileName: 'berkas_pengajuan.pdf',
                fileExtension: 'pdf',
                icon: Icons.picture_as_pdf_rounded,
                isSupported: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFileOptionTile({
    required String fileName,
    required String fileExtension,
    required IconData icon,
    required bool isSupported,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSupported ? const Color(0xFF123457).withOpacity(0.1) : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isSupported ? const Color(0xFF123457) : Colors.red),
      ),
      title: Text(
        fileName,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      subtitle: Text(
        isSupported ? 'Format .${fileExtension.toUpperCase()} (Didukung)' : 'Format .${fileExtension.toUpperCase()} (Tidak Didukung)',
        style: TextStyle(
          fontSize: 11,
          color: isSupported ? Colors.green.shade700 : Colors.red,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: isSupported
          ? const Icon(Icons.check_circle_outline_rounded, color: Colors.green)
          : const Icon(Icons.cancel_outlined, color: Colors.red),
      onTap: () {
        Navigator.pop(context);
        _prosesPilihanFile(fileName, fileExtension);
      },
    );
  }

  void _prosesPilihanFile(String fileName, String extension) {
    final extLower = extension.toLowerCase();
    if (!_allowedExtensions.contains(extLower)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Format file .$extension tidak didukung! Hanya file JPG, PNG, dan JPEG yang dapat diunggah.',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12.5),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _selectedFileName = fileName;
      _selectedFileExtension = extLower;
      _fileTerunggah = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Dokumen "$fileName" (Format .${extLower.toUpperCase()}) berhasil diunggah!',
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: const Color(0xFF123457),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _hapusDokumen() {
    setState(() {
      _selectedFileName = null;
      _selectedFileExtension = null;
      _fileTerunggah = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unggahan dokumen dibatalkan.', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pilihTanggal(BuildContext context, String fieldId) async {
    final DateTime initial = _dateValues[fieldId] ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateValues[fieldId] = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bool hasUploadField = _effectiveFields.any((f) => f.type == FieldType.fileUpload && f.isRequired);
      if (hasUploadField && (!_fileTerunggah || _selectedFileName == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap unggah dokumen persyaratan (JPG, PNG, atau JPEG) terlebih dahulu!'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isSubmitting = false;
        });

        final docText = _selectedFileName != null ? ' beserta dokumen ($_selectedFileName)' : '';

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Column(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 54),
                SizedBox(height: 10),
                Text(
                  'Pengajuan Berhasil!',
                  style: TextStyle(
                    color: Color(0xFF123457),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Permohonan "${widget.judulLayanan}" Anda$docText telah berhasil dikirim dan terdaftar di sistem terpadu.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF123457).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'No. Resi: RES-20260803-9912',
                    style: TextStyle(
                      color: Color(0xFF123457),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Tutup', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ActivityLogScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123457),
                  foregroundColor: const Color(0xFFE8A33D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Cek Riwayat', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      });
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
        title: const Text(
          'Formulir Permohonan',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER HERO FORUM
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: primaryColor,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: primaryColor, size: 36),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.judulLayanan,
                          style: const TextStyle(
                            color: accentColor,
                            fontSize: 16.5,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.deskripsi,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // FORM ISIAN DATA DINAMIS DARI MESIN FORM BUILDER ADMIN
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Pemohon Digital',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Lengkapi data isian di bawah ini sesuai petunjuk persyaratan resmi.',
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 16),

                    // RENDISI DINAMIS ELEMEN FIELD SESUAI TIPE
                    ..._effectiveFields.map((field) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: _buildDynamicFieldWidget(field),
                      );
                    }),

                    const SizedBox(height: 20),

                    // TOMBOL SUBMIT FORUM
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: accentColor)
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Kirim Permohonan Digital',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFieldWidget(CustomFieldConfig field) {
    const Color primaryColor = Color(0xFF123457);
    const Color accentColor = Color(0xFFE8A33D);

    switch (field.type) {
      // 1. TEKS PENDEK
      case FieldType.shortText:
        final ctrl = _fieldControllers[field.id] ?? TextEditingController();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel(field.label, field.isRequired),
            const SizedBox(height: 6),
            TextFormField(
              controller: ctrl,
              style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
              validator: (val) {
                if (field.isRequired && (val == null || val.isEmpty)) {
                  return '${field.label} wajib diisi';
                }
                return null;
              },
              decoration: _buildInputDecoration(
                hint: field.hint.isNotEmpty ? field.hint : 'Masukkan ${field.label}...',
                icon: Icons.edit_note_rounded,
              ),
            ),
          ],
        );

      // 2. TEKS PANJANG (PARAGRAF)
      case FieldType.longText:
        final ctrl = _fieldControllers[field.id] ?? TextEditingController();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel(field.label, field.isRequired),
            const SizedBox(height: 6),
            TextFormField(
              controller: ctrl,
              maxLines: 3,
              style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
              validator: (val) {
                if (field.isRequired && (val == null || val.isEmpty)) {
                  return '${field.label} wajib diisi';
                }
                return null;
              },
              decoration: _buildInputDecoration(
                hint: field.hint.isNotEmpty ? field.hint : 'Jelaskan ${field.label}...',
                icon: Icons.notes_rounded,
              ),
            ),
          ],
        );

      // 3. ANGKA / NOMOR
      case FieldType.number:
        final ctrl = _fieldControllers[field.id] ?? TextEditingController();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel(field.label, field.isRequired),
            const SizedBox(height: 6),
            TextFormField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
              validator: (val) {
                if (field.isRequired && (val == null || val.isEmpty)) {
                  return '${field.label} wajib diisi';
                }
                return null;
              },
              decoration: _buildInputDecoration(
                hint: field.hint.isNotEmpty ? field.hint : 'Masukkan angka ${field.label}...',
                icon: Icons.pin_outlined,
              ),
            ),
          ],
        );

      // 4. DROPDOWN (PILIHAN GANDA)
      case FieldType.dropdown:
        final String selectedVal = _dropdownValues[field.id] ?? (field.options.isNotEmpty ? field.options.first : '');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel(field.label, field.isRequired),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedVal.isNotEmpty ? selectedVal : null,
              style: const TextStyle(fontSize: 13, color: primaryColor, fontFamily: 'Poppins'),
              decoration: _buildInputDecoration(
                hint: 'Pilih ${field.label}...',
                icon: Icons.list_alt_rounded,
              ),
              items: field.options.map((opt) {
                return DropdownMenuItem(
                  value: opt,
                  child: Text(opt),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _dropdownValues[field.id] = val;
                  });
                }
              },
            ),
          ],
        );

      // 5. KALENDER (DATE PICKER)
      case FieldType.datePicker:
        final DateTime? dateVal = _dateValues[field.id];
        final String displayDate = dateVal != null
            ? '${dateVal.day.toString().padLeft(2, '0')}/${dateVal.month.toString().padLeft(2, '0')}/${dateVal.year}'
            : 'Klik untuk memilih tanggal kalender';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel(field.label, field.isRequired),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _pilihTanggal(context, field.id),
              child: InputDecorator(
                decoration: _buildInputDecoration(
                  hint: 'Pilih Tanggal',
                  icon: Icons.calendar_month_rounded,
                ),
                child: Text(
                  displayDate,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    color: dateVal != null ? primaryColor : Colors.grey,
                    fontWeight: dateVal != null ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        );

      // 6. UNGGAH DOKUMEN (FILE UPLOAD)
      case FieldType.fileUpload:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFieldLabel(field.label, field.isRequired),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'JPG, PNG, JPEG',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Hanya mendukung 3 format file gambar: .JPG, .PNG, .JPEG (Maks 2MB)',
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade600,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: _bukaModalPilihDokumen,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: _fileTerunggah ? const Color(0xFFE8F5E9) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _fileTerunggah ? Colors.green : primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _fileTerunggah ? Icons.check_circle_rounded : Icons.cloud_upload_rounded,
                      color: _fileTerunggah ? Colors.green : primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fileTerunggah ? (_selectedFileName ?? 'Dokumen Terunggah') : 'Pilih File Dokumen Syarat',
                            style: TextStyle(
                              color: _fileTerunggah ? Colors.green.shade900 : primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _fileTerunggah
                                ? 'Format .${_selectedFileExtension?.toUpperCase()} (Valid)'
                                : 'Klik untuk memilih file (.jpg, .png, .jpeg)',
                            style: TextStyle(
                              color: _fileTerunggah ? Colors.green.shade700 : Colors.grey,
                              fontSize: 11,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_fileTerunggah)
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        onPressed: _hapusDokumen,
                        tooltip: 'Hapus Dokumen',
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildFieldLabel(String label, bool isRequired) {
    const Color primaryColor = Color(0xFF123457);
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontFamily: 'Poppins',
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  InputDecoration _buildInputDecoration({required String hint, required IconData icon}) {
    const Color primaryColor = Color(0xFF123457);

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.5, fontFamily: 'Poppins'),
      prefixIcon: Icon(icon, color: primaryColor, size: 20),
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
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    );
  }
}
