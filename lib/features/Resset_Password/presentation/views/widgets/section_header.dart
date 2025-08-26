import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/themes/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),

        // Back Arrow and Title Row
        Row(
          children: [
            IconButton(
              onPressed: () {
                context.go('/verificationView');
              },
              icon: Icon(Icons.arrow_back, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
          ],
        ),

        const SizedBox(height: 15),

        // Main Title
        Text(
          '  Resset Password',
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
