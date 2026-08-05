import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message_model.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // In-memory cache for instant real-time UI updates
  final Map<String, List<ChatMessage>> _localCache = {};
  final Map<String, StreamController<List<ChatMessage>>> _streamControllers = {};

  StreamController<List<ChatMessage>> _getController(String threadId) {
    if (!_streamControllers.containsKey(threadId)) {
      _streamControllers[threadId] = StreamController<List<ChatMessage>>.broadcast();
    }
    return _streamControllers[threadId]!;
  }

  // Mengirim pesan ke Firestore & Local Cache
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

    // 1. Simpan ke Local Memory Cache & Trigger Stream
    if (!_localCache.containsKey(threadId)) {
      _localCache[threadId] = [];
    }
    _localCache[threadId]!.add(newMessage);
    _getController(threadId).add(List.from(_localCache[threadId]!));

    // 2. Simpan ke Firebase Firestore (dengan Catch error jika offline/rule)
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
      });

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
          );
    } catch (e) {
      // Ignored for offline/fallback mode
    }
  }

  // Mendapatkan aliran (Stream) pesan secara Real-Time (Firestore + Local Merge)
  Stream<List<ChatMessage>> getMessages(String threadId) {
    final safeThreadId = threadId.replaceAll(RegExp(r'[^\w\-]'), '_');
    final controller = _getController(threadId);

    // Kirim pesan awal dari cache lokal jika ada
    if (_localCache.containsKey(threadId) && _localCache[threadId]!.isNotEmpty) {
      controller.add(List.from(_localCache[threadId]!));
    }

    try {
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
        // Fallback ke cache jika error
      });
    } catch (e) {
      // Fallback
    }

    return controller.stream;
  }

  // Mendapatkan daftar seluruh thread chat (untuk Admin Inbox)
  Stream<QuerySnapshot> getChatThreads() {
    return _firestore
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  // Menandai chat sudah dibaca oleh admin
  Future<void> markAsRead(String threadId) async {
    try {
      final safeThreadId = threadId.replaceAll(RegExp(r'[^\w\-]'), '_');
      await _firestore.collection('chats').doc(safeThreadId).update({'unread': false});
    } catch (e) {
      // Fallback
    }
  }

  MessageSender _parseSender(String? senderStr) {
    if (senderStr == 'MessageSender.user') return MessageSender.user;
    if (senderStr == 'MessageSender.bot') return MessageSender.bot;
    return MessageSender.bot;
  }
}
