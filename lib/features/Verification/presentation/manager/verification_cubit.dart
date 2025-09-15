import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/repositories/auth_repository.dart';
import '../../../../core/utils/models/auth_models.dart';
import '../../../../core/utils/models/api_error.dart';

// States
abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object?> get props => [];
}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class VerificationError extends VerificationState {
  final String message;

  const VerificationError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResendCodeLoading extends VerificationState {}

class ResendCodeSuccess extends VerificationState {}

class ResendCodeError extends VerificationState {
  final String message;

  const ResendCodeError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class VerificationCubit extends Cubit<VerificationState> {
  final AuthRepository _authRepository = sl<AuthRepository>();

  VerificationCubit() : super(VerificationInitial());

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    emit(VerificationLoading());

    try {
      final request = VerifyEmailRequest(email: email, code: code);
      final response = await _authRepository.verifyEmail(request);

      if (response.isSuccess) {
        emit(VerificationSuccess());
      } else {
        emit(VerificationError(message: response.msg));
      }
    } on ApiError catch (e) {
      emit(VerificationError(message: e.message));
    } catch (e) {
      emit(VerificationError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> resendVerificationCode(String email) async {
    emit(ResendCodeLoading());

    try {
      final response = await _authRepository.resendVerification(email);

      if (response.isSuccess) {
        emit(ResendCodeSuccess());
      } else {
        emit(ResendCodeError(message: response.msg));
      }
    } on ApiError catch (e) {
      emit(ResendCodeError(message: e.message));
    } catch (e) {
      emit(ResendCodeError(message: 'An unexpected error occurred'));
    }
  }

  void resetState() {
    emit(VerificationInitial());
  }
}
