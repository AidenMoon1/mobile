// =============================================================================
// FILE: lib/services/chat_service.dart
// FUNGSI: Service Pengelola Obrolan Real-Time (Local LAN Server + Cloud Firestore)
// PATTERN: Singleton Pattern & Reactive Stream Architecture
// =============================================================================

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message_model.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, List<ChatMessage>> _localCache = {};
  final Map<String, StreamController<List<ChatMessage>>> _streamControllers = {};
  Timer? _pollingTimer;

  // Mendapatkan Base URL Server Lokal (Otomatis membedakan Web/Desktop vs Mobile Emulator)
  String get _serverBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    } else {
      return 'http://10.0.2.2:8080'; // Special host for Android Emulator to PC Localhost
    }
  }

  StreamController<List<ChatMessage>> _getController(String threadId) {
    if (!_streamControllers.containsKey(threadId)) {
      _streamControllers[threadId] = StreamController<List<ChatMessage>>.broadcast();
    }
    return _streamControllers[threadId]!;
  }

  /// --------------------------------------------------------------------------
  /// FUNGSI 1: Mengirim Pesan (Memperbarui RAM Lokal + Local LAN Server + Firestore)
  /// --------------------------------------------------------------------------
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

    // 1. Update Cache Memori Lokal
    if (!_localCache.containsKey(threadId)) {
      _localCache[threadId] = [];
    }
    _localCache[threadId]!.add(newMessage);
    _getController(threadId).add(List.from(_localCache[threadId]!));

    // 2. Kirim ke Server LAN Real-Time (Localhost / LAN Server)
    try {
      final uri = Uri.parse('$_serverBaseUrl/api/chat/send');
      await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'threadId': threadId,
          'text': text,
          'sender': sender == MessageSender.user ? 'user' : 'bot',
          'userName': userName ?? 'Warga Sukabumi',
          'topic': topic ?? 'Layanan Publik',
        }),
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      // Offline fallback
    }

    // 3. Sinkronisasi ke Firestore (Jika Terhubung)
    _syncToFirestore(
      threadId: threadId,
      text: text,
      sender: sender,
      userName: userName,
      topic: topic,
    );
  }

  void _syncToFirestore({
    required String threadId,
    required String text,
    required MessageSender sender,
    String? userName,
    String? topic,
  }) async {
    try {
      final safeThreadId = threadId.replaceAll(RegExp(r'[^\w\-]'), '_');
      await _firestore
          .collection('chats')
          .doc(safeThreadId)
          .collection('messages')
          .add({
        'text': text,
        'sender': sender.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 3));
    } catch (e) {
      // Offline fallback
    }
  }

  /// --------------------------------------------------------------------------
  /// FUNGSI 2: Aliran Stream Pesan Real-Time (Polling 1s ke Server LAN + Memory)
  /// --------------------------------------------------------------------------
  Stream<List<ChatMessage>> getMessages(String threadId) {
    final controller = _getController(threadId);

    if (_localCache.containsKey(threadId) && _localCache[threadId]!.isNotEmpty) {
      controller.add(List.from(_localCache[threadId]!));
    }

    // Mulai Polling 1 Detik ke Server LAN agar HP & PC Saling Sinkron
    _startPollingServer(threadId);

    return controller.stream;
  }

  void _startPollingServer(String threadId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final uri = Uri.parse('$_serverBaseUrl/api/chat/messages?threadId=$threadId');
        final response = await http.get(uri).timeout(const Duration(seconds: 2));

        if (response.statusCode == 200) {
          final resData = jsonDecode(response.body);
          if (resData['status'] == 'success' && resData['data'] is List) {
            final List rawList = resData['data'];
            final fetched = rawList.map((item) {
              return ChatMessage(
                text: item['text'] ?? '',
                sender: item['sender'] == 'user' ? MessageSender.user : MessageSender.bot,
                timestamp: item['timestamp'] != null
                    ? DateTime.parse(item['timestamp'])
                    : DateTime.now(),
              );
            }).toList();

            if (fetched.isNotEmpty) {
              _localCache[threadId] = fetched;
              _getController(threadId).add(fetched);
            }
          }
        }
      } catch (e) {
        // Fallback ke cache lokal jika server tidak aktif
      }
    });
  }

  Stream<QuerySnapshot> getChatThreads() {
    return _firestore
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Future<void> markAsRead(String threadId) async {
    try {
      final safeThreadId = threadId.replaceAll(RegExp(r'[^\w\-]'), '_');
      await _firestore.collection('chats').doc(safeThreadId).update({'unread': false});
    } catch (e) {
      // Fallback
    }
  }

  void dispose() {
    _pollingTimer?.cancel();
    for (var controller in _streamControllers.values) {
      controller.close();
    }
    _streamControllers.clear();
  }
}
