import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_complete_project/features/home/logic/home_cubit.dart';
import 'package:flutter_complete_project/features/home/ui/home_screen.dart';
import 'package:flutter_complete_project/features/login/logic/cubit/login_cubit.dart';
import 'package:flutter_complete_project/features/login/ui/login_screen.dart';
import 'package:flutter_complete_project/features/onboarding/onboarding_screen.dart';
import 'package:flutter_complete_project/features/venues/data/models/venue.dart';
import 'package:flutter_complete_project/features/venues/data/venue_api.dart';
import 'package:flutter_complete_project/features/venues/data/venue_repository.dart';
import 'package:flutter_complete_project/features/venues/logic/venues_cubit.dart';
import 'package:flutter_complete_project/features/venues/ui/booking_confirmation_screen.dart';
import 'package:flutter_complete_project/features/venues/ui/venue_details_screen.dart';
import 'package:flutter_complete_project/features/venues/ui/venues_screen.dart';
import 'package:flutter_complete_project/features/profile/logic/profile_screen.dart';
import 'package:flutter_complete_project/features/booking/booking_history_screen.dart';
import 'package:flutter_complete_project/features/chatbot/chatbot_screen.dart';
import 'package:flutter_complete_project/features/sports/ui/booking_screen.dart';
import 'package:flutter_complete_project/features/AdminPanel/admin/ui/admin_login_screen.dart';
import 'package:flutter_complete_project/features/AdminPanel/admin/ui/admin_screen.dart';
import 'package:flutter_complete_project/features/AdminPanel/admin/ui/admin_signup_screen.dart';
import 'package:flutter_complete_project/features/OwnerPanel/owner/ui/owner_login_screen.dart';
import 'package:flutter_complete_project/features/OwnerPanel/owner/ui/owner_signup_screen.dart';
import 'package:flutter_complete_project/features/OwnerPanel/owner/ui/owner_screen.dart';
import '../../features/sign_up/logic/sign_up_cubit.dart';
import '../../features/sign_up/ui/sign_up_screen.dart';
import '../di/dependency_injection.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_complete_project/features/login/ui/logic/forgot_password_cubit.dart';
import 'package:flutter_complete_project/features/login/ui/forgot_password_screen.dart';
import 'package:flutter_complete_project/features/login/ui/logic/reset_password_screen.dart';
import 'package:flutter_complete_project/features/profile/logic/profile_cubit.dart';
import 'package:flutter_complete_project/features/booking/logic/booking_cubit.dart';
import 'package:flutter_complete_project/features/payment/ui/payment_methods_screen.dart';
import 'package:flutter_complete_project/features/payment/logic/payment_cubit.dart';
import 'package:flutter_complete_project/features/payment/data/payment_repository.dart';
import 'package:flutter_complete_project/features/notifications/ui/notifications_screen.dart';
import 'package:flutter_complete_project/features/notifications/logic/notifications_cubit.dart';
import 'package:flutter_complete_project/features/notifications/data/notification_service.dart';
import 'package:flutter_complete_project/features/chatbot/logic/chatbot_cubit.dart';
import 'package:flutter_complete_project/features/stadiums/ui/edit_stadium_screen.dart';
import 'package:flutter_complete_project/features/stadiums/logic/edit_stadium_cubit.dart';
import 'package:flutter_complete_project/features/bookings/ui/owner_bookings_screen.dart';
import 'package:flutter_complete_project/features/nearby/ui/nearby_screen.dart';
import 'package:flutter_complete_project/features/nearby/logic/nearby_cubit.dart';
import 'package:flutter_complete_project/features/payment/ui/paymob_webview_screen.dart';

class ActiveHubShell extends StatefulWidget {
  final Widget child;
  const ActiveHubShell({super.key, required this.child});

  @override
  State<ActiveHubShell> createState() => _ActiveHubShellState();
}

class _ActiveHubShellState extends State<ActiveHubShell> {
  void _openChat() {
    Navigator.pushNamed(context, Routes.chatbotScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.cardBg,
      body: widget.child,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsManager.primaryBlue,
        elevation: 10,
        onPressed: _openChat,
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class AppRouter {
  final ProfileCubit _profileCubit = ProfileCubit();

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return _buildRoute(const OnboardingScreen());

      case Routes.loginScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => LoginCubit(getIt()),
            child: const LoginScreen(),
          ),
        );

      case Routes.signUpScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => getIt<SignupCubit>(),
            child: const SignupScreen(),
          ),
        );

      case Routes.forgetPasswordScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => ForgotPasswordCubit(),
            child: const ForgotPasswordScreen(),
          ),
        );

      // ✅ Reset Password
      case Routes.resetPasswordScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => ForgotPasswordCubit(),
            child: const ResetPasswordScreen(),
          ),
        );

      case Routes.homeScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) {
              final cubit = HomeCubit(getIt());
              Future.microtask(() => cubit.getSpecializations());
              return cubit;
            },
            child: ActiveHubShell(child: const HomeScreen()),
          ),
        );

      case Routes.venuesScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) {
              final cubit = VenuesCubit(VenueRepository(VenueApi(getIt())));
              Future.microtask(() => cubit.getVenues());
              return cubit;
            },
            child: ActiveHubShell(child: const VenuesScreen()),
          ),
        );

      case Routes.paymobWebView:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) return _errorRoute("No payment data");
        return _buildRoute(
          PaymobWebViewScreen(
            iframeUrl: args['iframe_url'] as String,
            bookingId: args['booking_id'] as int,
            amount: args['amount'] as double,
          ),
        );
      case Routes.venueDetailsScreen:
        final venue = settings.arguments as Venue?;
        if (venue == null) return _errorRoute("No venue provided");
        return _buildRoute(VenueDetailsScreen(venue: venue));

      case Routes.bookingScreen:
        final venue = settings.arguments as Venue?;
        if (venue == null) return _errorRoute("No venue provided for booking");
        return _buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => BookingCubit()),
              BlocProvider.value(value: _profileCubit),
            ],
            child: BookingScreen(venue: venue),
          ),
        );

      case Routes.bookingConfirmationScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) return _errorRoute("No booking data provided");
        return _buildRoute(
          MultiBlocProvider(
            providers: [BlocProvider.value(value: _profileCubit)],
            child: BookingConfirmationScreen(
              venue: args['venue'] as Venue,
              date: args['date'] as DateTime,
              timeSlot: args['timeSlot'] as String,
              duration: args['duration'] as int,
              totalPrice: args['totalPrice'] as double,
              depositAmount: args['depositAmount'] as double,
              bookingId: args['booking_id'] as int?,
            ),
          ),
        );

      case Routes.profileScreen:
        return _buildRoute(
          BlocProvider.value(value: _profileCubit, child: ProfileScreen()),
        );

      case Routes.bookingHistoryScreen:
        return _buildRoute(
          BlocProvider.value(
            value: _profileCubit,
            child: const BookingHistoryScreen(),
          ),
        );

      case Routes.paymentMethodsScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => PaymentCubit(PaymentRepository())..loadMethods(),
            child: const PaymentMethodsScreen(),
          ),
        );

      case Routes.chatbotScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => ChatbotCubit(),
            child: const ChatbotScreen(),
          ),
        );

      case Routes.adminLoginScreen:
        return _buildRoute(const AdminLoginScreen());

      case Routes.adminSignUpScreen:
        return _buildRoute(const AdminSignupScreen());

      case Routes.adminScreen:
        return _buildRoute(const AdminScreen());

      case Routes.ownerLoginScreen:
        return _buildRoute(const OwnerLoginScreen());

      case Routes.ownerSignUpScreen:
        return _buildRoute(const OwnerSignupScreen());

      case Routes.ownerScreen:
        return _buildRoute(const OwnerScreen());

      case Routes.notificationsScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) =>
                NotificationsCubit(NotificationService(getIt()))
                  ..loadNotifications(),
            child: const NotificationsScreen(),
          ),
        );

      case Routes.editStadiumScreen:
        final stadiumId = settings.arguments as int?;
        if (stadiumId == null) return _errorRoute("No stadium ID provided");
        return _buildRoute(
          BlocProvider(
            create: (_) => EditStadiumCubit(getIt())..loadStadium(stadiumId),
            child: EditStadiumScreen(stadiumId: stadiumId),
          ),
        );

      case Routes.ownerBookingsScreen:
        return _buildRoute(const OwnerBookingsScreen());

      case Routes.nearbyScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) => NearbyCubit(),
            child: const NearbyScreen(),
          ),
        );

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  MaterialPageRoute _buildRoute(Widget page) =>
      MaterialPageRoute(builder: (_) => page);

  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: ColorsManager.darkBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginScreen,
                  (route) => false,
                ),
                child: const Text("Back to Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
