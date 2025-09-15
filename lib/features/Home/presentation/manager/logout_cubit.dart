import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartshop_map/core/utils/repositories/auth_repository.dart';
import 'package:smartshop_map/core/utils/service_locator.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  final AuthRepository _authRepository = sl<AuthRepository>();

  Future<void> logout() async {
    try {
      emit(LogoutLoading());

      await _authRepository.logout();

      emit(LogoutSuccess());
    } catch (e) {
      String errorMessage = 'An unexpected error occurred. Please try again.';

      if (e.toString().contains('401')) {
        errorMessage = 'You are not logged in.';
      } else if (e.toString().contains('Connection')) {
        errorMessage = 'No internet connection. Please check your network.';
      } else if (e.toString().contains('Timeout')) {
        errorMessage = 'Connection timeout. Please try again.';
      }

      emit(LogoutError(errorMessage));
    }
  }
}

abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutError extends LogoutState {
  final String message;
  LogoutError(this.message);
}
