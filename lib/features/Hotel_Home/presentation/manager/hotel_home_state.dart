part of 'hotel_home_cubit.dart';

sealed class HotelHomeState extends Equatable {
  const HotelHomeState();

  @override
  List<Object> get props => [];
}

final class HotelHomeInitial extends HotelHomeState {}

final class HotelHomeLoading extends HotelHomeState {}

final class HotelHomeSuccess extends HotelHomeState {
  final HotelData hotelData;

  const HotelHomeSuccess(this.hotelData);

  @override
  List<Object> get props => [hotelData];
}

final class HotelHomeError extends HotelHomeState {
  final String message;

  const HotelHomeError(this.message);

  @override
  List<Object> get props => [message];
}
