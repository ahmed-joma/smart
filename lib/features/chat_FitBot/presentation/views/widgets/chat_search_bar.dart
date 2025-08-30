import 'package:flutter/material.dart';

class ChatSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const ChatSearchBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF7F2F3A).withOpacity(0.2)),
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Search messages...',
            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
            prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}
