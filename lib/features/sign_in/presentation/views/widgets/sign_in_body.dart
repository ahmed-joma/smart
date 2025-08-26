import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/themes/app_text_styles.dart';
import 'package:smartshop_map/shared/widgets/custom_text_field.dart';
import 'package:smartshop_map/shared/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshop_map/shared/widgets/custom_snackbar.dart';

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
                  const SizedBox(height: 140),

                  // Sign in Title - Left aligned
                  Text(
                    'Sign in',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 40),

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
                    controller: _emailController,
                    borderColor: _isEmailValid
                        ? const Color(0xFFE4DFDF)
                        : Colors.red,
                    onChanged: _onEmailChanged,
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  CustomTextField(
                    height: 60,
                    width: 350,
                    hintText: 'Your password',
                    obscureText: !_isPasswordVisible,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: const Color(0xFF807A7A),
                      size: 25,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    controller: _passwordController,
                    borderColor: _isPasswordValid
                        ? const Color(0xFFE4DFDF)
                        : Colors.red,
                    onChanged: _onPasswordChanged,
                  ),

                  const SizedBox(height: 20),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Switch(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          Text(
                            'Remember Me',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 23 / 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to verification
                          context.go('/verificationView');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 23 / 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Sign In Button - Centered
                  Center(
                    child: CustomButton(
                      text: '     SIGN IN',
                      height: 66,
                      width: 271,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      isSignInButton: true,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Noto Kufi Arabic',
                      suffixWidget: SvgPicture.asset(
                        'assets/images/arrow.svg',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: _onSignInPressed,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // OR Separator
                  Center(
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 23 / 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Google Login Button
                  Center(
                    child: SocialLoginButton(
                      text: 'Login with Google',
                      imagePath: 'assets/images/Google.svg',
                      height: 66,
                      width: 250,
                      borderRadius: BorderRadius.circular(12),
                      backgroundColor: Colors.white,
                      borderColor: const Color(0xFFE4DFDF),
                      textColor: AppColors.primary,
                      onPressed: () {
                        // Handle Google login
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Facebook Login Button
                  Center(
                    child: SocialLoginButton(
                      text: 'Login with FaceBook',
                      imagePath: 'assets/images/faceBook.svg',
                      height: 66,
                      width: 250,
                      borderRadius: BorderRadius.circular(12),
                      backgroundColor: Colors.white,
                      borderColor: const Color(0xFFE4DFDF),
                      textColor: AppColors.primary,
                      onPressed: () {
                        // Handle Facebook login
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Sign Up Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 23 / 14,
                            color: AppColors.primary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/signUpView');
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 23 / 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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
