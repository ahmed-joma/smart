import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/repositories/auth_repository.dart';
import '../../../../core/utils/models/auth_models.dart';
import '../../../../core/utils/models/api_error.dart';

// States
abstract class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object?> get props => [];
}

class PasswordResetInitial extends PasswordResetState {}

class SendCodeLoading extends PasswordResetState {}

class SendCodeSuccess extends PasswordResetState {}

class SendCodeError extends PasswordResetState {
  final String message;

  const SendCodeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResetPasswordLoading extends PasswordResetState {}

class ResetPasswordSuccess extends PasswordResetState {}

class ResetPasswordError extends PasswordResetState {
  final String message;

  const ResetPasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class PasswordResetCubit extends Cubit<PasswordResetState> {
  final AuthRepository _authRepository = sl<AuthRepository>();

  PasswordResetCubit() : super(PasswordResetInitial());

  Future<void> sendResetCode(String email) async {
    emit(SendCodeLoading());

    try {
      final request = SendResetCodeRequest(email: email);
      final response = await _authRepository.sendResetCode(request);

      if (response.isSuccess) {
        emit(SendCodeSuccess());
      } else {
        emit(SendCodeError(message: response.msg));
      }
    } on ApiError catch (e) {
      emit(SendCodeError(message: e.message));
    } catch (e) {
      emit(SendCodeError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ResetPasswordLoading());

    try {
      final request = ResetPasswordRequest(
        email: email,
        code: code,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      final response = await _authRepository.resetPassword(request);

      if (response.isSuccess) {
        emit(ResetPasswordSuccess());
      } else {
        emit(ResetPasswordError(message: response.msg));
      }
    } on ApiError catch (e) {
      emit(ResetPasswordError(message: e.message));
    } catch (e) {
      emit(ResetPasswordError(message: 'An unexpected error occurred'));
    }
  }

  void resetState() {
    emit(PasswordResetInitial());
  }
}
