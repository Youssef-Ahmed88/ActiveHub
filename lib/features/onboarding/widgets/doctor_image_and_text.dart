import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';

class DoctorImageAndText extends StatelessWidget {
  const DoctorImageAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle decoration
        Container(
          width: 320.w,
          height: 320.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorsManager.primaryBlue.withOpacity(0.08),
          ),
        ),

        // Sport icons decoration
        Positioned(
          top: 20.h,
          left: 30.w,
          child: _sportIcon(Icons.sports_soccer, 40),
        ),
        Positioned(
          top: 20.h,
          right: 30.w,
          child: _sportIcon(Icons.sports_basketball, 40),
        ),
        Positioned(
          bottom: 60.h,
          left: 20.w,
          child: _sportIcon(Icons.sports_tennis, 36),
        ),
        Positioned(
          bottom: 60.h,
          right: 20.w,
          child: _sportIcon(Icons.sports_volleyball, 36),
        ),

        // Center main icon
        Container(
          width: 160.w,
          height: 160.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorsManager.primaryBlue.withOpacity(0.15),
          ),
          child: Icon(
            Icons.sports,
            size: 80,
            color: ColorsManager.primaryBlue,
          ),
        ),

        // Bottom text
        Positioned(
          bottom: 10.h,
          left: 0,
          right: 0,
          child: Text(
            'Your Ultimate\nSports Booking App',
            textAlign: TextAlign.center,
            style: TextStyles.font32BlueBold.copyWith(
              height: 1.4,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sportIcon(IconData icon, double size) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsManager.cardBg,
        border: Border.all(
          color: ColorsManager.borderColor,
          width: 0.5,
        ),
      ),
      child: Icon(
        icon,
        color: ColorsManager.lightBlue,
        size: size * 0.5,
      ),
    );
  }
}