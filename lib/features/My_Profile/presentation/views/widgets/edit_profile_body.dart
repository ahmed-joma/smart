import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshop_map/shared/widgets/custom_snackbar.dart';
import 'section_edit_header.dart';
import 'section_edit_profile_picture.dart';
import 'section_edit_form.dart';
import 'section_save_button.dart';
import '../../../../Profile/presentation/manager/profile_cubit.dart';

// Simple class to hold profile image data for UI
class ProfileImageData {
  String profileImage = 'assets/images/profile.svg';

  void updateProfileImage(String newImagePath) {
    profileImage = newImagePath;
  }
}

// Instance for profile image data
final ProfileImageData profileImageData = ProfileImageData();

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({super.key});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final _nameController = TextEditingController();
  final _aboutMeController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // تحميل البيانات الحالية من ProfileCubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileSuccess) {
        _nameController.text = profileState.data.user.fullName;
        _aboutMeController.text = profileState.data.user.aboutMe;
      } else {
        // Load profile if not loaded yet
        context.read<ProfileCubit>().getProfile();
        // Use empty strings as fallback
        _nameController.text = '';
        _aboutMeController.text = '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    // التحقق من أن الحقول مملوءة
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Full name is required')));
      return;
    }

    if (_aboutMeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('About me is required')));
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    // تحديث البيانات في ProfileCubit مع الحقول المطلوبة
    context.read<ProfileCubit>().updateProfile(
      fullName: _nameController.text.trim(),
      aboutMe: _aboutMeController.text.trim(),
      // TODO: إضافة دعم رفع الصورة لاحقاً
      imageFile: null,
    );
  }

  void _onProfileImageChanged(String newImagePath) {
    // تحديث البيانات في ProfileImageData للعرض المحلي
    profileImageData.updateProfileImage(newImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdating) {
          CustomSnackBar.showInfo(
            context: context,
            message: 'Updating profile...',
          );
        } else if (state is ProfileSuccess) {
          // Update text controllers with loaded data
          if (!_isUpdating) {
            _nameController.text = state.data.user.fullName;
            _aboutMeController.text = state.data.user.aboutMe;
          } else {
            // Profile updated successfully
            CustomSnackBar.showSuccess(
              context: context,
              message: 'Profile updated successfully!',
            );
            // العودة لصفحة Profile بعد النجاح
            context.go('/myProfileView');
            // إعادة تعيين _isUpdating
            setState(() {
              _isUpdating = false;
            });
          }
        } else if (state is ProfileError) {
          setState(() {
            _isUpdating = false;
          });
          CustomSnackBar.showError(
            context: context,
            message: 'Failed to update profile: ${state.message}',
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                const SectionEditHeader(),

                // Profile Picture Section
                SectionEditProfilePicture(
                  currentImagePath: profileImageData.profileImage,
                  onImageChanged: _onProfileImageChanged,
                ),

                // Edit Form Section
                SectionEditForm(
                  nameController: _nameController,
                  aboutMeController: _aboutMeController,
                ),

                // Save Button Section
                SectionSaveButton(onSavePressed: _onSavePressed),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
