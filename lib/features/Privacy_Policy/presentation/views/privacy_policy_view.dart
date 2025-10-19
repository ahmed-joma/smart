import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/shared.dart';
import 'widgets/privacy_policy_body.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/settingsView');
            }
          },
        ),
      ),
      body: const PrivacyPolicyBody(),
    );
  }
}
