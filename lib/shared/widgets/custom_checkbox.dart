import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? checkColor;
  final Color? fillColor;
  final double borderWidth;

  const CustomCheckbox({
    super.key,
    this.value,
    this.onChanged,
    this.width = 20,
    this.height = 20,
    this.borderRadius,
    this.borderColor,
    this.checkColor,
    this.fillColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: fillColor ?? AppColors.primary,
        checkColor: checkColor ?? AppColors.onPrimary,
        side: BorderSide(
          color: borderColor ?? AppColors.outline,
          width: borderWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(6),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
