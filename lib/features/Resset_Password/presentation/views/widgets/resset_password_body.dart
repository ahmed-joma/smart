import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/widgets/custom_snackbar.dart';
import 'section_header.dart';
import 'section_instructions.dart';
import 'section_email_field.dart';
import 'section_password_fields.dart';
import 'section_action_button.dart';

class RessetPasswordBody extends StatefulWidget {
  const RessetPasswordBody({super.key});

  @override
  State<RessetPasswordBody> createState() => _RessetPasswordBodyState();
}

class _RessetPasswordBodyState extends State<RessetPasswordBody> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _showPasswordFields = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkEmailValidity();
    _emailController.addListener(_checkEmailValidity);
    _newPasswordController.addListener(_checkPasswordValidity);
    _confirmPasswordController.addListener(_checkPasswordValidity);
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkEmailValidity);
    _newPasswordController.removeListener(_checkPasswordValidity);
    _confirmPasswordController.removeListener(_checkPasswordValidity);
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkEmailValidity() {
    setState(() {
      _isEmailValid =
          _emailController.text.isNotEmpty &&
          _emailController.text.contains('@') &&
          _emailController.text.contains('.');
    });
  }

  void _checkPasswordValidity() {
    setState(() {
      _isPasswordValid = _newPasswordController.text.length >= 6;
      _isConfirmPasswordValid =
          _confirmPasswordController.text.isNotEmpty &&
          _newPasswordController.text == _confirmPasswordController.text;
    });
  }

  void _onToggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordVisible = !_isNewPasswordVisible;
    });
  }

  void _onToggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _onSendPressed() {
    CustomSnackBar.showSuccess(
      context: context,
      message: 'Password reset email sent successfully!',
      duration: const Duration(seconds: 3),
    );
    // Show password fields after notification
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showPasswordFields = true;
        });
      }
    });
  }

  void _onConfirmPressed() {
    CustomSnackBar.showSuccess(
      context: context,
      message: 'Password changed successfully!',
      duration: const Duration(seconds: 2),
    );
    // Navigate to sign in after showing notification
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/signInView');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  const SectionHeader(),

                  // Instructions Section
                  const SectionInstructions(),

                  // Email Field Section
                  SectionEmailField(emailController: _emailController),

                  // Password Fields Section (shown after email is sent)
                  if (_showPasswordFields)
                    SectionPasswordFields(
                      newPasswordController: _newPasswordController,
                      confirmPasswordController: _confirmPasswordController,
                      isNewPasswordVisible: _isNewPasswordVisible,
                      isConfirmPasswordVisible: _isConfirmPasswordVisible,
                      onToggleNewPasswordVisibility:
                          _onToggleNewPasswordVisibility,
                      onToggleConfirmPasswordVisibility:
                          _onToggleConfirmPasswordVisibility,
                    ),

                  // Action Button Section
                  SectionActionButton(
                    showPasswordFields: _showPasswordFields,
                    isEmailValid: _isEmailValid,
                    isPasswordValid: _isPasswordValid,
                    isConfirmPasswordValid: _isConfirmPasswordValid,
                    onPressed: _showPasswordFields
                        ? (_isPasswordValid && _isConfirmPasswordValid
                              ? _onConfirmPressed
                              : null)
                        : (_isEmailValid ? _onSendPressed : null),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
