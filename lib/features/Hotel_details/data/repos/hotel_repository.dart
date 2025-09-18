import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../../../core/utils/service_locator.dart';
import '../models/hotel_details_model.dart';

abstract class HotelRepository {
  Future<Map<String, dynamic>> getHotelDetails(String hotelId);
  Future<HotelDetails> getHotelDetailsById(int hotelId);
}

class HotelRepositoryImpl implements HotelRepository {
  final ApiService _apiService = sl<ApiService>();

  @override
  Future<Map<String, dynamic>> getHotelDetails(String hotelId) async {
    // Keep the old method for backward compatibility
    await Future.delayed(const Duration(seconds: 1));
    return {
      'id': hotelId,
      'title': 'Four Points by Sheraton',
      'date': '14 December, 2025',
      'day': 'Tuesday',
      'time': 'Check-in: 3:00PM',
      'location': 'Jeddah Corniche',
      'country': 'KSA',
      'organizer': 'Marriott International',
      'organizerCountry': 'USA',
      'about':
          'Luxury hotel with stunning sea views, world-class amenities, and exceptional service in the heart of Jeddah.',
      'guests': '+50 Guests',
      'price': 'SR165.3',
      'image': 'assets/images/hotel.svg',
    };
  }

  @override
  Future<HotelDetails> getHotelDetailsById(int hotelId) async {
    try {
      print(
        '🏨 HotelRepository: Starting hotel details fetch for ID: $hotelId',
      );

      // Load token for authentication
      await _apiService.loadToken();
      if (_apiService.token == null) {
        throw Exception(
          'No authentication token available. Please login again.',
        );
      }

      print('🔑 HotelRepository: Using token for authentication');

      final response = await _apiService.get<HotelDetailsData>(
        '${ApiConstants.hotelDetails}/$hotelId',
        fromJson: (json) {
          print('🔍 Raw API data (from ApiService): $json');
          return HotelDetailsData.fromJson(json);
        },
      );

      print('✅ HotelRepository: API response received');
      print('📊 Response status: ${response.status}');

      if (!response.status || response.data == null) {
        throw Exception('Invalid response from server');
      }

      print('✅ HotelRepository: Hotel details fetched successfully');
      print(
        '📊 Hotel: ${response.data!.hotel.name} (${response.data!.hotel.city})',
      );

      return response.data!.hotel;
    } catch (e) {
      print('❌ HotelRepository: Error fetching hotel details: $e');

      // Handle different types of errors
      String errorMessage;
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (e.toString().contains('No authentication token')) {
        errorMessage = 'Please login to access hotel details.';
      } else if (e.toString().contains('Connection')) {
        errorMessage = 'Network connection error. Please check your internet.';
      } else {
        errorMessage = 'Failed to load hotel details. Please try again.';
      }

      throw Exception(errorMessage);
    }
  }
}
