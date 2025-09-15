import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/widgets/custom_snackbar.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationCubit(),
      child: BlocListener<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            // Show success notification
            CustomSnackBar.showSuccess(
              context: context,
              message: 'Email verified successfully!',
              duration: const Duration(seconds: 2),
            );
            // Navigate to home page after showing notification
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.go('/homeView');
              }
            });
          } else if (state is VerificationError) {
            // Show error notification
            CustomSnackBar.showError(
              context: context,
              message: state.message,
              duration: const Duration(seconds: 3),
            );
          } else if (state is ResendCodeSuccess) {
            // Show success notification for resend
            CustomSnackBar.showSuccess(
              context: context,
              message: 'Verification code sent again',
              duration: const Duration(seconds: 2),
            );
          } else if (state is ResendCodeError) {
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
