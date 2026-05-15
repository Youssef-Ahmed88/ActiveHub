import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'nearby_state.dart';

class NearbyCubit extends Cubit<NearbyState> {
  NearbyCubit() : super(NearbyInitial());

  static const String _apiKey = 'AIzaSyAIrq36i54jaUQwhhW3gwEqn5ybEzCoVF8';

  Position? currentPosition;
  List<Map<String, dynamic>> nearbyCourts = [];
  Set<Marker> markers = {};

  Future<void> loadNearby() async {
    emit(NearbyLoading());
    try {
      // 1. اجيب location الـ user
      currentPosition = await _getUserLocation();

      // 2. اجيب الملاعب القريبة من Google Places
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
  }

  Set<Marker> _buildMarkers() {
    final Set<Marker> result = {};

    // Marker الـ user
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

    // Markers الملاعب
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
            snippet: court['address'],
          ),
        ),
      );
    }

    return result;
  }
}

