import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/widgets/custom_snackbar.dart';
import 'section_header.dart';
import 'section_form_fields.dart';
import 'section_remember_forgot.dart';
import 'section_signin_button.dart';
import 'section_social_login.dart';
import 'section_signup_link.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  // متغيرات للتحقق من صحة البيانات
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  // دوال لإعادة تعيين حالة الحقول عند الكتابة
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

  void _onTogglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _onRememberMeChanged(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignInPressed() {
    // التحقق من صحة البيانات
    setState(() {
      _isEmailValid = _emailController.text.isNotEmpty;
      _isPasswordValid = _passwordController.text.isNotEmpty;
    });

    // Check if email and password are valid
    if (_isEmailValid && _isPasswordValid) {
      // Show success notification
      CustomSnackBar.showSuccess(
        context: context,
        message: 'success sign in',
        duration: const Duration(seconds: 2),
      );

      // Navigate to home page after showing notification
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.go('/homeView');
        }
      });
    } else {
      // Show error notification
      CustomSnackBar.showError(
        context: context,
        message: 'Please fill in all fields',
        duration: const Duration(seconds: 2),
      );
    }
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
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isEmailValid: _isEmailValid,
                    isPasswordValid: _isPasswordValid,
                    isPasswordVisible: _isPasswordVisible,
                    onEmailChanged: _onEmailChanged,
                    onPasswordChanged: _onPasswordChanged,
                    onTogglePasswordVisibility: _onTogglePasswordVisibility,
                  ),

                  // Remember Me & Forgot Password Section
                  SectionRememberForgot(
                    rememberMe: _rememberMe,
                    onRememberMeChanged: _onRememberMeChanged,
                  ),

                  const SizedBox(height: 32),

                  // Sign In Button Section
                  SectionSignInButton(onPressed: _onSignInPressed),

                  // Social Login Section
                  const SectionSocialLogin(),

                  // Sign Up Link Section
                  const SectionSignUpLink(),

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
