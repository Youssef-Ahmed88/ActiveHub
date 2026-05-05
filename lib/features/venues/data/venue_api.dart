import 'package:dio/dio.dart';
import 'package:flutter_complete_project/features/venues/data/models/venue.dart';

class VenueApi {
  final Dio _dio;
  VenueApi(this._dio);

  Future<List<Venue>> getVenues({String? sportType}) async {
    final response = await _dio.get('/courts'); // ✅// ✅ تغيرت من /courts
    final List data = response.data['data'];
    final venues = data.map((v) => Venue.fromJson(v)).toList();
    return venues
        .where((v) =>
            sportType == null ||
            sportType == 'All' ||
            v.sport?['name'] == sportType)
        .toList();
  }

  Future<Venue> getVenueById(int id) async {
    final response = await _dio.get('/courts/$id');
    return Venue.fromJson(response.data['data']);
  }
}