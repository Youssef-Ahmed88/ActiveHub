import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';

part 'nearby_state.dart';

class NearbyCubit extends Cubit<NearbyState> {
  NearbyCubit() : super(NearbyInitial());

  Position? currentPosition;
  List<Map<String, dynamic>> nearbyCourts = [];
  Set<Marker> markers = {};

  Future<void> loadNearby() async {
    emit(NearbyLoading());
    try {
      // 1. Get user location
      currentPosition = await _getUserLocation();

      // 2. Get courts from backend
      nearbyCourts = await _fetchCourtsFromBackend();

      // 3. Build markers
      markers = _buildMarkers();

      emit(
        NearbyLoaded(
          position: currentPosition!,
          courts: nearbyCourts,
          markers: markers,
        ),
      );
    } catch (e) {
      emit(NearbyError(e.toString()));
    }
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Return Cairo as default if location disabled
      return Position(
        latitude: 30.0444,
        longitude: 31.2357,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Position(
          latitude: 30.0444,
          longitude: 31.2357,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<List<Map<String, dynamic>>> _fetchCourtsFromBackend() async {
    try {
      final dio = getIt<Dio>();
      final response = await dio.get('/courts');
      final List data = response.data['data'];

      return data.map((court) {
        return {
          'name': court['name'] ?? '',
          'address': court['address'] ?? court['description'] ?? '',
          'lat': double.tryParse(court['latitude']?.toString() ?? '30.0444') ?? 30.0444,
          'lng': double.tryParse(court['longitude']?.toString() ?? '31.2357') ?? 31.2357,
          'rating': court['rating']?.toString() ?? 'N/A',
          'isOpen': court['is_available'] == 1,
          'price': court['price_per_hour']?.toString() ?? '',
          'sport': court['sport']?['name'] ?? '',
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Set<Marker> _buildMarkers() {
    final Set<Marker> result = {};

    // User location marker
    if (currentPosition != null) {
      result.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(
            currentPosition!.latitude,
            currentPosition!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    // Court markers
    for (int i = 0; i < nearbyCourts.length; i++) {
      final court = nearbyCourts[i];
      result.add(
        Marker(
          markerId: MarkerId('court_$i'),
          position: LatLng(
            (court['lat'] as num).toDouble(),
            (court['lng'] as num).toDouble(),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: court['name'],
            snippet: court['address'],
          ),
        ),
      );
    }

    return result;
  }
}
