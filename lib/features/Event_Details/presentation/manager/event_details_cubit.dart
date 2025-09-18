import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/event_details_model.dart';
import '../../data/repos/event_repository.dart' as event_repo;

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

  EventDetailsCubit(this._eventRepository) : super(EventDetailsInitial());

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
}
