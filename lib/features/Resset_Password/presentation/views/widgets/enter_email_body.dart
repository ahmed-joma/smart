import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../shared/shared.dart';
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

  void _onConfirmPressed() {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _isEmailValid = false;
      });
      return;
    }

    // Navigate to reset password page with email
    context.go('/ressetPasswordView');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              CustomButton(
                text: '   CONFIRM',
                onPressed: _onConfirmPressed,
                width: 271,
                height: 66,
                fontFamily: 'Noto Kufi Arabic',
                isSignInButton: true,
                suffixWidget: SvgPicture.asset(
                  'assets/images/arrow.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
