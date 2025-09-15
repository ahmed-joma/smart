import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/filter_models.dart';
import '../models/api_error.dart';

class EventRepository {
  final ApiService _apiService = ApiService();

  // Get Event Details
  Future<ApiResponse<Event>> getEventDetails(int eventId) async {
    try {
      return await _apiService.get<Event>(
        '${ApiConstants.event}/$eventId',
        fromJson: (json) => Event.fromJson(json),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }
}
