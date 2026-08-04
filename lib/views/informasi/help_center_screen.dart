import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/chat_message_model.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // Data Jawaban FAQ untuk Bot
  final Map<String, String> _faqResponses = {
    'Bagaimana cara membuat pengaduan?': 
        'Untuk membuat pengaduan, Anda bisa masuk ke menu "Layanan" di navigasi bawah, pilih kategori layanan yang sesuai, lalu isi formulir pengaduan dengan lengkap dan unggah foto pendukung jika diperlukan.',
    'Bagaimana cara melihat status pengaduan saya?': 
        'Status pengaduan dapat dipantau melalui menu "Log Aktivitas" di halaman profil Anda. Anda akan mendapatkan notifikasi real-time setiap kali ada perubahan status.',
    'Berapa lama pengaduan diproses?': 
        'Proses pengaduan biasanya memakan waktu 1-3 hari kerja tergantung pada tingkat kompleksitas masalah dan instansi yang berwenang menanganinya.',
    'Apa saja layanan yang tersedia?': 
        'Saat ini tersedia layanan Pengaduan Infrastruktur, Layanan Dukcapil Digital, Informasi Cuaca, dan Berita Kota Sukabumi.',
    'Di mana lokasi kantor pelayanan?': 
        'Kantor Pusat Layanan terpadu berada di Balai Kota Sukabumi, Jl. R. Syamsudin, S.H. No.25.',
    'Mengapa pengaduan saya belum ditindaklanjuti?': 
        'Mohon pastikan data yang diinput sudah lengkap. Jika sudah lebih dari 3 hari kerja, Anda bisa menggunakan fitur "Hubungi Admin" di detail pengaduan tersebut.',
  };

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        sender: MessageSender.user,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulasi Balasan Bot setelah 1 detik
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      String reply = 'Terima kasih atas pesan Anda. Mohon tunggu sebentar, agen SOA akan segera merespon Anda.';
      
      // Cek apakah pesan user cocok dengan FAQ
      if (_faqResponses.containsKey(text)) {
        reply = _faqResponses[text]!;
      }

      setState(() {
        _messages.add(ChatMessage(
          text: reply,
          sender: MessageSender.bot,
          timestamp: DateTime.now(),
        ));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A1E33);
    const Color accentColor = Color(0xFFE8A33D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. TOPMOST LOGO BAR
          _buildLogoBar(primaryColor),

          // 2. MAIN HEADER (Weather & Profile)
          _buildMainHeader(primaryColor, accentColor),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // 3. HERO SECTION
                  _buildHeroSection(accentColor),

                  // 4. CHAT NAV BAR
                  _buildChatNavBar(context, primaryColor, accentColor),

                  // 5. FAQ & CHAT AREA
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // FAQ Card (Interactive)
                        _buildFAQCard(primaryColor),
                        
                        const SizedBox(height: 30),
                        
                        // Dynamic Message List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildChatBubble(_messages[index], accentColor);
                          },
                        ),
                        
                        if (_isTyping)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F2F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('SOA sedang mengetik...', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ),
                          ),

                        const SizedBox(height: 20),
                        
                        // Default Prompt
                        if (_messages.isEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F2F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Lanjutkan chat dengan SOA?',
                                style: TextStyle(color: Colors.black87, fontSize: 13),
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 6. CHAT INPUT BAR
          _buildInputBar(primaryColor),
        ],
      ),
    );
  }

  Widget _buildLogoBar(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                'https://via.placeholder.com/30x30',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, size: 24, color: Colors.blueGrey),
              ),
              const SizedBox(width: 8),
              Text('SukabumiCity', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14, fontStyle: FontStyle.italic)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: primaryColor.withOpacity(0.8), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Text('Sukabumi, ', style: TextStyle(color: Colors.white, fontSize: 8)),
                Text('28°C', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Icon(Icons.wb_cloudy, color: Colors.blueAccent, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainHeader(Color primaryColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: const Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Potensi Cuaca', style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
                    Text('Ekstrem', style: TextStyle(color: Colors.black, fontSize: 8)),
                  ],
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline, color: Colors.green, size: 12),
              ],
            ),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Sampurasun, mrn', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text('Jum\'at, 17 Juli 2026', style: TextStyle(color: accentColor, fontSize: 9)),
                ],
              ),
              const SizedBox(width: 10),
              const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(Color accentColor) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage('https://via.placeholder.com/600x400'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          onError: (exception, stackTrace) {
            // Log or handle the error
          },
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco_outlined, color: accentColor, size: 20),
              const SizedBox(width: 8),
              Text('SUKABUMI ONE ACCESS', style: TextStyle(color: accentColor, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Icon(Icons.eco_outlined, color: accentColor, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              children: [
                const TextSpan(text: 'Pusat Layanan ', style: TextStyle(color: Colors.white)),
                TextSpan(text: 'Kota Sukabumi.', style: TextStyle(color: accentColor)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Temukan kemudahan mengakses berbagai layanan informasi dari seluruh Instansi Pemerintah Kota Sukabumi dalam satu pintu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatNavBar(BuildContext context, Color primaryColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: primaryColor, border: Border(bottom: BorderSide(color: accentColor, width: 2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.chevron_left, color: accentColor, size: 28)),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(text: 'Pusat ', style: TextStyle(color: Colors.white)),
                    TextSpan(text: 'Bantuan', style: TextStyle(color: accentColor)),
                  ],
                ),
              ),
            ],
          ),
          Icon(Icons.more_vert, color: accentColor),
        ],
      ),
    );
  }

  Widget _buildFAQCard(Color primaryColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFE9EEF3), borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ada yang bisa kami bantu?', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          ..._faqResponses.keys.map((question) => _buildFAQItem(question)),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String text) {
    return InkWell(
      onTap: () => _handleSendMessage(text),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Text(text, style: const TextStyle(color: Color(0xFF3B5B80), fontSize: 13))),
          const Divider(color: Colors.white, height: 1, thickness: 1.5),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, Color accentColor) {
    bool isUser = message.sender == MessageSender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isUser ? accentColor : const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildInputBar(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(border: Border.all(color: Colors.black26, width: 0.8), borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  const Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.grey, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: _handleSendMessage,
                      decoration: const InputDecoration(hintText: 'Kami siap membantu', hintStyle: TextStyle(color: Colors.grey, fontSize: 13), border: InputBorder.none, isDense: true),
                    ),
                  ),
                  const Icon(Icons.attach_file, color: Colors.grey, size: 22),
                  const SizedBox(width: 12),
                  const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 22),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(onTap: () => _handleSendMessage(_messageController.text), child: const Icon(Icons.send, color: Colors.grey, size: 28)),
        ],
      ),
    );
  }
}
