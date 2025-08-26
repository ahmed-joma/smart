import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/widgets/custom_button.dart';

class SectionSocialLogin extends StatelessWidget {
  const SectionSocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // OR Separator
        Center(
          child: Text(
            'OR',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 23 / 14,
              color: Colors.grey.shade500,
            ),
          ),
        ),

        const SizedBox(height: 28),

        // Google Login Button
        Center(
          child: SocialLoginButton(
            text: 'Login with Google',
            imagePath: 'assets/images/Google.svg',
            height: 66,
            width: 250,
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.white,
            borderColor: const Color(0xFFE4DFDF),
            textColor: AppColors.primary,
            onPressed: () {
              // Handle Google login
            },
          ),
        ),

        const SizedBox(height: 16),

        // Facebook Login Button
        Center(
          child: SocialLoginButton(
            text: 'Login with FaceBook',
            imagePath: 'assets/images/faceBook.svg',
            height: 66,
            width: 250,
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.white,
            borderColor: const Color(0xFFE4DFDF),
            textColor: AppColors.primary,
            onPressed: () {
              // Handle Facebook login
            },
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
