import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../shared/shared.dart';

class SectionBuyTicketButton extends StatelessWidget {
  final String price;
  final Map<String, dynamic>? eventData;

  const SectionBuyTicketButton({
    super.key,
    required this.price,
    this.eventData,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 50, // لجعل الزر أضيق
      right: 50, // لجعل الزر أضيق
      child: ElevatedButton(
        onPressed: () => _showTicketConfirmation(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BUY TICKET $price',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF3D56F0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTicketConfirmation(BuildContext context) {
    // تحويل السعر من "SR 120" إلى رقم
    final cleanPrice = price.replaceAll('SR', '').replaceAll(' ', '').trim();
    final priceValue = double.tryParse(cleanPrice) ?? 120.0;
    final taxAmount = priceValue * 0.15; // 15% ضريبة
    final totalPrice = priceValue + taxAmount; // السعر + الضريبة

    print('🎫 Original price: $price');
    print('🎫 Clean price: $cleanPrice');
    print('🎫 Price value: $priceValue');
    print('🎫 Tax amount (15%): $taxAmount');
    print('🎫 Total price: $totalPrice');

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.confirmation_number, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'Confirm Ticket Purchase',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventData?['title'] ?? 'City Walk Event',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    eventData?['date'] ?? '14 December, 2025',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      eventData?['location'] ?? 'Jeddah King Abdulaziz Road',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ticket Price:'),
                  Text(
                    'SR ${priceValue.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tax & Fees (15%):'),
                  Text(
                    'SR ${taxAmount.toStringAsFixed(1)}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'SR ${totalPrice.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _proceedToPayment(context, totalPrice);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirm & Pay'),
            ),
          ],
        );
      },
    );
  }

  void _proceedToPayment(BuildContext context, double totalPrice) {
    // حساب الضريبة مرة أخرى
    final cleanPrice = price.replaceAll('SR', '').replaceAll(' ', '').trim();
    final priceValue = double.tryParse(cleanPrice) ?? 120.0;
    final taxAmount = priceValue * 0.15; // 15% ضريبة
    // Get event ID from eventData
    int? eventId;
    if (eventData != null) {
      if (eventData!['id'] is int) {
        eventId = eventData!['id'] as int;
      } else if (eventData!['id'] is String) {
        eventId = int.tryParse(eventData!['id']);
      } else if (eventData!['eventId'] is int) {
        eventId = eventData!['eventId'] as int;
      } else if (eventData!['eventId'] is String) {
        eventId = int.tryParse(eventData!['eventId']);
      }
    }

    // Fallback event ID if not found
    if (eventId == null) {
      eventId = 1; // Default event ID for testing
      print('⚠️ Event ID not found, using fallback ID: $eventId');
    }

    final orderData = {
      // Real API data
      'title': eventData?['title'] ?? 'City Walk event',
      'date': eventData?['date'] ?? '14 December, 2025',
      'location': eventData?['location'] ?? 'Jeddah King Abdulaziz Road, KSA',
      'image': eventData?['image'] ?? 'assets/images/citywaikevents.svg',
      // Pricing
      'price': price,
      'tax': 'SR ${taxAmount.toStringAsFixed(1)}',
      'total': 'SR ${totalPrice.toStringAsFixed(1)}',
      'type': 'event',
      // API integration data
      'event_id': eventId,
      'total_price': totalPrice,
      'api_integration': true,
      // Additional API data for display
      'organizer': eventData?['organizer'],
      'about': eventData?['about'],
      'attendees': eventData?['attendees'],
      'city': eventData?['city'],
    };
    context.push('/orderSummary', extra: orderData);
  }
}
