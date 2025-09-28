class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // API Key
  static const String apiKey = 'X-API-Key';

  // Authentication Endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String verifyEmail = '/verify';
  static const String resendVerification = '/verify/resend';
  static const String sendResetCode = '/password/send/code';
  static const String resetPassword = '/password/reset';

  // Profile Endpoints
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String uploadProfileImage = '/profile/upload-image';

  // Home Endpoints
  static const String home = '/home';

  // Event Endpoints
  static const String event = '/event';
  static const String eventDetails = '/event'; // GET /event/{id}

  // Order Endpoints
  static const String orderStore = '/order/store';
  static const String orderShowUserOrders = '/order/showUserOrders';

  // Hotel Endpoints
  static const String hotel = '/hotel';
  static const String hotelDetails = '/hotel'; // GET /hotel/{id}

  // Favorite Endpoints
  static const String favoriteUpdate = '/favorite/update';

  // Filter Endpoints
  static const String getDetails = '/filter/getDetails';
  static const String filter = '/filter';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeouts
  static const int connectTimeout = 120000; // 120 seconds
  static const int receiveTimeout = 120000; // 120 seconds
  static const int sendTimeout = 120000; // 120 seconds
}
