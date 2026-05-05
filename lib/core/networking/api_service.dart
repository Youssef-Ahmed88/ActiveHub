import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_complete_project/core/networking/api_constants.dart';
import 'package:flutter_complete_project/features/login/data/models/login_request_body.dart';
import 'package:flutter_complete_project/features/login/data/models/login_response.dart';
import '../../features/sign_up/data/models/sign_up_request_body.dart';
import '../../features/sign_up/data/models/sign_up_response.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Auth
  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);

  @POST(ApiConstants.register)
  Future<SignupResponse> signup(@Body() SignupRequestBody signupRequestBody);

  @GET(ApiConstants.currentUser)
  Future<dynamic> getCurrentUser();

@GET(ApiConstants.sports)
Future<dynamic> getSports();

@GET(ApiConstants.courts)
Future<dynamic> getCourts();

  @POST(ApiConstants.logout)
  Future<dynamic> logout();

  // Bookings – updated for time_slot_id
  @POST(ApiConstants.bookings)
  Future<dynamic> createBooking(@Body() Map<String, dynamic> body);

  @GET(ApiConstants.myBookings)
  Future<dynamic> getMyBookings();

  @DELETE('/api/bookings/{id}')
  Future<dynamic> cancelBooking(@Path('id') int bookingId);

  // Time Slots
  @GET('/api/courts/{courtId}/slots')
  Future<dynamic> getAvailableSlots(@Path('courtId') int courtId);
}