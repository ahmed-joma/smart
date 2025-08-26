import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/themes/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 140),

        // Sign in Title - Left aligned
        Text(
          'Sign in',
          style: AppTextStyles.heading1.copyWith(color: AppColors.primary),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
