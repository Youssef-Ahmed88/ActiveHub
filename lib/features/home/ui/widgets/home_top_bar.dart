import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/styles.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Champ! 👋',
              style: TextStyles.font18DarkBlueBold,
            ),
            Text(
              'Find your court & play today',
              style: TextStyles.font12GrayRegular,
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, Routes.notificationsScreen),
          child: CircleAvatar(
            radius: 24.0,
            backgroundColor: ColorsManager.cardBg,
            child: const Icon(
              Icons.notifications_outlined,
              color: ColorsManager.lightBlue,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}