part of 'edit_stadium_cubit.dart';

abstract class EditStadiumState {}

class EditStadiumInitial extends EditStadiumState {}

class EditStadiumLoading extends EditStadiumState {}

class EditStadiumSaving extends EditStadiumState {}

class EditStadiumLoaded extends EditStadiumState {
  final Map<String, dynamic> stadium;
  final bool hasOwner;
  EditStadiumLoaded(this.stadium, this.hasOwner);
}

class EditStadiumSuccess extends EditStadiumState {
  final Map<String, dynamic> updated;
  EditStadiumSuccess(this.updated);
}

class EditStadiumError extends EditStadiumState {
  final String message;
  EditStadiumError(this.message);
}
