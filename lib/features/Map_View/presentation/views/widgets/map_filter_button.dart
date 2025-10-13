import 'package:flutter/material.dart';

class MapFilterButton extends StatelessWidget {
  final Function(List<String>) onFilterApplied;

  const MapFilterButton({super.key, required this.onFilterApplied});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: IconButton(
        icon: const Icon(Icons.filter_list, color: Color(0xFF7F2F3A)),
        onPressed: () {
          _showFilterDialog(context);
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final List<String> selectedFilters = [];
    final List<Map<String, dynamic>> filterOptions = [
      {'id': 'hotels', 'label': 'Hotels', 'icon': Icons.hotel},
      {'id': 'events', 'label': 'Events', 'icon': Icons.event},
      {'id': 'restaurants', 'label': 'Restaurants', 'icon': Icons.restaurant},
      {'id': 'attractions', 'label': 'Attractions', 'icon': Icons.place},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Filter Map',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Filter Options
                  ...filterOptions.map((option) {
                    final isSelected = selectedFilters.contains(option['id']);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedFilters.remove(option['id']);
                          } else {
                            selectedFilters.add(option['id']);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF7F2F3A).withOpacity(0.1)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF7F2F3A)
                                : Colors.grey.shade200,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              option['icon'],
                              color: isSelected
                                  ? const Color(0xFF7F2F3A)
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              option['label'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFF7F2F3A)
                                    : Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF7F2F3A),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        onFilterApplied(selectedFilters);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F2F3A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Apply Filters (${selectedFilters.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
