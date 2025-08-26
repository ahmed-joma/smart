import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import '../widgets/edit_profile_body.dart'; // استيراد ProfileData

class SectionProfileInfo extends StatefulWidget {
  const SectionProfileInfo({super.key});

  @override
  State<SectionProfileInfo> createState() => _SectionProfileInfoState();
}

class _SectionProfileInfoState extends State<SectionProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: profileData,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Profile Picture
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      profileData.profileImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // User Name
              Text(
                profileData.name,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 20),

              // Following/Followers
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Following
                  Column(
                    children: [
                      Text(
                        '350',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        'Following',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),

                  // Separator Line
                  Container(
                    width: 1,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    color: Colors.grey.shade300,
                  ),

                  // Followers
                  Column(
                    children: [
                      Text(
                        '346',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        'Followers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Edit Profile Button
              GestureDetector(
                onTap: () {
                  context.go('/editProfileView');
                },
                child: Container(
                  width: 200,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF5669FF),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
