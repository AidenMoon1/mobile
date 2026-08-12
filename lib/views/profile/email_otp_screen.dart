import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mobile/services/api_service.dart';

class EmailOtpScreen extends StatefulWidget {
  final String email;
  final VoidCallback onVerified;

  const EmailOtpScreen({
    super.key,
    required this.email,
    required this.onVerified,
  });

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends State<EmailOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  bool _isLoading = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _resendTimer = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _resendTimer--);
      }
    });
  }

  void _resendOtp() async {
    setState(() => _isLoading = true);
    
    final response = await ApiService.post('auth/otp/email/send', {
      'email': widget.email,
    });

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP baru telah dikirim ke email Anda')),
      );
    }
  }

  void _verifyOtp() async {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) return;

    setState(() => _isLoading = true);
    
    final response = await ApiService.post('auth/otp/email/verify', {
      'email': widget.email,
      'otp': otp,
    });

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      widget.onVerified();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode OTP salah atau kedaluwarsa. Silakan coba lagi.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      // Reset input
      for (var c in _controllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A1E33);
    const accentColor = Color(0xFFE8A33D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verifikasi Email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Poppins'),
                children: [
                  const TextSpan(text: 'Masukkan 6 digit kode rahasia yang kami kirimkan ke '),
                  TextSpan(
                    text: widget.email,
                    style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // OTP INPUT BOXES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: accentColor, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      }
                      if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                      if (otp.length == 6) {
                        _verifyOtp();
                      }
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Verifikasi & Masuk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Column(
                children: [
                  const Text('Tidak menerima kode?', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  TextButton(
                    onPressed: _resendTimer == 0 ? _resendOtp : null,
                    child: Text(
                      _resendTimer == 0 
                        ? 'Kirim Ulang Kode' 
                        : 'Kirim ulang dalam $_resendTimer detik',
                      style: TextStyle(
                        color: _resendTimer == 0 ? accentColor : Colors.grey,
                        fontWeight: FontWeight.bold,
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

  String get otp => _controllers.map((c) => c.text).join();
}
