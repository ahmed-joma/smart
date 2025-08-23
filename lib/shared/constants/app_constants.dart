class AppConstants {
  // App Info
  static const String appName = 'Smart Shop Map';
  static const String appVersion = '1.0.0';

  // API Constants
  static const String baseUrl = 'https://api.smartshop.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String cartDataKey = 'cart_data';

  // Map Constants
  static const double defaultZoom = 15.0;
  static const double maxZoom = 18.0;
  static const double minZoom = 10.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
