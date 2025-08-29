import 'package:flutter/material.dart';

class SectionCategoryFilters extends StatelessWidget {
  final Set<String> selectedCategories;
  final Function(String, bool) onCategoryChanged;

  const SectionCategoryFilters({
    super.key,
    required this.selectedCategories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Sports',
        'icon': Icons.sports_basketball,
        'color': const Color(0xFF7F2F3A),
      },
      {'name': 'Hotel', 'icon': Icons.hotel, 'color': Colors.grey},
      {'name': 'Art', 'icon': Icons.palette, 'color': const Color(0xFF7F2F3A)},
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
}
