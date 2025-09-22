import 'package:flutter/material.dart';
import 'widgets/verification_body.dart';

class VerificationView extends StatelessWidget {
  final String? userEmail;

  const VerificationView({super.key, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return VerificationBody(userEmail: userEmail);
  }
}
