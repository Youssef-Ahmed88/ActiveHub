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
import 'package:flutter_complete_project/features/sports/ui/sport_details_screen.dart';
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
import 'package:flutter_complete_project/features/login/ui/logic/forget_password_cubit.dart';
import 'package:flutter_complete_project/features/login/ui/forget_password_screen.dart';
import 'package:flutter_complete_project/features/profile/logic/profile_cubit.dart';
import 'package:flutter_complete_project/features/payment/ui/payment_methods_screen.dart';
import 'package:flutter_complete_project/features/payment/logic/payment_cubit.dart';
import 'package:flutter_complete_project/features/payment/data/payment_repository.dart';
import 'package:flutter_complete_project/features/notifications/ui/notifications_screen.dart';
import 'package:flutter_complete_project/features/notifications/logic/notifications_cubit.dart';

class ActiveHubShell extends StatefulWidget {
  final Widget child;
  
  const ActiveHubShell({
    super.key,
    required this.child,
  });

  @override
  State<ActiveHubShell> createState() => _ActiveHubShellState();
}

class _ActiveHubShellState extends State<ActiveHubShell> {
  bool _isChatView = false;

  void _toggleChat() {
    setState(() {
      _isChatView = !_isChatView;
    });
  }

  void _closeChat() {
    setState(() {
      _isChatView = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isChatView ? ColorsManager.darkBg : ColorsManager.cardBg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isChatView 
          ? ChatbotPanelWrapper(onClose: _closeChat)
          : widget.child,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isChatView ? ColorsManager.borderColor : ColorsManager.primaryBlue,
        elevation: 10,
        onPressed: _toggleChat,
        child: Icon(
          _isChatView ? Icons.close : Icons.chat_bubble_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class ChatbotPanelWrapper extends StatelessWidget {
  final VoidCallback onClose;
  
  const ChatbotPanelWrapper({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return ChatbotPanel(onClose: onClose);
  }
}

class ChatbotPanel extends StatefulWidget {
  final VoidCallback onClose;
  
  const ChatbotPanel({super.key, required this.onClose});

  @override
  State<ChatbotPanel> createState() => _ChatbotPanelState();
}

class _ChatbotPanelState extends State<ChatbotPanel> {
  final List<Map<String, String>> messages = [
    {
      "sender": "bot",
      "text": "👋 Hi! I'm ActiveHub Assistant.\nI can help you with:\n• Court availability\n• Prices\n• Booking process\n• Sports types\n\nHow can I help you today?"
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final Map<String, String> _responses = {
    'hello': 'Hi there! 👋 How can I help you today?',
    'hi': 'Hello! 😊 What can I do for you?',
    'hey': 'Hey! 👋 How can I assist you?',
    'price': 'Our prices start from 150 EGP/hr for Football courts, 200 EGP/hr for Padel, and 180 EGP/hr for Basketball. 💰',
    'cost': 'Prices vary by sport:\n⚽ Football: from 150 EGP/hr\n🎾 Padel: from 200 EGP/hr\n🏀 Basketball: from 180 EGP/hr',
    'how much': 'Prices start from 150 EGP/hr depending on the sport and venue. Would you like more details?',
    'egp': 'Our prices range from 150-300 EGP per hour depending on the venue and sport type. 💰',
    'book': 'To book a court:\n1️⃣ Go to Venues\n2️⃣ Select your sport\n3️⃣ Choose a venue\n4️⃣ Pick date & time\n5️⃣ Pay deposit (30%)\n\nEasy! 🎯',
    'booking': 'Booking is simple! Browse venues, select your preferred court, choose a time slot, and pay a 30% deposit to confirm. ✅',
    'reserve': 'To reserve a court, browse our venues, select your sport type, pick an available slot, and confirm with a deposit. 🏟️',
    'how to book': 'Just go to Venues → Select sport → Choose venue → Pick time → Pay deposit. Done! 🎉',
    'available': 'Court availability varies by venue and time. Check the Venues section for real-time availability! 📅',
    'availability': 'You can check real-time availability in the Venues section. Green = Available, Red = Full. ✅',
    'free': 'To check free slots, browse our venues and look for the "Available" badge. 🟢',
    'football': 'We have ⚽ Football courts available! Standard size with good lighting. Prices from 150 EGP/hr.',
    'padel': 'We have 🎾 Padel courts! Great facilities with proper equipment. Prices from 200 EGP/hr.',
    'basketball': 'We have 🏀 Basketball courts! Indoor and outdoor options. Prices from 180 EGP/hr.',
    'volleyball': 'We have 🏐 Volleyball courts available too! Check the venues section for details.',
    'sports': 'We support:\n⚽ Football\n🎾 Padel\n🏀 Basketball\n🏐 Volleyball\n🏸 Badminton\n\nMore sports coming soon!',
    'deposit': 'We require a 30% deposit to confirm your booking. The remaining 70% is paid at the venue. 💳',
    'payment': 'We accept online payment for the 30% deposit. The rest is paid at the venue. Secure & easy! 🔒',
    'pay': 'Payment is split:\n💳 30% deposit online (to confirm booking)\n💵 70% at the venue\n\nSimple and secure!',
    'cancel': 'You can cancel your booking within a specific time window. Check your booking history for cancellation options. ❌',
    'cancellation': 'Cancellations are allowed within the specified window. Late cancellations may affect your deposit. ⚠️',
    'location': 'We have venues across Cairo! Use the "Find Nearby" feature to discover courts close to you. 📍',
    'where': 'Our venues are spread across Cairo. Use the location filter in the Venues section to find nearby courts! 🗺️',
    'cairo': 'Yes! We have multiple venues across Cairo. Use the map feature to find the nearest one. 📍',
    'help': 'I can help you with:\n📅 Booking process\n💰 Prices\n🏟️ Venues\n⚽ Sports types\n📍 Locations\n\nWhat do you need?',
    'support': 'Need support? You can:\n📱 Use this chat\n📧 Email us at support@activehub.com\n📞 Call us at 01000000000',
    'thank': 'You\'re welcome! 😊 Enjoy your game! 🏆',
    'thanks': 'Happy to help! 🎉 See you on the court! ⚽',
    'thx': 'Anytime! 😄 Have a great game!',
  };

  String _getResponse(String message) {
    final lower = message.toLowerCase();
    for (final key in _responses.keys) {
      if (lower.contains(key)) {
        return _responses[key]!;
      }
    }
    return "I'm not sure about that. 🤔\nYou can ask me about:\n• Prices 💰\n• Booking process 📅\n• Available sports ⚽\n• Venue locations 📍";
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add({"sender": "user", "text": text});
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isTyping = false;
        messages.add({"sender": "bot", "text": _getResponse(text)});
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: ColorsManager.cardBg,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: widget.onClose,
                ),
                const Text(
                  "ActiveBot Panel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (_isTyping && index == messages.length) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorsManager.cardBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
              final msg = messages[index];
              final isUser = msg["sender"] == "user";
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? ColorsManager.primaryBlue : ColorsManager.cardBg,
                    border: isUser ? null : Border.all(color: ColorsManager.borderColor),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomLeft: Radius.circular(isUser ? 15 : 2),
                      bottomRight: Radius.circular(isUser ? 2 : 15),
                    ),
                  ),
                  child: Text(
                    msg["text"]!,
                    style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          color: ColorsManager.cardBg,
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      hintStyle: const TextStyle(color: ColorsManager.mutedText),
                      filled: true,
                      fillColor: ColorsManager.fieldBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  onPressed: () => _sendMessage(_controller.text),
                  icon: const Icon(Icons.send, color: ColorsManager.primaryBlue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class AppRouter {
  final ProfileCubit _profileCubit = ProfileCubit()..loadUserProfile();

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
            create: (_) => ForgetPasswordCubit(),
            child: const ForgetPasswordScreen(),
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
            child: ActiveHubShell(
              child: const HomeScreen(),
            ),
          ),
        );

      case Routes.venuesScreen:
        return _buildRoute(
          BlocProvider(
            create: (_) {
              final cubit = VenuesCubit(
                VenueRepository(VenueApi(getIt())),
              );
              Future.microtask(() => cubit.getVenues());
              return cubit;
            },
            child: ActiveHubShell(
              child: const VenuesScreen(),
            ),
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
          BlocProvider.value(
            value: _profileCubit,
            child: BookingScreen(venue: venue),
          ),
        );

case Routes.bookingConfirmationScreen:
  final args = settings.arguments as Map<String, dynamic>?;
  if (args == null) return _errorRoute("No booking data provided");
  return _buildRoute(
    BlocProvider.value(
      value: _profileCubit,
      child: BookingConfirmationScreen(
        venue: args['venue'] as Venue,
        date: args['date'] as DateTime,
        timeSlot: args['timeSlot'] as String,
        duration: args['duration'] as int,
        totalPrice: args['totalPrice'] as double,
        depositAmount: args['depositAmount'] as double,
        bookingId: args['booking_id'] as int?, // ← ضيف ده
      ),
    ),
  );

      case Routes.profileScreen:
        return _buildRoute(
          BlocProvider.value(
            value: _profileCubit,
            child: const ProfileScreen(),
          ),
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
        return _buildRoute(const ChatbotScreen());

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
      create: (_) => NotificationsCubit()..loadNotifications(),
      child: const NotificationsScreen(),
    ),
  );

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  MaterialPageRoute _buildRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

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