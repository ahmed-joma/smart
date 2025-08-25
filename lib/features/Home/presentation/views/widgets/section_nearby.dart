import 'package:flutter/material.dart';
import '../../../../../shared/shared.dart';

class SectionNearby extends StatelessWidget {
  const SectionNearby({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearby You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF747688),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF747688),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Nearby Items (repeating for demo)
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 15, // 8 items + 7 spaces between them
            itemBuilder: (context, index) {
              if (index.isEven) {
                final itemIndex = index ~/ 2;
                final nearbyItems = [
                  {
                    'name': 'Restaurant',
                    'icon': Icons.restaurant,
                    'color': Colors.orange,
                  },
                  {'name': 'Cafe', 'icon': Icons.coffee, 'color': Colors.brown},
                  {'name': 'Park', 'icon': Icons.park, 'color': Colors.green},
                  {
                    'name': 'Museum',
                    'icon': Icons.museum,
                    'color': Colors.purple,
                  },
                  {
                    'name': 'Shopping',
                    'icon': Icons.shopping_bag,
                    'color': Colors.pink,
                  },
                  {
                    'name': 'Gym',
                    'icon': Icons.fitness_center,
                    'color': Colors.red,
                  },
                  {
                    'name': 'Library',
                    'icon': Icons.library_books,
                    'color': Colors.indigo,
                  },
                  {
                    'name': 'Cinema',
                    'icon': Icons.movie,
                    'color': Colors.deepPurple,
                  },
                ];

                if (itemIndex < nearbyItems.length) {
                  final item = nearbyItems[itemIndex];
                  return _buildNearbyItem(
                    item['name'] as String,
                    item['icon'] as IconData,
                    item['color'] as Color,
                  );
                }
                return const SizedBox.shrink();
              } else {
                return Container(
                  width: 16,
                  constraints: const BoxConstraints(minWidth: 16, maxWidth: 16),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyItem(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
