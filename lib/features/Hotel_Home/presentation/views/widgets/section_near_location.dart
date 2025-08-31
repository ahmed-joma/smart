import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionNearLocation extends StatefulWidget {
  const SectionNearLocation({super.key});

  @override
  State<SectionNearLocation> createState() => _SectionNearLocationState();
}

class _SectionNearLocationState extends State<SectionNearLocation> {
  // Map to track favorite status for each hotel
  final Map<String, bool> _favorites = {
    'Hilton': true,
    'DAMAC': true,
    'Marriott': true,
  };

  void _toggleFavorite(String hotelName) {
    setState(() {
      _favorites[hotelName] = !(_favorites[hotelName] ?? false);
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
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildHotelCard(
                  image: 'assets/images/hotel.svg',
                  name: 'Hilton',
                  rating: '5.0',
                  description: 'Jeddah Memorable',
                  price: '200.7',
                  isFavorite: _favorites['Hilton'] ?? false,
                  onFavoriteToggle: () => _toggleFavorite('Hilton'),
                ),
                const SizedBox(width: 20), // مسافة أكبر بين البطاقات
                _buildHotelCard(
                  image: 'assets/images/hotel.svg',
                  name: 'DAMAC',
                  rating: '5.0',
                  description: 'Prime Location',
                  price: '175.9',
                  isFavorite: _favorites['DAMAC'] ?? false,
                  onFavoriteToggle: () => _toggleFavorite('DAMAC'),
                ),
                const SizedBox(width: 20), // مسافة أكبر بين البطاقات
                _buildHotelCard(
                  image: 'assets/images/hotel.svg',
                  name: 'Marriott',
                  rating: '4.8',
                  description: 'Luxury Experience',
                  price: '220.0',
                  isFavorite: _favorites['Marriott'] ?? false,
                  onFavoriteToggle: () => _toggleFavorite('Marriott'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard({
    required String image,
    required String name,
    required String rating,
    required String description,
    required String price,
    required bool isFavorite,
    required VoidCallback onFavoriteToggle,
  }) {
    return Container(
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
                child: SvgPicture.asset(
                  image,
                  width: 250,
                  height: 180, // زيادة ارتفاع الصورة
                  fit: BoxFit.cover,
                  placeholderBuilder: (context) => Container(
                    width: 250,
                    height: 180,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
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
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    width: 40, // زيادة حجم الكونتينر
                    height: 40, // زيادة حجم الكونتينر
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? const Color(0xFF7F2F3A) : Colors.grey,
                      size: 24, // زيادة حجم القلب
                    ),
                  ),
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
                        name,
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
                          rating,
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
                  description,
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
                      'SR$price',
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
    );
  }
}
