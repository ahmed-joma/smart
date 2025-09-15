import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/filter_models.dart';
import '../models/api_error.dart';

class HotelRepository {
  final ApiService _apiService = ApiService();

  // Get All Hotels
  Future<ApiResponse<List<Hotel>>> getAllHotels() async {
    try {
      return await _apiService.get<List<Hotel>>(
        ApiConstants.hotel,
        fromJson: (json) {
          if (json is List) {
            return (json as List<dynamic>)
                .map<Hotel>((hotel) => Hotel.fromJson(hotel))
                .toList();
          }
          return <Hotel>[];
        },
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Get Hotel Details
  Future<ApiResponse<Hotel>> getHotelDetails(int hotelId) async {
    try {
      return await _apiService.get<Hotel>(
        '${ApiConstants.hotel}/$hotelId',
        fromJson: (json) => Hotel.fromJson(json),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }
}
