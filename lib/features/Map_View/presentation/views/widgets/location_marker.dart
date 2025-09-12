import 'package:flutter/material.dart';
import '../../../../../../shared/themes/app_colors.dart';

class LocationMarker extends StatelessWidget {
  final bool isCurrentLocation;
  final String? category;

  const LocationMarker({
    super.key,
    required this.isCurrentLocation,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    if (isCurrentLocation) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.person, color: Colors.white, size: 20),
      );
    }

    // Category-based icons
    IconData iconData;
    Color iconColor;

    switch (category) {
      case 'restaurant':
        iconData = Icons.restaurant;
        iconColor = Colors.orange;
        break;
      case 'shopping':
        iconData = Icons.shopping_bag;
        iconColor = Colors.blue;
        break;
      case 'park':
        iconData = Icons.park;
        iconColor = Colors.green;
        break;
      case 'search':
        iconData = Icons.search;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.place;
        iconColor = Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: iconColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(iconData, color: iconColor, size: 16),
    );
  }
}
