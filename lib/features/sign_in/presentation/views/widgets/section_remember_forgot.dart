import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionRememberForgot extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;

  const SectionRememberForgot({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Switch(
              value: rememberMe,
              onChanged: onRememberMeChanged,
              activeColor: AppColors.primary,
            ),
            Text(
              'Remember Me',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 23 / 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // Navigate to verification
            context.go('/verificationView');
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 23 / 14,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
