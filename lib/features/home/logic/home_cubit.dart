import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/helpers/extensions.dart';
import 'package:flutter_complete_project/core/networking/api_error_handler.dart';
import 'package:flutter_complete_project/core/networking/api_result.dart';
import '../data/models/specializations_response_model.dart';
import '../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;
  HomeCubit(this._homeRepo) : super(const HomeState.initial());

  List<SpecializationsData?>? sportCategoriesList = [];

  void getSpecializations() async {
    emit(const HomeState.specializationsLoading());
    final response = await _homeRepo.getSpecialization();
    response.when(
      success: (specializationsResponseModel) {
        sportCategoriesList =
            specializationsResponseModel.specializationDataList ?? [];

        getVenuesList(
          specializationId: sportCategoriesList?.first?.id,
        );

        emit(HomeState.specializationsSuccess(
            specializationsResponseModel.specializationDataList));
      },
      failure: (errorState) {
        emit(HomeState.specializationsError(errorState));
      },
    );
  }

  void getVenuesList({required int? specializationId}) {
    List<Doctors?>? venuesList = getVenuesListByCategoryId(specializationId);

    if (!venuesList.isNullOrEmpty()) {
      emit(HomeState.venuesSuccess(venuesList));
    } else {
      emit(HomeState.venuesError(
          ErrorHandler.handle('No venues found for this category')));
    }
  }

  List<Doctors?>? getVenuesListByCategoryId(int? categoryId) {
    return sportCategoriesList
        ?.firstWhere(
          (category) => category?.id == categoryId,
          orElse: () => null,
        )
        ?.doctorsList;
  }
}