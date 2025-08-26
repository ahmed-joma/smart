import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/widgets/custom_text_field.dart';

class SectionPasswordFields extends StatefulWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;

  const SectionPasswordFields({
    super.key,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isNewPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
  });

  @override
  State<SectionPasswordFields> createState() => _SectionPasswordFieldsState();
}

class _SectionPasswordFieldsState extends State<SectionPasswordFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // New Password Field
        Center(
          child: CustomTextField(
            height: 60,
            width: 350,
            hintText: 'New password',
            obscureText: !widget.isNewPasswordVisible,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: const Color(0xFF807A7A),
              size: 25,
            ),
            suffixIcon: IconButton(
              onPressed: widget.onToggleNewPasswordVisibility,
              icon: Icon(
                widget.isNewPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
            controller: widget.newPasswordController,
            borderColor: const Color(0xFFE4DFDF),
          ),
        ),

        const SizedBox(height: 16),

        // Confirm Password Field
        Center(
          child: CustomTextField(
            height: 60,
            width: 350,
            hintText: 'Confirm new password',
            obscureText: !widget.isConfirmPasswordVisible,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: const Color(0xFF807A7A),
              size: 25,
            ),
            suffixIcon: IconButton(
              onPressed: widget.onToggleConfirmPasswordVisibility,
              icon: Icon(
                widget.isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
            controller: widget.confirmPasswordController,
            borderColor: const Color(0xFFE4DFDF),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
