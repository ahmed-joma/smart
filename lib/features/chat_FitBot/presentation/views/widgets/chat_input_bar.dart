import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;
  final VoidCallback onVoiceMessage;

  const ChatInputBar({
    super.key,
    required this.messageController,
    required this.onSendMessage,
    required this.onVoiceMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildVoiceButton(),
          const SizedBox(width: 12),
          _buildMessageInput(),
          const SizedBox(width: 12),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildVoiceButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onVoiceMessage,
        icon: Icon(Icons.mic, color: Colors.grey.shade600, size: 20),
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF7F2F3A).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: TextField(
          controller: messageController,
          decoration: const InputDecoration(
            hintText: 'Type a message...',
            hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          style: const TextStyle(fontSize: 15, color: Color(0xFF2D3748)),
          maxLines: null,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => onSendMessage(),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7F2F3A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F2F3A).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onSendMessage,
        icon: const Icon(Icons.send, color: Colors.white, size: 20),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
