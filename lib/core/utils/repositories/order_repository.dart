import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/order_models.dart';
import '../models/api_error.dart';

class OrderRepository {
  final ApiService _apiService = ApiService();

  // Create Order
  Future<ApiResponse<Order>> createOrder(CreateOrderRequest request) async {
    try {
      return await _apiService.post<Order>(
        ApiConstants.orderStore,
        data: request.toJson(),
        fromJson: (json) => Order.fromJson(json),
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }

  // Get User Orders
  Future<ApiResponse<List<Order>>> getUserOrders() async {
    try {
      return await _apiService.get<List<Order>>(
        ApiConstants.orderShowUserOrders,
        fromJson: (json) {
          if (json is List) {
            return (json as List<dynamic>)
                .map<Order>((order) => Order.fromJson(order))
                .toList();
          }
          return <Order>[];
        },
      );
    } on ApiError catch (e) {
      throw e;
    } catch (e) {
      throw ApiError.fromException(e);
    }
  }
}
