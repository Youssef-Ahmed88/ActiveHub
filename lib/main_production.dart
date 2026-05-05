import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';
import 'package:flutter_complete_project/core/helpers/extensions.dart';
import 'package:flutter_complete_project/ActiveHub.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/helpers/constants.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ScreenUtil.ensureScreenSize();

  await setupGetIt();

  await checkIfLoggedInUser();

  runApp(ActiveHub(
    appRouter: AppRouter(),
  ));
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