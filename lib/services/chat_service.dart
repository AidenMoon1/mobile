import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message_model.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengirim pesan ke Firestore
  Future<void> sendMessage({
    required String threadId,
    required String text,
    required MessageSender sender,
    String? userName,
    String? topic,
  }) async {
    // 1. Tambah pesan ke sub-koleksi messages
    await _firestore
        .collection('chats')
        .doc(threadId)
        .collection('messages')
        .add({
      'text': text,
      'sender': sender.toString(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. Update info di dokumen thread utama
    Map<String, dynamic> updateData = {
      'lastMessage': text,
      'lastTime': FieldValue.serverTimestamp(),
      'unread': sender == MessageSender.user,
    };

    if (userName != null) updateData['userName'] = userName;
    if (topic != null) updateData['topic'] = topic;

    await _firestore.collection('chats').doc(threadId).set(
          updateData,
          SetOptions(merge: true),
        );
  }

  // Mendapatkan aliran (Stream) pesan secara Real-Time
  Stream<List<ChatMessage>> getMessages(String threadId) {
    return _firestore
        .collection('chats')
        .doc(threadId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage(
          text: data['text'] ?? '',
          sender: _parseSender(data['sender']),
          timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
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
    await _firestore.collection('chats').doc(threadId).update({'unread': false});
  }

  MessageSender _parseSender(String? senderStr) {
    if (senderStr == 'MessageSender.user') return MessageSender.user;
    if (senderStr == 'MessageSender.bot') return MessageSender.bot;
    return MessageSender.bot; // Default ke bot/admin
  }
}
