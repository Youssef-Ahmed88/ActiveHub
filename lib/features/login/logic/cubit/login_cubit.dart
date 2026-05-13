import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/networking/dio_factory.dart';
import 'package:flutter_complete_project/features/login/data/models/login_request_body.dart';
import 'package:flutter_complete_project/features/login/data/repos/login_repo.dart';
import 'package:flutter_complete_project/features/login/logic/cubit/login_state.dart';
import 'package:flutter_complete_project/core/networking/api_result.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  LoginCubit(this.loginRepo) : super(const LoginState.initial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> emitLoginStates() async {
    if (!formKey.currentState!.validate()) return;
    emit(const LoginState.loading());

    final dio = DioFactory.getDio();
    print('🌐 Login using baseUrl: ${dio.options.baseUrl}');

    final response = await loginRepo.login(
      LoginRequestBody(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );

    await response.when(
      success: (loginResponse) async {
        final token = loginResponse.data?.token;
        final role = loginResponse.data?.user?.role;

        if (token != null && token.isNotEmpty) {
          await DioFactory.saveToken(token);
          DioFactory.resetDio();
        } else {
          emit(
            LoginState.error(
              error: 'Invalid response from server (missing token)',
            ),
          );
          return;
        }

        if (role == 'admin') {
          emit(LoginState.adminSuccess(loginResponse));
        } else if (role == 'owner') {
          emit(LoginState.ownerSuccess(loginResponse));
        } else {
          emit(LoginState.success(loginResponse));
        }
      },
      failure: (error) {
        emit(
          LoginState.error(
            error: error.apiErrorModel.message ?? 'Login failed',
          ),
        );
      },
    );
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}
