import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionInstructions extends StatelessWidget {
  const SectionInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instructions
        Text(
          '   Please enter your email address\n   to request a password reset',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 23 / 16,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
