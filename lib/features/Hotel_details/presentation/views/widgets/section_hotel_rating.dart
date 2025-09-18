import 'package:flutter/material.dart';
import '../../../../../../shared/shared.dart';

class SectionHotelRating extends StatelessWidget {
  final int rating;
  final String hotelName;

  const SectionHotelRating({
    super.key,
    required this.rating,
    required this.hotelName,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 320, // نفس مكان الـ guests container السابق
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Rating Stars
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: index < rating ? Colors.amber : Colors.grey[400],
                  size: 28,
                );
              }),
            ),
            const SizedBox(width: 12),

            // Rating Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$rating.0 Rating',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hotelName,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
