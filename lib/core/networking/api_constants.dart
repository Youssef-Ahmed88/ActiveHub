class ApiConstants {
  static const String apiBaseUrl = 'http://192.168.1.14:8000/api';
  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String currentUser = '/user';
  // Bookings
  static const String bookings = '/bookings';
  static const String myBookings = '/my-bookings';
  static String cancelBooking(int id) => '/bookings/$id';
  // Sports & Courts
  static const String sports = '/sports';
  static const String courts = '/courts';
  static String availableSlots(int courtId, {required String date}) =>
      '/courts/$courtId/slots?date=$date';
  static String courtsBySport(int sportId) => '/courts?sport_id=$sportId';
  // Notifications
  static const String notifications = '/notifications';
  static String markNotificationRead(int id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/read-all';
  static String deleteNotification(int id) => '/notifications/$id';
  // Stadiums
  static String getStadium(int id) => '/stadiums/$id';
  static String updateStadium(int id) => '/stadiums/$id';
}
