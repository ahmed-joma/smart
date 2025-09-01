import 'package:flutter/material.dart';
import '../../../../../../shared/shared.dart';

class SectionHotelPreview extends StatelessWidget {
  const SectionHotelPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Title
            const Text(
              'Preview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Preview Images
            Row(
              children: [
                // First Image
                Expanded(child: _buildPreviewImage('assets/images/pre1.svg')),
                const SizedBox(width: 12),

                // Second Image
                Expanded(child: _buildPreviewImage('assets/images/pre2.svg')),
                const SizedBox(width: 12),

                // Third Image
                Expanded(child: _buildPreviewImage('assets/images/pre3.svg')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewImage(String imagePath) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, size: 40, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
