import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ServiceFormScreen extends StatefulWidget {
  final String serviceName;
  final String endpoint;
  final String serviceType;

  const ServiceFormScreen({
    super.key,
    required this.serviceName,
    required this.endpoint,
    required this.serviceType,
  });

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Form Fields Controllers
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _kkController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _alamatController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();

  // Alamat Defaults
  final String _provinsi = "Jawa Barat";
  final String _kota = "Kota Sukabumi";
  String _kecamatan = "Cikole";
  String _kelurahan = "Cikole";

  // Mock Upload State (untuk simulasi file)
  String? _file1Path = "berkas_kehilangan_mock.png";
  String? _file2Path = "kartu_keluarga_mock.png";

  final List<String> _kecamatanList = ["Cikole", "Citamiang", "Warudoyong", "Baros", "Gunungpuyuh", "Lembursitu", "Cibeureum"];
  final List<String> _kelurahanList = ["Cikole", "Subangjaya", "Gedongpanjang", "Tipar", "Sriwidari", "Benteng"];

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _kkController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _keteranganController.dispose();
    _alamatController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Buat data teks fields
    final Map<String, String> fields = {
      'nama': _namaController.text,
      'nik': _nikController.text,
      'no_kk': _kkController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'keterangan': _keteranganController.text,
      'provinsi': _provinsi,
      'kota': _kota,
      'kecamatan': _kecamatan,
      'kelurahan': _kelurahan,
      'alamat_lengkap': _alamatController.text,
      'rt': _rtController.text,
      'rw': _rwController.text,
    };

    // Buat data files
    final fileKey1 = widget.serviceType == 'hilang' ? 'file_kehilangan' : 'file_rusak';
    final Map<String, String> files = {
      fileKey1: _file1Path ?? '',
      'file_kk': _file2Path ?? '',
    };

    try {
      final response = await ApiService.postMultipart(widget.endpoint, fields, files);

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        _showSuccessDialog(resData['message'] ?? 'Permohonan berhasil dikirim!');
      } else {
        final resData = jsonDecode(response.body);
        _showErrorSnackBar(resData['message'] ?? 'Terjadi kesalahan pada server. Gagal mengirim permohonan.');
      }
    } catch (e) {
      _showErrorSnackBar('Gagal terhubung ke server Laravel: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Kirim Sukses'),
          ],
        ),
        content: Text(
          '$message\n\nData permohonan Anda kini telah tercatat secara riil di database MySQL server Laravel Anda.',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pop(context); // Kembali ke list layanan
            },
            child: const Text('OK', style: TextStyle(color: Color(0xFFE8A33D), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelFile1 = widget.serviceType == 'hilang' 
        ? 'Upload Surat Kehilangan (POLRES)' 
        : 'Upload Foto KTP Rusak';

    return Scaffold(
      appBar: AppBar(
        title: Text('Form ${widget.serviceName}'),
      ),
      body: _isSubmitting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Sedang mengirim formulir ke database MySQL...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Data Diri
                    _buildSectionHeader('Data Pemohon'),
                    const SizedBox(height: 10),
                    _buildTextField(_namaController, 'Nama Lengkap', Icons.person, (val) => val!.isEmpty ? 'Nama wajib diisi' : null),
                    _buildTextField(_nikController, 'NIK (16 Digit)', Icons.credit_card, (val) => val!.length != 16 ? 'NIK harus 16 digit' : null, keyboardType: TextInputType.number),
                    _buildTextField(_kkController, 'Nomor KK (16 Digit)', Icons.family_restroom, (val) => val!.length != 16 ? 'KK harus 16 digit' : null, keyboardType: TextInputType.number),
                    _buildTextField(_emailController, 'Email', Icons.email, (val) => !val!.contains('@') ? 'Email tidak valid' : null, keyboardType: TextInputType.emailAddress),
                    _buildTextField(_phoneController, 'Nomor HP', Icons.phone, (val) => val!.isEmpty ? 'Nomor HP wajib diisi' : null, keyboardType: TextInputType.phone),
                    _buildTextField(_keteranganController, 'Keterangan Tambahan (Opsional)', Icons.description, null, maxLines: 2),

                    const SizedBox(height: 20),

                    // Section 2: Alamat
                    _buildSectionHeader('Alamat Pemohon'),
                    const SizedBox(height: 10),
                    _buildReadOnlyField('Provinsi', _provinsi),
                    _buildReadOnlyField('Kota/Kabupaten', _kota),
                    
                    // Dropdowns Kecamatan & Kelurahan
                    _buildDropdown('Kecamatan', _kecamatan, _kecamatanList, (val) => setState(() => _kecamatan = val!)),
                    _buildDropdown('Kelurahan/Desa', _kelurahan, _kelurahanList, (val) => setState(() => _kelurahan = val!)),

                    _buildTextField(_alamatController, 'Alamat Lengkap (RT/RW dimasukkan di kolom bawah)', Icons.home_work, (val) => val!.isEmpty ? 'Alamat wajib diisi' : null, maxLines: 2),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_rtController, 'RT', Icons.tag, (val) => val!.isEmpty ? 'RT wajib' : null, keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(_rwController, 'RW', Icons.tag, (val) => val!.isEmpty ? 'RW wajib' : null, keyboardType: TextInputType.number)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Section 3: Berkas
                    _buildSectionHeader('Unggah Berkas (Simulasi)'),
                    const SizedBox(height: 10),
                    _buildFilePicker(labelFile1, _file1Path, (name) => setState(() => _file1Path = name)),
                    _buildFilePicker('Upload Kartu Keluarga (KK)', _file2Path, (name) => setState(() => _file2Path = name)),

                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8A33D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _submitForm,
                        child: const Text(
                          'KIRIM PENGAJUAN',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A1E33),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 50,
          height: 3,
          color: const Color(0xFFE8A33D),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String? Function(String?)? validator, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF123457)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String currentValue,
    List<String> items,
    void Function(String?)? onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        onChanged: onChanged,
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.map, color: Color(0xFF123457)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    );
  }

  Widget _buildFilePicker(String label, String? currentPath, Function(String) onPicked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  currentPath ?? 'Belum ada berkas dipilih',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: currentPath != null ? Colors.green.shade700 : Colors.black87,
                    fontWeight: currentPath != null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A1E33),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {
              // Simulasi pick file
              onPicked('dokumen_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.jpg');
            },
            icon: const Icon(Icons.upload_file, size: 16),
            label: const Text('Pilih', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
