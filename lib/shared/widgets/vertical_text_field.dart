import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class VerticalTextField extends StatelessWidget {
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

  const VerticalTextField({
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
    this.width = 156,
    this.height = 54,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) ...[
            Text(
              labelText!,
              style: AppTextStyles.smallMedium.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
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
                hintText: hintText,
                helperText: helperText,
                errorText: errorText,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                filled: fillColor != null,
                fillColor: fillColor,
                contentPadding:
                    padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: borderColor ?? AppColors.outline,
                    width: borderWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: borderColor ?? AppColors.outline,
                    width: borderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.error,
                    width: borderWidth,
                  ),
                ),
                hintStyle: AppTextStyles.medium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                helperStyle: AppTextStyles.small.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                errorStyle: AppTextStyles.small.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
