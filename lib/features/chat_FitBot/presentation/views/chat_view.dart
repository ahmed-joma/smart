import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/shared.dart';
import 'widgets/chat_header.dart';
import 'widgets/chat_search_bar.dart';
import 'widgets/chat_messages_list.dart';
import 'widgets/typing_indicator.dart';
import 'widgets/chat_input_bar.dart';
import '../manager/chat_controller.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatController _chatController;

  @override
  void initState() {
    super.initState();
    _chatController = ChatController();
    // Initialize chat immediately
    _chatController.initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _chatController,
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
