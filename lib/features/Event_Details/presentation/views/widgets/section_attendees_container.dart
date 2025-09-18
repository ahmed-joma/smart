import 'package:flutter/material.dart';
import '../../../../../../shared/shared.dart';

class SectionAttendeesContainer extends StatelessWidget {
  final String attendees;
  final List<String>? attendeesImages;

  const SectionAttendeesContainer({
    super.key,
    required this.attendees,
    this.attendeesImages,
  });

  @override
  Widget build(BuildContext context) {
    print('🔍 SectionAttendeesContainer: attendees=$attendees');
    print('📊 attendeesImages: $attendeesImages');
    print('📊 attendeesImages length: ${attendeesImages?.length ?? 0}');

    return Positioned(
      top: 320, // يتحكم بمكان الفلوتينج
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // ظل أقوى
              blurRadius: 15, // ظل أكبر
              spreadRadius: 2, // انتشار أكثر
              offset: Offset(0, 4), // ظل أعمق
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Images
            SizedBox(
              height: 40,
              width: attendeesImages != null && attendeesImages!.isNotEmpty
                  ? (attendeesImages!.length > 3
                        ? 76 // مساحة محسوبة للصور الثلاث مع التداخل (20*2 + 36)
                        : attendeesImages!.length * 20 + 16)
                  : 76,
              child: Stack(
                children: attendeesImages != null && attendeesImages!.isNotEmpty
                    ? (() {
                        print('✅ Condition met: Creating attendee avatars');
                        print(
                          '📊 Will create ${attendeesImages!.length > 3 ? 3 : attendeesImages!.length} avatars',
                        );
                        return List.generate(
                          attendeesImages!.length > 3
                              ? 3
                              : attendeesImages!.length,
                          (index) {
                            final imageUrl = attendeesImages![index];
                            print(
                              '🖼️ Creating CircleAvatar $index with URL: $imageUrl',
                            );

                            return Positioned(
                              left: index * 20.0,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            color: AppColors.primary,
                                            child: const Center(
                                              child: SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      print('❌ Error loading image: $error');
                                      // Fallback to text if image fails
                                      return Container(
                                        color: AppColors.primary,
                                        child: Center(
                                          child: Text(
                                            _extractTextFromPlaceholder(
                                              imageUrl,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      })()
                    : (() {
                        print(
                          '❌ Using fallback images - no attendeesImages data',
                        );
                        return [
                          // Fallback images if no attendees images
                          const Positioned(
                            left: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 20,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 40,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ];
                      })(),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              attendees,
              style: const TextStyle(
                color: Color(0xFF3F38DD),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Invite Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Invite',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extract text from placeholder URL
  String _extractTextFromPlaceholder(String url) {
    try {
      // Extract text from URL like: https://placehold.co/600x400/00695c/FFF/?font=raleway&text=KM
      final uri = Uri.parse(url);
      final textParam = uri.queryParameters['text'];
      if (textParam != null && textParam.isNotEmpty) {
        return textParam.toUpperCase();
      }
    } catch (e) {
      print('❌ Error extracting text from URL: $e');
    }
    return '?';
  }
}
