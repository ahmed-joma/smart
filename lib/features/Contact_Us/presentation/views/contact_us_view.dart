import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/shared.dart';
import 'widgets/contact_us_body.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Contact Us',
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
      body: const ContactUsBody(),
    );
  }
}
