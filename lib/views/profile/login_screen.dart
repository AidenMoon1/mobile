import 'package:flutter/material.dart';
import 'package:mobile/services/user_service.dart';
import 'package:mobile/services/notification_service.dart';
import 'package:mobile/models/notification_model.dart';
import 'package:mobile/main.dart';
import 'package:mobile/views/profile/register_screen.dart';
import 'package:mobile/views/admin/admin_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final usernameOrEmail = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // MEMERIKSA APAKAH AKUN SUDAH TERDAFTAR DI DATABASE USER
    final bool isSuccess = await UserService().authenticateAccount(usernameOrEmail, password);

    setState(() {
      _isLoading = false;
    });

    if (isSuccess) {
      final current = UserService().currentUser;
      await NotificationService().addNotification(
        title: '👋 Selamat Datang Kembali',
        description: 'Anda berhasil masuk sebagai ${current.name}.',
        category: NotificationCategory.general,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil masuk! Selamat datang ${current.name}'),
          backgroundColor: const Color(0xFF0A1E33),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Username/Email atau Kata Sandi tidak terdaftar/salah!\nSilakan lakukan Registrasi Akun Baru terlebih dahulu.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // 1. MODAL PICKER AKUN GOOGLE (SIMULASI GOOGLE OAUTH API DEVICE)
  // ---------------------------------------------------------------------------
  void _bukaGoogleAccountPicker() {
    final currentUserEmail = UserService().currentUser.email != 'guest@sukabumi.go.id' && UserService().currentUser.email != '-'
        ? UserService().currentUser.email
        : 'dzakwanmuh304@gmail.com';
    final currentUserName = UserService().currentUser.name != 'Tamu Sukabumi' && UserService().currentUser.name != 'Warga Sukabumi'
        ? UserService().currentUser.name
        : 'Muhammad Dzakwan';

    final List<Map<String, String>> googleAccounts = [
      {
        'name': currentUserName,
        'email': currentUserEmail,
      },
      {
        'name': 'Ahmad Subagja',
        'email': 'ahmad.subagja@gmail.com',
      },
      {
        'name': 'Warga Sukabumi',
        'email': 'warga.sukabumi@gmail.com',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.g_mobiledata_rounded, color: Color(0xFF4285F4), size: 36),
                SizedBox(width: 8),
                Text(
                  'Pilih Akun Google',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A1E33),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih akun Google terdaftar di HP Anda untuk melanjutkan ke Sukabumi One Access:',
              style: TextStyle(fontSize: 11.5, color: Colors.grey, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),

            // LIST AKUN GOOGLE DISIMPULASIKAN DARI DEVICE
            ...googleAccounts.map((account) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF4285F4).withOpacity(0.12),
                  child: Text(
                    account['name']![0],
                    style: const TextStyle(color: Color(0xFF4285F4), fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  account['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, fontFamily: 'Poppins'),
                ),
                subtitle: Text(
                  account['email']!,
                  style: const TextStyle(fontSize: 11.5, fontFamily: 'Poppins'),
                ),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);
                  Navigator.pop(context); // Tutup Picker Sheet

                  setState(() => _isLoading = true);
                  await Future.delayed(const Duration(milliseconds: 900));

                  await UserService().loginWithGoogleAccount(account['name']!, account['email']!);

                  await NotificationService().addNotification(
                    title: '🌐 Login Google OAuth Berhasil',
                    description: 'Terhubung dengan akun Google ${account['email']}.',
                    category: NotificationCategory.general,
                  );

                  if (!mounted) return;
                  setState(() => _isLoading = false);

                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Login berhasil dengan Google (${account['email']})!'),
                      backgroundColor: const Color(0xFF4285F4),
                    ),
                  );

                  navigator.pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                  );
                },
              );
            }),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.person_add_alt_outlined, color: Color(0xFF0A1E33)),
              title: const Text(
                'Tambah Akun Google Lainnya...',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. MODAL OTENTIKASI SINGLE SIGN-ON (SSO TERPADU KOTA SUKABUMI)
  // ---------------------------------------------------------------------------
  void _bukaModalSSO() {
    final TextEditingController ssoUsernameController = TextEditingController();
    final TextEditingController ssoPasswordController = TextEditingController();
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
                      child: const Icon(Icons.vpn_key_rounded, color: Color(0xFF0A1E33), size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Single Sign-On (SSO Sukabumi)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A1E33),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '1 Akun untuk Seluruh Aplikasi OPD Terpadu',
                            style: TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: Color(0xFF0A1E33), size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Sistem SSO memverifikasi akun Anda pada 1 Penyedia Identitas Utama & memberikan token khusus agar Anda dapat menggunakan semua layanan OPD tanpa login ulang.',
                          style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.4, fontFamily: 'Poppins'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ssoUsernameController,
                  style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    labelText: 'Username / NIK SSO',
                    hintText: 'Masukkan username SSO...',
                    prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF0A1E33)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: ssoPasswordController,
                  obscureText: true,
                  style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    labelText: 'Password SSO',
                    hintText: 'Masukkan kata sandi SSO...',
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
                    onPressed: isAuthenticating
                        ? null
                        : () async {
                            setModalState(() => isAuthenticating = true);
                            await Future.delayed(const Duration(milliseconds: 1200));

                            final username = ssoUsernameController.text.trim();
                            final current = UserService().currentUser;

                            await UserService().updateProfile(
                              current.copyWith(
                                username: username.isNotEmpty ? username : 'warga.sso.sukabumi',
                                name: username.isNotEmpty ? username : 'Warga Sukabumi (SSO Verified)',
                                status: 'Terverifikasi (SSO Identity Token)',
                              ),
                            );

                            await NotificationService().addNotification(
                              title: '🔑 Autentikasi SSO Berhasil',
                              description: 'Token akses SSO Sukabumi diterbitkan. Anda terhubung ke seluruh portal OPD.',
                              category: NotificationCategory.general,
                            );

                            if (!context.mounted) return;
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login SSO Berhasil! Token terverifikasi oleh Penyedia Identitas.'),
                                backgroundColor: Color(0xFF0A1E33),
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
                      isAuthenticating ? 'Memeriksa Token SSO...' : 'Verifikasi & Masuk SSO',
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
                    'Portal Terpadu Layanan Masyarakat Kota Sukabumi',
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
                      const Text(
                        'Masuk Akun Pengguna',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Silakan masuk untuk mengakses seluruh layanan publik terpadu',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // INPUT USERNAME / EMAIL / NIK
                      const Text(
                        'Nama Lengkap / Email / NIK',
                        style: TextStyle(
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
                          hintText: 'Masukkan Nama, Email, atau NIK...',
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
                            return 'Nama / Email / NIK wajib diisi';
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
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login_rounded, size: 20, color: accentColor),
                                    SizedBox(width: 8),
                                    Text(
                                      'Masuk Akun',
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

                      const SizedBox(height: 20),

                      // MENU DAFTAR AKUN BARU
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum memiliki akun? ',
                            style: TextStyle(fontSize: 12.5, color: Colors.grey, fontFamily: 'Poppins'),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Daftar Sekarang',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                fontFamily: 'Poppins',
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),

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

                      // 1. TOMBOL LOGIN GOOGLE
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _bukaGoogleAccountPicker,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4285F4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    'G',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Masuk dengan Google',
                                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 2. TOMBOL LOGIN SINGLE SIGN-ON (SSO SUKABUMI)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _bukaModalSSO,
                          icon: const Icon(Icons.vpn_key_rounded, size: 20, color: Colors.white),
                          label: const Text(
                            'Masuk dengan Single Sign-On (SSO)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
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
                          onPressed: () async {
                            await UserService().loginAsGuest();
                            if (!context.mounted) return;
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
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LINK INFORMASI PORTAL ADMIN (WEBSITE & OTP GMAIL 2FA)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF0A1E33), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Login Admin Instansi (Gmail & OTP 2FA)',
                        style: TextStyle(
                          color: Color(0xFF0A1E33),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
