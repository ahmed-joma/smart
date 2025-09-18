import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/hotel_models.dart';
import '../../data/repos/Hotel_Home_repo.dart';

part 'hotel_home_state.dart';

class HotelHomeCubit extends Cubit<HotelHomeState> {
  final HotelHomeRepo _hotelHomeRepo;

  HotelHomeCubit(this._hotelHomeRepo) : super(HotelHomeInitial());

  // Get hotel data (near location and popular hotels)
  Future<void> getHotelData() async {
    print('🏨 HotelHomeCubit: Starting getHotelData()');
    emit(HotelHomeLoading());

    try {
      print('🏨 HotelHomeCubit: Fetching hotel data...');

      final response = await _hotelHomeRepo.getHotelData();

      print('✅ HotelHomeCubit: Hotel data fetched successfully');
      print(
        '📊 Hotels count - Near Location: ${response.hotels.nearLocationHotels.length}, Popular: ${response.hotels.popularHotels.length}',
      );

      if (response.hotels.nearLocationHotels.isEmpty &&
          response.hotels.popularHotels.isEmpty) {
        print('⚠️ HotelHomeCubit: Both hotel lists are empty!');
      }

      emit(HotelHomeSuccess(response));
    } catch (e) {
      print('❌ HotelHomeCubit: Error fetching hotel data: $e');

      // Handle different types of errors
      String errorMessage;
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (e.toString().contains('No authentication token')) {
        errorMessage = 'Please login to access hotel data.';
      } else if (e.toString().contains('Connection')) {
        errorMessage = 'Network connection error. Please check your internet.';
      } else {
        errorMessage = 'Failed to load hotels. Please try again.';
      }

      emit(HotelHomeError(errorMessage));
    }
  }

  // Refresh hotel data
  Future<void> refreshHotelData() async {
    await getHotelData();
  }

  // Toggle favorite status for a hotel
  Future<void> toggleFavorite(int hotelId) async {
    // TODO: Implement favorite toggle API call
    print('🏨 HotelHomeCubit: Toggle favorite for hotel ID: $hotelId');

    // For now, we'll just refresh the data
    // In a real implementation, you would call an API to update favorite status
    // and then refresh the data or update the specific hotel in the current state
  }
}
