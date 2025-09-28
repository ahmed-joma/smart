import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';

class HelpFaqsView extends StatefulWidget {
  const HelpFaqsView({super.key});

  @override
  State<HelpFaqsView> createState() => _HelpFaqsViewState();
}

class _HelpFaqsViewState extends State<HelpFaqsView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _expandedItems = [];

  final List<String> _categories = [
    'All',
    'Account',
    'Bookings',
    'Payments',
    'Events',
    'Hotels',
    'Technical',
  ];

  final List<Map<String, dynamic>> _faqs = [
    {
      'category': 'Account',
      'question': 'How do I create an account?',
      'answer':
          'To create an account, tap on "Sign Up" on the login screen, enter your email address, create a password, and verify your email. You can also sign up using your Google or Apple ID.',
    },
    {
      'category': 'Account',
      'question': 'How do I reset my password?',
      'answer':
          'Go to the login screen and tap "Forgot Password". Enter your email address and we\'ll send you a link to reset your password. Check your email and follow the instructions.',
    },
    {
      'category': 'Account',
      'question': 'How do I update my profile information?',
      'answer':
          'Go to Settings > Edit Profile. You can update your name, email, phone number, and profile picture. Changes are saved automatically.',
    },
    {
      'category': 'Bookings',
      'question': 'How do I book a hotel?',
      'answer':
          'Search for hotels using the search bar, select your dates, choose a hotel, and proceed to payment. You\'ll receive a confirmation email with your booking details.',
    },
    {
      'category': 'Bookings',
      'question': 'How do I book event tickets?',
      'answer':
          'Browse events in the Events section, select an event, choose your tickets, and complete the payment. Your tickets will be available in the app and sent via email.',
    },
    {
      'category': 'Bookings',
      'question': 'Can I cancel my booking?',
      'answer':
          'Yes, you can cancel bookings within the cancellation policy. Go to My Bookings, select the booking, and tap "Cancel". Refunds are processed according to the cancellation terms.',
    },
    {
      'category': 'Payments',
      'question': 'What payment methods do you accept?',
      'answer':
          'We accept all major credit cards (Visa, Mastercard, American Express), debit cards, PayPal, Apple Pay, Google Pay, and bank transfers.',
    },
    {
      'category': 'Payments',
      'question': 'Is my payment information secure?',
      'answer':
          'Yes, all payments are processed securely using industry-standard encryption. We never store your full payment details on our servers.',
    },
    {
      'category': 'Payments',
      'question': 'How do I get a refund?',
      'answer':
          'Refunds are processed automatically for cancellations within the policy. For other cases, contact our support team with your booking reference number.',
    },
    {
      'category': 'Events',
      'question': 'How do I find events near me?',
      'answer':
          'Enable location services in your device settings, and the app will automatically show events near your location. You can also search by city or venue.',
    },
    {
      'category': 'Events',
      'question': 'Can I get notifications for new events?',
      'answer':
          'Yes, go to Settings > Notifications and enable event notifications. You can customize which types of events you want to be notified about.',
    },
    {
      'category': 'Events',
      'question': 'How do I add events to my favorites?',
      'answer':
          'Tap the heart icon on any event to add it to your favorites. You can view all your favorite events in the Favorites section.',
    },
    {
      'category': 'Hotels',
      'question': 'How do I search for hotels?',
      'answer':
          'Use the search bar to enter your destination, select check-in and check-out dates, and choose the number of guests. You can also filter by price, rating, and amenities.',
    },
    {
      'category': 'Hotels',
      'question': 'What amenities are included?',
      'answer':
          'Amenities vary by hotel. Common amenities include WiFi, parking, pool, gym, restaurant, and room service. Check the hotel details for a complete list.',
    },
    {
      'category': 'Hotels',
      'question': 'Can I modify my hotel booking?',
      'answer':
          'Yes, you can modify your booking through the app. Go to My Bookings, select your hotel booking, and tap "Modify". Changes are subject to availability and policy.',
    },
    {
      'category': 'Technical',
      'question': 'The app is not loading properly',
      'answer':
          'Try closing and reopening the app, check your internet connection, or restart your device. If the problem persists, contact our technical support.',
    },
    {
      'category': 'Technical',
      'question': 'How do I update the app?',
      'answer':
          'Go to your device\'s app store (Google Play Store or App Store), search for our app, and tap "Update" if an update is available.',
    },
    {
      'category': 'Technical',
      'question': 'The app crashes frequently',
      'answer':
          'Make sure you have the latest version of the app and your device\'s operating system. Clear the app cache or reinstall the app if needed.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Help & FAQs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            print('🔙 Help & FAQs: Back button pressed');
            if (context.canPop()) {
              context.pop();
              print('✅ Help & FAQs: Successfully popped');
            } else {
              print('❌ Help & FAQs: Cannot pop, navigating to home');
              context.go('/homeView');
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade700,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // FAQs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _getFilteredFaqs().length,
              itemBuilder: (context, index) {
                final faq = _getFilteredFaqs()[index];
                final isExpanded = _expandedItems.contains(faq);
                return _buildFaqItem(faq, isExpanded);
              },
            ),
          ),

          // Contact Support Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showContactSupportDialog(),
                icon: const Icon(Icons.support_agent),
                label: const Text('Contact Support'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredFaqs() {
    List<Map<String, dynamic>> filtered = _faqs;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((faq) => faq['category'] == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((faq) {
        return faq['question'].toLowerCase().contains(query) ||
            faq['answer'].toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  Widget _buildFaqItem(Map<String, dynamic> faq, bool isExpanded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            faq['question'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    faq['category'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: AppColors.primary,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expandedItems.add(faq);
              } else {
                _expandedItems.remove(faq);
              }
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq['answer'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need more help? Contact our support team:'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('support@smartevents.com'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('+966 50 123 4567'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('24/7 Support Available'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon('Contact Support');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Message'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature'),
        content: const Text(
          'This feature is coming soon! Stay tuned for updates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
