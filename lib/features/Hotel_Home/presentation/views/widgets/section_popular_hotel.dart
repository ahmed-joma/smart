import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/hotel_models.dart';
import '../../../../../shared/widgets/interactive_bookmark.dart';
import '../../../../../core/utils/cubits/favorite_cubit.dart';
import '../../../../../core/utils/cubits/favorite_state.dart';

class SectionPopularHotel extends StatefulWidget {
  final List<Hotel> hotels;

  const SectionPopularHotel({super.key, required this.hotels});

  @override
  State<SectionPopularHotel> createState() => _SectionPopularHotelState();
}

class _SectionPopularHotelState extends State<SectionPopularHotel> {
  // Track saved state for each hotel
  final Map<int, bool> _savedHotels = {};

  @override
  void initState() {
    super.initState();
    // Initialize saved hotels map with current states
    for (final hotel in widget.hotels) {
      _savedHotels[hotel.id] = hotel.isFavorite;
    }
  }

  void _toggleFavorite(int hotelId, bool currentState) {
    print('🏨 Toggle favorite for hotel ID: $hotelId');
    context.read<FavoriteCubit>().toggleHotelFavorite(hotelId);
    setState(() {
      _savedHotels[hotelId] = !currentState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteSuccess) {
          // Update local state when favorite changes from other pages
          setState(() {
            _savedHotels[state.favoriteId] = state.isFavorite;
          });
        }
      },
      child: Container(
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
                    context.go('/featuredHotelsView');
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
            widget.hotels.isEmpty
                ? const Center(
                    child: Text(
                      'No popular hotels found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Column(
                    children: widget.hotels.asMap().entries.map((entry) {
                      final index = entry.key;
                      final hotel = entry.value;
                      return Column(
                        children: [
                          _buildPopularHotelCard(
                            context: context,
                            hotel: hotel,
                          ),
                          if (index < widget.hotels.length - 1)
                            const SizedBox(
                              height: 20,
                            ), // مسافة أكبر بين البطاقات
                        ],
                      );
                    }).toList(),
                  ),
          ],
        ),
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
          'location': hotel.fullVenue,
          'country': 'KSA',
          'organizer': 'Hotel Management',
          'organizerCountry': 'KSA',
          'about':
              'Luxury hotel with world-class amenities and exceptional service in ${hotel.city}. Located at ${hotel.fullVenue}.',
          'guests': '+50 Guests',
          'price': hotel.formattedPrice,
          'image': hotel.coverUrl,
        };
        context.push('/hotelDetailsView', extra: hotelData);
      },
      child: Container(
        width: double.infinity, // عرض كامل للشاشة
        constraints: const BoxConstraints(
          minHeight: 140, // زيادة الارتفاع من 120 إلى 140
          maxHeight: 140,
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
                  // City
                  Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.city,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4), // مسافة أصغر
                  // Venue
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.shortVenue,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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

            // Rating and Favorite - positioned on the right side
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // توزيع العناصر
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Favorite Button at the top
                InteractiveBookmark(
                  isSaved: _savedHotels[hotel.id] ?? hotel.isFavorite,
                  onPressed: () => _toggleFavorite(
                    hotel.id,
                    _savedHotels[hotel.id] ?? hotel.isFavorite,
                  ),
                  size: 32,
                ),

                // Rating at the bottom
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
