import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/themes/app_text_styles.dart';
import 'package:smartshop_map/shared/widgets/custom_text_field.dart';
import 'package:smartshop_map/shared/widgets/custom_button.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final _emailController = TextEditingController(text: 'ahlam@email.com');
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF5F5), Colors.white, Color(0xFFF8F5FF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center
              children: [
                const SizedBox(height: 80),

                // Sign in Title
                Text(
                  'Sign in',
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 24),

                // Email Field
                CustomTextField(
                  height: 48,
                  hintText: 'ahlam@email.com',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: const Color(0xFF807A7A),
                    size: 20,
                  ),
                  controller: _emailController,
                ),

                const SizedBox(height: 12),

                // Password Field
                CustomTextField(
                  height: 48,
                  hintText: 'Your password',
                  obscureText: !_isPasswordVisible,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: const Color(0xFF807A7A),
                    size: 20,
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
                ),

                const SizedBox(height: 16),

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
                            fontSize: 14,
                            height: 23 / 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to forgot password
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 23 / 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Sign In Button
                CustomButton(
                  text: 'SIGN IN',
                  height: 48,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  isSignInButton: true,
                  suffixWidget: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  onPressed: () {
                    context.go('/homeView');
                  },
                ),

                const SizedBox(height: 20),

                // OR Separator
                Center(
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 23 / 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Google Login Button
                SocialLoginButton(
                  text: 'Login with Google',
                  imagePath: 'assets/images/Google.svg',
                  height: 48,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () {
                    // Handle Google login
                  },
                ),

                const SizedBox(height: 12),

                // Facebook Login Button
                SocialLoginButton(
                  text: 'Login with Facebook',
                  imagePath: 'assets/images/faceBook.svg',
                  height: 48,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () {
                    // Handle Facebook login
                  },
                ),

                const Spacer(),

                // Sign Up Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 23 / 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go('/signUpView');
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
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
    );
  }
}
