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
        onPressed: () {
          // تحويل السعر من "SR 120" إلى رقم
          final priceValue =
              double.tryParse(price.replaceAll('SR ', '')) ?? 120.0;
          final totalPrice = priceValue + 18.0; // إضافة الضريبة

          final orderData = {
            'title': eventData?['title'] ?? 'City Walk event',
            'date': eventData?['date'] ?? '14 December, 2025',
            'location':
                '${eventData?['location'] ?? 'Jeddah King Abdulaziz Road'}, ${eventData?['country'] ?? 'KSA'}',
            'price': price,
            'tax': 'SR 18',
            'total': 'SR ${totalPrice.toStringAsFixed(1)}',
            'type': 'event',
            'image': eventData?['image'] ?? 'assets/images/citywaikevents.svg',
          };
          context.push('/orderSummary', extra: orderData);
        },
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
}
