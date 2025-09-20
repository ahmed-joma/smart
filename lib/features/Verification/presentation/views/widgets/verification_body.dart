import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../manager/verification_cubit.dart';
import 'section_header.dart';
import 'section_email_info.dart';
import 'section_verification_fields.dart';
import 'section_continue_button.dart';
import 'section_resend_timer.dart';

class VerificationBody extends StatefulWidget {
  const VerificationBody({super.key});

  @override
  State<VerificationBody> createState() => _VerificationBodyState();
}

class _VerificationBodyState extends State<VerificationBody> {
  final List<TextEditingController> _codeControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // Email variable - can be changed based on user
  String _userEmail = 'ahmedjomma18@gmail.com';

  int _resendTimer = 300; // 5 minutes (300 seconds)
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
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

  String _formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _onResendPressed(BuildContext context) {
    setState(() {
      _resendTimer = 300; // Reset to 5 minutes
      _canResend = false;
    });
    _startTimer();

    // Call API to resend verification code
    context.read<VerificationCubit>().resendVerificationCode(_userEmail);
  }

  void _onVerifyPressed(BuildContext context) {
    if (_verificationCode.length == 4) {
      // Call API to verify email
      context.read<VerificationCubit>().verifyEmail(
        email: _userEmail,
        code: _verificationCode,
      );
    }
  }

  // دالة ذكية لمعالجة أخطاء التحقق
  void _handleVerificationError(String apiMessage) {
    String title = '';
    String message = '';
    IconData icon = Icons.error;
    Color color = Colors.red;

    if (apiMessage.toLowerCase().contains('invalid code') ||
        apiMessage.toLowerCase().contains('wrong code') ||
        apiMessage.toLowerCase().contains('incorrect code')) {
      title = '❌ Invalid Code';
      message =
          'The verification code you entered is incorrect.\nPlease check and try again.';
      icon = Icons.pin_outlined;
    } else if (apiMessage.toLowerCase().contains('expired') ||
        apiMessage.toLowerCase().contains('timeout')) {
      title = '⏰ Code Expired';
      message =
          'The verification code has expired.\nPlease request a new code.';
      icon = Icons.timer_off;
      color = Colors.orange;
    } else if (apiMessage.toLowerCase().contains('already verified')) {
      title = '✅ Already Verified';
      message = 'Your email is already verified.\nYou can proceed to login.';
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (apiMessage.toLowerCase().contains('too many attempts')) {
      title = '🚫 Too Many Attempts';
      message =
          'Too many verification attempts.\nPlease wait before trying again.';
      icon = Icons.block;
      color = Colors.orange;
    } else if (apiMessage.toLowerCase().contains('connection') ||
        apiMessage.toLowerCase().contains('network')) {
      title = '🌐 Connection Error';
      message = 'Please check your internet connection\nand try again.';
      icon = Icons.wifi_off;
      color = Colors.blue;
    } else {
      title = '❌ Verification Failed';
      message = 'Something went wrong during verification.\nPlease try again.';
      icon = Icons.error_outline;
    }

    _showErrorDialog(title, message, icon, color);
  }

  // دالة لمعالجة أخطاء إعادة الإرسال
  void _handleResendError(String apiMessage) {
    String title = '';
    String message = '';
    IconData icon = Icons.error;
    Color color = Colors.red;

    if (apiMessage.toLowerCase().contains('too many requests') ||
        apiMessage.toLowerCase().contains('rate limit')) {
      title = '⏰ Too Many Requests';
      message =
          'You have requested too many codes.\nPlease wait before requesting again.';
      icon = Icons.timer;
      color = Colors.orange;
    } else if (apiMessage.toLowerCase().contains('already verified')) {
      title = '✅ Already Verified';
      message = 'Your email is already verified.\nNo need to resend code.';
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (apiMessage.toLowerCase().contains('connection') ||
        apiMessage.toLowerCase().contains('network')) {
      title = '🌐 Connection Error';
      message =
          'Failed to send verification code.\nPlease check your connection.';
      icon = Icons.wifi_off;
      color = Colors.blue;
    } else {
      title = '❌ Failed to Send Code';
      message = 'Could not send verification code.\nPlease try again later.';
      icon = Icons.error_outline;
    }

    _showErrorDialog(title, message, icon, color);
  }

  // حوار مخصص للأخطاء
  void _showErrorDialog(
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

  // حوار النجاح
  void _showSuccessDialog(
    String title,
    String message,
    VoidCallback? onContinue,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 30,
                    color: Colors.green,
                  ),
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
                    onPressed: onContinue ?? () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      onContinue != null ? 'Continue' : 'OK',
                      style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationCubit(),
      child: BlocListener<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            _showSuccessDialog(
              '🎉 Email Verified!',
              'Your email has been verified successfully.\nWelcome to our platform!',
              () => context.go('/homeView'),
            );
          } else if (state is VerificationError) {
            _handleVerificationError(state.message);
          } else if (state is ResendCodeSuccess) {
            _showSuccessDialog(
              '📧 Code Sent!',
              'A new verification code has been sent to your email.\nPlease check your inbox.',
              null,
            );
          } else if (state is ResendCodeError) {
            _handleResendError(state.message);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: Column(
                children: [
                  // Top Section with all components
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        const SectionHeader(),

                        // Email Info Section
                        SectionEmailInfo(userEmail: _userEmail),

                        // Verification Fields Section
                        SectionVerificationFields(
                          codeControllers: _codeControllers,
                          focusNodes: _focusNodes,
                          onCodeChanged: _onCodeChanged,
                        ),

                        const SizedBox(height: 40),

                        // Continue Button Section
                        BlocBuilder<VerificationCubit, VerificationState>(
                          builder: (context, state) {
                            return SectionContinueButton(
                              onPressed:
                                  _verificationCode.length == 4 &&
                                      state is! VerificationLoading
                                  ? () => _onVerifyPressed(context)
                                  : null,
                              isLoading: state is VerificationLoading,
                            );
                          },
                        ),

                        // Resend Timer Section
                        BlocBuilder<VerificationCubit, VerificationState>(
                          builder: (context, state) {
                            return SectionResendTimer(
                              canResend:
                                  _canResend && state is! ResendCodeLoading,
                              resendTimer: _resendTimer,
                              onResendPressed: () => _onResendPressed(context),
                              formatTimer: _formatTimer,
                              isLoading: state is ResendCodeLoading,
                            );
                          },
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
