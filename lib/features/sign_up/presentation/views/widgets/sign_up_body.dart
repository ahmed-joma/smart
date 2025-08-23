import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/themes/app_text_styles.dart';
import 'package:smartshop_map/shared/widgets/custom_text_field.dart';
import 'package:smartshop_map/shared/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                  const SizedBox(height: 14),

                  // Back Arrow and Title Row
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.go('/signInView');
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sign up',
                        style: AppTextStyles.heading1.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

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
                    controller: _fullNameController,
                    borderColor: const Color(0xFFE4DFDF),
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
                    controller: _emailController,
                    borderColor: const Color(0xFFE4DFDF),
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
                    borderColor: const Color(0xFFE4DFDF),
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Field
                  CustomTextField(
                    height: 60,
                    width: 350,
                    hintText: 'Confirm password',
                    obscureText: !_isConfirmPasswordVisible,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: const Color(0xFF807A7A),
                      size: 25,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    controller: _confirmPasswordController,
                    borderColor: const Color(0xFFE4DFDF),
                  ),

                  const SizedBox(height: 32),

                  // Sign Up Button - Centered
                  Center(
                    child: CustomButton(
                      text: '     SIGN UP',
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
                      onPressed: () {
                        // Handle sign up
                        context.go('/homeView');
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // OR Separator without Lines
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

                  const SizedBox(height: 16),

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
                      text: 'Login with Facebook',
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

                  const SizedBox(height: 30),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Already have an account? ',
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
                            context.go('/signInView');
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign In',
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
