import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/shared.dart';
import 'package:smartshop_map/shared/widgets/custom_snackbar.dart';
import '../../manager/password_reset_cubit.dart';
import 'section_header.dart';
import 'section_instructions.dart';
import 'section_password_fields.dart';
import 'section_action_button.dart';

class RessetPasswordBody extends StatefulWidget {
  const RessetPasswordBody({super.key});

  @override
  State<RessetPasswordBody> createState() => _RessetPasswordBodyState();
}

class _RessetPasswordBodyState extends State<RessetPasswordBody> {
  final List<TextEditingController> _codeControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _showPasswordFields = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  int _resendTimer = 300; // 5 minutes (300 seconds)
  bool _canResend = false;

  // Email variable - will be received from route parameters
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Get email from route parameters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = Uri.parse(GoRouterState.of(context).uri.toString());
      final email = uri.queryParameters['email'];
      if (email != null) {
        setState(() {
          _userEmail = Uri.decodeComponent(email);
        });
        print('📧 Email received from route: $_userEmail');
      } else {
        print('⚠️ No email found in route parameters');
      }

      // Auto-focus first field
      _focusNodes[0].requestFocus();
    });

    _newPasswordController.addListener(_checkPasswordValidity);
    _confirmPasswordController.addListener(_checkPasswordValidity);
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _newPasswordController.removeListener(_checkPasswordValidity);
    _confirmPasswordController.removeListener(_checkPasswordValidity);
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        _startTimer();
      } else if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  String _formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      // Move to next field
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on delete
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _verificationCode {
    return _codeControllers.map((controller) => controller.text).join();
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? AppColors.success : AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? AppColors.success : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _checkPasswordValidity() {
    setState(() {
      // Check password requirements as per API documentation
      String password = _newPasswordController.text;
      bool hasMinLength = password.length >= 8;
      bool hasNumber = password.contains(RegExp(r'[0-9]'));
      bool hasSpecialChar = password.contains(
        RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
      );

      _isPasswordValid = hasMinLength && hasNumber && hasSpecialChar;

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

  void _onSendPressed(BuildContext context) {
    // Verify code first
    if (_verificationCode.length == 4) {
      print('🔍 Code entered: $_verificationCode for email: $_userEmail');

      // Show password fields - code will be verified when submitting password
      setState(() {
        _showPasswordFields = true;
      });

      // Show info message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code accepted! Please enter your new password.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onConfirmPressed(BuildContext context) {
    if (_isPasswordValid && _isConfirmPasswordValid) {
      print('🔄 Password Reset Request:');
      print('📧 Email: $_userEmail');
      print('🔢 Code: $_verificationCode');
      print('🔐 Password: ${_newPasswordController.text}');

      // Call API to reset password
      context.read<PasswordResetCubit>().resetPassword(
        email: _userEmail,
        code: _verificationCode,
        password: _newPasswordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );
    }
  }

  void _onResendPressed(BuildContext context) {
    if (_userEmail.isNotEmpty) {
      setState(() {
        _resendTimer = 300; // Reset to 5 minutes
        _canResend = false;
      });
      _startTimer();

      // Call API to resend reset code
      context.read<PasswordResetCubit>().sendResetCode(_userEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordResetCubit(),
      child: BlocListener<PasswordResetCubit, PasswordResetState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            // Show success notification
            CustomSnackBar.showSuccess(
              context: context,
              message: 'Password reset successfully!',
              duration: const Duration(seconds: 2),
            );
            // Navigate to sign in after showing notification
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.go('/signInView');
              }
            });
          } else if (state is ResetPasswordError) {
            // Show error notification with debug info
            print('❌ Reset Password Error: ${state.message}');
            print('📧 Email used: $_userEmail');
            print('🔢 Code used: $_verificationCode');

            // Customize error message for better user experience
            String userMessage = state.message;
            if (state.message.contains('invalid') ||
                state.message.contains('expired')) {
              userMessage =
                  'The reset code is invalid or has expired. Please request a new code.';
            } else if (state.message.contains('email')) {
              userMessage = 'Email not found. Please check your email address.';
            } else if (state.message.contains('password')) {
              userMessage =
                  'Password requirements not met. Please check your password.';
            }

            CustomSnackBar.showError(
              context: context,
              message: userMessage,
              duration: const Duration(seconds: 4),
            );
          } else if (state is SendCodeSuccess) {
            // Show success notification for resend
            CustomSnackBar.showSuccess(
              context: context,
              message: 'Reset code sent again',
              duration: const Duration(seconds: 2),
            );
          } else if (state is SendCodeError) {
            // Show error notification for resend
            CustomSnackBar.showError(
              context: context,
              message: state.message,
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

                      // Instructions Section
                      const SectionInstructions(),

                      // Instructions
                      const SizedBox(height: 24),

                      // Verification Code Fields (same as Verification page)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return Container(
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _focusNodes[index].hasFocus
                                      ? AppColors.primary
                                      : const Color(0xFFE4DFDF),
                                  width: _focusNodes[index].hasFocus ? 6 : 6,
                                ),
                              ),
                              child: TextField(
                                controller: _codeControllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24,
                                  color: AppColors.primary,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '-',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                onChanged: (value) =>
                                    _onCodeChanged(value, index),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_canResend) ...[
                            Text(
                              'Resend code in ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              _formatTimer(_resendTimer),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ] else ...[
                            TextButton(
                              onPressed: () => _onResendPressed(context),
                              child: Text(
                                'Re-send code',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Password Fields Section (shown after email is sent)
                      if (_showPasswordFields) ...[
                        // Password Requirements Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.outline.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password Requirements:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildRequirementItem(
                                'At least 8 characters',
                                _newPasswordController.text.length >= 8,
                              ),
                              _buildRequirementItem(
                                'Contains at least one number',
                                _newPasswordController.text.contains(
                                  RegExp(r'[0-9]'),
                                ),
                              ),
                              _buildRequirementItem(
                                'Contains at least one special character (!@#\$%^&*)',
                                _newPasswordController.text.contains(
                                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                                ),
                              ),
                            ],
                          ),
                        ),

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
                      ],

                      // Action Button Section
                      BlocBuilder<PasswordResetCubit, PasswordResetState>(
                        builder: (context, state) {
                          return SectionActionButton(
                            showPasswordFields: _showPasswordFields,
                            isVerificationCodeValid:
                                _verificationCode.length == 4,
                            isPasswordValid: _isPasswordValid,
                            isConfirmPasswordValid: _isConfirmPasswordValid,
                            onPressed: _showPasswordFields
                                ? (_isPasswordValid &&
                                          _isConfirmPasswordValid &&
                                          state is! ResetPasswordLoading
                                      ? () => _onConfirmPressed(context)
                                      : null)
                                : (_verificationCode.length == 4 &&
                                          state is! SendCodeLoading
                                      ? () => _onSendPressed(context)
                                      : null),
                            isLoading:
                                state is ResetPasswordLoading ||
                                state is SendCodeLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 40),
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
