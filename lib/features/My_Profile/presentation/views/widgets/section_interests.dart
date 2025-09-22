import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionInterests extends StatelessWidget {
  const SectionInterests({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interests Header Row
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B7AED).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.favorite_outline,
                    color: Color(0xFF6B7AED),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'My Interests',
                    style: const TextStyle(
                      color: Color(0xFF1D1E25),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                // Change Button with modern design
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to interests selection
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          const Color(0xFF6B7AED).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Interest Tags with modern design
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildInterestTag(
                  'Games Online',
                  const Color(0xFF6B7AED),
                  Icons.games_outlined,
                ),
                _buildInterestTag(
                  'Concert',
                  const Color(0xFFEE544A),
                  Icons.music_note_outlined,
                ),
                _buildInterestTag(
                  'Music',
                  const Color(0xFFFF9800),
                  Icons.headphones_outlined,
                ),
                _buildInterestTag(
                  'Art',
                  const Color(0xFF7D67EE),
                  Icons.palette_outlined,
                ),
                _buildInterestTag(
                  'Movie',
                  const Color(0xFF29D697),
                  Icons.movie_outlined,
                ),
                _buildInterestTag(
                  'Others',
                  const Color(0xFF39D1F2),
                  Icons.more_horiz_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestTag(String text, Color backgroundColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
