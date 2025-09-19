import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/filter_repository.dart';
import '../models/filter_models.dart';
import 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  final FilterRepository _filterRepository;

  FilterCubit(this._filterRepository) : super(FilterInitial());

  // Get filter details (cities and tags) for the UI
  Future<void> getFilterDetails() async {
    try {
      emit(FilterDetailsLoading());

      print('🔍 FilterCubit: Loading filter details...');

      final response = await _filterRepository.getDetails();

      if (response.status && response.data != null) {
        print('✅ FilterCubit: Filter details loaded successfully');
        emit(FilterDetailsSuccess(response.data!));
      } else {
        print('❌ FilterCubit: Failed to load filter details');
        emit(
          FilterDetailsError(
            response.msg.isNotEmpty
                ? response.msg
                : 'Failed to load filter details',
          ),
        );
      }
    } catch (e) {
      print('❌ FilterCubit: Error loading filter details: $e');
      emit(
        FilterDetailsError('Failed to load filter details: ${e.toString()}'),
      );
    }
  }

  // Apply filters and get results
  Future<void> applyFilters(FilterRequest request) async {
    try {
      emit(FilterResultsLoading());

      print('🔍 FilterCubit: Applying filters...');
      print('📊 Filter request: ${request.toJson()}');

      final response = await _filterRepository.filter(request);

      if (response.status && response.data != null) {
        print('✅ FilterCubit: Filter results loaded successfully');
        print(
          '🎉 Events: ${response.data!.events.length}, Hotels: ${response.data!.hotels.length}',
        );
        emit(FilterResultsSuccess(response.data!, request));
      } else {
        print('❌ FilterCubit: Failed to apply filters');
        emit(
          FilterResultsError(
            response.msg.isNotEmpty ? response.msg : 'No results found',
          ),
        );
      }
    } catch (e) {
      print('❌ FilterCubit: Error applying filters: $e');
      emit(FilterResultsError('Failed to apply filters: ${e.toString()}'));
    }
  }

  // Search by query
  Future<void> searchByQuery(String query) async {
    try {
      emit(FilterResultsLoading());

      print('🔍 FilterCubit: Searching for: $query');

      final response = await _filterRepository.search(query);

      if (response.status && response.data != null) {
        print('✅ FilterCubit: Search results loaded successfully');
        print(
          '🎉 Events: ${response.data!.events.length}, Hotels: ${response.data!.hotels.length}',
        );

        // Create a FilterRequest for the search to track active filters
        final searchRequest = FilterRequest(q: query);
        emit(FilterResultsSuccess(response.data!, searchRequest));
      } else {
        print('❌ FilterCubit: No search results found');
        emit(FilterResultsError('No results found for "$query"'));
      }
    } catch (e) {
      print('❌ FilterCubit: Error searching: $e');
      emit(FilterResultsError('Search failed: ${e.toString()}'));
    }
  }

  // Clear filters and reset to initial state
  void clearFilters() {
    print('🔄 FilterCubit: Clearing all filters');
    emit(FilterInitial());
  }

  // Reset to filter details (for going back to filter selection)
  void resetToFilterDetails(FilterDetails details) {
    print('🔄 FilterCubit: Resetting to filter details');
    emit(FilterDetailsSuccess(details));
  }
}
