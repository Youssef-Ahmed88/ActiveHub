import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_complete_project/features/venues/data/models/venue.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';

class VenueDetailsScreen extends StatefulWidget {
  final Venue venue;
  const VenueDetailsScreen({super.key, required this.venue});

  @override
  State<VenueDetailsScreen> createState() => _VenueDetailsScreenState();
}

class _VenueDetailsScreenState extends State<VenueDetailsScreen> {
  final List<Map<String, dynamic>> _reviews = [];
  int _selectedFilter = 0;
  final List<String> _filters = ['All', '5★', '4★', '3★'];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/reviews?court_id=${widget.venue.id}');
      final List data = response.data['data'];
      setState(() {
        _reviews.clear();
        _reviews.addAll(data.map((r) => {
          'user': r['user']['full_name'] ?? 'Unknown',
          'avatar': (r['user']['full_name'] ?? 'U')[0],
          'rating': r['rating'],
          'comment': r['comment'] ?? '',
          'date': r['created_at'].toString().split('T')[0],
          'sport': widget.venue.sport?['name'] ?? 'Sport',
          'verified': true,
        }).toList());
      });
    } catch (e) {
      debugPrint('Error loading reviews: $e');
    }
  }

  List<Map<String, dynamic>> get _filteredReviews {
    if (_selectedFilter == 0) return _reviews;
    final star = 6 - _selectedFilter;
    return _reviews.where((r) => r['rating'] == star).toList();
  }

  double get _avgRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.fold(0.0, (sum, r) => sum + (r['rating'] as int)) / _reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260.h,
            pinned: true,
            backgroundColor: ColorsManager.darkBg,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.venue.image ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: ColorsManager.fieldBg,
                  child: Icon(Icons.image_not_supported, color: ColorsManager.mutedText),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.venue.name ?? '',
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
                          SizedBox(width: 4.w),
                          Text(
                            _avgRating.toStringAsFixed(1),
                            style: TextStyle(fontSize: 13.sp, color: Colors.amber),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '(${_reviews.length})',
                            style: TextStyle(fontSize: 12.sp, color: ColorsManager.mutedText),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  if (widget.venue.description != null) ...[
                    Text(
                      widget.venue.description!,
                      style: TextStyle(fontSize: 13.sp, color: ColorsManager.mutedText, height: 1.5),
                    ),
                    SizedBox(height: 12.h),
                  ],

                  Row(
                    children: [
                      Icon(Icons.location_on, color: ColorsManager.lightBlue, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(widget.venue.address ?? '',
                          style: TextStyle(fontSize: 13.sp, color: ColorsManager.mutedText)),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      _infoChip(widget.venue.sport?['name'] ?? '', Icons.sports),
                      SizedBox(width: 8.w),
                      _infoChip('EGP ${(widget.venue.pricePerHour ?? 0).toInt()}/hr', Icons.attach_money),
                      SizedBox(width: 8.w),
                      _infoChip(
                        (widget.venue.isAvailable ?? false) ? 'Available' : 'Full',
                        (widget.venue.isAvailable ?? false) ? Icons.check_circle : Icons.cancel,
                        color: (widget.venue.isAvailable ?? false) ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  _buildReviewsSection(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorsManager.cardBg,
          border: Border(top: BorderSide(color: ColorsManager.borderColor)),
        ),
        child: ElevatedButton(
          onPressed: (widget.venue.isAvailable ?? false)
              ? () => Navigator.pushNamed(context, Routes.bookingScreen, arguments: widget.venue)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.primaryBlue,
            disabledBackgroundColor: ColorsManager.borderColor,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          child: Text(
            (widget.venue.isAvailable ?? false) ? 'Book Now' : 'Not Available',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Reviews', style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: Colors.white)),
            GestureDetector(
              onTap: () => _showWriteReviewSheet(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ColorsManager.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: ColorsManager.primaryBlue.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: ColorsManager.primaryBlue, size: 13.sp),
                    SizedBox(width: 4.w),
                    Text('Write a Review', style: TextStyle(color: ColorsManager.primaryBlue, fontSize: 12.sp, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildRatingSummary(),
        SizedBox(height: 16.h),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_filters.length, (i) {
              final active = _selectedFilter == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: active ? ColorsManager.primaryBlue : ColorsManager.cardBg,
                    borderRadius: BorderRadius.circular(99.r),
                    border: Border.all(color: active ? ColorsManager.primaryBlue : ColorsManager.borderColor),
                  ),
                  child: Text(_filters[i],
                      style: TextStyle(
                        color: active ? Colors.white : ColorsManager.mutedText,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 14.h),

        if (_filteredReviews.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Text('No reviews for this filter',
                  style: TextStyle(color: ColorsManager.mutedText, fontSize: 13.sp)),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredReviews.length,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (_, i) => _buildReviewCard(_filteredReviews[i]),
          ),
      ],
    );
  }

  Widget _buildRatingSummary() {
    final counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in _reviews) {
      counts[r['rating'] as int] = (counts[r['rating'] as int] ?? 0) + 1;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorsManager.borderColor),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(_avgRating.toStringAsFixed(1),
                  style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w900, color: Colors.white)),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < _avgRating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: Colors.amber, size: 14.sp,
                )),
              ),
              SizedBox(height: 4.h),
              Text('${_reviews.length} reviews',
                  style: TextStyle(color: ColorsManager.mutedText, fontSize: 11.sp)),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = counts[star] ?? 0;
                final pct = _reviews.isEmpty ? 0.0 : count / _reviews.length;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    children: [
                      Text('$star', style: TextStyle(color: ColorsManager.mutedText, fontSize: 11.sp, fontWeight: FontWeight.w700)),
                      SizedBox(width: 6.w),
                      Icon(Icons.star_rounded, color: Colors.amber, size: 10.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99.r),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 5.h,
                            backgroundColor: ColorsManager.borderColor,
                            valueColor: const AlwaysStoppedAnimation(Colors.amber),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      SizedBox(
                        width: 16.w,
                        child: Text('$count',
                            style: TextStyle(color: ColorsManager.mutedText, fontSize: 11.sp)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorsManager.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: ColorsManager.primaryBlue.withValues(alpha: 0.2),
                child: Text(review['avatar'],
                    style: TextStyle(color: ColorsManager.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14.sp)),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(review['user'],
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.sp)),
                        if (review['verified'] == true) ...[
                          SizedBox(width: 6.w),
                          Icon(Icons.verified, color: ColorsManager.lightBlue, size: 13.sp),
                        ],
                      ],
                    ),
                    Text(review['date'],
                        style: TextStyle(color: ColorsManager.mutedText, fontSize: 11.sp)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < (review['rating'] as int) ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: Colors.amber, size: 13.sp,
                )),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(review['comment'],
              style: TextStyle(color: ColorsManager.mutedText, fontSize: 13.sp, height: 1.5)),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: ColorsManager.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(review['sport'],
                style: TextStyle(color: ColorsManager.lightBlue, fontSize: 10.sp, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showWriteReviewSheet() {
    int selectedRating = 0;
    final commentCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorsManager.cardBg,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(
            left: 20.w, right: 20.w, top: 20.h,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24.h,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w, height: 4.h,
                    decoration: BoxDecoration(
                        color: ColorsManager.borderColor,
                        borderRadius: BorderRadius.circular(99.r)),
                  ),
                ),
                SizedBox(height: 20.h),
                Text('Write a Review',
                    style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w800)),
                SizedBox(height: 4.h),
                Text('Share your experience at ${widget.venue.name}',
                    style: TextStyle(color: ColorsManager.mutedText, fontSize: 12.sp)),
                SizedBox(height: 20.h),

                Text('YOUR RATING',
                    style: TextStyle(color: ColorsManager.mutedText, fontSize: 11.sp, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                SizedBox(height: 10.h),
                Row(
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => setS(() => selectedRating = i + 1),
                      child: Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: Icon(
                          i < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber, size: 36.sp,
                        ),
                      ),
                    );
                  }),
                ),
                if (selectedRating > 0) ...[
                  SizedBox(height: 6.h),
                  Text(
                    ['', 'Very Bad 😞', 'Not Good 😐', 'Average 🙂', 'Very Good 😊', 'Excellent! 🤩'][selectedRating],
                    style: TextStyle(color: ColorsManager.primaryBlue, fontSize: 13.sp, fontWeight: FontWeight.w700),
                  ),
                ],
                SizedBox(height: 20.h),

                Text('YOUR REVIEW',
                    style: TextStyle(color: ColorsManager.mutedText, fontSize: 11.sp, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: commentCtrl,
                  maxLines: 3,
                  maxLength: 300,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please write your review' : null,
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  decoration: InputDecoration(
                    hintText: 'How was your experience?',
                    hintStyle: TextStyle(color: ColorsManager.mutedText, fontSize: 13.sp),
                    filled: true,
                    fillColor: ColorsManager.darkBg,
                    counterStyle: TextStyle(color: ColorsManager.mutedText, fontSize: 11.sp),
                    contentPadding: EdgeInsets.all(14.w),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: ColorsManager.borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: ColorsManager.borderColor)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: ColorsManager.primaryBlue)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Colors.red)),
                  ),
                ),
                SizedBox(height: 20.h),

                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedRating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a rating'), backgroundColor: Colors.red),
                        );
                        return;
                      }
                      if (!formKey.currentState!.validate()) return;

                      try {
                        final dio = getIt<Dio>();
                        await dio.post('/reviews', data: {
                          'court_id': widget.venue.id,
                          'rating': selectedRating,
                          'comment': commentCtrl.text.trim(),
                        });

                        await _loadReviews();

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Review submitted successfully!'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      elevation: 0,
                    ),
                    child: Text('Submit Review',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15.sp)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String label, IconData icon, {Color? color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: (color ?? ColorsManager.primaryBlue).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: (color ?? ColorsManager.primaryBlue).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: color ?? ColorsManager.lightBlue),
          SizedBox(width: 4.w),
          Text(label,
              style: TextStyle(fontSize: 12.sp, color: color ?? ColorsManager.lightBlue, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

