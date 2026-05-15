import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/extensions.dart';
import 'ActiveHub.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'core/routing/app_router.dart';
import 'core/helpers/constants.dart';
import 'core/networking/dio_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ScreenUtil.ensureScreenSize();

  DioFactory.resetDio();

  await setupGetIt();

  // ✅ حمّل الـ token في الـ Dio قبل runApp
  String? token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  if (token.isNotEmpty) {
    DioFactory.setTokenIntoHeaderAfterLogin(token);
  }

  await checkIfLoggedInUser();

  runApp(ActiveHub(appRouter: AppRouter()));
}

Future<void> checkIfLoggedInUser() async {
  try {
    String? userToken =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    isLoggedInUser = !userToken.isNullOrEmpty();
  } catch (e) {
    isLoggedInUser = false;
  }
}