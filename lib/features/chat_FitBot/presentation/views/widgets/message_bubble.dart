import 'package:flutter/material.dart';
import '../../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final int index;
  final Function(String)? onQuickReplyTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.index,
    this.onQuickReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: isUser ? 60 : 0,
        right: isUser ? 0 : 60,
      ),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [_buildMessageRow(isUser), _buildMessageTime(isUser)],
      ),
    );
  }

  Widget _buildMessageRow(bool isUser) {
    return Row(
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser) ...[_buildBotAvatar(), const SizedBox(width: 8)],
        _buildMessageContent(isUser),
        if (isUser) ...[const SizedBox(width: 8), _buildUserAvatar()],
      ],
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F2F3A), Color(0xFFE74C3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.smart_toy, color: Colors.white, size: 14),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 14),
    );
  }

  Widget _buildMessageContent(bool isUser) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF7F2F3A) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 8),
            bottomRight: Radius.circular(isUser ? 8 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: isUser
                  ? const Color(0xFF7F2F3A).withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildMessageContentByType(),
      ),
    );
  }

  Widget _buildMessageContentByType() {
    // Ensure messageType is not null and handle any potential issues
    MessageType messageType;
    try {
      messageType = message.messageType ?? MessageType.text;
    } catch (e) {
      // Fallback to text if there's any issue
      messageType = MessageType.text;
    }

    switch (messageType) {
      case MessageType.text:
        return _buildTextMessage();
      case MessageType.quickReplies:
        return _buildQuickRepliesMessage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextMessage() {
    return Text(
      message.text,
      style: TextStyle(
        color: message.isUser ? Colors.white : const Color(0xFF2D3748),
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
    );
  }

  Widget _buildQuickRepliesMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.text,
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        _buildQuickRepliesButtons(),
      ],
    );
  }

  Widget _buildQuickRepliesButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: (message.quickReplies ?? []).map((reply) {
        return _buildQuickReplyButton(reply);
      }).toList(),
    );
  }

  Widget _buildQuickReplyButton(String reply) {
    return GestureDetector(
      onTap: () {
        if (onQuickReplyTap != null) {
          onQuickReplyTap!(reply);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF7F2F3A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF7F2F3A).withOpacity(0.3)),
        ),
        child: Text(
          reply,
          style: const TextStyle(
            color: Color(0xFF7F2F3A),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTime(bool isUser) {
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        left: isUser ? 0 : 36,
        right: isUser ? 36 : 0,
      ),
      child: Text(
        _formatTime(message.timestamp),
        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
