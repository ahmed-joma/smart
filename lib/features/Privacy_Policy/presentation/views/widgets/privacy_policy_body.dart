import 'package:flutter/material.dart';
import '../../../../../shared/shared.dart';

class PrivacyPolicyBody extends StatelessWidget {
  const PrivacyPolicyBody({super.key});

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

          // Privacy Content
          _buildPrivacyContent(),

          const SizedBox(height: 24),

          // Data Rights
          _buildDataRights(),

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
          Icon(Icons.privacy_tip_outlined, color: Colors.white, size: 40),
          const SizedBox(height: 16),
          Text(
            'Privacy Policy',
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

  Widget _buildPrivacyContent() {
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
            '1. Information We Collect',
            'We collect information you provide directly to us, such as when you create an account, make a booking, or contact us for support. This may include your name, email address, phone number, payment information, and preferences.',
          ),

          _buildSection(
            '2. How We Use Your Information',
            'We use the information we collect to provide, maintain, and improve our services, process transactions, send you technical notices and support messages, and communicate with you about products, services, and promotional offers.',
          ),

          _buildSection(
            '3. Information Sharing',
            'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this privacy policy. We may share your information with service providers who assist us in operating our app.',
          ),

          _buildSection(
            '4. Data Security',
            'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
          ),

          _buildSection(
            '5. Location Information',
            'We may collect and use location information to provide location-based services, such as finding nearby hotels and events. You can disable location services through your device settings.',
          ),

          _buildSection(
            '6. Cookies and Tracking',
            'We use cookies and similar tracking technologies to enhance your experience, analyze usage patterns, and provide personalized content. You can control cookie preferences through your device settings.',
          ),

          _buildSection(
            '7. Third-Party Services',
            'Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to read their privacy policies.',
          ),

          _buildSection(
            '8. Children\'s Privacy',
            'Our services are not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If we become aware that we have collected such information, we will take steps to delete it.',
          ),

          _buildSection(
            '9. Data Retention',
            'We retain your personal information for as long as necessary to provide our services and fulfill the purposes outlined in this privacy policy, unless a longer retention period is required by law.',
          ),

          _buildSection(
            '10. International Transfers',
            'Your information may be transferred to and processed in countries other than your own. We ensure that such transfers comply with applicable data protection laws.',
          ),

          _buildSection(
            '11. Changes to This Policy',
            'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page and updating the "Last updated" date.',
          ),

          _buildSection(
            '12. Contact Us',
            'If you have any questions about this privacy policy, please contact us at privacy@smartevent.com.',
          ),
        ],
      ),
    );
  }

  Widget _buildDataRights() {
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
            'Your Data Rights',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          _buildRightItem(
            Icons.accessibility_new,
            'Access',
            'You have the right to access your personal data and obtain information about how we process it.',
          ),

          _buildRightItem(
            Icons.edit,
            'Rectification',
            'You have the right to correct inaccurate or incomplete personal data.',
          ),

          _buildRightItem(
            Icons.delete_outline,
            'Erasure',
            'You have the right to request the deletion of your personal data under certain circumstances.',
          ),

          _buildRightItem(
            Icons.block,
            'Restriction',
            'You have the right to restrict the processing of your personal data in certain situations.',
          ),

          _buildRightItem(
            Icons.file_download,
            'Portability',
            'You have the right to receive your personal data in a structured, machine-readable format.',
          ),

          _buildRightItem(
            Icons.handshake,
            'Objection',
            'You have the right to object to the processing of your personal data for marketing purposes.',
          ),
        ],
      ),
    );
  }

  Widget _buildRightItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
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
            'Questions About Privacy?',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'If you have any questions about our privacy practices or this privacy policy, please contact us.',
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
                'privacy@smartevent.com',
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
