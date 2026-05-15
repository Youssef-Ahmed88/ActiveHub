import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

part 'forgot_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgetPasswordCubit() : super(ForgotPasswordInitial());

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api'));

  String? savedEmail;

  Future<void> sendResetEmail(String email) async {
    if (email.isEmpty) {
      emit(ForgotPasswordError('Please enter your email'));
      return;
    }

    emit(ForgotPasswordLoading());

    try {
      final response = await _dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      if (response.data['success'] == true) {
        savedEmail = email;
        emit(ForgotPasswordCodeSent());
      } else {
        emit(ForgotPasswordError(
          response.data['message'] ?? 'Something went wrong',
        ));
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to send email';
      emit(ForgotPasswordError(message));
    }
  }

  Future<void> resetPassword({
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ForgotPasswordLoading());

    try {
      final response = await _dio.post(
        '/auth/reset-password',
        data: {
          'email':                 savedEmail,
          'code':                  code,
          'password':              password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.data['success'] == true) {
        emit(ForgotPasswordSuccess());
      } else {
        emit(ForgotPasswordError(
          response.data['message'] ?? 'Something went wrong',
        ));
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to reset password';
      emit(ForgotPasswordError(message));
    }
  }
}