import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionInterests extends StatelessWidget {
  const SectionInterests({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Interests Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Interests Heading
              Text(
                'Interest',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),

              // Change Button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, color: AppColors.primary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'CHANGE',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Interest Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInterestTag(
                'Games Online',
                const Color(0xFF6B7AED),
              ), // Blue
              _buildInterestTag(
                'Concert',
                const Color(0xFFEE544A),
              ), // Red-Orange
              _buildInterestTag('Music', const Color(0xFFFF9800)), // Orange
              _buildInterestTag('Art', const Color(0xFF7D67EE)), // Purple
              _buildInterestTag('Movie', const Color(0xFF29D697)), // Green
              _buildInterestTag(
                'Others',
                const Color(0xFF39D1F2),
              ), // Light Blue
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInterestTag(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
