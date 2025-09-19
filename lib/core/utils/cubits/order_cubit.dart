import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/order_repository.dart';
import '../models/order_models.dart';
import '../service_locator.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository = sl<OrderRepository>();

  OrderCubit() : super(OrderInitial());

  // Store Order (Book Hotel or Buy Event Ticket)
  Future<void> storeOrder(OrderRequest request) async {
    print('🎫 OrderCubit: Starting order creation...');
    print('📦 OrderCubit: Request data: ${request.toJson()}');
    print('🔄 OrderCubit: Emitting OrderLoading state...');

    emit(OrderLoading());

    print('✅ OrderCubit: OrderLoading state emitted');

    try {
      print('📡 OrderCubit: Calling repository.storeOrder...');
      final response = await _orderRepository.storeOrder(request);
      print('📨 OrderCubit: Received response from repository');

      if (response.status && response.data != null) {
        print('✅ OrderCubit: Order created successfully');

        if (response.data!.booking != null) {
          print(
            '🏨 Hotel booking created: ${response.data!.booking!.orderNumber}',
          );
        } else if (response.data!.ticket != null) {
          print(
            '🎫 Event ticket created: ${response.data!.ticket!.orderNumber}',
          );
        }

        print('🔄 OrderCubit: Emitting OrderSuccess state...');
        emit(OrderSuccess(response.data!));
        print('✅ OrderCubit: OrderSuccess state emitted');
      } else {
        print('❌ OrderCubit: Order creation failed: ${response.msg}');
        emit(OrderError(response.msg));
      }
    } catch (e) {
      print('❌ OrderCubit: Error creating order: $e');
      print('🔄 OrderCubit: Emitting OrderError state...');
      emit(OrderError(e.toString()));
      print('✅ OrderCubit: OrderError state emitted');
    }
  }

  // Book Hotel
  Future<void> bookHotel({
    required int hotelId,
    required double totalPrice,
  }) async {
    print('🏨 OrderCubit: Booking hotel ID: $hotelId for SR$totalPrice');
    print('🔧 OrderCubit: Current state before booking: ${state.runtimeType}');

    final request = OrderRequest(
      orderableType: 'App\\Models\\Hotel',
      orderableId: hotelId,
      totalPrice: totalPrice,
    );

    print('📦 OrderCubit: Created request: ${request.toJson()}');
    await storeOrder(request);
  }

  // Buy Event Ticket
  Future<void> buyEventTicket({
    required int eventId,
    required double totalPrice,
  }) async {
    print(
      '🎫 OrderCubit: Buying ticket for event ID: $eventId for SR$totalPrice',
    );

    final request = OrderRequest(
      orderableType: 'App\\Models\\Event',
      orderableId: eventId,
      totalPrice: totalPrice,
    );

    await storeOrder(request);
  }

  // Get User Orders
  Future<void> getUserOrders() async {
    emit(UserOrdersLoading());
    print('📋 OrderCubit: Starting user orders fetch...');

    try {
      final response = await _orderRepository.getUserOrders();

      if (response.status && response.data != null) {
        print('✅ OrderCubit: User orders fetched successfully');
        print('📊 Upcoming events: ${response.data!.events.upcoming.length}');
        print('📊 Current hotels: ${response.data!.hotels.current.length}');

        emit(UserOrdersSuccess(response.data!));
      } else {
        print('❌ OrderCubit: User orders fetch failed: ${response.msg}');
        emit(UserOrdersError(response.msg));
      }
    } catch (e) {
      print('❌ OrderCubit: Error fetching user orders: $e');
      emit(UserOrdersError(e.toString()));
    }
  }

  // Refresh User Orders
  Future<void> refreshUserOrders() async {
    await getUserOrders();
  }

  // Reset states
  void resetOrderState() {
    emit(OrderInitial());
  }

  void resetUserOrdersState() {
    emit(UserOrdersInitial());
  }
}
