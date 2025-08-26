import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/widgets/custom_text_field.dart';

class SectionFormFields extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordVisible;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final VoidCallback onTogglePasswordVisibility;

  const SectionFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isPasswordVisible,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onTogglePasswordVisibility,
  });

  @override
  State<SectionFormFields> createState() => _SectionFormFieldsState();
}

class _SectionFormFieldsState extends State<SectionFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email Field
        CustomTextField(
          height: 60,
          width: 350,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: const Color(0xFF807A7A),
            size: 25,
          ),
          hintText: 'ahlam@email.com',
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

        const SizedBox(height: 20),
      ],
    );
  }
}
