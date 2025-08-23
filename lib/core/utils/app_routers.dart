import 'package:go_router/go_router.dart';
import '../../features/Splash_Screen/presentation/views/Splash_Screen_view.dart';
import '../../features/sign_in/presentation/views/sign_in_view.dart';
import '../../features/sign_up/presentation/views/sign_up_view.dart';

abstract class AppRouters {
  static const kSplashView = '/';
  static const kSignInView = '/signInView';
  static const kSignUpView = '/signUpView';
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
    ],
  );
}
