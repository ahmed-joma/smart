import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'resset_password_state.dart';

class RessetPasswordCubit extends Cubit<RessetPasswordState> {
  RessetPasswordCubit() : super(RessetPasswordInitial());
}
