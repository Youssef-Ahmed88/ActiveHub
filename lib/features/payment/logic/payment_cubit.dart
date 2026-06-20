import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/payment_method.dart';
import '../data/payment_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentMethod> methods;
  PaymentLoaded(this.methods);
}

class PaymentMethodSuccess extends PaymentState {
  final String message;
  final List<PaymentMethod> methods;
  PaymentMethodSuccess(this.message, this.methods);
}

class BookingConfirmed extends PaymentState {
  final String message;
  BookingConfirmed(this.message);
}

class PaymentFailure extends PaymentState {
  final String error;
  PaymentFailure(this.error);
}

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository repository;

  PaymentCubit(this.repository) : super(PaymentInitial());

  Future<void> loadMethods() async {
    emit(PaymentLoading());
    try {
      final methods = await repository.getMethods();
      emit(PaymentLoaded(methods));
    } catch (e) {
      emit(PaymentFailure("Failed to load methods: $e"));
    }
  }

  Future<void> addMethod(PaymentMethod method) async {
    try {
      await repository.addMethod(method);
      final methods = await repository.getMethods();
      emit(PaymentMethodSuccess("Payment method added successfully", methods));
    } catch (e) {
      emit(PaymentFailure("Failed to add method: $e"));
    }
  }

  Future<void> removeMethod(String id) async {
    try {
      await repository.removeMethod(id);
      final methods = await repository.getMethods();
      emit(
        PaymentMethodSuccess("Payment method removed successfully", methods),
      );
    } catch (e) {
      emit(PaymentFailure("Failed to remove method: $e"));
    }
  }

  Future<void> confirmBooking(Map<String, dynamic> bookingData) async {
    try {
      print('💳 Confirming payment: $bookingData');
      final dio = getIt<Dio>();
      await dio.post(
        '/payments',
        data: {
          'booking_id': bookingData['booking_id'],
          'amount': bookingData['totalPrice'],
          'payment_method': bookingData['paymentMethod'],
          'paid_at': DateTime.now().toIso8601String(),
        },
      );
      emit(BookingConfirmed("Booking confirmed successfully"));
    } catch (e) {
      if (e is DioException) {
        print('❌ Payment error details: ${e.response?.data}');
      }
      print('❌ Payment error: $e');
      emit(PaymentFailure("Failed to confirm booking: $e"));
    }
  }
}
