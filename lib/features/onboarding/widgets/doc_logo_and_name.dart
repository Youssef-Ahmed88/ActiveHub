import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';

class DocLogoAndName extends StatelessWidget {
  const DocLogoAndName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: ColorsManager.primaryBlue,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Icon(
            Icons.sports,
            color: Colors.white,
            size: 26,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          'ActiveHub',
          style: TextStyles.font26WhiteMedium,
        ),
      ],
    );
  }
}