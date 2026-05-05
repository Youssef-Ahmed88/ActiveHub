class AppNotification {
  final int id;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      message: json['message'],
      isRead: json['is_read'] == 1 ? true : false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}