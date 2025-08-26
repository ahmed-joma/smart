import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/themes/app_text_styles.dart';
import 'package:smartshop_map/shared/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Column(
            children: [
              // Top Section with Back Arrow and Title
              Padding(
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
                            context.go('/signInView');
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

                    const SizedBox(height: 16),

                    // Main Title
                    Text(
                      '  Verification',
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Email Text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '   We\'ve send you the verification',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 23 / 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '   code on ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 23 / 16,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              _userEmail,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 23 / 16,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Verification Code Input Fields
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
                                FilteringTextInputFormatter
                                    .digitsOnly, // يقبل الأرقام فقط
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

                    // Continue Button
                    Center(
                      child: CustomButton(
                        text: '     CONTINUE',
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
                        onPressed: _verificationCode.length == 4
                            ? () {
                                // Navigate to reset password
                                context.go('/ressetPasswordView');
                              }
                            : null,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Resend Code Timer - Clickable when timer is done
                    Center(
                      child: _canResend
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _resendTimer = 300; // Reset to 30 seconds
                                  _canResend = false;
                                });
                                _startTimer();
                              },
                              child: Text(
                                'Re-send code',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  height: 23 / 16,
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          : Text(
                              'Re-send code in ${_formatTimer(_resendTimer)}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 23 / 16,
                                color: AppColors.primary,
                              ),
                            ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
