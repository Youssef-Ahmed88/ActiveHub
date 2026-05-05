class ApiConstants {
  static const String apiBaseUrl = 'http://100.89.12.127:8000/api';

  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String currentUser = '/user';
  static const String bookings = '/bookings';
  static const String myBookings = '/my-bookings';
  static const String sports = '/sports';
  static const String courts = '/courts';
  static String cancelBooking(int id) => '/bookings/$id';
  static String availableSlots(int courtId) => '/courts/$courtId/slots';
  static String courtsBySport(int sportId) => '/courts?sport_id=$sportId';
}