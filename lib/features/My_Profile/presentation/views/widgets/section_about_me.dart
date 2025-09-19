import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import '../../../../Profile/presentation/manager/profile_cubit.dart';
// Removed unused import

class SectionAboutMe extends StatefulWidget {
  const SectionAboutMe({super.key});

  @override
  State<SectionAboutMe> createState() => _SectionAboutMeState();
}

class _SectionAboutMeState extends State<SectionAboutMe> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileSuccess) {
          final user = state.data.user;
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
                  user.aboutMe.isNotEmpty
                      ? user.aboutMe
                      : 'No description available',
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
        }

        // Default fallback
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                'Loading...',
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
