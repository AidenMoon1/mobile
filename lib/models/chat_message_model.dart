// =============================================================================
// FILE: lib/models/chat_message_model.dart
// FUNGSI: Data Model untuk Pesan Obrolan Live Chat & AI Bot SOA
// PATTERN: Data Transfer Object (DTO)
// =============================================================================

/// Enum Penanda Pengirim Pesan (User = Warga, Bot = AI Bot / Admin)
enum MessageSender { user, bot }

/// Kelas Model Representasi 1 Butir Pesan Obrolan Chat
class ChatMessage {
  final String text;          // Isi teks pesan yang dikirim
  final MessageSender sender; // Pengirim pesan (user atau bot/admin)
  final DateTime timestamp;   // Waktu stempel tanggal & jam pesan dikirim

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}
