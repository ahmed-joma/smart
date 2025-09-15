import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/auth_models.dart';
import '../models/api_error.dart';
import '../service_locator.dart';

class AuthRepository {
  final ApiService _apiService = sl<ApiService>();

  // Register
  Future<ApiResponse<AuthResponse>> register(RegisterRequest request) async {
    try {
      // Clear any existing token before register
      _apiService.clearToken();

      // Debug: Print the request data
      print('🔍 RegisterRequest toJson: ${request.toJson()}');

      final response = await _apiService.post<AuthResponse>(
        ApiConstants.register,
        data: request.toJson(),
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        _apiService.setToken(response.data!.token);
      }

      return response;
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Login
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      print('🔐 Starting Login Process...');
      print('📧 Email: ${request.email}');

      // Clear any existing token before login
      _apiService.clearToken();

      final response = await _apiService.post<AuthResponse>(
        ApiConstants.login,
        data: request.toJson(),
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        _apiService.setToken(response.data!.token);
        print('✅ Login Successful!');
      } else {
        print('❌ Login Failed: ${response.msg}');
      }

      return response;
    } on ApiError catch (e) {
      print('💥 Login Error: ${e.message}');
      throw e;
    } catch (e) {
      print('💥 Unexpected Error: $e');
      throw ApiError.fromException(e);
    }
  }

  // Logout
  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _apiService.post<void>(ApiConstants.logout);

      // Clear token regardless of response
      _apiService.clearToken();

      return response;
    } on ApiError catch (e) {
      // Clear token even if logout fails
      _apiService.clearToken();
      throw e;
    } catch (e) {
      _apiService.clearToken();
      throw ApiError.fromException(e);
    }
  }

  // Verify Email
  Future<ApiResponse<void>> verifyEmail(VerifyEmailRequest request) async {
    try {
      return await _apiService.post<void>(
        ApiConstants.verifyEmail,
        data: request.toJson(),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Resend Verification Code
  Future<ApiResponse<void>> resendVerification(String email) async {
    try {
      return await _apiService.post<void>(
        ApiConstants.resendVerification,
        data: {'email': email},
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Send Reset Code
  Future<ApiResponse<void>> sendResetCode(SendResetCodeRequest request) async {
    try {
      return await _apiService.post<void>(
        ApiConstants.sendResetCode,
        data: request.toJson(),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Reset Password
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    try {
      return await _apiService.post<void>(
        ApiConstants.resetPassword,
        data: request.toJson(),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => _apiService.token != null;

  // Get current token
  String? get token => _apiService.token;
}
