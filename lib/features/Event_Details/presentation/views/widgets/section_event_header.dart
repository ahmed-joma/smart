import 'package:flutter/material.dart';
import '../../../../../../shared/shared.dart';

class SectionEventHeader extends StatelessWidget {
  final String? imageUrl;

  const SectionEventHeader({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
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
          'Event Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0x4DFFFFFF), // 30% شفافية
            borderRadius: BorderRadius.circular(15.31),
          ),
          child: const Icon(Icons.bookmark, color: Colors.white, size: 24),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            (imageUrl != null && imageUrl!.isNotEmpty && imageUrl != 'null')
                ? Image.network(
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
                      return Container(
                        color: AppColors.primary,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    color: AppColors.primary,
                    child: const Center(
                      child: Icon(Icons.event, color: Colors.white, size: 80),
                    ),
                  ),
            // Red overlay
            Container(color: AppColors.primary.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }
}
