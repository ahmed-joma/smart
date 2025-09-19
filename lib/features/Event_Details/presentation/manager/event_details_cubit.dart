import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/event_details_model.dart';
import '../../data/repos/event_repository.dart' as event_repo;
import '../../../../core/utils/repositories/favorite_repository.dart';

// States
abstract class EventDetailsState extends Equatable {
  const EventDetailsState();

  @override
  List<Object> get props => [];
}

class EventDetailsInitial extends EventDetailsState {}

class EventDetailsLoading extends EventDetailsState {}

class EventDetailsSuccess extends EventDetailsState {
  final EventDetailsModel event;

  const EventDetailsSuccess(this.event);

  @override
  List<Object> get props => [event];
}

class EventDetailsError extends EventDetailsState {
  final String message;

  const EventDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class EventDetailsCubit extends Cubit<EventDetailsState> {
  final event_repo.EventRepository _eventRepository;
  final FavoriteRepository _favoriteRepository;

  EventDetailsCubit(this._eventRepository, this._favoriteRepository)
    : super(EventDetailsInitial());

  Future<void> getEventDetails(int eventId) async {
    emit(EventDetailsLoading());
    try {
      print('🔍 EventDetailsCubit: Loading event details for ID: $eventId');

      final event = await _eventRepository.getEventDetailsById(eventId);

      print('✅ EventDetailsCubit: Event details loaded successfully');
      print('📊 Event title: ${event.title}');
      print('🏢 Venue: ${event.venue}');
      print('🏙️ City: ${event.city}');

      emit(EventDetailsSuccess(event));
    } catch (e) {
      print('❌ EventDetailsCubit: Error loading event details: $e');
      emit(EventDetailsError(e.toString()));
    }
  }

  Future<void> refreshEventDetails(int eventId) async {
    // Don't emit loading state for refresh to avoid UI flickering
    try {
      print('🔄 EventDetailsCubit: Refreshing event details for ID: $eventId');

      final event = await _eventRepository.getEventDetailsById(eventId);

      print('✅ EventDetailsCubit: Event details refreshed successfully');
      emit(EventDetailsSuccess(event));
    } catch (e) {
      print('❌ EventDetailsCubit: Error refreshing event details: $e');
      emit(EventDetailsError(e.toString()));
    }
  }

  Future<void> toggleFavorite(int eventId) async {
    print('💖 EventDetailsCubit: Toggle favorite for event ID: $eventId');

    try {
      final response = await _favoriteRepository.toggleEventFavorite(eventId);

      if (response.status && response.data != null) {
        final isFavorite = response.data!['is_favorite'] as bool;
        print(
          '✅ EventDetailsCubit: Favorite toggled successfully. Is favorite: $isFavorite',
        );

        // Refresh event details to get updated favorite status
        await refreshEventDetails(eventId);
      } else {
        print('❌ EventDetailsCubit: Failed to toggle favorite');
        emit(EventDetailsError('Failed to update favorite status'));
      }
    } catch (e) {
      print('❌ EventDetailsCubit: Error toggling favorite: $e');
      emit(EventDetailsError('Failed to update favorite: ${e.toString()}'));
    }
  }
}
