import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/repositories/profile_repository.dart';
import '../../../../core/utils/models/profile_models.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/api_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository = sl<ProfileRepository>();

  ProfileCubit() : super(ProfileInitial());

  // Get user profile
  Future<void> getProfile() async {
    emit(ProfileLoading());
    print('🔍 ProfileCubit: Starting to fetch profile...');

    try {
      final response = await _profileRepository.getProfile();

      if (response.status && response.data != null) {
        print('✅ ProfileCubit: Profile fetched successfully');
        emit(ProfileSuccess(response.data!));
      } else {
        print('❌ ProfileCubit: Profile fetch failed: ${response.msg}');
        emit(ProfileError(response.msg));
      }
    } catch (e) {
      print('💥 ProfileCubit: Error fetching profile: $e');

      // If email verification is required, try to get user data from login response
      if (e.toString().contains('unverified email') ||
          e.toString().contains('403')) {
        print(
          '🔄 ProfileCubit: Trying to get user data from login response...',
        );
        await _getUserDataFromLogin();
      } else {
        emit(ProfileError(e.toString()));
      }
    }
  }

  // Get user data from login response (fallback for unverified email)
  Future<void> _getUserDataFromLogin() async {
    try {
      // Get user data from the login response stored in ApiService
      final apiService = sl<ApiService>();
      // We need to get the user data from somewhere - let's check if we can get it from the token
      print('🔍 ProfileCubit: Getting user data from login response...');

      if (apiService.userData != null) {
        // Create profile data from login response
        final userData = apiService.userData!;
        final userProfile = UserProfile.fromJson(userData);

        final profileData = ProfileData(
          user: userProfile,
          favorites: Favorites(events: [], hotels: []),
        );

        print('✅ ProfileCubit: Using user data from login response');
        emit(ProfileSuccess(profileData));
      } else {
        print('❌ ProfileCubit: No user data available from login');
        emit(ProfileError('Unable to load profile. Please verify your email.'));
      }
    } catch (e) {
      print('💥 ProfileCubit: Error getting user data: $e');
      emit(ProfileError('Unable to load profile. Please verify your email.'));
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? fullName,
    String? aboutMe,
    String? imageUrl,
  }) async {
    emit(ProfileUpdating());

    try {
      // Update user data in ApiService directly (local storage)
      final apiService = sl<ApiService>();
      if (apiService.userData != null) {
        if (fullName != null) {
          apiService.userData!['full_name'] = fullName;
        }
        if (aboutMe != null) {
          apiService.userData!['about_me'] = aboutMe;
        }
        if (imageUrl != null) {
          apiService.userData!['image_url'] = imageUrl;
        }
        await apiService.setUserData(apiService.userData!);
        print('🔄 ProfileCubit: Updated user data in ApiService');
      }

      // Update current state with new data
      final currentState = state;
      if (currentState is ProfileSuccess) {
        final updatedUser = UserProfile(
          id: currentState.data.user.id,
          imageUrl: currentState.data.user.imageUrl,
          fullName: fullName ?? currentState.data.user.fullName,
          aboutMe: aboutMe ?? currentState.data.user.aboutMe,
        );

        final updatedProfileData = ProfileData(
          user: updatedUser,
          favorites: currentState.data.favorites,
        );

        emit(ProfileSuccess(updatedProfileData));
      } else {
        // If no current state, refresh profile
        await getProfile();
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Refresh profile
  Future<void> refreshProfile() async {
    await getProfile();
  }

  // Upload profile image
  Future<void> uploadProfileImage(File imageFile) async {
    emit(ProfileUpdating());
    print('📸 ProfileCubit: Starting to upload profile image...');

    try {
      final response = await _profileRepository.uploadProfileImage(imageFile);

      if (response.status && response.data != null) {
        print('✅ ProfileCubit: Profile image uploaded successfully');

        // Update user data with new image URL
        final apiService = sl<ApiService>();
        if (apiService.userData != null) {
          apiService.userData!['image_url'] = response.data!.imageUrl;
          apiService.setUserData(apiService.userData!);
          print(
            '🔄 ProfileCubit: Updated user data with new image URL: ${response.data!.imageUrl}',
          );
        }

        // Refresh profile to show updated image
        await getProfile();
      } else {
        print('❌ ProfileCubit: Profile image upload failed: ${response.msg}');
        emit(ProfileError(response.msg));
      }
    } catch (e) {
      print('💥 ProfileCubit: Error uploading profile image: $e');
      emit(ProfileError('Failed to upload image: $e'));
    }
  }
}
