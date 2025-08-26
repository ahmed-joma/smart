import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';

class SectionEmailInfo extends StatelessWidget {
  final String userEmail;

  const SectionEmailInfo({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '   We\'ve send you the verification',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 23 / 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '   code on ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 23 / 16,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 23 / 16,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
