import 'package:flutter/material.dart';
import '../../../../../shared/shared.dart';

class TermsOfServiceBody extends StatelessWidget {
  const TermsOfServiceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeaderSection(),

          const SizedBox(height: 24),

          // Terms Content
          _buildTermsContent(),

          const SizedBox(height: 24),

          // Contact Info
          _buildContactInfo(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.description_outlined, color: Colors.white, size: 40),
          const SizedBox(height: 16),
          Text(
            'Terms of Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: September 28, 2024',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            '1. Acceptance of Terms',
            'By accessing and using Smart Events & Hotels application, you accept and agree to be bound by the terms and provision of this agreement.',
          ),

          _buildSection(
            '2. Use License',
            'Permission is granted to temporarily download one copy of Smart Events & Hotels for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.',
          ),

          _buildSection(
            '3. User Accounts',
            'You are responsible for safeguarding the password and for maintaining the confidentiality of your account. You agree to accept responsibility for all activities that occur under your account.',
          ),

          _buildSection(
            '4. Booking and Payment',
            'All bookings and payments are subject to availability and confirmation. We reserve the right to refuse service, terminate accounts, remove or edit content at our sole discretion.',
          ),

          _buildSection(
            '5. Cancellation Policy',
            'Cancellation policies vary by event and hotel. Please review the specific cancellation terms before making a booking. Refunds are processed according to our refund policy.',
          ),

          _buildSection(
            '6. Privacy and Data Protection',
            'Your privacy is important to us. Please review our Privacy Policy, which also governs your use of the service, to understand our practices.',
          ),

          _buildSection(
            '7. Prohibited Uses',
            'You may not use our service for any unlawful purpose or to solicit others to perform unlawful acts. You may not violate any international, federal, provincial, or state regulations, rules, laws, or local ordinances.',
          ),

          _buildSection(
            '8. Content Liability',
            'We shall not be held responsible for any content that appears on your website. You agree to protect and defend us against all claims that are rising on your website.',
          ),

          _buildSection(
            '9. Disclaimer',
            'The information on this application is provided on an "as is" basis. To the fullest extent permitted by law, this Company excludes all representations, warranties, conditions and terms.',
          ),

          _buildSection(
            '10. Governing Law',
            'These terms and conditions are governed by and construed in accordance with the laws of Saudi Arabia and you irrevocably submit to the exclusive jurisdiction of the courts in that state or location.',
          ),

          _buildSection(
            '11. Changes to Terms',
            'We reserve the right, at our sole discretion, to modify or replace these Terms of Service at any time. If a revision is material, we will try to provide at least 30 days notice prior to any new terms taking effect.',
          ),

          _buildSection(
            '12. Contact Information',
            'If you have any questions about these Terms of Service, please contact us at legal@smartevent.com.',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions About These Terms?',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'If you have any questions about these Terms of Service, please don\'t hesitate to contact us.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.email, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'legal@smartevent.com',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.phone, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '+966 11 123 4567',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
