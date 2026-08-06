import 'package:flutter/material.dart';
import 'package:mobile/services/user_service.dart';
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/models/notification_model.dart';
import 'package:mobile/main.dart';
import 'package:mobile/views/admin/admin_dashboard_screen.dart';
import 'package:mobile/views/profile/otp_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isAdminMode = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _prosesLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final username = _usernameController.text.trim();

    setState(() {
      _isLoading = false;
    });

    if (_isAdminMode) {
      // PROSES LOGIN ADMIN INSTANSI
      await NotificationService().addNotification(
        title: '🔐 Login Admin Berhasil',
        description: 'Selamat datang kembali Administrator $username pada Portal Sukabumi One Access.',
        category: NotificationCategory.general,
      );

      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else {
      // PROSES LOGIN WARGA KOTA
      final current = UserService().currentUser;
      await UserService().updateProfile(
        current.copyWith(
          name: username.isNotEmpty ? username : current.name,
          username: username.isNotEmpty ? username : current.username,
        ),
      );

      await NotificationService().addNotification(
        title: '👋 Selamat Datang Kembali',
        description: 'Anda berhasil masuk ke akun Warga Sukabumi One Access.',
        category: NotificationCategory.general,
      );

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Berhasil masuk ke Beranda Warga!'),
          backgroundColor: Color(0xFF0A1E33),
        ),
      );

      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // 1. MODAL OTENTIKASI IKD SINGLE SIGN-ON (DUKCAPIL KEMENDAGRI)
  // ---------------------------------------------------------------------------
  void _bukaModalIKDSSO() {
    final TextEditingController nikController = TextEditingController(text: '3272012508980002');
    bool isAuthenticating = false;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF3FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF123457), size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IKD Single Sign-On (SSO)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A1E33),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Identitas Kependudukan Digital Ditjen Dukcapil',
                            style: TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Masukkan NIK terdaftar atau gunakan pemindaian QR dari aplikasi IKD HP Anda untuk masuk instan:',
                  style: TextStyle(fontSize: 12, color: Colors.black87, fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: nikController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    labelText: 'NIK KTP Digital',
                    hintText: '16 digit NIK...',
                    prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF123457)),
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
                    onPressed: isAuthenticating
                        ? null
                        : () async {
                            setModalState(() => isAuthenticating = true);
                            await Future.delayed(const Duration(milliseconds: 1200));

                            final nik = nikController.text.trim();
                            final current = UserService().currentUser;

                            await UserService().updateProfile(
                              current.copyWith(
                                username: nik.isNotEmpty ? nik : '3272012508980002',
                                name: 'Warga Sukabumi (IKD Verified)',
                                status: 'Terverifikasi (IKD Kemendagri)',
                              ),
                            );

                            await NotificationService().addNotification(
                              title: '🪪 Login IKD SSO Sukses',
                              description: 'Identitas Kependudukan Digital (NIK $nik) berhasil diverifikasi.',
                              category: NotificationCategory.general,
                            );

                            if (!context.mounted) return;
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login IKD SSO Berhasil! NIK Terverifikasi Dukcapil.'),
                                backgroundColor: Color(0xFF123457),
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                            );
                          },
                    icon: isAuthenticating
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.verified_user_rounded, size: 20),
                    label: Text(
                      isAuthenticating ? 'Menverifikasi IKD...' : 'Otentikasi & Masuk IKD',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A1E33),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A1E33);
    const accentColor = Color(0xFFE8A33D);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER HERO CONTAINER WITH BRANDING
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x29000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 46,
                        height: 46,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.account_balance_rounded,
                          color: primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sukabumi One Access',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Portal Terpadu Layanan Publik Kota Sukabumi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // FORM CONTAINER CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
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
                      // TOGGLE WARGA / ADMIN MODE
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _isAdminMode = false),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: !_isAdminMode ? primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Warga Kota',
                                      style: TextStyle(
                                        color: !_isAdminMode ? Colors.white : Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _isAdminMode = true),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _isAdminMode ? primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Admin Portal',
                                      style: TextStyle(
                                        color: _isAdminMode ? Colors.white : Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // INPUT USERNAME
                      Text(
                        _isAdminMode ? 'Username Administrator' : 'Nama Lengkap / NIK Warga',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                          hintText: _isAdminMode ? 'Masukkan username admin...' : 'Masukkan nama/NIK Anda...',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12.5, fontFamily: 'Poppins'),
                          prefixIcon: const Icon(Icons.person_outline_rounded, color: primaryColor),
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
                            return _isAdminMode ? 'Username admin wajib diisi' : 'Nama/NIK Warga wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // INPUT PASSWORD
                      const Text(
                        'Kata Sandi',
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
                          hintText: 'Masukkan kata sandi...',
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

                      // SUBMIT BUTTON (LOGIN MANUAL)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _prosesLogin,
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
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(_isAdminMode ? Icons.admin_panel_settings_rounded : Icons.login_rounded, size: 20, color: accentColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isAdminMode ? 'Masuk Portal Admin' : 'Masuk Akun Warga',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      if (!_isAdminMode) ...[
                        const SizedBox(height: 24),

                        // DIVIDER SOCIAL LOGIN
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('ATAU MASUK DENGAN', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 1. TOMBOL LOGIN IKD (IDENTITAS KEPENDUDUKAN DIGITAL - SINGLE SIGN-ON)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _bukaModalIKDSSO,
                            icon: const Icon(Icons.qr_code_scanner_rounded, color: primaryColor, size: 20),
                            label: const Text(
                              'Masuk dengan IKD Single Sign-On',
                              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins'),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: primaryColor, width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),



                        // 3. TOMBOL LOGIN WHATSAPP OTP
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const OtpLoginScreen()),
                              );
                            },
                            icon: const Icon(Icons.chat_rounded, size: 20),
                            label: const Text(
                              'Masuk dengan WhatsApp',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // TOMBOL JELAJAH TAMU / TANPA LOGIN
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: primaryColor),
                            label: const Text(
                              'Jelajah Layanan Tanpa Login (Tamu)',
                              style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
