import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/models/notification_model.dart';
import 'package:mobile/views/admin/admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(text: 'admin.oneaccess@gmail.com');
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _kirimOtpAdmin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    final email = _emailController.text.trim();
    final random = Random();
    final generatedOtp = (100000 + random.nextInt(900000)).toString(); // Dynamic 6-digit OTP

    await NotificationService().addNotification(
      title: '📩 Gmail OTP Received ($email)',
      description: 'Kode verifikasi keamanan 2FA Admin Anda adalah: $generatedOtp',
      category: NotificationCategory.general,
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminOtpScreen(
          adminEmail: email,
          expectedOtp: generatedOtp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A1E33);
    const accentColor = Color(0xFFE8A33D);

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
          'Portal Login Admin Instansi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            // HEADER HERO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0x1F76A9EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Color(0xFFE8A33D),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Autentikasi 2-Langkah',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Masukkan akun Gmail terdaftar. Kode OTP verifikasi akan dikirimkan ke Gmail One Access.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                            fontFamily: 'Poppins',
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // FORM LOGIN ADMIN GMAIL
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Gmail Admin',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        hintText: 'admin.oneaccess@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12.5, fontFamily: 'Poppins'),
                        prefixIcon: const Icon(Icons.mark_email_read_outlined, color: primaryColor),
                        fillColor: const Color(0xFFF8FAFC),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Email Gmail Admin wajib diisi';
                        }
                        if (!val.contains('@')) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Kata Sandi (Password)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        hintText: 'Masukkan kata sandi admin...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12.5, fontFamily: 'Poppins'),
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: primaryColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        fillColor: const Color(0xFFF8FAFC),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Kata sandi wajib diisi';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // SUBMIT BUTTON -> ROUTE TO OTP SCREEN
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _kirimOtpAdmin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded, size: 18, color: accentColor),
                                  SizedBox(width: 8),
                                  Text(
                                    'Lanjutkan & Kirim Kode OTP Gmail',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LINK REGISTRASI AKUN ADMIN BARU (SUPERADMIN & ADMIN OPD)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum memiliki Akun Admin? ',
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
                        ),
                        GestureDetector(
                          onTap: _bukaModalDaftarAdmin,
                          child: const Text(
                            'Buat Akun Admin Baru',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontFamily: 'Poppins',
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MODAL REGISTRASI / BUAT AKUN ADMIN BARU (SUPERADMIN / ADMIN OPD)
  // ---------------------------------------------------------------------------
  void _bukaModalDaftarAdmin() {
    final regEmailController = TextEditingController();
    final regPasswordController = TextEditingController();
    final regNameController = TextEditingController();
    String selectedRole = 'Superadmin / Pengelola Utama Terpadu';
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              top: 24,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF0A1E33), size: 26),
                      SizedBox(width: 10),
                      Text(
                        'Registrasi Akun Admin Baru',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A1E33),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Daftarkan email Gmail Anda sebagai Superadmin atau Admin Perwakilan OPD',
                    style: TextStyle(fontSize: 11.5, color: Colors.grey, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 18),

                  TextFormField(
                    controller: regNameController,
                    style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap & Jabatan Admin',
                      hintText: 'Contoh: Muhammad Dzakwan (Superadmin)',
                      prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF0A1E33)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: regEmailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: 'Email Gmail Admin',
                      hintText: 'Contoh: dzakwan@gmail.com',
                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF0A1E33)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Peran / Hak Akses Admin',
                      prefixIcon: const Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF0A1E33)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Superadmin / Pengelola Utama Terpadu',
                        child: Text('Superadmin (Akses Penuh)', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                      ),
                      DropdownMenuItem(
                        value: 'Admin OPD / Perwakilan Dinas',
                        child: Text('Admin OPD (Disdukcapil / RSUD)', style: TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedRole = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: regPasswordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      labelText: 'Buat Kata Sandi (Password Admin)',
                      hintText: 'Masukkan kata sandi baru...',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF0A1E33)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              final email = regEmailController.text.trim();
                              final password = regPasswordController.text.trim();
                              final name = regNameController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('⚠️ Email dan Password Admin wajib diisi!'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              setModalState(() => isSubmitting = true);
                              await Future.delayed(const Duration(milliseconds: 800));

                              if (!context.mounted) return;

                              setState(() {
                                _emailController.text = email;
                                _passwordController.text = password;
                              });

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('✅ Akun Admin ($name) Berhasil Didaftarkan!\nEmail: $email terpasang di form login.'),
                                  backgroundColor: const Color(0xFF0A1E33),
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                            },
                      icon: isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.check_circle_rounded, size: 20),
                      label: Text(
                        isSubmitting ? 'Mendaftarkan Akun...' : 'Simpan & Aktifkan Akun Admin',
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A1E33),
                        foregroundColor: const Color(0xFFE8A33D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// LAYAR VERIFIKASI OTP GMAIL ADMIN
// -----------------------------------------------------------------------------
class AdminOtpScreen extends StatefulWidget {
  final String adminEmail;
  final String expectedOtp;

  const AdminOtpScreen({
    super.key,
    required this.adminEmail,
    required this.expectedOtp,
  });

  @override
  State<AdminOtpScreen> createState() => _AdminOtpScreenState();
}

class _AdminOtpScreenState extends State<AdminOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  late String _currentOtp;

  @override
  void initState() {
    super.initState();
    _currentOtp = widget.expectedOtp;
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getEnteredOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  void _verifikasiOtp() async {
    final entered = _getEnteredOtp();
    if (entered.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan 6 digit kode OTP secara lengkap!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() => _isVerifying = false);

    if (entered == _currentOtp) {
      await NotificationService().addNotification(
        title: '🔐 Verifikasi OTP Gmail Berhasil',
        description: 'Administrator terverifikasi dari Gmail ${widget.adminEmail}.',
        category: NotificationCategory.general,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Terverifikasi! Masuk ke Dashboard Admin...'),
          backgroundColor: Color(0xFF0A1E33),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode OTP salah! Kode yang tepat adalah $_currentOtp'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _kirimUlangOtp() async {
    final random = Random();
    final newOtp = (100000 + random.nextInt(900000)).toString();

    setState(() {
      _currentOtp = newOtp;
    });

    await NotificationService().addNotification(
      title: '📩 Kode OTP Gmail Baru',
      description: 'Kode OTP keamanan 2FA Admin baru Anda adalah: $newOtp',
      category: NotificationCategory.general,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode OTP baru ($newOtp) dikirim ke ${widget.adminEmail}'),
        backgroundColor: const Color(0xFF0A1E33),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A1E33);
    const accentColor = Color(0xFFE8A33D);

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
          'Verifikasi Kode OTP Gmail',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            // SIMULATED GMAIL NOTIFICATION BANNER
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF4285F4).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mark_email_read_rounded, color: Color(0xFF4285F4), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📩 Gmail One Access (Simulasi)',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A1E33),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kode OTP Anda adalah: $_currentOtp',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4285F4),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // OTP FORM CONTAINER
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: primaryColor,
                    size: 48,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Masukkan 6-Digit Kode OTP',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kode OTP telah dikirimkan ke akun Gmail:\n${widget.adminEmail}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 6-DIGIT PIN INPUT FIELDS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 44,
                        height: 52,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontFamily: 'Poppins',
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            fillColor: const Color(0xFFF8FAFC),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: primaryColor, width: 2),
                            ),
                          ),
                          onChanged: (val) {
                            if (val.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (val.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            if (_getEnteredOtp().length == 6) {
                              _verifikasiOtp();
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 28),

                  // SUBMIT VERIFY BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isVerifying ? null : _verifikasiOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isVerifying
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.verified_user_rounded, size: 20, color: accentColor),
                                SizedBox(width: 8),
                                Text(
                                  'Verifikasi & Masuk Dashboard',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // RESEND OTP BUTTON
                  TextButton.icon(
                    onPressed: _kirimUlangOtp,
                    icon: const Icon(Icons.refresh_rounded, size: 16, color: primaryColor),
                    label: const Text(
                      'Kirim Ulang Kode OTP ke Gmail',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
