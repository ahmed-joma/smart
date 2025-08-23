import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'empty_events_state.dart';

class EmptyEventsCubit extends Cubit<EmptyEventsState> {
  EmptyEventsCubit() : super(EmptyEventsInitial());
}
