import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/hotel_details_model.dart';
import '../../data/repos/hotel_repository.dart';
import '../../../../core/utils/repositories/favorite_repository.dart';

// States
abstract class HotelDetailsState extends Equatable {
  const HotelDetailsState();

  @override
  List<Object> get props => [];
}

final class HotelDetailsInitial extends HotelDetailsState {}

final class HotelDetailsLoading extends HotelDetailsState {}

final class HotelDetailsSuccess extends HotelDetailsState {
  final HotelDetails hotel;

  const HotelDetailsSuccess(this.hotel);

  @override
  List<Object> get props => [hotel];
}

final class HotelDetailsError extends HotelDetailsState {
  final String message;

  const HotelDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class HotelDetailsCubit extends Cubit<HotelDetailsState> {
  final HotelRepository _hotelRepository;
  final FavoriteRepository _favoriteRepository;

  HotelDetailsCubit(this._hotelRepository, this._favoriteRepository)
    : super(HotelDetailsInitial());

  Future<void> getHotelDetails(int hotelId) async {
    print('🏨 HotelDetailsCubit: Loading hotel details for ID: $hotelId');
    emit(HotelDetailsLoading());

    try {
      final hotel = await _hotelRepository.getHotelDetailsById(hotelId);
      print('✅ HotelDetailsCubit: Hotel details loaded successfully');
      print('📊 Hotel: ${hotel.name} (${hotel.city})');
      emit(HotelDetailsSuccess(hotel));
    } catch (e) {
      print('❌ HotelDetailsCubit: Error loading hotel details: $e');
      emit(HotelDetailsError('Failed to load hotel details: ${e.toString()}'));
    }
  }

  Future<void> refreshHotelDetails(int hotelId) async {
    await getHotelDetails(hotelId);
  }

  Future<void> toggleFavorite(int hotelId) async {
    print('💖 HotelDetailsCubit: Toggle favorite for hotel ID: $hotelId');

    try {
      final response = await _favoriteRepository.toggleHotelFavorite(hotelId);

      if (response.status && response.data != null) {
        final isFavorite = response.data!['is_favorite'] as bool;
        print(
          '✅ HotelDetailsCubit: Favorite toggled successfully. Is favorite: $isFavorite',
        );

        // Refresh hotel details to get updated favorite status
        await refreshHotelDetails(hotelId);
      } else {
        print('❌ HotelDetailsCubit: Failed to toggle favorite');
        emit(HotelDetailsError('Failed to update favorite status'));
      }
    } catch (e) {
      print('❌ HotelDetailsCubit: Error toggling favorite: $e');
      emit(HotelDetailsError('Failed to update favorite: ${e.toString()}'));
    }
  }
}
