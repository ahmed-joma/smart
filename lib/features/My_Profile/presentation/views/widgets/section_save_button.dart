import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/widgets/custom_button.dart';

class SectionSaveButton extends StatelessWidget {
  final VoidCallback onSavePressed;

  const SectionSaveButton({super.key, required this.onSavePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: CustomButton(
          text: '     SAVE CHANGES',
          height: 60,
          width: 250,
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          borderRadius: BorderRadius.circular(20),
          isSignInButton: true,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          onPressed: onSavePressed,
        ),
      ),
    );
  }
}
