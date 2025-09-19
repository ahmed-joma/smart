import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/filter_models.dart';
import '../models/api_error.dart';

class FilterRepository {
  final ApiService _apiService;

  FilterRepository(this._apiService);

  // Get Filter Details (Cities and Tags) - API Integration
  Future<ApiResponse<FilterDetails>> getDetails() async {
    try {
      print('🔍 FilterRepository: Fetching filter details (cities & tags)...');

      final response = await _apiService.get<FilterDetails>(
        ApiConstants.getDetails,
        fromJson: (json) => FilterDetails.fromJson(json),
      );

      print('✅ FilterRepository: Filter details fetched successfully');
      print('🏙️ Cities count: ${response.data?.cities.length ?? 0}');
      print('🏷️ Tags count: ${response.data?.tags.length ?? 0}');

      return response;
    } catch (e) {
      print('❌ FilterRepository: Error fetching filter details: $e');
      rethrow;
    }
  }

  // Filter Events and Hotels - API Integration
  Future<ApiResponse<FilterResult>> filter(FilterRequest request) async {
    try {
      print('🔍 FilterRepository: Applying filters...');
      print('📊 Filter params: ${request.toJson()}');

      final response = await _apiService.get<FilterResult>(
        ApiConstants.filter,
        queryParameters: request.toQueryParams(),
        fromJson: (json) => FilterResult.fromJson(json),
      );

      print('✅ FilterRepository: Filter applied successfully');
      print('🎉 Events found: ${response.data?.events.length ?? 0}');
      print('🏨 Hotels found: ${response.data?.hotels.length ?? 0}');

      return response;
    } catch (e) {
      print('❌ FilterRepository: Error applying filter: $e');
      rethrow;
    }
  }

  // Get Cities Only
  Future<List<City>> getCities() async {
    try {
      final response = await getDetails();
      if (response.isSuccess && response.data != null) {
        return response.data!.cities;
      }
      return [];
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Get Tags Only
  Future<List<Tag>> getTags() async {
    try {
      final response = await getDetails();
      if (response.isSuccess && response.data != null) {
        return response.data!.tags;
      }
      return [];
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Search Events and Hotels by Query
  Future<ApiResponse<FilterResult>> search(String query) async {
    try {
      final request = FilterRequest(q: query);
      return await filter(request);
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Filter by City
  Future<ApiResponse<FilterResult>> filterByCity(int cityId) async {
    try {
      final request = FilterRequest(cityId: cityId);
      return await filter(request);
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Filter by Tags
  Future<ApiResponse<FilterResult>> filterByTags(List<int> tagIds) async {
    try {
      final request = FilterRequest(tags: tagIds);
      return await filter(request);
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Filter by Price Range
  Future<ApiResponse<FilterResult>> filterByPriceRange({
    required double minPrice,
    required double maxPrice,
  }) async {
    try {
      final request = FilterRequest(priceMin: minPrice, priceMax: maxPrice);
      return await filter(request);
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Filter by Date Range
  Future<ApiResponse<FilterResult>> filterByDateRange({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final request = FilterRequest(startAtFrom: startDate, endAtTo: endDate);
      return await filter(request);
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }
}
