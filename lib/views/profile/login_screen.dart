import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../services/notification_service.dart';
import '../../models/notification_model.dart';
import '../admin/admin_dashboard_screen.dart';

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
          content: Text('Berhasil masuk ke akun Warga!'),
          backgroundColor: Color(0xFF0A1E33),
        ),
      );

      navigator.pop();
    }
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
            // HEADER NAVY LOGO & HERO SECTION
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 36,
                left: 24,
                right: 24,
              ),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accentColor.withOpacity(0.5)),
                        ),
                        child: const Text(
                          'Sukabumi One Access',
                          style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 70,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.account_balance_rounded,
                      size: 64,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _isAdminMode ? 'Portal Login Administrator' : 'Selamat Datang Warga Sukabumi',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isAdminMode
                        ? 'Masuk untuk mengelola sistem, OPD, & membalas live chat warga.'
                        : 'Masuk dengan NIK / Email untuk mengakses seluruh layanan publik.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // FORMULIR LOGIN CONTAINER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TOGGLE SEGMENTED BUTTON (WARGA VS ADMIN)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isAdminMode = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: !_isAdminMode ? primaryColor : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person_rounded,
                                            size: 16,
                                            color: !_isAdminMode ? accentColor : Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Login Warga',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: !_isAdminMode ? Colors.white : Colors.grey.shade700,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isAdminMode = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _isAdminMode ? primaryColor : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.admin_panel_settings_rounded,
                                            size: 16,
                                            color: _isAdminMode ? accentColor : Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Login Admin',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: _isAdminMode ? Colors.white : Colors.grey.shade700,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // INPUT USERNAME / NIK
                        Text(
                          _isAdminMode ? 'Kode ID Admin Instansi' : 'NIK / Nomor HP / Email',
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
                            hintText: _isAdminMode ? 'Contoh: admin_diskominfo' : 'Masukkan NIK (16 digit) atau email',
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins'),
                            prefixIcon: Icon(_isAdminMode ? Icons.shield_rounded : Icons.person_outline_rounded, color: primaryColor),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: primaryColor, width: 1.5),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return _isAdminMode ? 'Kode ID Admin wajib diisi' : 'NIK / Email wajib diisi';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // INPUT PASSWORD
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
                            hintText: 'Masukkan kata sandi akun',
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins'),
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: primaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                color: Colors.grey,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: primaryColor, width: 1.5),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Kata sandi tidak boleh kosong';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur Lupa Password: Silakan hubungi layanan bantuan Pemkot Sukabumi.'),
                                ),
                              );
                            },
                            child: const Text(
                              'Lupa Kata Sandi?',
                              style: TextStyle(color: primaryColor, fontSize: 11.5, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // TOMBOL LOGIN SUBMIT
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _prosesLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
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
                      ],
                    ),
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
