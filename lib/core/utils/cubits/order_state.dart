part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

// Order Creation States
class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final OrderData orderData;

  const OrderSuccess(this.orderData);

  @override
  List<Object> get props => [orderData];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

// User Orders States
class UserOrdersInitial extends OrderState {}

class UserOrdersLoading extends OrderState {}

class UserOrdersSuccess extends OrderState {
  final UserOrdersData userOrders;

  const UserOrdersSuccess(this.userOrders);

  @override
  List<Object> get props => [userOrders];
}

class UserOrdersError extends OrderState {
  final String message;

  const UserOrdersError(this.message);

  @override
  List<Object> get props => [message];
}
