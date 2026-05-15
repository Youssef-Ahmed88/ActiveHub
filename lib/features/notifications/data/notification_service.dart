import 'package:flutter_complete_project/core/networking/api_service.dart';
import 'notification.dart';

class NotificationService {
  final ApiService _apiService;

  NotificationService(this._apiService);

  Future<List<AppNotification>> getNotifications() async {
    final response = await _apiService.getNotifications();

    if (response is Map<String, dynamic>) {
      final list = response['data'] ?? [];
      return (list as List)
          .map((json) => AppNotification.fromJson(json))
          .toList();
    }

    return [];
  }

  Future<void> markAsRead(int id) async {
    await _apiService.markNotificationAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await _apiService.markAllNotificationsAsRead();
  }

  Future<void> deleteNotification(int id) async {
    await _apiService.deleteNotification(id);
  }
}
