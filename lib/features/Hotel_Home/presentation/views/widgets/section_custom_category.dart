import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';

class SectionCustomCategory extends StatelessWidget {
  const SectionCustomCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Sports',
        'icon': Icons.sports_soccer,
        'color': AppColors.sports,
      },
      {'name': 'Hotel', 'icon': Icons.hotel, 'color': AppColors.hotel},
      {'name': 'Food', 'icon': Icons.restaurant, 'color': AppColors.food},
      {'name': 'Events', 'icon': Icons.event, 'color': AppColors.events},
    ];

    return Transform.translate(
      offset: const Offset(0, 42),
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: EdgeInsets.only(
                right: index < categories.length - 1 ? 8 : 0,
              ),
              child: GestureDetector(
                onTap: () {
                  if (category['name'] == 'Events') {
                    context.go('/eventsView');
                  }
                },
                child: _buildCategoryChip(
                  category['name'] as String,
                  category['icon'] as IconData,
                  category['color'] as Color,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String title, IconData icon, Color color) {
    return Container(
      constraints: const BoxConstraints(minWidth: 80, maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
