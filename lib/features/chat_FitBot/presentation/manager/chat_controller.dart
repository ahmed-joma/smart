import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatController extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isSearchVisible = false;
  String _searchQuery = '';

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isSearchVisible => _isSearchVisible;
  String get searchQuery => _searchQuery;

  final List<String> _quickReplies = [
    "Tell me about events",
    "Show me restaurants",
    "What's happening today?",
    "Help me find places",
    "Weather information",
  ];

  List<String> get quickReplies => _quickReplies;

  void initializeChat() {
    _addInitialBotMessage();
    _addWelcomeQuickReplies();
  }

  void _addInitialBotMessage() {
    _messages.add(
      ChatMessage(
        text:
            "Hi, I'm FitBot! 👋 I'm your assistant in exploring events and areas. How can I help you?",
        isUser: false,
        timestamp: DateTime.now(),
        messageType: MessageType.text,
      ),
    );
  }

  void _addWelcomeQuickReplies() {
    _messages.add(
      ChatMessage(
        text: "Choose a quick option:",
        isUser: false,
        timestamp: DateTime.now(),
        messageType: MessageType.quickReplies,
        quickReplies: _quickReplies,
      ),
    );
  }

  void sendMessage({String? customText}) {
    final text = customText ?? '';
    if (text.isEmpty) return;

    _addUserMessage(text);
    _showTypingIndicator();
    _simulateBotResponse(text);
  }

  void _addUserMessage(String text) {
    _messages.add(
      ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
        messageType: MessageType.text,
      ),
    );
    notifyListeners();
  }

  void _showTypingIndicator() {
    _isTyping = true;
    notifyListeners();
  }

  void _hideTypingIndicator() {
    _isTyping = false;
    notifyListeners();
  }

  void _simulateBotResponse(String userMessage) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      _hideTypingIndicator();

      String botResponse = _generateBotResponse(userMessage);

      _messages.add(
        ChatMessage(
          text: botResponse,
          isUser: false,
          timestamp: DateTime.now(),
          messageType: MessageType.text,
        ),
      );
      notifyListeners();
    });
  }

  String _generateBotResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('event') || message.contains('events')) {
      return "🎉 Great! I found some amazing events for you:\n\n• City Walk Festival - Tonight at 7 PM\n• Food & Music Night - Tomorrow at 6 PM\n• Sports Tournament - This weekend\n\nWould you like me to show you more details about any of these?";
    } else if (message.contains('restaurant') || message.contains('food')) {
      return "🍽️ Here are some top-rated restaurants nearby:\n\n• Al Baik - Famous for fried chicken\n• Shawarma House - Best wraps in town\n• Pizza Palace - Authentic Italian\n\nWhat type of cuisine are you craving?";
    } else if (message.contains('weather')) {
      return "🌤️ Current weather in your area:\n\n• Temperature: 25°C\n• Condition: Partly cloudy\n• Humidity: 65%\n• Perfect weather for outdoor activities!";
    } else if (message.contains('place') || message.contains('places')) {
      return "📍 Popular places to visit:\n\n• Jeddah Corniche - Beautiful waterfront\n• Al-Balad Historic District\n• Red Sea Mall - Shopping & entertainment\n• King Fahd Fountain\n\nWhich area interests you most?";
    } else {
      return "Thanks for your message! I'm here to help you explore events, find restaurants, check weather, and discover amazing places. What would you like to know more about?";
    }
  }

  void toggleSearch() {
    _isSearchVisible = !_isSearchVisible;
    if (!_isSearchVisible) {
      _searchQuery = '';
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<ChatMessage> get filteredMessages {
    if (_searchQuery.isEmpty) return _messages;
    return _messages
        .where(
          (message) =>
              message.text.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void dispose() {
    super.dispose();
  }
}
