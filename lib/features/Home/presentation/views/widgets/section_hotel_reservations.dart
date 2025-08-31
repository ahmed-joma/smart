import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';

class SectionHotelReservations extends StatelessWidget {
  const SectionHotelReservations({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 185, 253, 255),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hotel Reservations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'View counts on reservations',
                  style: TextStyle(color: Color(0xFF484D70), fontSize: 14),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    context.go('/hotelHomeView');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00F8FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'BOOK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Building Icon with Stars
          Stack(
            children: [
              SvgPicture.asset(
                'assets/images/building.svg',
                width: 100,
                height: 100,
                colorFilter: const ColorFilter.mode(
                  Colors.brown,
                  BlendMode.srcIn,
                ),
              ),
              Positioned(top: -5, right: -5, child: Row()),
            ],
          ),
        ],
      ),
    );
  }
}
