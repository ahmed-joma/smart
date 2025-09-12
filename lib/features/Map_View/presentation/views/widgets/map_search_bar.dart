import 'package:flutter/material.dart';
import '../../../../../../shared/themes/app_colors.dart';

class MapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const MapSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'ابحث عن مكان...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontFamily: 'Inter',
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.primary,
            size: 24,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                  onPressed: () {
                    controller.clear();
                    onSearch('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Inter',
          color: Colors.black87,
        ),
      ),
    );
  }
}
