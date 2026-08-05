import 'package:flutter/material.dart';
import 'package:mobile/models/chat_message_model.dart';

class AdminChatInboxScreen extends StatefulWidget {
  const AdminChatInboxScreen({super.key});

  @override
  State<AdminChatInboxScreen> createState() => _AdminChatInboxScreenState();
}

class _AdminChatInboxScreenState extends State<AdminChatInboxScreen> {
  final List<Map<String, dynamic>> _chatThreads = [
    {
      'id': 'CHAT-101',
      'userName': 'Budi Santoso',
      'userAvatar': 'assets/images/logo.png',
      'lastMessage': 'Halo Admin, permohonan KTP saya statusnya masih diproses sejak 2 hari lalu.',
      'time': '10:42 WIB',
      'unread': true,
      'status': 'Perlu Balasan',
      'topic': 'Administrasi KTP',
      'messages': [
        ChatMessage(
          text: 'Halo Bot SOA, bagaimana cara cek status KTP saya?',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        ChatMessage(
          text: 'Anda dapat mengecek status KTP melalui menu Log Aktivitas.',
          sender: MessageSender.bot,
          timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
        ),
        ChatMessage(
          text: 'Dialihkan ke Admin: Warga membutuhkan bantuan petugas manusia.',
          sender: MessageSender.bot,
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        ),
        ChatMessage(
          text: 'Halo Admin, permohonan KTP saya statusnya masih diproses sejak 2 hari lalu.',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
      ],
    },
    {
      'id': 'CHAT-102',
      'userName': 'Siti Rahma',
      'userAvatar': 'assets/images/disduk.png',
      'lastMessage': 'Terima kasih atas bantuannya pak admin!',
      'time': '09:15 WIB',
      'unread': false,
      'status': 'Sudah Dibalas',
      'topic': 'Layanan PBB',
      'messages': [
        ChatMessage(
          text: 'Saya ingin menanyakan diskon PBB Kota Sukabumi.',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ChatMessage(
          text: 'Halo Ibu Siti, diskon PBB 10% berlaku hingga akhir bulan ini di BPKPD.',
          sender: MessageSender.bot,
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        ),
        ChatMessage(
          text: 'Terima kasih atas bantuannya pak admin!',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        ),
      ],
    },
    {
      'id': 'CHAT-103',
      'userName': 'Ahmad Fauzi',
      'userAvatar': 'assets/images/dpmptsp.png',
      'lastMessage': 'Persyaratan NIB untuk usaha mikro apa saja ya?',
      'time': 'Kemarin',
      'unread': true,
      'status': 'Perlu Balasan',
      'topic': 'Izin Usaha DPMPTSP',
      'messages': [
        ChatMessage(
          text: 'Persyaratan NIB untuk usaha mikro apa saja ya?',
          sender: MessageSender.user,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    },
  ];

  void _bukaRuangChatAdmin(Map<String, dynamic> thread) {
    setState(() {
      thread['unread'] = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminChatRoomScreen(
          thread: thread,
          onMessageSent: (newMsg) {
            setState(() {
              (thread['messages'] as List<ChatMessage>).add(
                ChatMessage(
                  text: newMsg,
                  sender: MessageSender.bot, // Agent
                  timestamp: DateTime.now(),
                ),
              );
              thread['lastMessage'] = 'Admin: $newMsg';
              thread['time'] = 'Baru saja';
              thread['status'] = 'Sudah Dibalas';
            });
          },
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
        title: const Row(
          children: [
            Icon(Icons.headset_mic_rounded, color: accentColor, size: 22),
            SizedBox(width: 10),
            Text(
              'Inbox Live Chat Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // HEADER BANNER STATISTIK ADMIN
          Container(
            padding: const EdgeInsets.all(16),
            color: primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Pesan', '${_chatThreads.length}', Icons.chat_rounded, accentColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    'Perlu Balasan',
                    '${_chatThreads.where((t) => t['unread'] == true).length}',
                    Icons.mark_chat_unread_rounded,
                    Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),

          // LIST PERCAKAPAN MASUK DARI WARGA
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chatThreads.length,
              itemBuilder: (context, index) {
                final thread = _chatThreads[index];
                final bool isUnread = thread['unread'] == true;

                return GestureDetector(
                  onTap: () => _bukaRuangChatAdmin(thread),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isUnread ? accentColor : Colors.grey.shade200,
                        width: isUnread ? 2 : 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: primaryColor.withOpacity(0.08),
                          child: const Icon(Icons.person_rounded, color: primaryColor, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    thread['userName'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: primaryColor,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    thread['time'] as String,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: isUnread ? accentColor : Colors.grey,
                                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  thread['topic'] as String,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                thread['lastMessage'] as String,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isUnread ? Colors.black87 : Colors.grey.shade600,
                                  fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'Poppins'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LAYAR RUANG CHAT ADMIN (MEMBALAS PESAN WARGA SECARA LANGSUNG)
// ---------------------------------------------------------------------------
class AdminChatRoomScreen extends StatefulWidget {
  final Map<String, dynamic> thread;
  final ValueChanged<String> onMessageSent;

  const AdminChatRoomScreen({
    super.key,
    required this.thread,
    required this.onMessageSent,
  });

  @override
  State<AdminChatRoomScreen> createState() => _AdminChatRoomScreenState();
}

class _AdminChatRoomScreenState extends State<AdminChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _kirimBalasanAdmin() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onMessageSent(text);
    _controller.clear();

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
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A1E33);
    const accentColor = Color(0xFFE8A33D);
    final messages = widget.thread['messages'] as List<ChatMessage>;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: accentColor,
              child: Icon(Icons.person, color: primaryColor, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.thread['userName'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
                Text(
                  'Topik: ${widget.thread['topic']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // DAFTAR PESAN OBROLAN WARGA & ADMIN
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final bool isAdmin = msg.sender != MessageSender.user;

                return Align(
                  alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isAdmin ? primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(14).copyWith(
                        bottomRight: isAdmin ? Radius.zero : const Radius.circular(14),
                        bottomLeft: !isAdmin ? Radius.zero : const Radius.circular(14),
                      ),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0F000000), blurRadius: 4, offset: Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAdmin ? 'Petugas Admin SOA' : widget.thread['userName'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isAdmin ? accentColor : primaryColor,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isAdmin ? Colors.white : Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // INPUT CHAT BALASAN ADMIN
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x10000000), blurRadius: 8, offset: Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      hintText: 'Ketik balasan admin ke warga...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Poppins'),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      fillColor: const Color(0xFFF4F6F9),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: accentColor, size: 20),
                    onPressed: _kirimBalasanAdmin,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
