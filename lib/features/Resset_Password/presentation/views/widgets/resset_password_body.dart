import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../shared/shared.dart';

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
                  const SizedBox(height: 14),

                  // Back Arrow and Title Row
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.go('/verificationView');
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Main Title
                  Text(
                    '  Resset Password',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Instructions
                  Text(
                    '   Please enter your email address\n   to request a password reset',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 23 / 16,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Email Input Field
                  Center(
                    child: CustomTextField(
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
                  ),

                  const SizedBox(height: 40),

                  // Password Fields (shown after email is sent)
                  if (_showPasswordFields) ...[
                    // New Password Field
                    Center(
                      child: CustomTextField(
                        height: 60,
                        width: 350,
                        hintText: 'New password',
                        obscureText: !_isNewPasswordVisible,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: const Color(0xFF807A7A),
                          size: 25,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isNewPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        controller: _newPasswordController,
                        borderColor: const Color(0xFFE4DFDF),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password Field
                    Center(
                      child: CustomTextField(
                        height: 60,
                        width: 350,
                        hintText: 'Confirm new password',
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
                    ),

                    const SizedBox(height: 40),
                  ],

                  // Send/Confirm Button
                  Center(
                    child: CustomButton(
                      text: _showPasswordFields ? '     CONFIRM' : '     SEND',
                      height: 66,
                      width: 271,
                      backgroundColor: _showPasswordFields
                          ? (_isPasswordValid && _isConfirmPasswordValid
                                ? AppColors.primary
                                : Colors.grey.shade300)
                          : (_isEmailValid
                                ? AppColors.primary
                                : Colors.grey.shade300),
                      textColor: _showPasswordFields
                          ? (_isPasswordValid && _isConfirmPasswordValid
                                ? Colors.white
                                : Colors.grey.shade600)
                          : (_isEmailValid
                                ? Colors.white
                                : Colors.grey.shade600),
                      borderRadius: BorderRadius.circular(12),
                      isSignInButton: true,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Noto Kufi Arabic',
                      suffixWidget: SvgPicture.asset(
                        'assets/images/arrow.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          _showPasswordFields
                              ? (_isPasswordValid && _isConfirmPasswordValid
                                    ? Colors.white
                                    : Colors.grey.shade600)
                              : (_isEmailValid
                                    ? Colors.white
                                    : Colors.grey.shade600),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: _showPasswordFields
                          ? (_isPasswordValid && _isConfirmPasswordValid
                                ? _onConfirmPressed
                                : null)
                          : (_isEmailValid ? _onSendPressed : null),
                    ),
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
