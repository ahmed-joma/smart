import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SectionBookHotelButton extends StatelessWidget {
  final double totalPrice;
  final Map<String, dynamic>? hotelData;
  final int selectedRooms;
  final int selectedBeds;
  final int selectedGuests;
  final int selectedNights;

  const SectionBookHotelButton({
    super.key,
    required this.totalPrice,
    required this.hotelData,
    required this.selectedRooms,
    required this.selectedBeds,
    required this.selectedGuests,
    required this.selectedNights,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              final orderData = {
                'title': hotelData?['title'] ?? 'Four Points by Sheraton',
                'date': hotelData?['date'] ?? 'Nov 15 2025',
                'location':
                    '${hotelData?['location'] ?? 'Jeddah Corniche'}, ${hotelData?['country'] ?? 'KSA'}',
                'price': 'SR ${totalPrice.toStringAsFixed(1)}',
                'image': hotelData?['image'] ?? 'assets/images/hotel.svg',
                'rooms': selectedRooms,
                'beds': selectedBeds,
                'guests': selectedGuests,
                'nights': selectedNights,
              };
              context.push('/paymentMethodSelection', extra: orderData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7F2F3A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              'BOOK HOTEL SR ${totalPrice.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
