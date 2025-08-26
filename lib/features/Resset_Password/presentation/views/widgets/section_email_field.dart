import 'package:flutter/material.dart';
import '../../../../../shared/shared.dart';

class SectionEmailField extends StatelessWidget {
  final TextEditingController emailController;
  final bool isEmailValid;
  final ValueChanged<String> onEmailChanged;

  const SectionEmailField({
    super.key,
    required this.emailController,
    required this.isEmailValid,
    required this.onEmailChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your email address to reset your password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: emailController,
          hintText: 'Email',
          height: 60,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: isEmailValid ? AppColors.onSurfaceVariant : AppColors.error,
            size: 24,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: onEmailChanged,
          borderColor: isEmailValid ? null : AppColors.error,
        ),
      ],
    );
  }
}
