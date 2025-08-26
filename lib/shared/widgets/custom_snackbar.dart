import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.green,
    Color iconColor = Colors.white,
    Color textColor = AppColors.primary,
    Duration duration = const Duration(seconds: 3),
    bool isSuccess = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isSuccess ? Icons.check : Icons.info,
                color: backgroundColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor.withOpacity(
          0.95,
        ), // زيادة عدم الشفافية
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: backgroundColor.withOpacity(0.3), width: 1),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
        elevation: 8, // إضافة ظل أقوى
      ),
    );
  }

  // Success SnackBar
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      iconColor: Colors.white,
      textColor: AppColors.primary,
      duration: duration,
      isSuccess: true,
    );
  }

  // Error SnackBar
  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      iconColor: Colors.white,
      textColor: AppColors.primary,
      duration: duration,
      isSuccess: false,
    );
  }

  // Info SnackBar
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.blue,
      iconColor: Colors.white,
      textColor: AppColors.primary,
      duration: duration,
      isSuccess: false,
    );
  }

  // Warning SnackBar
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.orange,
      iconColor: Colors.white,
      textColor: AppColors.primary,
      duration: duration,
      isSuccess: false,
    );
  }
}
