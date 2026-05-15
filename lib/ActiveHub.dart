import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/routing/app_router.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/helpers/constants.dart';
import 'core/routing/routes.dart';

class ActiveHub extends StatefulWidget {
  final AppRouter appRouter;
  const ActiveHub({super.key, required this.appRouter});

  @override
  State<ActiveHub> createState() => _ActiveHubState();
}

class _ActiveHubState extends State<ActiveHub> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    // لما الـ app يكون شغال وييجي deep link
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });

    // لما الـ app يفتح من deep link وهو مقفول
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    // activehub://reset-password?token=xxx&email=xxx
    if (uri.host == 'reset-password') {
      final token = uri.queryParameters['token'];
      final email = uri.queryParameters['email'];

      if (token != null && email != null) {
        _navigatorKey.currentState?.pushNamed(
          Routes.resetPasswordScreen,
          arguments: {'token': token, 'email': email},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'ActiveHub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: ColorsManager.primaryBlue,
          scaffoldBackgroundColor: ColorsManager.darkBg,
          colorScheme: const ColorScheme.dark(
            primary: ColorsManager.primaryBlue,
            secondary: ColorsManager.lightBlue,
            surface: ColorsManager.cardBg,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorsManager.darkBg,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          dividerColor: ColorsManager.borderColor,
        ),
        initialRoute: isLoggedInUser ? Routes.homeScreen : Routes.loginScreen,
        onGenerateRoute: widget.appRouter.generateRoute,
      ),
    );
  }
}
