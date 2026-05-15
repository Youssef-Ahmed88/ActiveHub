import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SportFilterChips extends StatefulWidget {
  final Function(String) onSportSelected;

  const SportFilterChips({super.key, required this.onSportSelected});

  @override
  State<SportFilterChips> createState() => _SportFilterChipsState();
}

class _SportFilterChipsState extends State<SportFilterChips> {
  final List<Map<String, dynamic>> sports = [
    {'label': 'All', 'icon': Icons.sports},
    {'label': 'Football', 'icon': Icons.sports_soccer},
    {'label': 'Padel', 'icon': Icons.sports_tennis},
    {'label': 'Basketball', 'icon': Icons.sports_basketball},
  ];

  String selected = 'All';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: sports.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final sport = sports[index];
          final isSelected = selected == sport['label'];
          return GestureDetector(
            onTap: () {
              setState(() => selected = sport['label']);
              widget.onSportSelected(sport['label']);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorsManager.primaryBlue
                    : ColorsManager.cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? ColorsManager.primaryBlue
                      : ColorsManager.borderColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    sport['icon'],
                    size: 14.sp,
                    color: isSelected
                        ? Colors.white
                        : ColorsManager.mutedText,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    sport['label'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : ColorsManager.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}