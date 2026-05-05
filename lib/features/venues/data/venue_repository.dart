import 'package:flutter_complete_project/features/venues/data/models/venue.dart';
import 'package:flutter_complete_project/features/venues/data/repos/venues_repo.dart';
import 'package:flutter_complete_project/features/venues/data/venue_api.dart';

class VenueRepository implements VenuesRepo {
  final VenueApi _venueApi;

  VenueRepository(this._venueApi);

  @override
  Future<List<Venue>> getVenues({String? sportType}) {
    return _venueApi.getVenues(sportType: sportType);
  }

  @override
  Future<Venue> getVenueById(int id) {
    return _venueApi.getVenueById(id);
  }
}