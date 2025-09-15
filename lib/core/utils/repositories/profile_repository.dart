import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/auth_models.dart';
import '../models/api_error.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();

  // Get Profile
  Future<ApiResponse<User>> getProfile() async {
    try {
      return await _apiService.get<User>(
        ApiConstants.profile,
        fromJson: (json) => User.fromJson(json),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Update Profile
  Future<ApiResponse<User>> updateProfile({
    String? name,
    String? phone,
    String? image,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (image != null) data['image'] = image;

      return await _apiService.post<User>(
        ApiConstants.profile,
        data: data,
        fromJson: (json) => User.fromJson(json),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }
}
