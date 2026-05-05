import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/theming/font_weight_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ActiveHub Colors
class ActiveHubColors {
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF378ADD);
  static const Color darkBg = Color(0xFF0A0F1E);
  static const Color cardBg = Color(0xFF111827);
  static const Color fieldBg = Color(0xFF0D1526);
  static const Color borderColor = Color(0xFF1E293B);
  static const Color mutedText = Color(0xFF8892A4);
  static const Color subtleText = Color(0xFF4A5568);
}

class TextStyles {
  // ============ ActiveHub Styles (Dark Theme) ============
  static TextStyle font26WhiteMedium = TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font20WhiteMedium = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font16WhiteMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font16WhiteSemiBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font14WhiteRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: Colors.white,
  );

  static TextStyle font13MutedRegular = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.regular,
    color: ActiveHubColors.mutedText,
  );

  static TextStyle font14MutedRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ActiveHubColors.mutedText,
  );

  static TextStyle font13BlueRegular = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.regular,
    color: ActiveHubColors.lightBlue,
  );

  static TextStyle font13BlueMedium = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.medium,
    color: ActiveHubColors.lightBlue,
  );

  static TextStyle font14BlueSemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ActiveHubColors.lightBlue,
  );

  static TextStyle font12SubtleRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ActiveHubColors.subtleText,
  );

  static TextStyle font11MutedRegular = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeightHelper.regular,
    color: ActiveHubColors.mutedText,
  );

  // ============ Docdoc Styles (kept for reference) ============
  static TextStyle font24BlackBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.black,
  );

  static TextStyle font24BlueBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
    color: const Color(0xFF1565C0),
  );

  static TextStyle font14GrayRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: const Color(0xFF8892A4),
  );

  static TextStyle font14LightGrayRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: const Color(0xFF4A5568),
  );

  static TextStyle font14DarkBlueMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font13DarkBlueMedium = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font13DarkBlueRegular = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.regular,
    color: Colors.white,
  );

  static TextStyle font12DarkBlueRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: Colors.white,
  );

  static TextStyle font12GrayRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: const Color(0xFF8892A4),
  );

  static TextStyle font12GrayMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.medium,
    color: const Color(0xFF8892A4),
  );

  static TextStyle font13GrayRegular = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.regular,
    color: const Color(0xFF8892A4),
  );

  static TextStyle font13BlueSemiBold = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: const Color(0xFF378ADD),
  );

  static TextStyle font12BlueRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: const Color(0xFF378ADD),
  );

  static TextStyle font14DarkBlueBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font32BlueBold = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeightHelper.bold,
    color: const Color(0xFF1565C0),
  );

  static TextStyle font15DarkBlueMedium = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font18DarkBlueBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font18DarkBlueSemiBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font18WhiteMedium = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle? get font16BlueSemiBold => null;
}