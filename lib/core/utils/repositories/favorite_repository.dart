import '../api_service.dart';
import '../models/api_response.dart';
import '../constants/api_constants.dart';

class FavoriteRepository {
  final ApiService _apiService;

  FavoriteRepository(this._apiService);

  /// Toggle favorite status for an item (Hotel or Event)
  /// favoritable_type: "App\\Models\\Hotel" or "App\\Models\\Event"
  /// favoritable_id: ID of the hotel or event
  Future<ApiResponse<Map<String, dynamic>>> toggleFavorite({
    required String
    favoriteType, // "App\\Models\\Hotel" or "App\\Models\\Event"
    required int favoriteId,
  }) async {
    try {
      print(
        '🔄 FavoriteRepository: Toggling favorite for $favoriteType ID: $favoriteId',
      );

      final response = await _apiService
          .postMultipartForm<Map<String, dynamic>>(
            ApiConstants.favoriteUpdate,
            fields: {
              'favoritable_type': favoriteType,
              'favoritable_id': favoriteId.toString(),
            },
            fromJson: (json) => json, // Return raw JSON response
          );

      print('✅ FavoriteRepository: Toggle favorite response: ${response.data}');
      return response;
    } catch (e) {
      print('❌ FavoriteRepository: Error toggling favorite: $e');
      rethrow;
    }
  }

  /// Helper method to toggle hotel favorite
  Future<ApiResponse<Map<String, dynamic>>> toggleHotelFavorite(
    int hotelId,
  ) async {
    return await toggleFavorite(
      favoriteType: 'App\\Models\\Hotel',
      favoriteId: hotelId,
    );
  }

  /// Helper method to toggle event favorite
  Future<ApiResponse<Map<String, dynamic>>> toggleEventFavorite(
    int eventId,
  ) async {
    return await toggleFavorite(
      favoriteType: 'App\\Models\\Event',
      favoriteId: eventId,
    );
  }
}
