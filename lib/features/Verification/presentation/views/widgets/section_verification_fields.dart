import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionVerificationFields extends StatelessWidget {
  final List<TextEditingController> codeControllers;
  final List<FocusNode> focusNodes;
  final Function(String, int) onCodeChanged;

  const SectionVerificationFields({
    super.key,
    required this.codeControllers,
    required this.focusNodes,
    required this.onCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: focusNodes[index].hasFocus
                    ? AppColors.primary
                    : const Color(0xFFE4DFDF),
                width: focusNodes[index].hasFocus ? 6 : 6,
              ),
            ),
            child: TextField(
              controller: codeControllers[index],
              focusNode: focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // يقبل الأرقام فقط
              ],
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: AppColors.primary,
              ),
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: '-',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  color: Colors.grey.shade400,
                ),
              ),
              onChanged: (value) => onCodeChanged(value, index),
            ),
          );
        }),
      ),
    );
  }
}
