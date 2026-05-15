import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/helpers/spacing.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class DoctorsBlueContainer extends StatelessWidget {
  const DoctorsBlueContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
<<<<<<< HEAD
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
=======
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: const Text(
                    '🏟️ ActiveHub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                verticalSpace(10),
                Text(
                  'Find & Book\nYour Court\nNearby',
                  style: TextStyles.font18WhiteMedium.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                verticalSpace(16),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.nearbyScreen),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(48.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: ColorsManager.primaryBlue,
                          size: 16,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Find Nearby',
                          style: TextStyle(
                            color: ColorsManager.primaryBlue,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: ColorsManager.primaryBlue,
                          size: 11,
                        ),
                      ],
                    ),
                  ),
=======
                Text(
                  'Find & Book\nYour Court\nNearby',
                  style: TextStyles.font18WhiteMedium,
                  textAlign: TextAlign.start,
                ),
                verticalSpace(12),
                ElevatedButton(
                  // ✅ هنا الإضافة
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.nearbyScreen),
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
                      Text('Find Nearby', style: TextStyles.font12BlueRegular),
                    ],
                  ),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
                ),
              ],
            ),
          ),
<<<<<<< HEAD
          SizedBox(width: 16.w),
          Column(
            children: [
              _sportIcon(Icons.sports_soccer, 44),
              verticalSpace(10),
              _sportIcon(Icons.sports_basketball, 44),
              verticalSpace(10),
              _sportIcon(Icons.sports_tennis, 44),
=======
          Column(
            children: [
              _sportIcon(Icons.sports_soccer, 38),
              verticalSpace(8),
              _sportIcon(Icons.sports_basketball, 38),
              verticalSpace(8),
              _sportIcon(Icons.sports_tennis, 38),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
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
<<<<<<< HEAD
        color: Colors.white.withValues(alpha: 0.15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.45),
=======
        color: Colors.white.withOpacity(0.15),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.5),
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    );
  }
}
