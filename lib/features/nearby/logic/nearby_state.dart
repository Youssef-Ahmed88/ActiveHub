part of 'nearby_cubit.dart';

abstract class NearbyState {}

class NearbyInitial extends NearbyState {}

class NearbyLoading extends NearbyState {}

class NearbyLoaded extends NearbyState {
  final Position position;
  final List<Map<String, dynamic>> courts;
  final Set<Marker> markers;
  NearbyLoaded({
    required this.position,
    required this.courts,
    required this.markers,
  });
}

class NearbyError extends NearbyState {
  final String message;
  NearbyError(this.message);
}
