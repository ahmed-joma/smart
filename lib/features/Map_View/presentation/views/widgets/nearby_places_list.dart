import 'package:flutter/material.dart';
import '../../../../../../shared/themes/app_colors.dart';
import '../../../domain/entities/map_location.dart';

class NearbyPlacesList extends StatelessWidget {
  final List<MapLocation> places;
  final Function(MapLocation?) onPlaceSelected;

  const NearbyPlacesList({
    super.key,
    required this.places,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.near_me, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'الأماكن القريبة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: 'Inter',
                  ),
                ),
                const Spacer(),
                Text(
                  '${places.length} مكان',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),

          // Places List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return _buildPlaceItem(place);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceItem(MapLocation place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onPlaceSelected(place),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(place.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(place.category),
                    color: _getCategoryColor(place.category),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name ?? 'مكان غير محدد',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (place.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          place.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: 'Inter',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'park':
        return Icons.park;
      default:
        return Icons.place;
    }
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'restaurant':
        return Colors.orange;
      case 'shopping':
        return Colors.blue;
      case 'park':
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}
