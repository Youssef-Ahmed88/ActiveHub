import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theming/colors.dart';
import '../logic/notifications_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.darkBg,
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
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
                child: Text("No notifications found",
                    style: TextStyle(color: Colors.white70)),
              );
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? ColorsManager.cardBg
                        : ColorsManager.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorsManager.borderColor, width: 0.5),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: notification.isRead ? Colors.grey : Colors.orange,
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
                    subtitle: Text(
                      notification.createdAt.toLocal().toString().split(' ')[0],
                      style: const TextStyle(color: ColorsManager.mutedText),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!notification.isRead)
                          IconButton(
                            icon: const Icon(Icons.done, color: Colors.green, size: 20),
                            onPressed: () => context
                                .read<NotificationsCubit>()
                                .markAsRead(notification.id),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
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
              child: Text(state.message,
                  style: const TextStyle(color: Colors.red)),
            );
          }
          return const Center(
              child: Text("No notifications found",
                  style: TextStyle(color: Colors.white70)));
        },
      ),
    );
  }
}