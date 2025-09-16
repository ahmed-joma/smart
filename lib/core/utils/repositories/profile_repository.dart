import 'dart:io';
import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/profile_models.dart';
import '../service_locator.dart';

class ProfileRepository {
  final ApiService _apiService = sl<ApiService>();

  // Get user profile with favorites
  Future<ApiResponse<ProfileData>> getProfile() async {
    try {
      print('🔍 Fetching user profile...');

      // Ensure token is loaded before making the request
      await _apiService.loadToken();

      final response = await _apiService.get<ProfileData>(
        ApiConstants.profile,
        fromJson: (json) => ProfileData.fromJson(json),
      );

      print('✅ Profile fetched successfully');
      return response;
    } catch (e) {
      print('❌ Error fetching profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<ApiResponse<UserProfile>> updateProfile({
    String? fullName,
    String? aboutMe,
    String? imageUrl,
  }) async {
    try {
      print('🔍 Updating user profile...');

      final data = <String, dynamic>{};
      if (fullName != null) data['full_name'] = fullName;
      if (aboutMe != null) data['about_me'] = aboutMe;
      if (imageUrl != null) data['image_url'] = imageUrl;

      print('📦 Update data: $data');

      final response = await _apiService.post<UserProfile>(
        ApiConstants.profile,
        data: data,
        fromJson: (json) => UserProfile.fromJson(json),
      );

      print('✅ Profile updated successfully');
      return response;
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }

  // Upload profile image
  Future<ApiResponse<ImageUploadResponse>> uploadProfileImage(
    File imageFile,
  ) async {
    try {
      print('📸 Uploading profile image...');
      print('📁 Image path: ${imageFile.path}');

      // Ensure token is loaded before making the request
      await _apiService.loadToken();

      final response = await _apiService.postMultipart<ImageUploadResponse>(
        ApiConstants.uploadProfileImage,
        file: imageFile,
        fieldName: 'image', // Field name for the image file
        fromJson: (json) => ImageUploadResponse.fromJson(json),
      );

      print('✅ Profile image uploaded successfully');
      return response;
    } catch (e) {
      print('❌ Error uploading profile image: $e');
      rethrow;
    }
  }
}
