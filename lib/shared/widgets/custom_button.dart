import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? suffixWidget;
  final bool isSignInButton;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width = 271,
    this.height = 58,
    this.margin,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.suffixWidget,
    this.isSignInButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.onPrimary,
          elevation: 2,
          padding: padding ?? EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.onPrimary,
                  ),
                ),
              )
            : isSignInButton
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.mediumSemiBold.copyWith(
                      color: textColor ?? AppColors.onPrimary,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                  suffixWidget ?? const SizedBox.shrink(),
                ],
              )
            : Text(
                text,
                style: AppTextStyles.mediumSemiBold.copyWith(
                  color: textColor ?? AppColors.onPrimary,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.imagePath,
    this.onPressed,
    this.width,
    this.height = 48,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(imagePath, width: 24, height: 24),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: fontWeight ?? FontWeight.w400,
                  fontSize: fontSize ?? 16,
                  height: 25 / 16,
                  color: textColor ?? Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
