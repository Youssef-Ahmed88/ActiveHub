import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';
import '../data/notification.dart';

abstract class NotificationsState {}
class NotificationsInitial extends NotificationsState {}
class NotificationsLoading extends NotificationsState {}
class NotificationsLoaded extends NotificationsState {
  final List<AppNotification> notifications;
  NotificationsLoaded(this.notifications);
}
class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/notifications');
      final List data = response.data['data'];
      final notifications = data.map((n) => AppNotification.fromJson(n)).toList();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError("Failed to load notifications: $e"));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final dio = getIt<Dio>();
      await dio.patch('/notifications/$id/read');
      loadNotifications();
    } catch (e) {
      emit(NotificationsError("Failed to mark as read: $e"));
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      final dio = getIt<Dio>();
      await dio.delete('/notifications/$id');
      loadNotifications();
    } catch (e) {
      emit(NotificationsError("Failed to delete notification: $e"));
    }
  }
}