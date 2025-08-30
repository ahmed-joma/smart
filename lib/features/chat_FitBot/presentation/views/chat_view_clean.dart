import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../manager/chat_controller.dart';
import 'widgets/chat_header.dart';
import 'widgets/chat_search_bar.dart';
import 'widgets/chat_messages_list.dart';
import 'widgets/typing_indicator.dart';
import 'widgets/chat_input_bar.dart';

class ChatViewClean extends StatefulWidget {
  const ChatViewClean({super.key});

  @override
  State<ChatViewClean> createState() => _ChatViewCleanState();
}

class _ChatViewCleanState extends State<ChatViewClean> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatController>().initializeChat();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatController(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildChatMessages(),
              _buildTypingIndicator(),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<ChatController>(
      builder: (context, controller, child) {
        return ChatHeader(
          isSearchVisible: controller.isSearchVisible,
          onSearchToggle: controller.toggleSearch,
          onMoreOptions: () {
            // Handle more options
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Consumer<ChatController>(
      builder: (context, controller, child) {
        if (!controller.isSearchVisible) return const SizedBox.shrink();

        return ChatSearchBar(
          searchController: _searchController,
          onSearchChanged: controller.updateSearchQuery,
        );
      },
    );
  }

  Widget _buildChatMessages() {
    return Expanded(
      child: Consumer<ChatController>(
        builder: (context, controller, child) {
          return ChatMessagesList(
            messages: controller.filteredMessages,
            scrollController: _scrollController,
            onQuickReplyTap: (reply) {
              controller.sendMessage(customText: reply);
              _scrollToBottom();
            },
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Consumer<ChatController>(
      builder: (context, controller, child) {
        if (!controller.isTyping) return const SizedBox.shrink();

        return const TypingIndicator();
      },
    );
  }

  Widget _buildInputBar() {
    return Consumer<ChatController>(
      builder: (context, controller, child) {
        return ChatInputBar(
          messageController: _messageController,
          onSendMessage: () {
            final text = _messageController.text.trim();
            if (text.isNotEmpty) {
              controller.sendMessage(customText: text);
              _messageController.clear();
              _scrollToBottom();
            }
          },
          onVoiceMessage: () {
            // Handle voice message
          },
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
