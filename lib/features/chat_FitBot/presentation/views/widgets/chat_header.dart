import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatHeader extends StatelessWidget {
  final bool isSearchVisible;
  final VoidCallback onSearchToggle;
  final VoidCallback onMoreOptions;

  const ChatHeader({
    super.key,
    required this.isSearchVisible,
    required this.onSearchToggle,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildBackButton(context),
          const SizedBox(width: 16),
          _buildBotAvatar(),
          const SizedBox(width: 12),
          _buildBotInfo(),
          _buildSearchButton(),
          const SizedBox(width: 8),
          _buildMoreOptionsButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7F2F3A).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () => context.go('/homeView'),
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF7F2F3A),
          size: 20,
        ),
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F2F3A), Color(0xFFE74C3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F2F3A).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
    );
  }

  Widget _buildBotInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FitBot',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onSearchToggle,
        icon: Icon(
          isSearchVisible ? Icons.close : Icons.search,
          color: Colors.grey.shade600,
          size: 20,
        ),
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildMoreOptionsButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onMoreOptions,
        icon: Icon(Icons.more_vert, color: Colors.grey.shade600, size: 20),
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
