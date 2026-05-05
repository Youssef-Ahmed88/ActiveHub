import 'package:flutter_complete_project/core/networking/api_error_handler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/specializations_response_model.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;

  // Sport Categories
  const factory HomeState.specializationsLoading() = SpecializationsLoading;
  const factory HomeState.specializationsSuccess(
    List<SpecializationsData?>? specializationDataList,
  ) = SpecializationsSuccess;
  const factory HomeState.specializationsError(
    ErrorState errorState,
  ) = SpecializationsError;

  // Venues
  const factory HomeState.venuesSuccess(
    List<Doctors?>? venuesList,
  ) = VenuesSuccess;
  const factory HomeState.venuesError(
    ErrorState errorState,
  ) = VenuesError;
}