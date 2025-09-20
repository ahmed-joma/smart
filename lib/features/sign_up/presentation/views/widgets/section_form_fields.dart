import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/widgets/custom_text_field.dart';

class SectionFormFields extends StatefulWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isFullNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final String passwordErrorMessage;
  final String confirmPasswordErrorMessage;
  final Function(String) onFullNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final Function(String) onConfirmPasswordChanged;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;

  const SectionFormFields({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isFullNameValid,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isConfirmPasswordValid,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.passwordErrorMessage,
    required this.confirmPasswordErrorMessage,
    required this.onFullNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
  });

  @override
  State<SectionFormFields> createState() => _SectionFormFieldsState();
}

class _SectionFormFieldsState extends State<SectionFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Full Name Field
        CustomTextField(
          height: 60,
          width: 350,
          hintText: 'Full name',
          prefixIcon: Icon(
            Icons.person_outline,
            color: const Color(0xFF807A7A),
            size: 25,
          ),
          controller: widget.fullNameController,
          borderColor: widget.isFullNameValid
              ? const Color(0xFFE4DFDF)
              : Colors.red,
          onChanged: widget.onFullNameChanged,
        ),

        const SizedBox(height: 16),

        // Email Field
        CustomTextField(
          height: 60,
          width: 350,
          hintText: 'ahlam@email.com',
          prefixIcon: Icon(
            Icons.email_outlined,
            color: const Color(0xFF807A7A),
            size: 25,
          ),
          controller: widget.emailController,
          borderColor: widget.isEmailValid
              ? const Color(0xFFE4DFDF)
              : Colors.red,
          onChanged: widget.onEmailChanged,
        ),

        const SizedBox(height: 16),

        // Password Field
        CustomTextField(
          height: 60,
          width: 350,
          hintText: 'Your password',
          obscureText: !widget.isPasswordVisible,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: const Color(0xFF807A7A),
            size: 25,
          ),
          suffixIcon: IconButton(
            onPressed: widget.onTogglePasswordVisibility,
            icon: Icon(
              widget.isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
          controller: widget.passwordController,
          borderColor: widget.isPasswordValid
              ? const Color(0xFFE4DFDF)
              : Colors.red,
          onChanged: widget.onPasswordChanged,
        ),

        // Password Requirements
        if (widget.passwordController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordRequirement(
                  'At least 8 characters',
                  widget.passwordController.text.length >= 8,
                ),
                _buildPasswordRequirement(
                  'Contains uppercase letter (A-Z)',
                  widget.passwordController.text.contains(RegExp(r'[A-Z]')),
                ),
                _buildPasswordRequirement(
                  'Contains lowercase letter (a-z)',
                  widget.passwordController.text.contains(RegExp(r'[a-z]')),
                ),
                _buildPasswordRequirement(
                  'Contains number (0-9)',
                  widget.passwordController.text.contains(RegExp(r'[0-9]')),
                ),
                _buildPasswordRequirement(
                  'Contains special character (!@#\$%^&*)',
                  widget.passwordController.text.contains(
                    RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                  ),
                ),
              ],
            ),
          ),

        // Password Error Message
        if (widget.passwordErrorMessage.isNotEmpty &&
            widget.passwordController.text.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              widget.passwordErrorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Confirm Password Field
        CustomTextField(
          height: 60,
          width: 350,
          hintText: 'Confirm password',
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
          borderColor: widget.isConfirmPasswordValid
              ? const Color(0xFFE4DFDF)
              : Colors.red,
          onChanged: widget.onConfirmPasswordChanged,
        ),

        // Confirm Password Error Message
        if (widget.confirmPasswordErrorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              widget.confirmPasswordErrorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
          ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildPasswordRequirement(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isValid ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.red,
              fontSize: 11,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
