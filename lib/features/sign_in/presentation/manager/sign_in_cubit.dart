import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/repositories/auth_repository.dart';
import '../../../../core/utils/models/auth_models.dart';
import '../../../../core/utils/models/api_error.dart';

// States
abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final User user;

  const SignInSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignInError extends SignInState {
  final String message;

  const SignInError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository = sl<AuthRepository>();

  SignInCubit() : super(SignInInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(SignInLoading());

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authRepository.login(request);

      if (response.isSuccess && response.data != null) {
        emit(SignInSuccess(user: response.data!.user));
      } else {
        emit(SignInError(message: response.msg));
      }
    } on ApiError catch (e) {
      emit(SignInError(message: e.message));
    } catch (e) {
      emit(SignInError(message: 'An unexpected error occurred'));
    }
  }

  void resetState() {
    emit(SignInInitial());
  }
}
