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

  // دالة ذكية لمعالجة أخطاء تسجيل الدخول
  void _handleSignInError(String apiMessage) {
    String email = _emailController.text.trim();

    String title = '';
    String message = '';
    IconData icon = Icons.error;
    Color color = Colors.red;

    // تحليل نوع الخطأ وإعطاء رسائل ذكية
    if (apiMessage.toLowerCase().contains('invalid credentials') ||
        apiMessage.toLowerCase().contains('unauthorized') ||
        apiMessage.toLowerCase().contains('wrong password') ||
        apiMessage.toLowerCase().contains('incorrect')) {
      // التحقق من صحة الإيميل أولاً
      if (!_isValidEmail(email)) {
        title = '📧 Invalid Email Format';
        message = 'Please enter a valid email address\n(e.g., user@gmail.com)';
        icon = Icons.email_outlined;
      } else {
        title = '🔐 Login Failed';
        message =
            'Email or password is incorrect.\nPlease double-check your credentials.';
        icon = Icons.lock_outline;
      }
    } else if (apiMessage.toLowerCase().contains('user not found') ||
        apiMessage.toLowerCase().contains('email not found') ||
        apiMessage.toLowerCase().contains('account not found')) {
      title = '👤 Account Not Found';
      message =
          'No account found with this email.\nWould you like to create a new account?';
      icon = Icons.person_search;
      color = Colors.orange;

      // إضافة زر للانتقال للتسجيل
      _showAccountNotFoundDialog();
      return;
    } else if (apiMessage.toLowerCase().contains('email not verified') ||
        apiMessage.toLowerCase().contains('account not verified')) {
      title = '✉️ Email Not Verified';
      message = 'Please check your email and verify your account first.';
      icon = Icons.mark_email_unread;
      color = Colors.orange;
    } else if (apiMessage.toLowerCase().contains('account disabled') ||
        apiMessage.toLowerCase().contains('account suspended')) {
      title = '🚫 Account Suspended';
      message =
          'Your account has been suspended.\nPlease contact support for assistance.';
      icon = Icons.block;
    } else if (apiMessage.toLowerCase().contains('too many attempts') ||
        apiMessage.toLowerCase().contains('rate limit')) {
      title = '⏰ Too Many Attempts';
      message =
          'Too many login attempts.\nPlease wait a few minutes and try again.';
      icon = Icons.timer;
      color = Colors.orange;
    } else if (apiMessage.toLowerCase().contains('connection') ||
        apiMessage.toLowerCase().contains('timeout') ||
        apiMessage.toLowerCase().contains('network')) {
      title = '🌐 Connection Error';
      message = 'Please check your internet connection\nand try again.';
      icon = Icons.wifi_off;
      color = Colors.blue;
    } else if (apiMessage.toLowerCase().contains('server error') ||
        apiMessage.toLowerCase().contains('internal error')) {
      title = '🛠️ Server Error';
      message = 'Something went wrong on our end.\nPlease try again later.';
      icon = Icons.build_circle_outlined;
      color = Colors.purple;
    } else {
      // خطأ عام
      title = '❌ Login Failed';
      message =
          'Something went wrong.\nPlease check your credentials and try again.';
      icon = Icons.error_outline;
    }

    // عرض الإشعار
    _showCustomErrorDialog(title, message, icon, color);
  }

  // التحقق من صحة الإيميل
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  // حوار مخصص للأخطاء
  void _showCustomErrorDialog(
    String title,
    String message,
    IconData icon,
    Color color,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 30, color: color),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // حوار خاص للحسابات غير الموجودة
  void _showAccountNotFoundDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 30,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '👤 Account Not Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'No account found with this email.\nWould you like to create a new account?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.go('/signUpView');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
            _handleSignInError(state.message);
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
