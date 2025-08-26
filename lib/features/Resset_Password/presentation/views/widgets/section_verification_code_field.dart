import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/shared.dart';

class SectionVerificationCodeField extends StatelessWidget {
  final TextEditingController verificationCodeController;
  final int verificationTimer;
  final bool canResend;
  final VoidCallback onResendPressed;

  const SectionVerificationCodeField({
    super.key,
    required this.verificationCodeController,
    required this.verificationTimer,
    required this.canResend,
    required this.onResendPressed,
  });

  String _formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter the verification code sent to your email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: verificationCodeController,
          hintText: 'Verification Code',
          prefixIcon: Icon(
            Icons.security,
            color: AppColors.onSurfaceVariant,
            size: 24,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 4,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!canResend) ...[
              Text(
                'Resend code in ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                _formatTimer(verificationTimer),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ] else ...[
              TextButton(
                onPressed: onResendPressed,
                child: Text(
                  'Re-send code',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
