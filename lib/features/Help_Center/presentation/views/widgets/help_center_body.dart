import 'package:flutter/material.dart';
import '../../../../../shared/shared.dart';

class HelpCenterBody extends StatelessWidget {
  const HelpCenterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(),

          const SizedBox(height: 24),

          // Quick Help Section
          _buildQuickHelpSection(),

          const SizedBox(height: 24),

          // FAQ Section
          _buildFAQSection(),

          const SizedBox(height: 24),

          // Contact Support Section
          _buildContactSupportSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
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
          Icon(Icons.help_outline, color: Colors.white, size: 40),
          const SizedBox(height: 16),
          Text(
            'Welcome to Help Center',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re here to help you get the most out of Smart Events & Hotels. Find answers to common questions and get support when you need it.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickHelpSection() {
    return _buildSection('Quick Help', Icons.flash_on, [
      _buildHelpItem(
        'How to book a hotel?',
        'Learn how to find and book the perfect hotel for your stay.',
        Icons.hotel,
      ),
      _buildHelpItem(
        'How to buy event tickets?',
        'Step-by-step guide to purchasing tickets for events.',
        Icons.event,
      ),
      _buildHelpItem(
        'Managing your bookings',
        'View, modify, or cancel your existing bookings.',
        Icons.calendar_today,
      ),
      _buildHelpItem(
        'Payment methods',
        'Information about accepted payment methods and security.',
        Icons.payment,
      ),
    ]);
  }

  Widget _buildFAQSection() {
    return _buildSection('Frequently Asked Questions', Icons.quiz, [
      _buildFAQItem(
        'How do I create an account?',
        'Tap "Sign Up" on the login screen, enter your details, verify your email, and you\'re ready to go!',
      ),
      _buildFAQItem(
        'Can I cancel my booking?',
        'Yes! You can cancel most bookings up to 24 hours before the event or check-in date.',
      ),
      _buildFAQItem(
        'What payment methods do you accept?',
        'We accept credit cards, PayPal, and Apple Pay for your convenience.',
      ),
      _buildFAQItem(
        'How do I contact customer support?',
        'You can reach us through the Contact Us section or email us at support@smartevent.com',
      ),
      _buildFAQItem(
        'Is my personal information secure?',
        'Absolutely! We use industry-standard encryption to protect your data and never share it with third parties.',
      ),
    ]);
  }

  Widget _buildContactSupportSection() {
    return _buildSection('Contact Support', Icons.support_agent, [
      _buildContactItem(
        'Email Support',
        'Get help via email within 24 hours',
        Icons.email,
        'support@smartevent.com',
      ),
      _buildContactItem(
        'Live Chat',
        'Chat with our support team in real-time',
        Icons.chat,
        'Available 9 AM - 6 PM',
      ),
      _buildContactItem(
        'Phone Support',
        'Call us for immediate assistance',
        Icons.phone,
        '+966 11 123 4567',
      ),
    ]);
  }

  Widget _buildSection(String title, IconData icon, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildHelpItem(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // TODO: Navigate to detailed help page
      },
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    String title,
    String subtitle,
    IconData icon,
    String contact,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            contact,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // TODO: Handle contact action
      },
    );
  }
}
