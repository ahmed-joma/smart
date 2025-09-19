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
  Future<ApiResponse<Map<String, dynamic>>> updateProfile({
    required String fullName, // ✅ Required field
    required String aboutMe, // ✅ Required field
    File? imageFile, // ✅ Optional image file
  }) async {
    try {
      print('🔍 Updating user profile...');
      print('📝 Full Name: $fullName');
      print('📝 About Me: $aboutMe');
      print('📷 Image File: ${imageFile?.path ?? 'No image'}');

      // Ensure token is loaded before making the request
      await _apiService.loadToken();

      // Use multipart form data as required by API
      final response = await _apiService
          .postMultipartForm<Map<String, dynamic>>(
            ApiConstants.profile, // POST /profile (not /profile/update)
            fields: {'full_name': fullName, 'about_me': aboutMe},
            file: imageFile,
            fileFieldName: 'image',
            fromJson: (json) => json, // Just return the JSON as-is
          );

      print('✅ Profile updated successfully');
      print('📦 Response: ${response.data}');
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
