<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';
=======
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6

part 'nearby_state.dart';

class NearbyCubit extends Cubit<NearbyState> {
  NearbyCubit() : super(NearbyInitial());

<<<<<<< HEAD
=======
  static const String _apiKey = 'AIzaSyAIrq36i54jaUQwhhW3gwEqn5ybEzCoVF8';

>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  Position? currentPosition;
  List<Map<String, dynamic>> nearbyCourts = [];
  Set<Marker> markers = {};

  Future<void> loadNearby() async {
    emit(NearbyLoading());
    try {
      // 1. اجيب location الـ user
      currentPosition = await _getUserLocation();

<<<<<<< HEAD
      // 2. اجيب الملاعب من الـ Laravel API
=======
      // 2. اجيب الملاعب القريبة من Google Places
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
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
<<<<<<< HEAD
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
=======
    double lat,
    double lng,
  ) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=$lat,$lng'
      '&radius=5000'
      '&keyword=stadium|sports+court|football|basketball'
      '&key=$_apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch nearby courts');
    }

    final data = json.decode(response.body);
    final results = data['results'] as List<dynamic>;

    return results.map((place) {
      return {
        'name': place['name'],
        'address': place['vicinity'] ?? '',
        'lat': place['geometry']['location']['lat'],
        'lng': place['geometry']['location']['lng'],
        'rating': place['rating']?.toString() ?? 'N/A',
        'isOpen': place['opening_hours']?['open_now'] ?? false,
      };
    }).toList();
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  }

  Set<Marker> _buildMarkers() {
    final Set<Marker> result = {};

<<<<<<< HEAD
=======
    // Marker الـ user
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
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

<<<<<<< HEAD
=======
    // Markers الملاعب
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
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
<<<<<<< HEAD
            snippet: '${court['distance']} km away',
=======
            snippet: court['address'],
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
          ),
        ),
      );
    }

    return result;
  }
}
