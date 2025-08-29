import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../shared/shared.dart';

class SectionAttendeesContainer extends StatelessWidget {
  final String attendees;

  const SectionAttendeesContainer({super.key, required this.attendees});

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                  child: SvgPicture.asset(
                    'assets/images/person1.svg',
                    width: 32,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.grey);
                    },
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-10, 0), // تداخل أكثر مع الصورة الأولى
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: SvgPicture.asset(
                      'assets/images/person2.svg',
                      width: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, color: Colors.grey);
                      },
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-20, 0), // تداخل أكثر مع الصورة الثانية
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: SvgPicture.asset(
                      'assets/images/person3.svg',
                      width: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, color: Colors.grey);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
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
}
