import 'package:flutter/material.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'edit_profile_body.dart'; // استيراد ProfileData

class SectionAboutMe extends StatefulWidget {
  const SectionAboutMe({super.key});

  @override
  State<SectionAboutMe> createState() => _SectionAboutMeState();
}

class _SectionAboutMeState extends State<SectionAboutMe> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: profileData,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About Me Heading
              Text(
                'About Me',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 15),

              // About Me Text
              Text(
                profileData.aboutMe,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
