import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionResendTimer extends StatelessWidget {
  final bool canResend;
  final int resendTimer;
  final VoidCallback onResendPressed;
  final String Function(int) formatTimer;
  final bool isLoading;

  const SectionResendTimer({
    super.key,
    required this.canResend,
    required this.resendTimer,
    required this.onResendPressed,
    required this.formatTimer,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sending...',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 23 / 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            )
          : canResend
          ? GestureDetector(
              onTap: onResendPressed,
              child: Text(
                'Re-send code',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 23 / 16,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          : Text(
              'Re-send code in ${formatTimer(resendTimer)}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 23 / 16,
                color: AppColors.primary,
              ),
            ),
    );
  }
}
