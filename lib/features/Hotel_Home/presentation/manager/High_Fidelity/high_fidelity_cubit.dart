import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'high_fidelity_state.dart';

class HighFidelityCubit extends Cubit<HighFidelityState> {
  HighFidelityCubit() : super(HighFidelityInitial());
}
