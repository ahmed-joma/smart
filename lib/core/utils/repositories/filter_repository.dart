import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/filter_models.dart';
import '../models/api_error.dart';

class FilterRepository {
  final ApiService _apiService = ApiService();

  // Get Filter Details (Cities and Tags)
  Future<ApiResponse<FilterDetails>> getDetails() async {
    try {
      return await _apiService.get<FilterDetails>(
        ApiConstants.getDetails,
        fromJson: (json) => FilterDetails.fromJson(json),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Filter Events and Hotels
  Future<ApiResponse<FilterResult>> filter(FilterRequest request) async {
    try {
      return await _apiService.get<FilterResult>(
        ApiConstants.filter,
        queryParameters: request.toQueryParams(),
        fromJson: (json) => FilterResult.fromJson(json),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
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
