import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';

class SportFilterChips extends StatefulWidget {
  final Function(String) onSportSelected;

  const SportFilterChips({super.key, required this.onSportSelected});

  @override
  State<SportFilterChips> createState() => _SportFilterChipsState();
}

class _SportFilterChipsState extends State<SportFilterChips> {
  String _selected = 'All';

  final List<Map<String, dynamic>> sports = [
    {'name': 'All', 'icon': Icons.sports},
    {'name': 'Football', 'icon': Icons.sports_soccer},
    {'name': 'Padel', 'icon': Icons.sports_tennis},
    {'name': 'Basketball', 'icon': Icons.sports_basketball},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final sport = sports[index];
          final isSelected = _selected == sport['name'];

          return GestureDetector(
            onTap: () {
              setState(() => _selected = sport['name']);
              widget.onSportSelected(sport['name']);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorsManager.primaryBlue
                    : ColorsManager.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? ColorsManager.primaryBlue
                      : ColorsManager.borderColor,
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    sport['icon'] as IconData,
                    size: 14,
                    color: isSelected
                        ? Colors.white
                        : ColorsManager.mutedText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    sport['name'],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : ColorsManager.mutedText,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
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