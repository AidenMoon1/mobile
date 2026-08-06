// =============================================================================
// FILE: lib/services/chat_service.dart
// FUNGSI: Service Pengelola Obrolan Real-Time (Cloud Firestore + Local Stream Fallback)
// PATTERN: Singleton Pattern & Reactive Stream Architecture
// LEVEL KODE: Level 2-3 (Sangat Terstruktur, Mudah Dipahami Mahasiswa)
// =============================================================================

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message_model.dart';

/// ----------------------------------------------------------------------------
/// KELAS CHAT SERVICE (SINGLETON CLASS)
/// ----------------------------------------------------------------------------
/// Catatan Mahasiswa: Singleton memastikan hanya ada 1 instance ChatService 
/// di seluruh aplikasi untuk menghemat penggunaan memori dan menjaga sinkronisasi data.
class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  // Instance Firebase Cloud Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache Lokal Memori agar Pesan & Balasan Bot Langsung Tampil Instan (< 1ms)
  final Map<String, List<ChatMessage>> _localCache = {};
  final Map<String, StreamController<List<ChatMessage>>> _streamControllers = {};

  /// --------------------------------------------------------------------------
  /// FUNGSI 1: Mendapatkan atau Membuat StreamController untuk Thread Tertentu
  /// --------------------------------------------------------------------------
  StreamController<List<ChatMessage>> _getController(String threadId) {
    if (!_streamControllers.containsKey(threadId)) {
      _streamControllers[threadId] = StreamController<List<ChatMessage>>.broadcast();
    }
    return _streamControllers[threadId]!;
  }

  /// --------------------------------------------------------------------------
  /// FUNGSI 2: Mengirim Pesan ke Local Cache & Firebase Firestore (Non-Blocking)
  /// --------------------------------------------------------------------------
  /// Catatan Mahasiswa: Fungsi ini menambahkan pesan ke cache lokal terlebih dahulu
  /// agar tampilan UI merespon seketika tanpa perlu menunggu jaringan internet/server.
  Future<void> sendMessage({
    required String threadId,
    required String text,
    required MessageSender sender,
    String? userName,
    String? topic,
  }) async {
    final newMessage = ChatMessage(
      text: text,
      sender: sender,
      timestamp: DateTime.now(),
    );

    // Step A: Update Cache Memori & Pemicu Stream Lokal secara INSTAN
    if (!_localCache.containsKey(threadId)) {
      _localCache[threadId] = [];
    }
    _localCache[threadId]!.add(newMessage);
    _getController(threadId).add(List.from(_localCache[threadId]!));

    // Step B: Sinkronkan Data ke Firebase Cloud Firestore di Background
    _syncToFirestore(
      threadId: threadId,
      text: text,
      sender: sender,
      userName: userName,
      topic: topic,
    );
  }

  /// --------------------------------------------------------------------------
  /// FUNGSI 3: Sinkronisasi Asinkron Asli ke Firebase Cloud Firestore
  /// --------------------------------------------------------------------------
  void _syncToFirestore({
    required String threadId,
    required String text,
    required MessageSender sender,
    String? userName,
    String? topic,
  }) async {
    try {
      // Mengamankan Karakter Khusus pada Thread ID
      final safeThreadId = threadId.replaceAll(RegExp(r'[^\w\-]'), '_');

      // 1. Tambah dokumen pesan ke Sub-Koleksi Firestore 'messages'
      await _firestore
          .collection('chats')
          .doc(safeThreadId)
          .collection('messages')
          .add({
        'text': text,
        'sender': sender.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 4));

      // 2. Update Ringkasan Thread Obrolan di Dokumen Utama
      Map<String, dynamic> updateData = {
        'lastMessage': text,
        'lastTime': FieldValue.serverTimestamp(),
        'unread': sender == MessageSender.user,
      };

      if (userName != null) updateData['userName'] = userName;
      if (topic != null) updateData['topic'] = topic;

      await _firestore.collection('chats').doc(safeThreadId).set(
            updateData,
            SetOptions(merge: true),
          ).timeout(const Duration(seconds: 4));
    } catch (e) {
      // Catatan: Jika offline, data tetap aman di cache lokal
    }
  }

  /// --------------------------------------------------------------------------
  /// FUNGSI 4: Mendapatkan Aliran Stream Pesan Real-Time (Merge Local + Firestore)
  /// --------------------------------------------------------------------------
  /// Catatan Mahasiswa: Digunakan oleh StreamBuilder di layar HelpCenterScreen 
  /// untuk merender gelembung percakapan secara otomatis saat ada pesan baru.
  Stream<List<ChatMessage>> getMessages(String threadId) {
    final safeThreadId = threadId.replaceAll(RegExp(r'[^\w\-]'), '_');
    final controller = _getController(threadId);

    // Kirim pesan awal dari cache lokal jika tersedia
    if (_localCache.containsKey(threadId) && _localCache[threadId]!.isNotEmpty) {
      controller.add(List.from(_localCache[threadId]!));
    }

    try {
      // Mendengarkan Listener Snapshots dari Cloud Firestore secara Real-Time
      _firestore
          .collection('chats')
          .doc(safeThreadId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .listen((snapshot) {
        final remoteDocs = snapshot.docs.map((doc) {
          final data = doc.data();
          return ChatMessage(
            text: data['text'] ?? '',
            sender: _parseSender(data['sender']),
            timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          );
        }).toList();

        if (remoteDocs.isNotEmpty) {
          _localCache[threadId] = remoteDocs;
          controller.add(remoteDocs);
        }
      }, onError: (err) {
        // Fallback aman
      });
    } catch (e) {
      // Fallback aman
    }

    return controller.stream;
  }

  /// --------------------------------------------------------------------------
  /// FUNGSI 5: Mendapatkan Daftar Thread Chat (Khusus Inbox Admin Panel)
  /// --------------------------------------------------------------------------
  Stream<QuerySnapshot> getChatThreads() {
    return _firestore
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  /// --------------------------------------------------------------------------
  /// FUNGSI 6: Menandai Obrolan Sudah Dibaca oleh Admin
  /// --------------------------------------------------------------------------
  Future<void> markAsRead(String threadId) async {
    try {
      final safeThreadId = threadId.replaceAll(RegExp(r'[^\w\-]'), '_');
      await _firestore.collection('chats').doc(safeThreadId).update({'unread': false});
    } catch (e) {
      // Fallback aman
    }
  }

  /// Helper untuk Parsing Enum Sender dari String Firestore
  MessageSender _parseSender(String? senderStr) {
    if (senderStr == 'MessageSender.user') return MessageSender.user;
    if (senderStr == 'MessageSender.bot') return MessageSender.bot;
    return MessageSender.bot;
  }
}
