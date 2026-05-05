import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/routing/app_router.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/helpers/constants.dart';
import 'core/routing/routes.dart';

class ActiveHub extends StatelessWidget {
  final AppRouter appRouter;
  const ActiveHub({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
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
            background: ColorsManager.darkBg,
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
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}