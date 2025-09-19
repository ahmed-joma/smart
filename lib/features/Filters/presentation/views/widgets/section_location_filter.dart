import 'package:flutter/material.dart';
import '../../../../../core/utils/models/filter_models.dart';

class SectionLocationFilter extends StatelessWidget {
  final String selectedLocation;
  final Function(String) onLocationChanged;
  final List<City> availableCities;

  const SectionLocationFilter({
    super.key,
    required this.selectedLocation,
    required this.onLocationChanged,
    required this.availableCities,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7F2F3A),
            ),
          ),

          const SizedBox(height: 16),

          // Location Dropdown (now using API cities)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value:
                    availableCities.any((city) => city.name == selectedLocation)
                    ? selectedLocation
                    : null,
                hint: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: const Color(0xFF7F2F3A),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Select City',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                items: availableCities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city.name,
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: city.imageUrl.isNotEmpty
                                ? Image.network(
                                    city.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.location_city,
                                        color: const Color(0xFF7F2F3A),
                                        size: 20,
                                      );
                                    },
                                  )
                                : Icon(
                                    Icons.location_city,
                                    color: const Color(0xFF7F2F3A),
                                    size: 20,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          city.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onLocationChanged(value);
                  }
                },
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: const Color(0xFF7F2F3A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
