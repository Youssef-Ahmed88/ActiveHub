import 'package:flutter_bloc/flutter_bloc.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  Future<void> sendResetEmail(String email) async {
    emit(ForgetPasswordLoading());

    try {
      await Future.delayed(const Duration(seconds: 2)); // مثال مؤقت
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordError("Something went wrong"));
    }
  }
}
