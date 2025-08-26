import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Back Arrow
          IconButton(
            onPressed: () {
              context.go('/homeView');
            },
            icon: Icon(Icons.arrow_back, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          // Profile Title
          Text(
            'My Profile',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 23,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
