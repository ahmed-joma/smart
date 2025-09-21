import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../shared/shared.dart';
import '../../manager/password_reset_cubit.dart';
import 'section_header.dart';
import 'section_email_field.dart';

class EnterEmailBody extends StatefulWidget {
  const EnterEmailBody({super.key});

  @override
  State<EnterEmailBody> createState() => _EnterEmailBodyState();
}

class _EnterEmailBodyState extends State<EnterEmailBody> {
  final _emailController = TextEditingController();
  bool _isEmailValid = true;

  void _onEmailChanged(String value) {
    if (!_isEmailValid) {
      setState(() {
        _isEmailValid = true;
      });
    }
  }

  void _onConfirmPressed(BuildContext context) {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _isEmailValid = false;
      });
      return;
    }

    // Call API to send reset code
    context.read<PasswordResetCubit>().sendResetCode(
      _emailController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // دالة لمعالجة أخطاء إرسال كود إعادة التعيين
  void _handleSendCodeError(String apiMessage) {
    String title = '';
    String message = '';
    IconData icon = Icons.error;
    Color color = Colors.red;

    if (apiMessage.toLowerCase().contains('email not found') ||
        apiMessage.toLowerCase().contains('user not found')) {
      title = '👤 Email Not Found';
      message =
          'No account found with this email address.\nPlease check your email or sign up for a new account.';
      icon = Icons.person_search;
      color = Colors.orange;
    } else if (apiMessage.toLowerCase().contains('invalid email') ||
        apiMessage.toLowerCase().contains('email format')) {
      title = '📧 Invalid Email';
      message = 'Please enter a valid email address\n(e.g., user@gmail.com)';
      icon = Icons.email_outlined;
      color = Colors.orange;
    } else if (apiMessage.toLowerCase().contains('too many requests') ||
        apiMessage.toLowerCase().contains('rate limit')) {
      title = '⏰ Too Many Requests';
      message =
          'You have requested too many reset codes.\nPlease wait before requesting again.';
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
      title = '❌ Failed to Send Code';
      message =
          'Could not send reset code.\nPlease check your email and try again.';
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
      create: (context) => PasswordResetCubit(),
      child: BlocListener<PasswordResetCubit, PasswordResetState>(
        listener: (context, state) {
          if (state is SendCodeSuccess) {
            _showSuccessDialog(
              '📧 Reset Code Sent!',
              'A password reset code has been sent to your email.\nPlease check your inbox.',
              () => context.go(
                '/ressetPasswordView?email=${Uri.encodeComponent(_emailController.text.trim())}',
              ),
            );
          } else if (state is SendCodeError) {
            _handleSendCodeError(state.message);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SectionHeader(),
                  const SizedBox(height: 40),
                  SectionEmailField(
                    emailController: _emailController,
                    isEmailValid: _isEmailValid,
                    onEmailChanged: _onEmailChanged,
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<PasswordResetCubit, PasswordResetState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: state is SendCodeLoading
                            ? 'Sending...'
                            : '   CONFIRM',
                        onPressed: state is SendCodeLoading
                            ? null
                            : () => _onConfirmPressed(context),
                        width: 271,
                        height: 66,
                        fontFamily: 'Noto Kufi Arabic',
                        isSignInButton: true,
                        suffixWidget: state is SendCodeLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/images/arrow.svg',
                                width: 24,
                                height: 24,
                              ),
                      );
                    },
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
