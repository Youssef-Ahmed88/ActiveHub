import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/networking/api_service.dart';

part 'edit_stadium_state.dart';

class EditStadiumCubit extends Cubit<EditStadiumState> {
  final ApiService _apiService;

  EditStadiumCubit(this._apiService) : super(EditStadiumInitial());

  bool hasOwner = true;
  Map<String, dynamic>? stadium;

  Future<void> loadStadium(int id) async {
    emit(EditStadiumLoading());
    try {
      stadium = await _apiService.getStadium(id);
      hasOwner = stadium?['owner'] != null;
      emit(EditStadiumLoaded(stadium!, hasOwner));
    } catch (e) {
      emit(EditStadiumError(e.toString()));
    }
  }

  Future<void> updateStadium(int id, Map<String, dynamic> data) async {
    emit(EditStadiumSaving());
    try {
      // لو مفيش owner → data هتحتوي على ownerEmail و ownerPassword
      final updated = await _apiService.updateStadium(id, data);
      emit(EditStadiumSuccess(updated));
    } catch (e) {
      emit(EditStadiumError(e.toString()));
    }
  }
}
