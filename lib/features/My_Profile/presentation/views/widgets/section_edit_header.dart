import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionEditHeader extends StatelessWidget {
  const SectionEditHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Back Arrow
          IconButton(
            onPressed: () {
              context.go('/myProfileView');
            },
            icon: Icon(Icons.arrow_back, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          // Edit Profile Title
          Text(
            'Edit Profile',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
