import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/hotel_models.dart';

class SectionPopularHotel extends StatelessWidget {
  final List<Hotel> hotels;

  const SectionPopularHotel({super.key, required this.hotels});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header with title and "See all" link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Hotel',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to see all popular hotels
                },
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7F2F3A),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Vertical list of popular hotel cards
          hotels.isEmpty
              ? const Center(
                  child: Text(
                    'No popular hotels found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: hotels.asMap().entries.map((entry) {
                    final index = entry.key;
                    final hotel = entry.value;
                    return Column(
                      children: [
                        _buildPopularHotelCard(context: context, hotel: hotel),
                        if (index < hotels.length - 1)
                          const SizedBox(height: 20), // مسافة أكبر بين البطاقات
                      ],
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildPopularHotelCard({
    required BuildContext context,
    required Hotel hotel,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to Hotel Details with hotel data
        final hotelData = {
          'id': hotel.id,
          'title': hotel.name,
          'date': '14 December, 2025',
          'day': 'Tuesday',
          'time': 'Check-in: 3:00PM',
          'location': hotel.shortVenue,
          'country': 'KSA',
          'organizer': 'Hotel Management',
          'organizerCountry': 'KSA',
          'about':
              'Luxury hotel with world-class amenities and exceptional service in ${hotel.city}.',
          'guests': '+50 Guests',
          'price': hotel.formattedPrice,
          'image': hotel.coverUrl,
        };
        context.push('/hotelDetailsView', extra: hotelData);
      },
      child: Container(
        width: double.infinity, // عرض كامل للشاشة
        constraints: const BoxConstraints(
          minHeight: 120, // ارتفاع ثابت لجميع البطاقات
          maxHeight: 120,
        ),
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
          crossAxisAlignment: CrossAxisAlignment.start, // محاذاة من الأعلى
          children: [
            // Hotel Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                hotel.coverUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading hotel image: $error');
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.hotel,
                      size: 30,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 16),

            // Hotel Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, // محاذاة من الأعلى
                mainAxisSize:
                    MainAxisSize.min, // جعل النصوص تأخذ أقل مساحة ممكنة
                children: [
                  // Hotel Name
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6), // مسافة متوازنة
                  // Description
                  Text(
                    hotel.city,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8), // مسافة متوازنة
                  // Price
                  Text(
                    '${hotel.formattedPrice} /night',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7F2F3A),
                    ),
                  ),
                ],
              ),
            ),

            // Rating - positioned on the right side
            Column(
              mainAxisAlignment: MainAxisAlignment.start, // محاذاة من الأعلى
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      hotel.ratingAsDouble.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
