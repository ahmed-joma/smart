import 'package:flutter/material.dart';
import '../../../../../shared/shared.dart';

class SectionCityList extends StatelessWidget {
  const SectionCityList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cities = [
      // Original 5 cities
      {
        'name': 'Jeddah',
        'country': 'ksa',
        'image': 'assets/images/search1.svg',
        'date': '1ST MAY- SAT -2:00 PM',
      },
      {
        'name': 'Riyadh',
        'country': 'ksa',
        'image': 'assets/images/search2.svg',
        'date': '1ST MAY- SAT -2:00 PM',
      },
      {
        'name': 'Dammam',
        'country': 'ksa',
        'image': 'assets/images/search3.svg',
        'date': '1ST MAY- SAT -2:00 PM',
      },
      {
        'name': 'Abha',
        'country': 'ksa',
        'image': 'assets/images/search4.svg',
        'date': '1ST MAY- SAT -2:00 PM',
      },
      {
        'name': 'Taif',
        'country': 'ksa',
        'image': 'assets/images/search5.svg',
        'date': '1ST MAY- SAT -2:00 PM',
      },
      // Additional 5 cities
      {
        'name': 'Mecca',
        'country': 'ksa',
        'image': 'assets/images/search1.svg',
        'date': '2ND MAY- SUN -3:00 PM',
      },
      {
        'name': 'Medina',
        'country': 'ksa',
        'image': 'assets/images/search2.svg',
        'date': '2ND MAY- SUN -4:00 PM',
      },
      {
        'name': 'Dammam',
        'country': 'ksa',
        'image': 'assets/images/search3.svg',
        'date': '3RD MAY- MON -1:00 PM',
      },
      {
        'name': 'Jizan',
        'country': 'ksa',
        'image': 'assets/images/search4.svg',
        'date': '3RD MAY- MON -2:00 PM',
      },
      {
        'name': 'Tabuk',
        'country': 'ksa',
        'image': 'assets/images/search5.svg',
        'date': '4TH MAY- TUE -5:00 PM',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return _buildCityCard(city);
      },
    );
  }

  Widget _buildCityCard(Map<String, dynamic> city) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.outline.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // City Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: SizedBox(
              width: 120,
              height: 120,
              child: Image.asset(
                city['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: AppColors.surfaceVariant,
                    child: Icon(Icons.image, color: AppColors.onSurfaceVariant),
                  );
                },
              ),
            ),
          ),

          // City Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Text(
                    city['date'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // City Name and Country
                  Text(
                    '${city['name']} ,${city['country']}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
