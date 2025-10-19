import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/shared.dart';
import 'widgets/terms_of_service_body.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Terms of Service',
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
      body: const TermsOfServiceBody(),
    );
  }
}
