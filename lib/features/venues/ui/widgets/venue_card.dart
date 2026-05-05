import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_complete_project/features/venues/data/models/venue.dart';

class VenueCard extends StatelessWidget {
  final Venue venue;
  final VoidCallback onTap;

  const VenueCard({super.key, required this.venue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorsManager.cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorsManager.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  Image.network(
                    venue.image ?? '',
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 160.h,
                      color: ColorsManager.fieldBg,
                      child: Icon(Icons.image_not_supported,
                          color: ColorsManager.mutedText),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: (venue.isAvailable ?? false)
                            ? Colors.green.withOpacity(0.85)
                            : Colors.red.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        (venue.isAvailable ?? false) ? 'Available' : 'Full',
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          venue.name ?? '',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              color: Colors.amber, size: 14.sp),
                          SizedBox(width: 2.w),
                          Text(
                            (venue.rating ?? 0).toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.amber),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12.sp, color: ColorsManager.mutedText),
                      SizedBox(width: 4.w),
                      Text(
                        venue.address ?? '',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorsManager.mutedText),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color:
                              ColorsManager.primaryBlue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          venue.sport?['name'] ?? '',
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: ColorsManager.lightBlue,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        'EGP ${(venue.pricePerHour ?? 0).toInt()}/hr',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorsManager.lightBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}