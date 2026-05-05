import 'package:flutter/material.dart';
import '../../../core/theming/colors.dart';
import 'package:flutter_complete_project/features/venues/data/models/venue.dart';
import '../../venues/ui/venue_details_screen.dart';

class SportDetailsScreen extends StatelessWidget {
  final int sportId;
  final String sportName;              // ✅ أضفنا اسم الرياضة كمعامل
  final List<Venue> venues;

  const SportDetailsScreen({
    super.key,
    required this.sportId,
    required this.sportName,           // ✅ required
    required this.venues,
  });

  @override
  Widget build(BuildContext context) {
    // تصفية الملاعب التي تنتمي إلى هذه الرياضة
    final List<Venue> filteredVenues = venues
        .where((v) => v.sportId == sportId)
        .toList();

    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.darkBg,
        title: Text(
          sportName,                    // ✅ استخدم اسم الرياضة المرسل
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: filteredVenues.isEmpty
            ? const Center(
                child: Text(
                  "No courts available for this sport",
                  style: TextStyle(color: Colors.white70),
                ),
              )
            : ListView.builder(
                itemCount: filteredVenues.length,
                itemBuilder: (context, index) {
                  final venue = filteredVenues[index];
                  return _courtCard(context, venue);
                },
              ),
      ),
    );
  }

  Widget _courtCard(BuildContext context, Venue venue) {
    final bool available = venue.isAvailable ?? false;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VenueDetailsScreen(venue: venue),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: ColorsManager.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorsManager.borderColor, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.sports,
                  color: ColorsManager.lightBlue,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${venue.address ?? ''} · EGP ${venue.pricePerHour.toInt()}/hr',
                      style: const TextStyle(
                        color: ColorsManager.mutedText,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${venue.rating?.toStringAsFixed(1) ?? '0.0'}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: (available ? Colors.green : Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  available ? 'Open' : 'Full',
                  style: TextStyle(
                    color: available ? Colors.green : Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}