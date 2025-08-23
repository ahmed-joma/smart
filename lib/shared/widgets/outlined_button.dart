import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double borderWidth;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width = 105,
    this.height = 46,
    this.margin,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          side: BorderSide(
            color: borderColor ?? AppColors.primary,
            width: borderWidth,
          ),
          padding:
              padding ??
              const EdgeInsets.only(top: 8, right: 14, bottom: 8, left: 14),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(40),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.smallSemiBold.copyWith(
                      color: textColor ?? AppColors.primary,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                  const SizedBox(width: 8), // Gap
                ],
              ),
      ),
    );
  }
}
