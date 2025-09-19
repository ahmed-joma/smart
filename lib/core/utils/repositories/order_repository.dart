import '../api_service.dart';
import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/order_models.dart';
import '../service_locator.dart';

class OrderRepository {
  final ApiService _apiService = sl<ApiService>();

  // Store Order (Book Hotel or Buy Event Ticket)
  Future<ApiResponse<OrderData>> storeOrder(OrderRequest request) async {
    try {
      print('🎫 OrderRepository: Starting order creation...');
      print('📦 Order type: ${request.orderableType}');
      print('🆔 Order ID: ${request.orderableId}');
      print('💰 Total price: ${request.totalPrice}');

      // Ensure token is loaded before making the request
      await _apiService.loadToken();

      if (_apiService.token == null) {
        throw Exception(
          'No authentication token available. Please login again.',
        );
      }

      print('🔑 OrderRepository: Using token for authentication');

      final response = await _apiService.post<OrderData>(
        ApiConstants.orderStore,
        data: request.toJson(),
        fromJson: (json) {
          print('🔍 Raw order API response: $json');
          return OrderData.fromJson(json);
        },
      );

      print('✅ OrderRepository: Order created successfully');
      print('📊 Response status: ${response.status}');

      if (!response.status) {
        throw Exception('Order creation failed: ${response.msg}');
      }

      return response;
    } catch (e) {
      print('❌ OrderRepository: Error creating order: $e');

      String errorMessage;
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (e.toString().contains('422')) {
        errorMessage = 'Invalid order data. Please check your selection.';
      } else if (e.toString().contains('No authentication token')) {
        errorMessage = 'Please login to place orders.';
      } else if (e.toString().contains('Connection')) {
        errorMessage = 'Network connection error. Please check your internet.';
      } else {
        errorMessage = 'Failed to create order. Please try again.';
      }

      throw Exception(errorMessage);
    }
  }

  // Get User Orders
  Future<ApiResponse<UserOrdersData>> getUserOrders() async {
    try {
      print('📋 OrderRepository: Starting user orders fetch...');

      // Ensure token is loaded before making the request
      await _apiService.loadToken();

      if (_apiService.token == null) {
        throw Exception(
          'No authentication token available. Please login again.',
        );
      }

      print('🔑 OrderRepository: Using token for authentication');

      final response = await _apiService.get<UserOrdersData>(
        ApiConstants.orderShowUserOrders,
        fromJson: (json) {
          print('🔍 Raw user orders API response: $json');
          return UserOrdersData.fromJson(json);
        },
      );

      print('✅ OrderRepository: User orders fetched successfully');
      print('📊 Response status: ${response.status}');

      if (!response.status) {
        throw Exception('Failed to fetch user orders: ${response.msg}');
      }

      if (response.data != null) {
        print('📊 Upcoming events: ${response.data!.events.upcoming.length}');
        print('📊 Past events: ${response.data!.events.past.length}');
        print('📊 Current hotels: ${response.data!.hotels.current.length}');
        print('📊 Past hotels: ${response.data!.hotels.past.length}');
      }

      return response;
    } catch (e) {
      print('❌ OrderRepository: Error fetching user orders: $e');

      String errorMessage;
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (e.toString().contains('No authentication token')) {
        errorMessage = 'Please login to view your orders.';
      } else if (e.toString().contains('Connection')) {
        errorMessage = 'Network connection error. Please check your internet.';
      } else {
        errorMessage = 'Failed to load orders. Please try again.';
      }

      throw Exception(errorMessage);
    }
  }

  // Helper methods for creating specific order types
  Future<ApiResponse<OrderData>> bookHotel({
    required int hotelId,
    required double totalPrice,
  }) async {
    final request = OrderRequest(
      orderableType: 'App\\Models\\Hotel',
      orderableId: hotelId,
      totalPrice: totalPrice,
    );
    return storeOrder(request);
  }

  Future<ApiResponse<OrderData>> buyEventTicket({
    required int eventId,
    required double totalPrice,
  }) async {
    final request = OrderRequest(
      orderableType: 'App\\Models\\Event',
      orderableId: eventId,
      totalPrice: totalPrice,
    );
    return storeOrder(request);
  }
}
