import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  EventDetailsCubit() : super(EventDetailsInitial());
}
