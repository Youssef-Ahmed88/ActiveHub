import 'package:dio/dio.dart';

class ErrorHandler {
  static ErrorState handle(dynamic error) {
    if (error is DioException) {
      return ErrorState(
        apiErrorModel: ApiErrorModel(
          message: error.response?.data['message'] ?? error.message ?? 'Unknown error',
        ),
      );
    }
    return ErrorState(
      apiErrorModel: ApiErrorModel(message: error.toString()),
    );
  }
}

class ErrorState {
  final ApiErrorModel apiErrorModel;
  ErrorState({required this.apiErrorModel});
}

class ApiErrorModel {
  final String? message;
  ApiErrorModel({this.message});
}