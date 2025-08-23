import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? fillColor;
  final double borderWidth;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.width = 335,
    this.height = 48,
    this.margin,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.fillColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: fillColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : Border.all(color: AppColors.outline, width: 1),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        maxLines: maxLines,
        maxLength: maxLength,
        onTap: onTap,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        style: AppTextStyles.medium.copyWith(color: AppColors.onSurface),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: false,
          contentPadding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          labelStyle: AppTextStyles.medium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          hintStyle: AppTextStyles.medium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          helperStyle: AppTextStyles.small.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          errorStyle: AppTextStyles.small.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}
