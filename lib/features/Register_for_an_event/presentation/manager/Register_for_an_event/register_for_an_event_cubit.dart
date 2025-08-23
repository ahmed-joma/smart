import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'register_for_an_event_state.dart';

class RegisterForAnEventCubit extends Cubit<RegisterForAnEventState> {
  RegisterForAnEventCubit() : super(RegisterForAnEventInitial());
}
