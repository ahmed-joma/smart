import 'dart:io';
import 'package:dio/dio.dart';
import 'constants/api_constants.dart';
import 'models/api_response.dart';
import 'models/api_error.dart';
import 'token_manager.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _token;
  TokenManager? _tokenManager;
  Map<String, dynamic>? _userData;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        sendTimeout: Duration(milliseconds: ApiConstants.sendTimeout),
        headers: ApiConstants.defaultHeaders,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_createAuthInterceptor());
    _dio.interceptors.add(_createLoggingInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());

    print('✅ ApiService initialized');
  }

  // Set token manager reference
  void setTokenManager(TokenManager tokenManager) {
    _tokenManager = tokenManager;
    print('🔗 TokenManager linked to ApiService');
  }

  // Reset function for hot reload
  void reset() {
    _token = null;
    print('🔄 ApiService Reset - Token Cleared');
  }

  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
          print(
            '🔑 Using Token: ${_token!.substring(0, 20)}... for ${options.path}',
          );
        } else {
          print('🔓 No Token - Making public request to ${options.path}');
        }
        handler.next(options);
      },
    );
  }

  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
        print('🌐 Full URL: ${options.baseUrl}${options.path}');
        print('📝 Headers: ${options.headers}');
        if (options.data != null) {
          print('📦 Data: ${options.data}');
        }
        if (options.queryParameters.isNotEmpty) {
          print('🔍 Query Params: ${options.queryParameters}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print(
          '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
        );
        print('📄 Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print(
          '❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
        );
        print('💥 Message: ${error.message}');
        print(
          '🔗 Full URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}',
        );
        if (error.response?.data != null) {
          print('📄 Error Data: ${error.response?.data}');
        }
        handler.next(error);
      },
    );
  }

  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        ApiError apiError = _handleError(error);
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: apiError,
            response: error.response,
            type: error.type,
          ),
        );
      },
    );
  }

  ApiError _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          code: 408,
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        if (error.response?.data != null) {
          try {
            return ApiError.fromJson(error.response!.data);
          } catch (e) {
            return ApiError(
              code: error.response?.statusCode,
              message: error.response?.statusMessage ?? 'Server error occurred',
            );
          }
        }
        return ApiError(
          code: error.response?.statusCode,
          message: error.response?.statusMessage ?? 'Server error occurred',
        );
      case DioExceptionType.cancel:
        return ApiError(code: 499, message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        return ApiError(
          code: 0,
          message:
              'Cannot connect to server. Please check your internet connection.',
        );
      default:
        return ApiError(code: 500, message: 'An unexpected error occurred');
    }
  }

  // Token management
  void setToken(String token) {
    _token = token;
    _tokenManager?.saveToken(token);
    print('💾 Token Saved: ${token.substring(0, 20)}...');
  }

  void clearToken() {
    _token = null;
    _userData = null;
    _tokenManager?.clearToken();
    _tokenManager?.clearUserData();
    print('🗑️ Token and User Data Cleared');
  }

  void clearAllData() {
    _token = null;
    _userData = null;
    _tokenManager?.clearAll();
    print('🗑️ All Data Cleared');
  }

  // User data management
  void setUserData(Map<String, dynamic> userData) async {
    // Clear old user data first
    if (_tokenManager != null) {
      await _tokenManager!.clearUserData();
    }

    _userData = userData;

    // Save new user data to SharedPreferences for persistence
    if (_tokenManager != null) {
      await _tokenManager!.saveUserData(userData);
    }

    print(
      '👤 User Data Saved: ${userData['full_name']} (${userData['email']})',
    );
  }

  Map<String, dynamic>? get userData => _userData;

  // Load token from storage
  Future<void> loadToken() async {
    if (_tokenManager != null) {
      _token = await _tokenManager!.getToken();
      if (_token != null) {
        print('🔄 Token Loaded: ${_token!.substring(0, 20)}...');
      } else {
        print('🔓 No Token Found in Storage');
      }

      // Load user data from storage
      _userData = await _tokenManager!.getUserData();
      if (_userData != null) {
        print(
          '👤 User Data Loaded: ${_userData!['full_name']} (${_userData!['email']})',
        );
      } else {
        print('🔓 No User Data Found in Storage');
      }
    } else {
      print('❌ TokenManager is null - cannot load token');
    }
  }

  String? get token => _token;

  // Generic HTTP methods
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return ApiResponse.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      } else {
        throw _handleError(e);
      }
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      } else {
        throw _handleError(e);
      }
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      } else {
        throw _handleError(e);
      }
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      } else {
        throw _handleError(e);
      }
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return ApiResponse.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      } else {
        throw _handleError(e);
      }
    }
  }

  // Multipart file upload method
  Future<ApiResponse<T>> postMultipart<T>(
    String path, {
    required File file,
    required String fieldName,
    Map<String, dynamic>? additionalFields,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      print('📤 Uploading file: ${file.path}');

      // Create FormData for multipart upload
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        ...?additionalFields,
      });

      final response = await _dio.post(
        path,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print('✅ File uploaded successfully');
      return ApiResponse.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      if (e.error is ApiError) {
        throw e.error as ApiError;
      } else {
        throw _handleError(e);
      }
    }
  }
}
