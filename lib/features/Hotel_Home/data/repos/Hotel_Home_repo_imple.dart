import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../models/hotel_models.dart';
import 'Hotel_Home_repo.dart';

class HotelHomeRepoImpl implements HotelHomeRepo {
  final ApiService _apiService;

  HotelHomeRepoImpl(this._apiService);

  @override
  Future<HotelData> getHotelData() async {
    try {
      print('🏨 HotelHomeRepo: Starting hotel data fetch...');

      // Load token for authentication
      await _apiService.loadToken();
      if (_apiService.token == null) {
        throw Exception(
          'No authentication token available. Please login again.',
        );
      }

      print('🔑 HotelHomeRepo: Using token for authentication');

      final response = await _apiService.get<HotelData>(
        ApiConstants.hotel,
        fromJson: (json) {
          print('🔍 Raw API data (from ApiService): $json');
          return HotelData.fromJson(json);
        },
      );

      print('✅ HotelHomeRepo: API response received');
      print('📊 Response status: ${response.status}');

      if (!response.status || response.data == null) {
        throw Exception('Invalid response from server');
      }

      print('✅ HotelHomeRepo: Hotel data fetched successfully');
      print(
        '📊 Near location hotels: ${response.data!.hotels.nearLocationHotels.length}',
      );
      print('📊 Popular hotels: ${response.data!.hotels.popularHotels.length}');

      return response.data!;
    } catch (e) {
      print('❌ HotelHomeRepo: Error fetching hotel data: $e');

      // Handle different types of errors
      String errorMessage;
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (e.toString().contains('No authentication token')) {
        errorMessage = 'Please login to access hotel data.';
      } else if (e.toString().contains('Connection')) {
        errorMessage = 'Network connection error. Please check your internet.';
      } else {
        errorMessage = 'Failed to load hotels. Please try again.';
      }

      throw Exception(errorMessage);
    }
  }
}
