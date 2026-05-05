import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/helpers/spacing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class DoctorsBlueContainer extends StatelessWidget {
  const DoctorsBlueContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 16.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Color(0xFF0D47A1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Left side text and button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find & Book\nYour Court\nNearby',
                  style: TextStyles.font18WhiteMedium,
                  textAlign: TextAlign.start,
                ),
                verticalSpace(12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: ColorsManager.primaryBlue,
                        size: 14,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Find Nearby',
                        style: TextStyles.font12BlueRegular,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right side sport icons
          Column(
            children: [
              _sportIcon(Icons.sports_soccer, 38),
              verticalSpace(8),
              _sportIcon(Icons.sports_basketball, 38),
              verticalSpace(8),
              _sportIcon(Icons.sports_tennis, 38),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sportIcon(IconData icon, double size) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: size * 0.5,
      ),
    );
  }
}