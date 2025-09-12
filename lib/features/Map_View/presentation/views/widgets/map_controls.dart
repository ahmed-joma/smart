import 'package:flutter/material.dart';
import '../../../../../../shared/themes/app_colors.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onLocationPressed;
  final VoidCallback onNearbyPressed;
  final bool showNearbyPlaces;

  const MapControls({
    super.key,
    required this.onLocationPressed,
    required this.onNearbyPressed,
    required this.showNearbyPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Location Button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onLocationPressed,
              child: const Icon(
                Icons.my_location,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Nearby Places Button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: showNearbyPlaces ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onNearbyPressed,
              child: Icon(
                Icons.place,
                color: showNearbyPlaces ? Colors.white : AppColors.primary,
                size: 24,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Map Type Button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // TODO: Implement map type change
              },
              child: const Icon(
                Icons.layers,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
