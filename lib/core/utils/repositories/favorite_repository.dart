import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/favorite_models.dart';
import '../models/api_error.dart';

class FavoriteRepository {
  final ApiService _apiService = ApiService();

  // Update Favorite (Toggle)
  Future<ApiResponse<FavoriteResponse>> updateFavorite(
    FavoriteRequest request,
  ) async {
    try {
      return await _apiService.post<FavoriteResponse>(
        ApiConstants.favoriteUpdate,
        data: request.toJson(),
        fromJson: (json) => FavoriteResponse.fromJson(json),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Add Event to Favorites
  Future<ApiResponse<FavoriteResponse>> addEventToFavorites(int eventId) async {
    try {
      final request = FavoriteRequest(
        favoritableType: 'App\\Models\\Event',
        favoritableId: eventId,
      );
      return await updateFavorite(request);
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Add Hotel to Favorites
  Future<ApiResponse<FavoriteResponse>> addHotelToFavorites(int hotelId) async {
    try {
      final request = FavoriteRequest(
        favoritableType: 'App\\Models\\Hotel',
        favoritableId: hotelId,
      );
      return await updateFavorite(request);
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Remove Event from Favorites
  Future<ApiResponse<FavoriteResponse>> removeEventFromFavorites(
    int eventId,
  ) async {
    try {
      final request = FavoriteRequest(
        favoritableType: 'App\\Models\\Event',
        favoritableId: eventId,
      );
      return await updateFavorite(request);
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Remove Hotel from Favorites
  Future<ApiResponse<FavoriteResponse>> removeHotelFromFavorites(
    int hotelId,
  ) async {
    try {
      final request = FavoriteRequest(
        favoritableType: 'App\\Models\\Hotel',
        favoritableId: hotelId,
      );
      return await updateFavorite(request);
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }
}
