import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'section_header.dart';
import 'section_form_fields.dart';
import 'section_signup_button.dart';
import 'section_social_login.dart';
import 'section_signin_link.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // متغيرات للتحقق من صحة البيانات
  bool _isFullNameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  // دوال لإعادة تعيين حالة الحقول عند الكتابة
  void _onFullNameChanged(String value) {
    if (_isFullNameValid != true) {
      setState(() {
        _isFullNameValid = true;
      });
    }
  }

  void _onEmailChanged(String value) {
    if (_isEmailValid != true) {
      setState(() {
        _isEmailValid = true;
      });
    }
  }

  void _onPasswordChanged(String value) {
    if (_isPasswordValid != true) {
      setState(() {
        _isPasswordValid = true;
      });
    }
  }

  void _onConfirmPasswordChanged(String value) {
    if (_isConfirmPasswordValid != true) {
      setState(() {
        _isConfirmPasswordValid = true;
      });
    }
  }

  void _onTogglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _onToggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    // Validate all fields
    bool isValid = true;

    if (_fullNameController.text.trim().isEmpty) {
      setState(() => _isFullNameValid = false);
      isValid = false;
    }

    if (_emailController.text.trim().isEmpty) {
      setState(() => _isEmailValid = false);
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _isPasswordValid = false);
      isValid = false;
    }

    if (_confirmPasswordController.text.isEmpty) {
      setState(() => _isConfirmPasswordValid = false);
      isValid = false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _isConfirmPasswordValid = false);
      isValid = false;
    }

    if (!isValid) return;

    // Clear errors
    setState(() {
      _isFullNameValid = true;
      _isEmailValid = true;
      _isPasswordValid = true;
      _isConfirmPasswordValid = true;
    });

    // Navigate to verification page
    context.go('/verificationView');
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

                  // Form Fields Section
                  SectionFormFields(
                    fullNameController: _fullNameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    isFullNameValid: _isFullNameValid,
                    isEmailValid: _isEmailValid,
                    isPasswordValid: _isPasswordValid,
                    isConfirmPasswordValid: _isConfirmPasswordValid,
                    isPasswordVisible: _isPasswordVisible,
                    isConfirmPasswordVisible: _isConfirmPasswordVisible,
                    onFullNameChanged: _onFullNameChanged,
                    onEmailChanged: _onEmailChanged,
                    onPasswordChanged: _onPasswordChanged,
                    onConfirmPasswordChanged: _onConfirmPasswordChanged,
                    onTogglePasswordVisibility: _onTogglePasswordVisibility,
                    onToggleConfirmPasswordVisibility:
                        _onToggleConfirmPasswordVisibility,
                  ),

                  // Sign Up Button Section
                  SectionSignUpButton(onPressed: _onSignUpPressed),

                  // Social Login Section
                  const SectionSocialLogin(),

                  // Sign In Link Section
                  const SectionSignInLink(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
