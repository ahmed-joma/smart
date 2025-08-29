import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/event_model.dart';
import '../../data/repos/event_repository.dart';

// Events
abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class LoadEvent extends EventEvent {
  final String eventId;

  const LoadEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class BookmarkEvent extends EventEvent {
  final String eventId;

  const BookmarkEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}

class UnbookmarkEvent extends EventEvent {
  final String eventId;

  const UnbookmarkEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}

// States
abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final EventModel event;

  const EventLoaded(this.event);

  @override
  List<Object> get props => [event];
}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object> get props => [message];
}

class EventBookmarking extends EventState {}

class EventBookmarked extends EventState {
  final String eventId;

  const EventBookmarked(this.eventId);

  @override
  List<Object> get props => [eventId];
}

// Cubit
class EventCubit extends Cubit<EventState> {
  final EventRepository _eventRepository;

  EventCubit(this._eventRepository) : super(EventInitial());

  Future<void> loadEvent(String eventId) async {
    emit(EventLoading());
    try {
      final event = await _eventRepository.getEventById(eventId);
      emit(EventLoaded(event));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> bookmarkEvent(String eventId) async {
    emit(EventBookmarking());
    try {
      final success = await _eventRepository.bookmarkEvent(eventId);
      if (success) {
        emit(EventBookmarked(eventId));
        // Reload event to update bookmark status
        await loadEvent(eventId);
      }
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> unbookmarkEvent(String eventId) async {
    emit(EventBookmarking());
    try {
      final success = await _eventRepository.unbookmarkEvent(eventId);
      if (success) {
        // Reload event to update bookmark status
        await loadEvent(eventId);
      }
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}
