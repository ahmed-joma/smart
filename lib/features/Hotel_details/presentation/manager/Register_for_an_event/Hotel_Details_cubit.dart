import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'Hotel_Details_state.dart';

class RegisterForAnEventCubit extends Cubit<RegisterForAnEventState> {
  RegisterForAnEventCubit() : super(RegisterForAnEventInitial());
}
