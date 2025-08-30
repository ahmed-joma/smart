import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import 'message_bubble.dart';

class ChatMessagesList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final Function(String) onQuickReplyTap;

  const ChatMessagesList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.onQuickReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return MessageBubble(
            message: message,
            index: index,
            onQuickReplyTap: onQuickReplyTap,
          );
        },
      ),
    );
  }
}
