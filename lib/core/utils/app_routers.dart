import 'package:go_router/go_router.dart';
import '../../features/Splash_Screen/presentation/views/widgets/splash_screen_view.dart';
import '../../features/sign_in/presentation/views/sign_in_view.dart';
import '../../features/sign_up/presentation/views/sign_up_view.dart';
import '../../features/Verification/presentation/views/Verification_view.dart';
import '../../features/Resset_Password/presentation/views/Resset_Password_view.dart';
import '../../features/Resset_Password/presentation/views/enter_email_view.dart';
import '../../features/Home/presentation/views/Home_view.dart';
import '../../features/My_Profile/presentation/views/my_profile_view.dart';
import '../../features/My_Profile/presentation/views/edit_profile_view.dart';
import '../../features/Search_White_Bar/presentation/views/search_view.dart';
import 'package:flutter/material.dart';

class AppRouters {
  static const String kSplashView = '/splashView';
  static const String kSignInView = '/signInView';
  static const String kSignUpView = '/signUpView';
  static const String kVerificationView = '/verificationView';
  static const String kEnterEmailView = '/enterEmailView';
  static const String kRessetPasswordView = '/ressetPasswordView';
  static const String kHomeView = '/homeView';
  static const String kMyProfileView = '/myProfileView';
  static const String kEditProfileView = '/editProfileView';
  static const String kCalendarView = '/calendarView';
  static const String kAiChatbotView = '/aiChatbotView';
  static const String kSettingsView = '/settingsView';
  static const String kHelpFaqsView = '/helpFaqsView';
  static const String kSearchView = '/searchView';

  static final router = GoRouter(
    initialLocation: kSplashView,
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
        path: kEnterEmailView,
        builder: (context, state) => const EnterEmailView(),
      ),
      GoRoute(
        path: kRessetPasswordView,
        builder: (context, state) => const RessetPasswordView(),
      ),
      GoRoute(path: kHomeView, builder: (context, state) => const HomeView()),
      GoRoute(
        path: kMyProfileView,
        builder: (context, state) => const MyProfileView(),
      ),
      GoRoute(
        path: kEditProfileView,
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path: kCalendarView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Calendar'))),
      ),
      GoRoute(
        path: kAiChatbotView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('AI Chatbot'))),
      ),
      GoRoute(
        path: kSettingsView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Settings'))),
      ),
      GoRoute(
        path: kHelpFaqsView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Help & FAQs'))),
      ),
      GoRoute(
        path: kSearchView,
        builder: (context, state) => const SearchView(),
      ),
    ],
  );
}
