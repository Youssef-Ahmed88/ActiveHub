import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/helpers/spacing.dart';
import 'package:flutter_complete_project/features/venues/data/models/venue.dart';
import 'package:flutter_complete_project/features/venues/data/venue_repository.dart';
import 'package:flutter_complete_project/features/venues/data/venue_api.dart';
import 'package:flutter_complete_project/features/sports/data/models/sport.dart';
import 'package:flutter_complete_project/features/sports/data/sport_api.dart';
import 'package:flutter_complete_project/features/sports/data/repos/sport_repository.dart';
import 'package:flutter_complete_project/core/networking/dio_factory.dart';
import 'widgets/home_banner.dart';
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
      final dio = DioFactory.getDio();
      final venueRepo = VenueRepository(VenueApi(dio));
      final sportRepo = SportRepository(SportApi(dio));
      final venuesData = await venueRepo.getVenues();
      final sportsData = await sportRepo.getSports();
      setState(() {
        venues = venuesData;
        sports = sportsData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  final List<List<Color>> _sportGradients = [
    [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
    [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
    [const Color(0xFF00695C), const Color(0xFF26A69A)],
    [const Color(0xFFE65100), const Color(0xFFFF9800)],
    [const Color(0xFFB71C1C), const Color(0xFFEF5350)],
    [const Color(0xFF1B5E20), const Color(0xFF66BB6A)],
  ];

  final List<IconData> _sportIcons = [
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_tennis,
    Icons.sports_volleyball,
    Icons.sports_handball,
    Icons.sports,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.darkBg,
        elevation: 0,
        title: Image.asset('assets/images/logo.png', height: 32),
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
                border: Border.all(
                  color: ColorsManager.borderColor,
                  width: 0.5,
                ),
              ),
              child: const Icon(
                Icons.person_outline,
                color: ColorsManager.lightBlue,
                size: 20,
              ),
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

                    // Sports Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sports Courts',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.venuesScreen),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsManager.primaryBlue.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: ColorsManager.primaryBlue.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: ColorsManager.primaryBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(16),

                    // Sports Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.8,
                          ),
                      itemCount: sports.length,
                      itemBuilder: (context, index) {
                        final sport = sports[index];
                        final gradient =
                            _sportGradients[index % _sportGradients.length];
                        final icon = _sportIcons[index % _sportIcons.length];

                        return GestureDetector(
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
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: gradient[0].withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Background icon
                                Positioned(
                                  right: -10,
                                  bottom: -10,
                                  child: Icon(
                                    icon,
                                    size: 80,
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                // Content
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          sport.icon ?? '🏅',
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sport.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Tap to explore',
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.7,
                                              ),
                                              fontSize: 11,
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
                      },
                    ),
                    verticalSpace(8),
                  ],
                ),
              ),
      ),
    );
  }
}
