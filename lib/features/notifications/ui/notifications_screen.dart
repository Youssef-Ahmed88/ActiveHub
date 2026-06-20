import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theming/colors.dart';
import '../logic/notifications_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  /// Returns an icon based on the sport type string
  IconData _sportIcon(String? sportType) {
    if (sportType == null) return Icons.notifications;
    switch (sportType.toLowerCase()) {
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'baseball':
        return Icons.sports_baseball;
      case 'cricket':
        return Icons.sports_cricket;
      case 'handball':
        return Icons.sports_handball;
      case 'hockey':
        return Icons.sports_hockey;
      case 'golf':
        return Icons.sports_golf;
      case 'swimming':
        return Icons.pool;
      case 'gym':
      case 'fitness':
        return Icons.fitness_center;
      case 'cycling':
        return Icons.directions_bike;
      case 'running':
        return Icons.directions_run;
      case 'padel':
        return Icons.sports_tennis;
      case 'squash':
        return Icons.sports_tennis;
      case 'badminton':
        return Icons.sports;
      default:
        return Icons.emoji_events;
    }
  }

  /// Returns a color based on the sport type string
  Color _sportColor(String? sportType, bool isRead) {
    if (isRead) return Colors.grey;
    if (sportType == null) return Colors.orange;
    switch (sportType.toLowerCase()) {
      case 'football':
      case 'soccer':
        return Colors.green;
      case 'basketball':
        return Colors.orange;
      case 'tennis':
      case 'padel':
      case 'squash':
        return Colors.yellow;
      case 'volleyball':
        return Colors.blue;
      case 'swimming':
        return Colors.lightBlue;
      case 'gym':
      case 'fitness':
        return Colors.red;
      case 'cycling':
        return Colors.teal;
      default:
        return Colors.purpleAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.darkBg,
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationsLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return const Center(
                child: Text(
                  "No notifications found",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final icon = _sportIcon(notification.sportType);
                final color = _sportColor(
                  notification.sportType,
                  notification.isRead,
                );

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? ColorsManager.cardBg
                        : ColorsManager.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorsManager.borderColor,
                      width: 0.5,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.15),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    title: Text(
                      notification.message,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: notification.isRead
                            ? FontWeight.w400
                            : FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (notification.sportType != null)
                          Text(
                            notification.sportType!,
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        Text(
                          notification.createdAt.toLocal().toString().split(
                            ' ',
                          )[0],
                          style: const TextStyle(
                            color: ColorsManager.mutedText,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!notification.isRead)
                          IconButton(
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                              size: 20,
                            ),
                            onPressed: () => context
                                .read<NotificationsCubit>()
                                .markAsRead(notification.id),
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => context
                              .read<NotificationsCubit>()
                              .deleteNotification(notification.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is NotificationsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text(
              "No notifications found",
              style: TextStyle(color: Colors.white70),
            ),
          );
        },
      ),
    );
  }
}
