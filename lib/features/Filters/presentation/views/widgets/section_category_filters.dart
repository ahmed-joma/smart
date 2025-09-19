import 'package:flutter/material.dart';
import '../../../../../core/utils/models/filter_models.dart';

class SectionCategoryFilters extends StatelessWidget {
  final Set<String> selectedCategories;
  final Function(String, bool) onCategoryChanged;
  final List<Tag> availableTags;

  const SectionCategoryFilters({
    super.key,
    required this.selectedCategories,
    required this.onCategoryChanged,
    required this.availableTags,
  });

  @override
  Widget build(BuildContext context) {
    // Use API tags if available, otherwise fallback to static categories
    final categories = availableTags.isNotEmpty
        ? availableTags
              .map(
                (tag) => {
                  'name': tag.name,
                  'icon': _getIconForTag(tag.name),
                  'color': const Color(0xFF7F2F3A),
                },
              )
              .toList()
        : [
            {
              'name': 'Sports',
              'icon': Icons.sports_basketball,
              'color': const Color(0xFF7F2F3A),
            },
            {'name': 'Hotel', 'icon': Icons.hotel, 'color': Colors.grey},
            {
              'name': 'Art',
              'icon': Icons.palette,
              'color': const Color(0xFF7F2F3A),
            },
            {'name': 'Food', 'icon': Icons.restaurant, 'color': Colors.grey},
            {'name': 'Events', 'icon': Icons.event, 'color': Colors.grey},
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories Row with Horizontal Scroll
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategories.contains(
                  category['name'],
                );
                final color = isSelected
                    ? const Color(0xFF7F2F3A)
                    : Colors.grey;

                return Container(
                  margin: EdgeInsets.only(
                    right: index == categories.length - 1 ? 0 : 20,
                  ),
                  child: Column(
                    children: [
                      // Category Icon
                      GestureDetector(
                        onTap: () => onCategoryChanged(
                          category['name'] as String,
                          !isSelected,
                        ),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF7F2F3A)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF7F2F3A)
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: isSelected ? Colors.white : Colors.grey,
                            size: 28,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Category Name
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get icon for tag name
  IconData _getIconForTag(String tagName) {
    switch (tagName.toLowerCase()) {
      case 'sports':
        return Icons.sports_basketball;
      case 'food':
        return Icons.restaurant;
      case 'music':
        return Icons.music_note;
      case 'culture':
        return Icons.palette;
      case 'technology':
        return Icons.computer;
      case 'luxury':
        return Icons.diamond;
      case 'budget':
        return Icons.attach_money;
      case 'family friendly':
        return Icons.family_restroom;
      case 'pet friendly':
        return Icons.pets;
      case 'romantic':
        return Icons.favorite;
      default:
        return Icons.local_offer;
    }
  }
}
