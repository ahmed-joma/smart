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
            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - opacity)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Profile Picture with modern design
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.primary.withOpacity(0.1),
                                        const Color(
                                          0xFF6B7AED,
                                        ).withOpacity(0.1),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: ProfileAvatar(
                                    imageUrl: user.imageUrl.isNotEmpty
                                        ? user.imageUrl
                                        : null,
                                    name: user.fullName,
                                    size: 70,
                                    showEditIcon: false,
                                    onTap: () => _changeProfileImage(context),
                                  ),
                                ),
                                // Edit Icon
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _changeProfileImage(context),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // User Name with modern typography
                            Text(
                              user.fullName,
                              style: const TextStyle(
                                color: Color(0xFF1D1E25),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 8),

                            // User Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF29D697).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(
                                    0xFF29D697,
                                  ).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF29D697),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Active Member',
                                    style: TextStyle(
                                      color: const Color(0xFF29D697),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Stats Cards
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Following Card
                                  Expanded(
                                    child: _buildStatCard(
                                      '350',
                                      'Following',
                                      Icons.people_outline,
                                      const Color(0xFF6B7AED),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 50,
                                    color: Colors.grey.shade300,
                                  ),
                                  // Followers Card
                                  Expanded(
                                    child: _buildStatCard(
                                      '346',
                                      'Followers',
                                      Icons.favorite_outline,
                                      const Color(0xFFEE544A),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Edit Profile Button with modern design
                            GestureDetector(
                              onTap: () {
                                context.go('/editProfileView');
                              },
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary,
                                      const Color(0xFF6B7AED),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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

  Widget _buildStatCard(
    String number,
    String label,
    IconData icon,
    Color color,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0, end: double.parse(number)),
      builder: (context, animatedValue, child) {
        return Column(
          children: [
            // Animated Icon Container
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(icon, color: color, size: 24),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            // Animated Counter
            Text(
              animatedValue.toInt().toString(),
              style: const TextStyle(
                color: Color(0xFF1D1E25),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ],
        );
      },
    );
  }
}
