import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';

abstract class ChatbotState {}
class ChatbotInitial extends ChatbotState {}
class ChatbotLoading extends ChatbotState {}
class ChatbotSuccess extends ChatbotState {
  final String reply;
  ChatbotSuccess(this.reply);
}
class ChatbotError extends ChatbotState {
  final String message;
  ChatbotError(this.message);
}

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit() : super(ChatbotInitial());

  Future<void> sendMessage(String message) async {
    emit(ChatbotLoading());
    try {
      final dio = getIt<Dio>();
      final response = await dio.post('/chatbot', data: {'message': message});
      // حسب هيكل الـ response من الـ backend
      final reply = response.data['data']['reply'] ?? response.data['reply'] ?? 'No reply';
      emit(ChatbotSuccess(reply));
    } catch (e) {
      emit(ChatbotError(e.toString()));
    }
  }
}