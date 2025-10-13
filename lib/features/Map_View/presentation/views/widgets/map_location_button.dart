import 'package:flutter/material.dart';

class MapLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapLocationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7F2F3A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F2F3A).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.my_location, color: Colors.white),
        iconSize: 28,
        onPressed: onPressed,
      ),
    );
  }
}
