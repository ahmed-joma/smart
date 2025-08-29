import 'package:flutter/material.dart';

class SectionLocationFilter extends StatelessWidget {
  final String selectedLocation;
  final Function(String) onLocationChanged;

  const SectionLocationFilter({
    super.key,
    required this.selectedLocation,
    required this.onLocationChanged,
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

          // Location Input Field
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Location Icon
                Container(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: const Color(0xFF7F2F3A),
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Location Text
                Expanded(
                  child: Text(
                    selectedLocation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Chevron Icon
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFF7F2F3A),
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
