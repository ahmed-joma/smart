import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/home_models.dart';
import '../../../data/repos/Home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeInitial());

  // Get home data (upcoming, ongoing, expired events)
  Future<void> getHomeData() async {
    emit(HomeLoading());

    try {
      print('🏠 HomeCubit: Fetching home data...');

      final response = await _homeRepo.getHomeData();

      print('✅ HomeCubit: Home data fetched successfully');
      print(
        '📊 Events count - Upcoming: ${response.events.upcoming.length}, Ongoing: ${response.events.ongoing.length}, Expired: ${response.events.expired.length}',
      );

      emit(HomeSuccess(response));
    } catch (e) {
      print('❌ HomeCubit: Error fetching home data: $e');

      // Handle different types of errors
      String errorMessage;
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (e.toString().contains('No authentication token')) {
        errorMessage = 'Please login to access home data.';
      } else if (e.toString().contains('Connection')) {
        errorMessage = 'Network connection error. Please check your internet.';
      } else {
        errorMessage = 'Failed to load events. Please try again.';
      }

      emit(HomeError(errorMessage));
    }
  }

  // Refresh home data
  Future<void> refreshHomeData() async {
    await getHomeData();
  }
}
