import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionSignUpLink extends StatelessWidget {
  const SectionSignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 23 / 14,
              color: AppColors.primary,
            ),
          ),
          TextButton(
            onPressed: () {
              context.go('/signUpView');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Sign Up',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 23 / 14,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
