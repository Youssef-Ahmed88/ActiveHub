part of 'forget_password_cubit.dart';

abstract class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordSuccess extends ForgetPasswordState {}

class ForgetPasswordError extends ForgetPasswordState {
  final String error;
  ForgetPasswordError(this.error);
}
