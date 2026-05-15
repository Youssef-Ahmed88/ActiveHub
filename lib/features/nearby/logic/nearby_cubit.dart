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
      // 1. اجيب location الـ user
      currentPosition = await _getUserLocation();

      // 2. اجيب الملاعب من الـ Laravel API
      nearbyCourts = await _fetchNearbyCourts(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );

      // 3. اعمل markers
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
    if (!serviceEnabled) throw Exception('Location services are disabled');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<List<Map<String, dynamic>>> _fetchNearbyCourts(
    double userLat,
    double userLng,
  ) async {
    final dio = getIt<Dio>();
    final response = await dio.get('/courts');
    final List data = response.data['data'];

    final List<Map<String, dynamic>> courts = [];

    for (final court in data) {
      final lat = double.tryParse(court['latitude']?.toString() ?? '');
      final lng = double.tryParse(court['longitude']?.toString() ?? '');

      if (lat == null || lng == null) continue;

      // احسب المسافة بالـ km
      final distanceInMeters = Geolocator.distanceBetween(
        userLat,
        userLng,
        lat,
        lng,
      );
      final distanceInKm = distanceInMeters / 1000;

      // بس لو في نطاق 20 km
      if (distanceInKm <= 50) {
        courts.add({
          'name': court['name'],
          'address': court['address'] ?? '',
          'lat': lat,
          'lng': lng,
          'rating': court['rating']?.toString() ?? 'N/A',
          'isOpen': court['is_available'] == 1,
          'distance': distanceInKm.toStringAsFixed(1),
          'price': court['price_per_hour'],
          'sport': court['sport']?['name'] ?? '',
        });
      }
    }

    // رتب حسب الأقرب
    courts.sort(
      (a, b) =>
          double.parse(a['distance']).compareTo(double.parse(b['distance'])),
    );

    return courts;
  }

  Set<Marker> _buildMarkers() {
    final Set<Marker> result = {};

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

    for (int i = 0; i < nearbyCourts.length; i++) {
      final court = nearbyCourts[i];
      result.add(
        Marker(
          markerId: MarkerId('court_$i'),
          position: LatLng(court['lat'], court['lng']),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: court['name'],
            snippet: '${court['distance']} km away',
          ),
        ),
      );
    }

    return result;
  }
}
