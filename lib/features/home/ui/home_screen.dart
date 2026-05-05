import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/helpers/spacing.dart';
import 'package:flutter_complete_project/features/venues/data/models/venue.dart';
import 'package:flutter_complete_project/features/venues/data/venue_repository.dart';
import 'package:flutter_complete_project/features/venues/data/venue_api.dart';
import 'package:flutter_complete_project/features/sports/data/models/sport.dart';
import 'package:flutter_complete_project/features/sports/data/sport_api.dart';
import 'package:flutter_complete_project/features/sports/data/repos/sport_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/networking/dio_factory.dart'; // ✅ استخدمنا DioFactory بدلاً من getIt
import 'widgets/home_banner.dart';
import 'widgets/sports_see_all.dart';
import 'widgets/home_top_bar.dart';
import '../../../core/theming/colors.dart';
import '../../sports/ui/sport_details_screen.dart';
import '../../../core/routing/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Venue> venues = [];
  List<Sport> sports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // ✅ استخدام DioFactory بدلاً من getIt<Dio>()
      final dio = DioFactory.getDio();
      final venueRepo = VenueRepository(VenueApi(dio));
      final sportRepo = SportRepository(SportApi(dio));

      final venuesData = await venueRepo.getVenues();
      final sportsData = await sportRepo.getSports();

      // ✅ طباعة عدد الرياضات للتأكد (تظهر في Terminal)
      print('Number of sports loaded: ${sportsData.length}');

      setState(() {
        venues = venuesData;
        sports = sportsData;
        isLoading = false;
      });
    } catch (e) {
      // ✅ طباعة الخطأ التفصيلي
      print('Error loading home data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.darkBg,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 32),
            const SizedBox(width: 8),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.profileScreen),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: ColorsManager.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorsManager.borderColor, width: 0.5),
              ),
              child: const Icon(Icons.person_outline,
                  color: ColorsManager.lightBlue, size: 20),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeTopBar(),
                    verticalSpace(20),
                    const DoctorsBlueContainer(),
                    verticalSpace(28),
                    const DoctorsSpecialitySeeAll(),
                    verticalSpace(18),

                    // Sports Grid
                    Row(
                      children: sports.map((sport) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SportDetailsScreen(
                                  sportId: sport.id,
                                  sportName: sport.name,
                                  venues: venues,
                                ),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: sport == sports.last ? 0 : 12,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                color: ColorsManager.cardBg,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: ColorsManager.borderColor,
                                    width: 0.5),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: ColorsManager.primaryBlue.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Text(
                                        sport.icon ?? '🏅',
                                        style: const TextStyle(fontSize: 26),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    sport.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    verticalSpace(8),
                  ],
                ),
              ),
      ),
    );
  }
}