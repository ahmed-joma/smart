import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../shared/shared.dart';
import '../../../../../shared/widgets/custom_snackbar.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordResetCubit(),
      child: BlocListener<PasswordResetCubit, PasswordResetState>(
        listener: (context, state) {
          if (state is SendCodeSuccess) {
            // Show success notification
            CustomSnackBar.showSuccess(
              context: context,
              message: 'Reset code sent successfully!',
              duration: const Duration(seconds: 2),
            );
            // Navigate to reset password page after showing notification
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.go('/ressetPasswordView');
              }
            });
          } else if (state is SendCodeError) {
            // Show error notification
            CustomSnackBar.showError(
              context: context,
              message: state.message,
              duration: const Duration(seconds: 3),
            );
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
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
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
