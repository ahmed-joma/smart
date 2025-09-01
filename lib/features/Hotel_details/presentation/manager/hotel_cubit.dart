import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repos/hotel_repository.dart';

// Events
abstract class HotelEvent extends Equatable {
  const HotelEvent();

  @override
  List<Object> get props => [];
}

class LoadHotelDetails extends HotelEvent {
  final String hotelId;

  const LoadHotelDetails(this.hotelId);

  @override
  List<Object> get props => [hotelId];
}

// States
abstract class HotelState extends Equatable {
  const HotelState();

  @override
  List<Object> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelLoaded extends HotelState {
  final Map<String, dynamic> hotelData;

  const HotelLoaded(this.hotelData);

  @override
  List<Object> get props => [hotelData];
}

class HotelError extends HotelState {
  final String message;

  const HotelError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class HotelCubit extends Cubit<HotelState> {
  final HotelRepository _hotelRepository;

  HotelCubit(this._hotelRepository) : super(HotelInitial());

  Future<void> loadHotelDetails(String hotelId) async {
    emit(HotelLoading());
    try {
      final hotelData = await _hotelRepository.getHotelDetails(hotelId);
      emit(HotelLoaded(hotelData));
    } catch (e) {
      emit(HotelError(e.toString()));
    }
  }
}
