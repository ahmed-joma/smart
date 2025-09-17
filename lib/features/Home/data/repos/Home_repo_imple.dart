import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../models/home_models.dart';
import 'Home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiService _apiService;

  HomeRepoImpl(this._apiService);

  @override
  Future<HomeData> getHomeData() async {
    try {
      print('🏠 HomeRepository: Fetching home data...');

      // Ensure token is loaded before making the request
      await _apiService.loadToken();

      // Check if we have a valid token
      if (_apiService.token == null) {
        throw Exception(
          'No authentication token available. Please login again.',
        );
      }

      print('🔑 HomeRepository: Using token for authentication');

      final response = await _apiService.get<HomeData>(
        ApiConstants.home,
        fromJson: (json) => HomeData.fromJson(json),
      );

      print('✅ HomeRepository: Home data fetched successfully');

      if (!response.status || response.data == null) {
        throw Exception('Invalid response from server');
      }

      return response.data!;
    } catch (e) {
      print('❌ HomeRepository: Error fetching home data: $e');

      // If it's a 403 error, suggest re-login
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        throw Exception(
          'Authentication failed. Please login again to access home data.',
        );
      }

      rethrow;
    }
  }
}
