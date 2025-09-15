import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/widgets/custom_button.dart';

class SectionActionButton extends StatelessWidget {
  final bool showPasswordFields;
  final bool isVerificationCodeValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SectionActionButton({
    super.key,
    required this.showPasswordFields,
    required this.isVerificationCodeValid,
    required this.isPasswordValid,
    required this.isConfirmPasswordValid,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        text: isLoading
            ? (showPasswordFields ? 'Confirming...' : 'Sending...')
            : (showPasswordFields ? '     CONFIRM' : '     SEND'),
        height: 66,
        width: 271,
        backgroundColor: isLoading
            ? AppColors.primary
            : (showPasswordFields
                  ? (isPasswordValid && isConfirmPasswordValid
                        ? AppColors.primary
                        : Colors.grey.shade300)
                  : (isVerificationCodeValid
                        ? AppColors.primary
                        : Colors.grey.shade300)),
        textColor: isLoading
            ? Colors.white
            : (showPasswordFields
                  ? (isPasswordValid && isConfirmPasswordValid
                        ? Colors.white
                        : Colors.grey.shade600)
                  : (isVerificationCodeValid
                        ? Colors.white
                        : Colors.grey.shade600)),
        borderRadius: BorderRadius.circular(12),
        isSignInButton: true,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Noto Kufi Arabic',
        suffixWidget: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D56F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 16,
                ),
              ),
        onPressed: isLoading ? null : onPressed,
      ),
    );
  }
}
