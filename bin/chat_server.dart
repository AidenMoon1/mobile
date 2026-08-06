// =============================================================================
// FILE: bin/chat_server.dart
// FUNGSI: Server Obrolan Real-Time Lokal (LAN/WiFi Bridge)
// CARA JALANKAN: dart run bin/chat_server.dart
// =============================================================================

import 'dart:convert';
import 'dart:io';

void main() async {
  // Bind server ke IP local network (0.0.0.0) pada port 8080
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  
  // Dapatkan IP lokal laptop
  String localIp = '127.0.0.1';
  try {
    final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        if (!addr.isLoopback) {
          localIp = addr.address;
          break;
        }
      }
    }
  } catch (e) {
    // Fallback
  }

  stdout.writeln('=============================================================================');
  stdout.writeln('🚀 SERVER CHAT REAL-TIME LOKAL KOTA SUKABUMI ONE ACCESS BERJALAN!');
  stdout.writeln('=============================================================================');
  stdout.writeln('📍 Alamat Localhost (PC Admin) : http://localhost:8080');
  stdout.writeln('📍 Alamat LAN WiFi (HP User)   : http://$localIp:8080');
  stdout.writeln('=============================================================================');
  stdout.writeln('Pesan dari HP User dan PC Admin akan tersinkronisasi 100% secara Real-Time!\n');

  // Database Chat dalam memori server
  final Map<String, List<Map<String, dynamic>>> chats = {};

  await for (HttpRequest request in server) {
    // Enable CORS (Cross-Origin Resource Sharing) untuk Chrome Web & Mobile
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      continue;
    }

    final path = request.uri.path;

    if (path == '/api/chat/send' && request.method == 'POST') {
      // PROSES KIRIM PESAN BARU DARI HP / PC
      final bodyStr = await utf8.decoder.bind(request).join();
      final data = jsonDecode(bodyStr) as Map<String, dynamic>;

      final String threadId = data['threadId'] ?? 'umum';
      final String text = data['text'] ?? '';
      final String sender = data['sender'] ?? 'user';
      final String userName = data['userName'] ?? 'Warga';
      final String topic = data['topic'] ?? 'Umum';

      if (!chats.containsKey(threadId)) {
        chats[threadId] = [];
      }

      final msg = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': text,
        'sender': sender,
        'userName': userName,
        'topic': topic,
        'timestamp': DateTime.now().toIso8601String(),
      };

      chats[threadId]!.add(msg);

      stdout.writeln('📩 [PESAN MASUK] Thread: $threadId | Dari: $userName ($sender) | Isi: "$text"');

      request.response.statusCode = HttpStatus.ok;
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({'status': 'success', 'data': msg}));
      await request.response.close();
    } else if (path == '/api/chat/messages' && request.method == 'GET') {
      // PROSES AMBIL SEMUA PESAN REAL-TIME
      final String threadId = request.uri.queryParameters['threadId'] ?? 'umum';
      final list = chats[threadId] ?? [];

      request.response.statusCode = HttpStatus.ok;
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({'status': 'success', 'data': list}));
      await request.response.close();
    } else if (path == '/api/chat/threads' && request.method == 'GET') {
      // PROSES AMBIL DAFTAR INBOX THREAD UNTUK ADMIN
      final List<Map<String, dynamic>> threadSummary = [];
      chats.forEach((threadId, messages) {
        if (messages.isNotEmpty) {
          final lastMsg = messages.last;
          threadSummary.add({
            'threadId': threadId,
            'userName': lastMsg['userName'] ?? 'Warga',
            'topic': lastMsg['topic'] ?? 'Umum',
            'lastMessage': lastMsg['text'],
            'lastTime': lastMsg['timestamp'],
            'unread': lastMsg['sender'] == 'user',
          });
        }
      });

      request.response.statusCode = HttpStatus.ok;
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({'status': 'success', 'data': threadSummary}));
      await request.response.close();
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Endpoint not found');
      await request.response.close();
    }
  }
}
