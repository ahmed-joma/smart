import 'package:flutter/material.dart';

class SectionHotelInfoCard extends StatelessWidget {
  final Map<String, dynamic>? hotelData;

  const SectionHotelInfoCard({super.key, this.hotelData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF7F2F3A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: hotelData?['image']?.toString().startsWith('http') == true
                  ? Image.network(
                      hotelData!['image'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.hotel,
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.hotel, color: Colors.white, size: 40),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotelData?['title'] ?? 'Four Points by Sheraton',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${hotelData?['location'] ?? 'Jeddah Corniche'}, ${hotelData?['country'] ?? 'KSA'}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${hotelData?['rating']?.toString() ?? '4.8'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '(${hotelData?['price'] ?? 'SR 200.7'} per night)',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Services/Amenities
                if (hotelData?['services'] != null &&
                    hotelData!['services'] is List) ...[
                  Wrap(
                    spacing: 4,
                    children: (hotelData!['services'] as List)
                        .take(3)
                        .map<Widget>((service) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7F2F3A).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              service.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF7F2F3A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
