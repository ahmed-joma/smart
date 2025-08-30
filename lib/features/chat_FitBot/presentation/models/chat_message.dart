// Define MessageType enum
enum MessageType { text, quickReplies }

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType messageType;
  final List<String>? quickReplies;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    MessageType? messageType,
    this.quickReplies,
  }) : messageType = messageType ?? MessageType.text;
}
