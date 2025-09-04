import 'package:flutter/material.dart';

class SectionPriceSummary extends StatelessWidget {
  final double basePrice;
  final int selectedRooms;
  final int selectedBeds;
  final int selectedGuests;
  final int selectedNights;
  final double totalPrice;

  const SectionPriceSummary({
    super.key,
    required this.basePrice,
    required this.selectedRooms,
    required this.selectedBeds,
    required this.selectedGuests,
    required this.selectedNights,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow('Base Price', 'SR $basePrice'),
          const SizedBox(height: 8),
          _buildPriceRow('Rooms × Beds', '$selectedRooms × $selectedBeds'),
          const SizedBox(height: 8),
          _buildPriceRow('Guests', '$selectedGuests'),
          const SizedBox(height: 8),
          _buildPriceRow('Nights', '$selectedNights'),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'SR ${totalPrice.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7F2F3A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }
}
