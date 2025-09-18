import 'package:flutter/material.dart';
import '../../../../../../shared/shared.dart';

class SectionHotelHeader extends StatelessWidget {
  final String? imageUrl;
  final bool? isFavorite;
  final VoidCallback? onFavoriteToggle;

  const SectionHotelHeader({
    super.key,
    this.imageUrl,
    this.isFavorite,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    print('🖼️ SectionHotelHeader: Received imageUrl: $imageUrl');
    print('💖 SectionHotelHeader: isFavorite: $isFavorite');

    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
      ),
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Hotel Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onFavoriteToggle,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0x4DFFFFFF), // 30% شفافية
              borderRadius: BorderRadius.circular(15.31),
            ),
            child: Icon(
              isFavorite == true ? Icons.bookmark : Icons.bookmark_border,
              color: isFavorite == true ? Colors.red : Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (imageUrl != null && imageUrl!.isNotEmpty && imageUrl != 'null')
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.primary,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading hotel header image: $error');
                  return Container(
                    color: AppColors.primary,
                    child: const Center(
                      child: Icon(Icons.hotel, color: Colors.white, size: 80),
                    ),
                  );
                },
              )
            else
              Container(
                color: AppColors.primary,
                child: const Center(
                  child: Icon(Icons.hotel, color: Colors.white, size: 80),
                ),
              ),
            // No overlay - clean image
          ],
        ),
      ),
    );
  }
}
