import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/features/notifications/data/notification.dart';
import 'package:flutter_complete_project/features/notifications/data/notification_service.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationService _notificationService;

  NotificationsCubit(this._notificationService) : super(NotificationsInitial());

  List<AppNotification> notifications = [];

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    try {
      notifications = await _notificationService.getNotifications();
      emit(NotificationsLoaded(List.from(notifications)));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _notificationService.markAsRead(id);
      notifications = notifications
          .map(
            (n) => n.id == id
                ? AppNotification(
                    id: n.id,
                    message: n.message,
                    isRead: true,
                    createdAt: n.createdAt,
                  )
                : n,
          )
          .toList();
      emit(NotificationsLoaded(List.from(notifications)));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      notifications = notifications
          .map(
            (n) => AppNotification(
              id: n.id,
              message: n.message,
              isRead: true,
              createdAt: n.createdAt,
            ),
          )
          .toList();
      emit(NotificationsLoaded(List.from(notifications)));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      await _notificationService.deleteNotification(id);
      notifications = notifications.where((n) => n.id != id).toList();
      emit(NotificationsLoaded(List.from(notifications)));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}
