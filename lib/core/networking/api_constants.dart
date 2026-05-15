class ApiConstants {
<<<<<<< HEAD
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api';
 
=======
  static const String apiBaseUrl = 'http://192.168.100.8:8000/api';

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String currentUser = '/user';
<<<<<<< HEAD
 
=======

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  // Bookings
  static const String bookings = '/bookings';
  static const String myBookings = '/my-bookings';
  static String cancelBooking(int id) => '/bookings/$id';
<<<<<<< HEAD
 
  // ✅ Owner Bookings (جديد)
  static const String ownerBookings = '/owner/bookings';
 
=======

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  // Sports & Courts
  static const String sports = '/sports';
  static const String courts = '/courts';
  static String availableSlots(int courtId, {required String date}) =>
      '/courts/$courtId/slots?date=$date';
  static String courtsBySport(int sportId) => '/courts?sport_id=$sportId';
<<<<<<< HEAD
 
  // ✅ Notifications
=======

  // ✅ Notifications (جديد)
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  static const String notifications = '/notifications';
  static String markNotificationRead(int id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/read-all';
  static String deleteNotification(int id) => '/notifications/$id';
<<<<<<< HEAD
 
  // ✅ Stadiums
  static String getStadium(int id) => '/stadiums/$id';
  static String updateStadium(int id) => '/stadiums/$id';
}
=======

  // ✅ Stadiums (جديد)
  static String getStadium(int id) => '/stadiums/$id';
  static String updateStadium(int id) => '/stadiums/$id';
}
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
