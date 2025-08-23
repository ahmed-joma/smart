import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(VerificationInitial());
}
