import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final Function(String?) validator;

  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: inputTextStyle ??
          TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
      obscureText: isObscureText ?? false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),

        // Enabled Border
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF1E293B),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),

        // Focused Border
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF1565C0),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),

        // Error Border
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),

        // Focused Error Border
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),

        hintText: hintText,
        hintStyle: hintStyle ??
            TextStyle(
              color: const Color(0xFF4A5568),
              fontSize: 14.sp,
            ),

        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: const IconThemeData(color: Color(0xFF8892A4)),
                child: suffixIcon!,
              )
            : null,

        fillColor: backgroundColor ?? const Color(0xFF0D1526),
        filled: true,
      ),
      validator: (value) => validator(value),
    );
  }
}