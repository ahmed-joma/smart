import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/saved_item_model.dart';
import '../../data/repos/saved_items_repository.dart';

// Events
abstract class SavedItemsEvent extends Equatable {
  const SavedItemsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedEvents extends SavedItemsEvent {}

class LoadSavedHotels extends SavedItemsEvent {}

class SaveEvent extends SavedItemsEvent {
  final SavedEventModel event;

  const SaveEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class SaveHotel extends SavedItemsEvent {
  final SavedHotelModel hotel;

  const SaveHotel(this.hotel);

  @override
  List<Object?> get props => [hotel];
}

class RemoveSavedEvent extends SavedItemsEvent {
  final String eventId;

  const RemoveSavedEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class RemoveSavedHotel extends SavedItemsEvent {
  final String hotelId;

  const RemoveSavedHotel(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}

class CheckEventSaved extends SavedItemsEvent {
  final String eventId;

  const CheckEventSaved(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class CheckHotelSaved extends SavedItemsEvent {
  final String hotelId;

  const CheckHotelSaved(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}

// States
abstract class SavedItemsState extends Equatable {
  const SavedItemsState();

  @override
  List<Object?> get props => [];
}

class SavedItemsInitial extends SavedItemsState {}

class SavedItemsLoading extends SavedItemsState {}

class SavedEventsLoaded extends SavedItemsState {
  final List<SavedEventModel> events;

  const SavedEventsLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class SavedHotelsLoaded extends SavedItemsState {
  final List<SavedHotelModel> hotels;

  const SavedHotelsLoaded(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class SavedItemsError extends SavedItemsState {
  final String message;

  const SavedItemsError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventSaved extends SavedItemsState {
  final bool isSaved;

  const EventSaved(this.isSaved);

  @override
  List<Object?> get props => [isSaved];
}

class HotelSaved extends SavedItemsState {
  final bool isSaved;

  const HotelSaved(this.isSaved);

  @override
  List<Object?> get props => [isSaved];
}

class SaveSuccess extends SavedItemsState {
  final String message;

  const SaveSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RemoveSuccess extends SavedItemsState {
  final String message;

  const RemoveSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class SavedItemsCubit extends Cubit<SavedItemsState> {
  final SavedItemsRepository _repository;

  SavedItemsCubit(this._repository) : super(SavedItemsInitial());

  Future<void> loadSavedEvents() async {
    emit(SavedItemsLoading());
    try {
      final events = await _repository.getSavedEvents();
      emit(SavedEventsLoaded(events));
    } catch (e) {
      emit(SavedItemsError('Failed to load saved events: $e'));
    }
  }

  Future<void> loadSavedHotels() async {
    emit(SavedItemsLoading());
    try {
      final hotels = await _repository.getSavedHotels();
      emit(SavedHotelsLoaded(hotels));
    } catch (e) {
      emit(SavedItemsError('Failed to load saved hotels: $e'));
    }
  }

  Future<void> saveEvent(SavedEventModel event) async {
    try {
      await _repository.saveEvent(event);
      emit(SaveSuccess('Event saved successfully'));
      // Reload saved events
      await loadSavedEvents();
    } catch (e) {
      emit(SavedItemsError('Failed to save event: $e'));
    }
  }

  Future<void> saveHotel(SavedHotelModel hotel) async {
    try {
      await _repository.saveHotel(hotel);
      emit(SaveSuccess('Hotel saved successfully'));
      // Reload saved hotels
      await loadSavedHotels();
    } catch (e) {
      emit(SavedItemsError('Failed to save hotel: $e'));
    }
  }

  Future<void> removeSavedEvent(String eventId) async {
    try {
      await _repository.removeSavedEvent(eventId);
      emit(RemoveSuccess('Event removed from saved items'));
      // Reload saved events
      await loadSavedEvents();
    } catch (e) {
      emit(SavedItemsError('Failed to remove event: $e'));
    }
  }

  Future<void> removeSavedHotel(String hotelId) async {
    try {
      await _repository.removeSavedHotel(hotelId);
      emit(RemoveSuccess('Hotel removed from saved items'));
      // Reload saved hotels
      await loadSavedHotels();
    } catch (e) {
      emit(SavedItemsError('Failed to remove hotel: $e'));
    }
  }

  Future<void> checkEventSaved(String eventId) async {
    try {
      final isSaved = await _repository.isEventSaved(eventId);
      emit(EventSaved(isSaved));
    } catch (e) {
      emit(SavedItemsError('Failed to check save status: $e'));
    }
  }

  Future<void> checkHotelSaved(String hotelId) async {
    try {
      final isSaved = await _repository.isHotelSaved(hotelId);
      emit(HotelSaved(isSaved));
    } catch (e) {
      emit(SavedItemsError('Failed to check save status: $e'));
    }
  }
}
