import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/venues_repo.dart';
import 'venues_state.dart';

class VenuesCubit extends Cubit<VenuesState> {
  final VenuesRepo _venuesRepo;
  String selectedSport = 'All';

  VenuesCubit(this._venuesRepo) : super(VenuesInitial());

  Future<void> getVenues({String? sportType}) async {
    emit(VenuesLoading());

    try {
      final venues = await _venuesRepo.getVenues(
        sportType: sportType ?? selectedSport,
      );

      emit(VenuesSuccess(venues));
    } catch (e) {
      emit(VenuesError(e.toString()));
    }
  }

  void filterBySport(String sport) {
    selectedSport = sport;
    getVenues(sportType: sport);
  }
}