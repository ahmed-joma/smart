import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/widgets/custom_button.dart';

class SectionContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SectionContinueButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Continue Button
        Center(
          child: CustomButton(
            text: '     CONTINUE',
            height: 66,
            width: 271,
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            isSignInButton: true,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Noto Kufi Arabic',
            suffixWidget: SvgPicture.asset(
              'assets/images/arrow.svg',
              width: 24,
              height: 24,
            ),
            onPressed: onPressed,
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
