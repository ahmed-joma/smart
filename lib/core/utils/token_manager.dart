import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  static TokenManager? _instance;
  static TokenManager get instance => _instance ??= TokenManager._internal();
  
  TokenManager._internal();
  
  SharedPreferences? _prefs;
  
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Token Management
  Future<void> saveToken(String token) async {
    await _prefs?.setString(_tokenKey, token);
  }
  
  Future<String?> getToken() async {
    return _prefs?.getString(_tokenKey);
  }
  
  Future<void> clearToken() async {
    await _prefs?.remove(_tokenKey);
  }
  
  // User Data Management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final userJson = userData.toString();
    await _prefs?.setString(_userKey, userJson);
  }
  
  Future<Map<String, dynamic>?> getUserData() async {
    final userJson = _prefs?.getString(_userKey);
    if (userJson != null) {
      // Parse the string back to Map
      // Note: This is a simple implementation. In production, use proper JSON serialization
      try {
        // You might want to use jsonDecode here for proper parsing
        return {}; // Placeholder - implement proper JSON parsing
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  Future<void> clearUserData() async {
    await _prefs?.remove(_userKey);
  }
  
  // Clear all data
  Future<void> clearAll() async {
    await clearToken();
    await clearUserData();
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
