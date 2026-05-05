import '../models/venue.dart';

abstract class VenuesRepo {
  Future<List<Venue>> getVenues({String? sportType});
  Future<Venue> getVenueById(int id);
}