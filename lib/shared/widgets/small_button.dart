import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class SmallButton extends StatelessWidget {
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

  const SmallButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width = 60,
    this.height = 30,
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
      margin: margin ?? const EdgeInsets.only(left: 297),
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
              const EdgeInsets.only(top: 6, right: 11, bottom: 6, left: 11),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(6),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.small.copyWith(
                      color: textColor ?? AppColors.primary,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                  const SizedBox(width: 10), // Gap
                ],
              ),
      ),
    );
  }
}
