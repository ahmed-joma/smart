import 'dart:convert';
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
    print('✅ TokenManager initialized');
  }

  // Token Management
  Future<void> saveToken(String token) async {
    await _prefs?.setString(_tokenKey, token);
    print('💾 Token saved to SharedPreferences');
  }

  Future<String?> getToken() async {
    final token = _prefs?.getString(_tokenKey);
    if (token != null) {
      print('🔄 Token retrieved from SharedPreferences');
    } else {
      print('🔓 No token found in SharedPreferences');
    }
    return token;
  }

  Future<void> clearToken() async {
    await _prefs?.remove(_tokenKey);
    print('🗑️ Token cleared from SharedPreferences');
  }

  // User Data Management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final userJson = jsonEncode(userData);
    await _prefs?.setString(_userKey, userJson);
    print('💾 User data saved to SharedPreferences');
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userJson = _prefs?.getString(_userKey);
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        print('🔄 User data retrieved from SharedPreferences');
        return userData;
      } catch (e) {
        print('❌ Error parsing user data: $e');
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
