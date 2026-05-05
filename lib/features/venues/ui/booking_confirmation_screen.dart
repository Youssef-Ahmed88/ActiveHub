import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_complete_project/features/venues/data/models/venue.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Venue venue;
  final DateTime date;
  final String timeSlot;
  final int duration;
  final double totalPrice;
  final double depositAmount;

final int? bookingId;

const BookingConfirmationScreen({
  super.key,
  required this.venue,
  required this.date,
  required this.timeSlot,
  required this.duration,
  required this.totalPrice,
  required this.depositAmount,
  this.bookingId, // ← ضيف ده
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        backgroundColor: ColorsManager.darkBg,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSuccessHeader(),
            SizedBox(height: 24.h),
            _buildBookingDetailsCard(),
            SizedBox(height: 16.h),
            _buildPriceSummaryCard(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  // ─── Success Header ────────────────────────────────────────
  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green.withOpacity(0.3), width: 2),
          ),
          child: Icon(Icons.check_circle_outline,
              color: Colors.green, size: 40.sp),
        ),
        SizedBox(height: 16.h),
        Text(
          'Booking Summary',
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white),
        ),
        SizedBox(height: 6.h),
        Text(
          'Review your booking details before payment',
          style: TextStyle(fontSize: 13.sp, color: ColorsManager.mutedText),
        ),
      ],
    );
  }

  // ─── Booking Details Card ──────────────────────────────────
  Widget _buildBookingDetailsCard() {
    return _buildCard(
      title: 'Booking Details',
      children: [
        _detailRow(Icons.stadium_outlined, 'Venue', venue.name ?? 'Unknown'),
        _detailRow(Icons.sports, 'Sport', venue.sport?['name'] ?? 'Unknown'),
        _detailRow(Icons.location_on_outlined, 'Location', venue.address ?? 'Unknown'),
        _detailRow(Icons.calendar_today, 'Date',
            '${date.day}/${date.month}/${date.year}'),
        _detailRow(Icons.access_time, 'Time', timeSlot),
        _detailRow(Icons.hourglass_bottom_outlined, 'Duration',
            '$duration ${duration == 1 ? 'hour' : 'hours'}'),
      ],
    );
  }

  // ─── Price Summary Card ────────────────────────────────────
  Widget _buildPriceSummaryCard() {
    return _buildCard(
      title: 'Price Summary',
      children: [
        _priceRow('Price per hour', 'EGP ${(venue.pricePerHour ?? 0).toInt()}'),
        _priceRow('Duration', '$duration hr'),
        Divider(color: ColorsManager.borderColor, height: 20.h),
        _priceRow('Total', 'EGP ${totalPrice.toInt()}', isTotal: true),
        SizedBox(height: 8.h),
        _depositHighlight(),
      ],
    );
  }

  // ─── Bottom Bar ────────────────────────────────────────────
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        border: Border(top: BorderSide(color: ColorsManager.borderColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              // ✅ بدل ما نعمل تأكيد مباشر، نروح لشاشة الدفع
Navigator.pushNamed(
  context,
  Routes.paymentMethodsScreen,
  arguments: {
    'venue': venue,
    'date': date,
    'timeSlot': timeSlot,
    'duration': duration,
    'totalPrice': totalPrice,
    'depositAmount': depositAmount,
    'booking_id': bookingId, // ← ضيف ده
  },
);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.primaryBlue,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text(
              'Pay Deposit — EGP ${depositAmount.toInt()}',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 10.h),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homeScreen,
              (route) => false,
            ),
            child: Text(
              'Back to Home',
              style: TextStyle(fontSize: 14.sp, color: ColorsManager.mutedText),
            ),
          ),
        ],
      ),
    );
  }
   // ─── Helpers ───────────────────────────────────────────────
  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          Divider(color: ColorsManager.borderColor, height: 20.h),
          ...children.map((child) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: child,
              )),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: ColorsManager.lightBlue),
        SizedBox(width: 10.w),
        Text('$label:',
            style: TextStyle(fontSize: 13.sp, color: ColorsManager.mutedText)),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(value,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isTotal ? 15.sp : 13.sp,
                color: isTotal ? Colors.white : ColorsManager.mutedText,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400)),
        Text(value,
            style: TextStyle(
                fontSize: isTotal ? 15.sp : 13.sp,
                color: isTotal ? Colors.white : ColorsManager.mutedText,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }

  Widget _depositHighlight() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ColorsManager.primaryBlue.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Deposit Required (30%)',
                style: TextStyle(fontSize: 12.sp, color: ColorsManager.mutedText)),
            SizedBox(height: 2.h),
            Text('Pay now to confirm your booking',
                style: TextStyle(fontSize: 11.sp, color: ColorsManager.subtleText)),
          ]),
          Text('EGP ${depositAmount.toInt()}',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: ColorsManager.lightBlue)),
        ],
      ),
    );
  }
    // ─── Payment Success Dialog ────────────────────────────────
  void _showPaymentSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
            SizedBox(height: 16.h),
            Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your deposit has been paid successfully.',
              style: TextStyle(
                fontSize: 13.sp,
                color: ColorsManager.mutedText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.homeScreen,
                (route) => false,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryBlue,
                minimumSize: Size(double.infinity, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
