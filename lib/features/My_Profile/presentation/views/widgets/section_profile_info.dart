import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/themes/app_colors.dart';
import 'package:smartshop_map/shared/widgets/custom_snackbar.dart';
import 'package:smartshop_map/shared/widgets/profile_avatar.dart';
import 'package:smartshop_map/shared/widgets/image_picker_widget.dart';
import '../../../../Profile/presentation/manager/profile_cubit.dart';

class SectionProfileInfo extends StatefulWidget {
  const SectionProfileInfo({super.key});

  @override
  State<SectionProfileInfo> createState() => _SectionProfileInfoState();
}

class _SectionProfileInfoState extends State<SectionProfileInfo> {
  bool _isUploadingImage = false;

  Future<void> _changeProfileImage(BuildContext context) async {
    try {
      final File? imageFile = await ImagePickerWidget.showImageSourceDialog(
        context,
      );

      if (imageFile != null) {
        // Upload image to API
        print('Selected image: ${imageFile.path}');

        // Show loading snackbar
        CustomSnackBar.showInfo(
          context: context,
          message: 'Uploading image...',
          duration: const Duration(seconds: 2),
        );

        // Upload the image
        setState(() {
          _isUploadingImage = true;
        });
        context.read<ProfileCubit>().uploadProfileImage(imageFile);
      }
    } catch (e) {
      CustomSnackBar.showError(
        context: context,
        message: 'Failed to select image: $e',
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          CustomSnackBar.showError(
            context: context,
            message: state.message,
            duration: const Duration(seconds: 3),
          );
        } else if (state is ProfileUpdating) {
          CustomSnackBar.showInfo(
            context: context,
            message: 'Uploading image...',
            duration: const Duration(seconds: 2),
          );
        } else if (state is ProfileSuccess && _isUploadingImage) {
          // Check if this is after an image upload
          CustomSnackBar.showSuccess(
            context: context,
            message: 'Profile image updated successfully!',
            duration: const Duration(seconds: 2),
          );
          setState(() {
            _isUploadingImage = false;
          });
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProfileSuccess) {
            final user = state.data.user;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Profile Picture
                  Center(
                    child: ProfileAvatar(
                      imageUrl: user.imageUrl.isNotEmpty ? user.imageUrl : null,
                      name: user.fullName,
                      size: 120,
                      showEditIcon: true,
                      onTap: () => _changeProfileImage(context),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // User Name
                  Text(
                    user.fullName,
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
          }

          // Default fallback
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: const Center(child: Text('No profile data available')),
          );
        },
      ),
    );
  }
}
