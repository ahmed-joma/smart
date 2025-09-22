import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../manager/sign_up_cubit.dart';
import 'section_header.dart';
import 'section_form_fields.dart';
import 'section_signup_button.dart';
import 'section_social_login.dart';
import 'section_signin_link.dart';

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

  // متغيرات للتحقق من صحة البيانات
  bool _isFullNameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  // رسائل الخطأ
  String _passwordErrorMessage = '';
  String _confirmPasswordErrorMessage = '';

  // دالة للتحقق من قوة كلمة المرور
  String _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return '';
  }

  // دوال لإعادة تعيين حالة الحقول عند الكتابة
  void _onFullNameChanged(String value) {
    if (_isFullNameValid != true) {
      setState(() {
        _isFullNameValid = true;
      });
    }
  }

  void _onEmailChanged(String value) {
    if (_isEmailValid != true) {
      setState(() {
        _isEmailValid = true;
      });
    }
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordErrorMessage = _validatePassword(value);
      _isPasswordValid = _passwordErrorMessage.isEmpty;
    });
  }

  void _onConfirmPasswordChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordErrorMessage = 'Please confirm your password';
        _isConfirmPasswordValid = false;
      } else if (value != _passwordController.text) {
        _confirmPasswordErrorMessage = 'Passwords do not match';
        _isConfirmPasswordValid = false;
      } else {
        _confirmPasswordErrorMessage = '';
        _isConfirmPasswordValid = true;
      }
    });
  }

  void _onTogglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _onToggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed(BuildContext context) {
    // Validate all fields
    bool isValid = true;

    if (_fullNameController.text.trim().isEmpty) {
      setState(() => _isFullNameValid = false);
      isValid = false;
    }

    if (_emailController.text.trim().isEmpty) {
      setState(() => _isEmailValid = false);
      isValid = false;
    }

    // Validate password with detailed requirements
    _passwordErrorMessage = _validatePassword(_passwordController.text);
    if (_passwordErrorMessage.isNotEmpty) {
      setState(() => _isPasswordValid = false);
      isValid = false;
    }

    // Validate confirm password
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordErrorMessage = 'Please confirm your password';
        _isConfirmPasswordValid = false;
      });
      isValid = false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordErrorMessage = 'Passwords do not match';
        _isConfirmPasswordValid = false;
      });
      isValid = false;
    }

    if (!isValid) return;

    // Clear errors
    setState(() {
      _isFullNameValid = true;
      _isEmailValid = true;
      _isPasswordValid = true;
      _isConfirmPasswordValid = true;
    });

    // Call API through Cubit
    context.read<SignUpCubit>().signUp(
      name: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
  }

  // دالة ذكية لمعالجة أخطاء التسجيل
  void _handleSignUpError(String apiMessage) {
    String title = '';
    String message = '';
    IconData icon = Icons.error;
    Color color = Colors.red;

    if (apiMessage.toLowerCase().contains('email has already been taken') ||
        apiMessage.toLowerCase().contains('email already exists')) {
      title = '📧 Email Already Registered';
      message =
          'This email is already registered.\nWould you like to sign in instead?';
      icon = Icons.email;
      color = Colors.orange;

      _showEmailExistsDialog();
      return;
    } else if (apiMessage.toLowerCase().contains('password') &&
        (apiMessage.toLowerCase().contains('weak') ||
            apiMessage.toLowerCase().contains('requirement') ||
            apiMessage.toLowerCase().contains('invalid'))) {
      title = '🔐 Weak Password';
      message =
          'Password does not meet requirements.\nPlease check the requirements below.';
      icon = Icons.security;
      color = Colors.orange;
    } else if (apiMessage.toLowerCase().contains('name') ||
        apiMessage.toLowerCase().contains('full name')) {
      title = '👤 Invalid Name';
      message =
          'Please enter a valid full name.\nName should be at least 2 characters.';
      icon = Icons.person_outline;
      color = Colors.orange;
    } else if (apiMessage.toLowerCase().contains('email') &&
        apiMessage.toLowerCase().contains('invalid')) {
      title = '📧 Invalid Email';
      message = 'Please enter a valid email address\n(e.g., user@gmail.com)';
      icon = Icons.email_outlined;
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
      title = '❌ Registration Failed';
      message =
          'Something went wrong during registration.\nPlease check your information and try again.';
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

  // حوار خاص للإيميل المسجل مسبقاً
  void _showEmailExistsDialog() {
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
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_pin,
                    size: 30,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '📧 Email Already Registered',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'This email is already registered.\nWould you like to sign in instead?',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.go('/signInView');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      onContinue != null ? 'Continue to Verification' : 'OK',
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
      create: (context) => SignUpCubit(),
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            _showSuccessDialog(
              '🎉 Account Created!',
              'Your account has been created successfully.\nPlease check your email for verification.',
              () =>
                  context.go('/verificationView', extra: _emailController.text),
            );
          } else if (state is SignUpError) {
            _handleSignUpError(state.message);
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

                      // Form Fields Section
                      SectionFormFields(
                        fullNameController: _fullNameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        isFullNameValid: _isFullNameValid,
                        isEmailValid: _isEmailValid,
                        isPasswordValid: _isPasswordValid,
                        isConfirmPasswordValid: _isConfirmPasswordValid,
                        isPasswordVisible: _isPasswordVisible,
                        isConfirmPasswordVisible: _isConfirmPasswordVisible,
                        passwordErrorMessage: _passwordErrorMessage,
                        confirmPasswordErrorMessage:
                            _confirmPasswordErrorMessage,
                        onFullNameChanged: _onFullNameChanged,
                        onEmailChanged: _onEmailChanged,
                        onPasswordChanged: _onPasswordChanged,
                        onConfirmPasswordChanged: _onConfirmPasswordChanged,
                        onTogglePasswordVisibility: _onTogglePasswordVisibility,
                        onToggleConfirmPasswordVisibility:
                            _onToggleConfirmPasswordVisibility,
                      ),

                      // Sign Up Button Section
                      BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) {
                          return SectionSignUpButton(
                            onPressed: state is SignUpLoading
                                ? null
                                : () => _onSignUpPressed(context),
                            isLoading: state is SignUpLoading,
                          );
                        },
                      ),

                      // Social Login Section
                      const SectionSocialLogin(),

                      // Sign In Link Section
                      const SectionSignInLink(),

                      const SizedBox(height: 20),
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
