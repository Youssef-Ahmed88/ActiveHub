import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/venues_cubit.dart';
import '../logic/venues_state.dart';
import 'widgets/sport_filter_chips.dart';
import 'widgets/venue_card.dart';

class VenuesScreen extends StatefulWidget {
  const VenuesScreen({super.key});

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VenuesCubit>().getVenues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        title: const Text('Venues'),
        backgroundColor: ColorsManager.darkBg,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: SportFilterChips(
              onSportSelected: (sport) =>
                  context.read<VenuesCubit>().filterBySport(sport),
            ),
          ),
        ),
      ),
      body: BlocBuilder<VenuesCubit, VenuesState>(
        builder: (context, state) {
          if (state is VenuesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primaryBlue,
              ),
            );
          } else if (state is VenuesSuccess) {
            if (state.venues.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off,
                        size: 60.sp, color: ColorsManager.mutedText),
                    SizedBox(height: 12.h),
                    Text(
                      'No venues found',
                      style: TextStyle(
                          color: ColorsManager.mutedText, fontSize: 16.sp),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              color: ColorsManager.primaryBlue,
              onRefresh: () =>
                  context.read<VenuesCubit>().getVenues(),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: state.venues.length,
                itemBuilder: (context, index) {
                  final venue = state.venues[index];
                  return VenueCard(
                    venue: venue,
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.venueDetailsScreen,
                      arguments: venue,
                    ),
                  );
                },
              ),
            );
          } else if (state is VenuesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 60.sp, color: Colors.redAccent),
                  SizedBox(height: 12.h),
                  Text(
                    state.error,
                    style: TextStyle(
                        color: ColorsManager.mutedText, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<VenuesCubit>().getVenues(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primaryBlue),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}