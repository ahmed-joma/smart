import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/widgets/custom_button.dart';

class SectionActionButton extends StatelessWidget {
  final bool showPasswordFields;
  final bool isVerificationCodeValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final VoidCallback? onPressed;

  const SectionActionButton({
    super.key,
    required this.showPasswordFields,
    required this.isVerificationCodeValid,
    required this.isPasswordValid,
    required this.isConfirmPasswordValid,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        text: showPasswordFields ? '     CONFIRM' : '     SEND',
        height: 66,
        width: 271,
        backgroundColor: showPasswordFields
            ? (isPasswordValid && isConfirmPasswordValid
                  ? AppColors.primary
                  : Colors.grey.shade300)
            : (isVerificationCodeValid
                  ? AppColors.primary
                  : Colors.grey.shade300),
        textColor: showPasswordFields
            ? (isPasswordValid && isConfirmPasswordValid
                  ? Colors.white
                  : Colors.grey.shade600)
            : (isVerificationCodeValid ? Colors.white : Colors.grey.shade600),
        borderRadius: BorderRadius.circular(12),
        isSignInButton: true,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Noto Kufi Arabic',
        suffixWidget: SvgPicture.asset(
          'assets/images/arrow.svg',
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            showPasswordFields
                ? (isPasswordValid && isConfirmPasswordValid
                      ? Colors.white
                      : Colors.grey.shade600)
                : (isVerificationCodeValid
                      ? Colors.white
                      : Colors.grey.shade600),
            BlendMode.srcIn,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
