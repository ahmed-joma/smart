import 'package:go_router/go_router.dart';
import 'package:smartshop_map/features/sign_in/views/settings_view.dart';
import '../../features/Splash_Screen/presentation/views/widgets/splash_screen_view.dart';
import '../../features/sign_in/presentation/views/sign_in_view.dart';
import '../../features/sign_up/presentation/views/sign_up_view.dart';
import '../../features/Verification/presentation/views/Verification_view.dart';
import '../../features/Resset_Password/presentation/views/Resset_Password_view.dart';
import '../../features/Resset_Password/presentation/views/enter_email_view.dart';
import '../../features/Home/presentation/views/Home_view.dart';
import '../../features/Home/presentation/views/upcoming_events_view.dart';
import '../../features/Home/presentation/views/ongoing_events_view.dart';
import '../../features/Home/presentation/views/expired_events_view.dart';
import '../../features/Hotel_Home/presentation/views/featured_hotels_view.dart';
import '../../features/Hotel_Home/presentation/views/near_location_hotels_view.dart';
import '../../features/Calendar/presentation/views/calendar_view.dart';
import '../../features/Help_Faqs/presentation/views/help_faqs_view.dart';
import '../../features/My_Profile/presentation/views/my_profile_view.dart';
import '../../features/My_Profile/presentation/views/edit_profile_view.dart';
import '../../features/Search_White_Bar/presentation/views/search_view.dart';
import '../../features/Event_Details/presentation/views/Event_Details_view.dart';
import '../../features/Event_Details/presentation/views/events_view.dart';
import '../../features/chat_FitBot/presentation/views/chat_view.dart';
import '../../features/Filters/presentation/views/Filter_view.dart';
import '../../features/Hotel_Home/presentation/views/Hotel_Home_view.dart';
import '../../features/Hotel_details/presentation/views/Hotel_Details_view.dart';
import '../../features/Hotel_details/presentation/views/hotel_booking_view.dart';
import '../../features/payments/presentation/views/order_summary_view.dart';
import '../../features/payments/presentation/views/credit_card_payment_view.dart';
import '../../features/payments/presentation/views/apple_pay_payment_view.dart';
import '../../features/payments/presentation/views/paypal_payment_view.dart';
import '../../features/payments/presentation/views/paypal_login_view.dart';
import '../../features/payments/presentation/views/booking_success_view.dart';

import 'package:flutter/material.dart';

class AppRouters {
  static const String kSplashView = '/splashView';
  static const String kSignInView = '/signInView';
  static const String kSignUpView = '/signUpView';
  static const String kVerificationView = '/verificationView';
  static const String kEnterEmailView = '/enterEmailView';
  static const String kRessetPasswordView = '/ressetPasswordView';
  static const String kHomeView = '/homeView';
  static const String kUpcomingEventsView = '/upcomingEventsView';
  static const String kOngoingEventsView = '/ongoingEventsView';
  static const String kExpiredEventsView = '/expiredEventsView';
  static const String kFeaturedHotelsView = '/featuredHotelsView';
  static const String kNearLocationHotelsView = '/nearLocationHotelsView';
  static const String kMyProfileView = '/myProfileView';
  static const String kEditProfileView = '/editProfileView';
  static const String kCalendarView = '/calendarView';
  static const String kAiChatbotView = '/aiChatbotView';
  static const String kSettingsView = '/settingsView';
  static const String kHelpFaqsView = '/helpFaqsView';
  static const String kSearchView = '/searchView';
  static const String kEventDetailsView = '/eventDetailsView';
  static const String kEventsView = '/eventsView';
  static const String kChatView = '/chatView';
  static const String kFilterView = '/filterView';
  static const String kHotelHomeView = '/hotelHomeView';
  static const String kHotelDetailsView = '/hotelDetailsView';
  static const String kHotelBookingView = '/hotelBooking';
  static const String kOrderSummaryView = '/orderSummary';
  static const String kCreditCardPaymentView = '/creditCardPayment';
  static const String kApplePayPaymentView = '/applePayPayment';
  static const String kPayPalPaymentView = '/paypalPayment';
  static const String kPayPalLoginView = '/paypalLogin';
  static const String kBookingSuccessView = '/bookingSuccess';
  static const String kTicketSuccessView = '/ticketSuccess';
  static const String kMapView = '/mapView';

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
        builder: (context, state) {
          final email = state.extra as String?;
          return VerificationView(userEmail: email);
        },
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
        path: kUpcomingEventsView,
        builder: (context, state) => const UpcomingEventsView(),
      ),
      GoRoute(
        path: kOngoingEventsView,
        builder: (context, state) => const OngoingEventsView(),
      ),
      GoRoute(
        path: kExpiredEventsView,
        builder: (context, state) => const ExpiredEventsView(),
      ),
      GoRoute(
        path: kFeaturedHotelsView,
        builder: (context, state) => const FeaturedHotelsView(),
      ),
      GoRoute(
        path: kNearLocationHotelsView,
        builder: (context, state) => const NearLocationHotelsView(),
      ),
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
        builder: (context, state) => const CalendarView(),
      ),
      GoRoute(
        path: kAiChatbotView,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('AI Chatbot'))),
      ),
      GoRoute(
        path: kSettingsView,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: kHelpFaqsView,
        builder: (context, state) => const HelpFaqsView(),
      ),
      GoRoute(
        path: kSearchView,
        builder: (context, state) {
          final searchData = state.extra as Map<String, dynamic>?;
          return SearchView(searchData: searchData);
        },
      ),
      GoRoute(
        path: kEventDetailsView,
        builder: (context, state) {
          final eventData = state.extra as Map<String, dynamic>?;
          return EventDetailsView(eventData: eventData);
        },
      ),
      GoRoute(
        path: kEventsView,
        builder: (context, state) => const EventsView(),
      ),
      GoRoute(path: kChatView, builder: (context, state) => const ChatView()),
      GoRoute(
        path: kFilterView,
        builder: (context, state) => const FilterView(),
      ),
      GoRoute(
        path: kHotelHomeView,
        builder: (context, state) => const HotelHomeView(),
      ),
      GoRoute(
        path: kHotelDetailsView,
        builder: (context, state) {
          final hotelData = state.extra as Map<String, dynamic>?;
          return HotelDetailsView(hotelData: hotelData);
        },
      ),
      GoRoute(
        path: kHotelBookingView,
        builder: (context, state) {
          final hotelData = state.extra as Map<String, dynamic>?;
          return HotelBookingView(hotelData: hotelData);
        },
      ),
      GoRoute(
        path: kOrderSummaryView,
        builder: (context, state) {
          final orderData = state.extra as Map<String, dynamic>?;
          return OrderSummaryView(orderData: orderData);
        },
      ),
      GoRoute(
        path: kCreditCardPaymentView,
        builder: (context, state) {
          final paymentData = state.extra as Map<String, dynamic>?;
          return CreditCardPaymentView(
            totalAmount: paymentData?['totalAmount'] ?? 'SR 138',
            orderTitle: paymentData?['orderTitle'] ?? 'Order',
            orderData: paymentData?['orderData'] as Map<String, dynamic>?,
          );
        },
      ),
      GoRoute(
        path: kApplePayPaymentView,
        builder: (context, state) {
          final paymentData = state.extra as Map<String, dynamic>?;
          return ApplePayPaymentView(
            totalAmount: paymentData?['totalAmount'] ?? 'SR 138',
            orderTitle: paymentData?['orderTitle'] ?? 'Order',
            orderData: paymentData?['orderData'] as Map<String, dynamic>?,
          );
        },
      ),
      GoRoute(
        path: kPayPalLoginView,
        builder: (context, state) {
          final paymentData = state.extra as Map<String, dynamic>?;
          return PayPalLoginView(
            totalAmount: paymentData?['totalAmount'] ?? 'SR 138',
            orderTitle: paymentData?['orderTitle'] ?? 'Order',
            orderData: paymentData?['orderData'] ?? {},
          );
        },
      ),
      GoRoute(
        path: kPayPalPaymentView,
        builder: (context, state) {
          final paymentData = state.extra as Map<String, dynamic>?;
          return PayPalPaymentView(
            totalAmount: paymentData?['totalAmount'] ?? 'SR 138',
            orderTitle: paymentData?['orderTitle'] ?? 'Order',
            orderData: paymentData?['orderData'] ?? {},
          );
        },
      ),
      GoRoute(
        path: kBookingSuccessView,
        builder: (context, state) {
          final successData = state.extra as Map<String, dynamic>?;
          return BookingSuccessView(successData: successData);
        },
      ),
      GoRoute(
        path: kTicketSuccessView,
        builder: (context, state) {
          final successData = state.extra as Map<String, dynamic>?;
          return BookingSuccessView(successData: successData);
        },
      ),
    ],
  );
}
