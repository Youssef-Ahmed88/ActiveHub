import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theming/colors.dart';
import '../../core/theming/styles.dart';
import 'widgets/doc_logo_and_name.dart';
import 'widgets/doctor_image_and_text.dart';
import 'widgets/get_started_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
            child: Column(
              children: [
                const DocLogoAndName(),
                SizedBox(height: 40.h),
                const DoctorImageAndText(),
                SizedBox(height: 32.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    children: [
                      Text(
                        'Find and book sports courts near you in just a few taps. Play your game, your way.',
                        style: TextStyles.font13MutedRegular,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30.h),
                      const GetStartedButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}