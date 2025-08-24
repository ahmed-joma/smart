import 'package:go_router/go_router.dart';
import '../../features/Splash_Screen/presentation/views/Splash_Screen_view.dart';
import '../../features/sign_in/presentation/views/sign_in_view.dart';
import '../../features/sign_up/presentation/views/sign_up_view.dart';
import '../../features/Verification/presentation/views/Verification_view.dart';
import '../../features/Resset_Password/presentation/views/Resset_Password_view.dart';

abstract class AppRouters {
  static const kSplashView = '/';
  static const kSignInView = '/signInView';
  static const kSignUpView = '/signUpView';
  static const kVerificationView = '/verificationView';
  static const kRessetPasswordView = '/ressetPasswordView';
  static const kHomeView = '/homeView';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: kSplashView,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: kSignInView,
        builder: (context, state) => const SignInView(),
      ),
      GoRoute(
        path: kSignUpView,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: kVerificationView,
        builder: (context, state) => const VerificationView(),
      ),
      GoRoute(
        path: kRessetPasswordView,
        builder: (context, state) => const RessetPasswordView(),
      ),
    ],
  );
}
