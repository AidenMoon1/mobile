import 'package:flutter/material.dart';
import 'activity_log_screen.dart';

class FormPengajuanScreen extends StatefulWidget {
  final String judulLayanan;
  final String deskripsi;
  final IconData icon;

  const FormPengajuanScreen({
    super.key,
    required this.judulLayanan,
    required this.deskripsi,
    required this.icon,
  });

  @override
  State<FormPengajuanScreen> createState() => _FormPengajuanScreenState();
}

class _FormPengajuanScreenState extends State<FormPengajuanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noKkController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  bool _fileTerunggah = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _noKkController.dispose();
    _noHpController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  void _simulasiUploadDokumen() {
    setState(() {
      _fileTerunggah = !_fileTerunggah;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _fileTerunggah ? 'Dokumen persyaratan berhasil diunggah!' : 'Dokumen dibatalkan.',
        ),
        backgroundColor: _fileTerunggah ? const Color(0xFF123457) : Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_fileTerunggah) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap unggah dokumen persyaratan terlebih dahulu!'),
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

        // Dialog Berhasil Kirim Berkas
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
                  'Permohonan "${widget.judulLayanan}" Anda telah berhasil dikirim dan terdaftar di sistem terpadu.',
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
                    'No. Resi: RES-20260730-8912',
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
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Kembali dari form
                },
                child: const Text('Tutup', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
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

            // FORM ISIAN DATA
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Pemohon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pastikan data diri yang Anda masukkan sudah sesuai dengan data KTP/KK resmi.',
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 16),

                    // INPUT NIK
                    _buildTextField(
                      controller: _nikController,
                      label: 'NIK Pemohon (16 Digit)',
                      hint: 'Masukkan 16 angka NIK',
                      icon: Icons.badge_outlined,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'NIK wajib diisi';
                        if (val.length < 16) return 'NIK harus 16 digit';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // INPUT NAMA LENGKAP
                    _buildTextField(
                      controller: _namaController,
                      label: 'Nama Lengkap',
                      hint: 'Sesuai KTP / Akta',
                      icon: Icons.person_outline_rounded,
                      validator: (val) => (val == null || val.isEmpty) ? 'Nama lengkap wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),

                    // INPUT NO KK
                    _buildTextField(
                      controller: _noKkController,
                      label: 'Nomor Kartu Keluarga (KK)',
                      hint: 'Masukkan 16 angka No. KK',
                      icon: Icons.family_restroom_outlined,
                      keyboardType: TextInputType.number,
                      validator: (val) => (val == null || val.isEmpty) ? 'Nomor KK wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),

                    // INPUT NO HP / WA
                    _buildTextField(
                      controller: _noHpController,
                      label: 'Nomor WhatsApp / HP',
                      hint: 'Contoh: 081234567890',
                      icon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                      validator: (val) => (val == null || val.isEmpty) ? 'Nomor HP wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),

                    // INPUT ALASAN / KETERANGAN
                    _buildTextField(
                      controller: _keteranganController,
                      label: 'Keterangan / Alasan Permohonan',
                      hint: 'Jelaskan keperluan permohonan Anda...',
                      icon: Icons.notes_rounded,
                      maxLines: 3,
                      validator: (val) => (val == null || val.isEmpty) ? 'Keterangan wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),

                    // SEKSI UPLOAD DOKUMEN
                    const Text(
                      'Unggah Dokumen Syarat (PDF/JPG)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: _simulasiUploadDokumen,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _fileTerunggah ? const Color(0xFFE8F5E9) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _fileTerunggah ? Colors.green : primaryColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _fileTerunggah ? Icons.check_circle_rounded : Icons.cloud_upload_rounded,
                              color: _fileTerunggah ? Colors.green : primaryColor,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _fileTerunggah ? 'Dokumen Persyaratan Terunggah' : 'Pilih File Dokumen Syarat (Max 2MB)',
                              style: TextStyle(
                                color: _fileTerunggah ? Colors.green.shade800 : primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF123457),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.5, fontFamily: 'Poppins'),
            prefixIcon: Icon(icon, color: const Color(0xFF123457), size: 20),
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
