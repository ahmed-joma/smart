import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/widgets/interactive_bookmark.dart';
import '../../../data/models/hotel_models.dart';

class SectionNearLocation extends StatefulWidget {
  final List<Hotel> hotels;

  const SectionNearLocation({super.key, required this.hotels});

  @override
  State<SectionNearLocation> createState() => _SectionNearLocationState();
}

class _SectionNearLocationState extends State<SectionNearLocation> {
  void _toggleFavorite(int hotelId) {
    // TODO: Implement API call to toggle favorite
    print('🏨 Toggle favorite for hotel ID: $hotelId');
    setState(() {
      // For now, just trigger a rebuild
      // In a real implementation, you would update the hotel's favorite status
    });
  }

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
                'Near Location',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to see all hotels
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

          // Horizontal scrollable hotel cards
          SizedBox(
            height: 370, // زيادة الارتفاع ليتناسب مع البطاقات الأكبر
            child: widget.hotels.isEmpty
                ? const Center(
                    child: Text(
                      'No hotels found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = widget.hotels[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 20,
                          right: index == widget.hotels.length - 1 ? 20 : 0,
                        ),
                        child: _buildHotelCard(context: context, hotel: hotel),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard({
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
        width: 250, // زيادة العرض من 200 إلى 250
        height: 350, // زيادة الارتفاع أكثر لتجنب overflow نهائياً
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image with Favorite Button
            Stack(
              clipBehavior: Clip.none, // السماح للقلب بالظهور خارج حدود الصورة
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    hotel.coverUrl,
                    width: 250,
                    height: 180, // زيادة ارتفاع الصورة
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 250,
                        height: 180,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading hotel image: $error');
                      return Container(
                        width: 250,
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.hotel,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // Favorite Button - positioned on the right side, bigger and more beautiful
                Positioned(
                  top: 16,
                  right: 16, // تغيير إلى يمين البطاقة
                  child: InteractiveBookmark(
                    isSaved: hotel.isFavorite,
                    onPressed: () => _toggleFavorite(hotel.id),
                    size: 40,
                  ),
                ),
              ],
            ),

            // Hotel Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hotel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            hotel.ratingAsDouble.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10), // مسافة متوازنة
                  // Description
                  Text(
                    hotel.city,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1, // تقليل عدد الأسطر لتجنب overflow
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16), // مسافة متوازنة
                  // Price
                  Row(
                    children: [
                      Text(
                        hotel.formattedPrice,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7F2F3A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/night',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
