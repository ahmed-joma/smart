import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/repositories/auth_repository.dart';
import '../../../../core/utils/models/auth_models.dart';
import '../../../../core/utils/models/api_error.dart';

// States
abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final User user;

  const SignUpSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignUpError extends SignUpState {
  final String message;

  const SignUpError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Cubit
class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository = sl<AuthRepository>();

  SignUpCubit() : super(SignUpInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    emit(SignUpLoading());

    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );

      final response = await _authRepository.register(request);

      if (response.isSuccess && response.data != null) {
        emit(SignUpSuccess(user: response.data!.user));
      } else {
        // تحقق من نوع الخطأ أولاً
        print('🔍 SignUp API Response: ${response.msg}');
        print('🔍 SignUp API Data: ${response.data}');

        String message = response.msg.toLowerCase();

        // تحقق من رسائل النجاح أولاً
        if (message.contains('verification') ||
            message.contains('confirm') ||
            message.contains('check your email') ||
            message.contains('sent to your email') ||
            message.contains('code sent') ||
            message.contains('verify') ||
            message.contains('email sent') ||
            message.contains('تم إرسال') ||
            message.contains('تأكيد') ||
            message.contains('رمز') ||
            message.contains('كود') ||
            message.contains('created') ||
            message.contains('registered')) {
          // تم إنشاء الحساب وإرسال رمز التأكيد بنجاح
          emit(
            SignUpSuccess(
              user: User(
                id: 0,
                name: name,
                email: email,
                isEmailVerified: false,
              ),
            ),
          );
        } else {
          // تحقق من الأخطاء المحددة في data أو msg
          String errorMessage = response.msg;

          // تحقق من الـ data إذا كان فيه errors
          if (response.data != null) {
            String errorData = response.data.toString().toLowerCase();
            if (errorData.contains('email has already been taken') ||
                errorData.contains('email already exists') ||
                errorData.contains('already taken')) {
              errorMessage = 'Email has already been taken';
            }
          }

          emit(SignUpError(message: errorMessage));
        }
      }
    } on ApiError catch (e) {
      emit(SignUpError(message: e.message));
    } catch (e) {
      emit(SignUpError(message: 'An unexpected error occurred'));
    }
  }

  void resetState() {
    emit(SignUpInitial());
  }
}
