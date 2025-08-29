import 'package:flutter/material.dart';
import '../../../../../../shared/shared.dart';

class SectionBuyTicketButton extends StatelessWidget {
  final String price;

  const SectionBuyTicketButton({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 50, // لجعل الزر أضيق
      right: 50, // لجعل الزر أضيق
      child: ElevatedButton(
        onPressed: () {
          // Handle buy ticket action
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
