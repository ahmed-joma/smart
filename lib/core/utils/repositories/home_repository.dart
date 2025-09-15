import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/home_models.dart';
import '../models/api_error.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();

  // Get Home Data
  Future<ApiResponse<HomeData>> getHomeData() async {
    try {
      return await _apiService.get<HomeData>(
        ApiConstants.home,
        fromJson: (json) => HomeData.fromJson(json),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }
}
