import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SectionHotelDetailsButton extends StatelessWidget {
  final Map<String, dynamic> hotelData;

  const SectionHotelDetailsButton({super.key, required this.hotelData});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 50,
      right: 50,
      child: ElevatedButton(
        onPressed: () {
          context.push('/hotelBooking', extra: hotelData);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7F2F3A),
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
              'BOOK HOTEL',
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
