import 'package:flutter_complete_project/features/venues/data/models/venue.dart';

abstract class VenuesState {}

class VenuesInitial extends VenuesState {}

class VenuesLoading extends VenuesState {}

class VenuesSuccess extends VenuesState {
  final List<Venue> venues;
  VenuesSuccess(this.venues);
}

class VenuesError extends VenuesState {
  final String error;
  VenuesError(this.error);
}