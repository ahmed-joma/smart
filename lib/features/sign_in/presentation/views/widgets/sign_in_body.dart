import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/widgets/custom_snackbar.dart';
import '../../manager/sign_in_cubit.dart';
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

  void _onSignInPressed(BuildContext context) {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    // التحقق من صحة البيانات
    setState(() {
      _isEmailValid = email.isNotEmpty;
      _isPasswordValid = password.isNotEmpty;
    });

    // Check if email and password are valid
    if (_isEmailValid && _isPasswordValid) {
      // Check email format
      if (!email.contains('@gmail.com') &&
          !email.contains('@yahoo.com') &&
          !email.contains('@hotmail.com')) {
        CustomSnackBar.showError(
          context: context,
          message: 'Please enter a valid email address (e.g., user@gmail.com)',
          duration: const Duration(seconds: 2),
        );
        return;
      }

      // Call API through Cubit
      context.read<SignInCubit>().signIn(email: email, password: password);
    } else {
      // Show error notification
      String errorMessage = 'Please fill in all fields';
      if (!_isEmailValid) {
        errorMessage = 'Please enter a valid email address';
      } else if (!_isPasswordValid) {
        errorMessage = 'Please enter your password';
      }

      CustomSnackBar.showError(
        context: context,
        message: errorMessage,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            // Show success notification
            CustomSnackBar.showSuccess(
              context: context,
              message: 'Login successful! Welcome back.',
              duration: const Duration(seconds: 2),
            );

            // Navigate to home page after showing notification
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.go('/homeView');
              }
            });
          } else if (state is SignInError) {
            // Show error notification with specific messages
            String errorMessage = state.message;

            // Customize error messages based on API response
            if (state.message.contains('Invalid credentials')) {
              // Check if it's email or password issue
              String email = _emailController.text.trim();
              if (email.contains('@gmail.com') ||
                  email.contains('@yahoo.com') ||
                  email.contains('@hotmail.com')) {
                errorMessage = 'Incorrect password. Please try again.';
              } else {
                errorMessage = 'No account found for this email address.';
              }
            } else if (state.message.contains('email')) {
              errorMessage =
                  'Please enter a valid email address (e.g., user@gmail.com)';
            } else if (state.message.contains('password')) {
              errorMessage = 'Incorrect password. Please try again.';
            } else if (state.message.contains('Connection timeout')) {
              errorMessage =
                  'Connection timeout. Please check your internet connection.';
            } else if (state.message.contains('Cannot connect')) {
              errorMessage =
                  'Cannot connect to server. Please check your internet connection.';
            }

            CustomSnackBar.showError(
              context: context,
              message: errorMessage,
              duration: const Duration(seconds: 3),
            );
          }
        },
        child: Scaffold(
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
                      BlocBuilder<SignInCubit, SignInState>(
                        builder: (context, state) {
                          return SectionSignInButton(
                            onPressed: state is SignInLoading
                                ? null
                                : () => _onSignInPressed(context),
                            isLoading: state is SignInLoading,
                          );
                        },
                      ),

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
        ),
      ),
    );
  }
}
