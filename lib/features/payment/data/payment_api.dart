import 'package:dio/dio.dart';

class PaymentApi {
  final Dio _dio;
  PaymentApi(this._dio);

  Future<Map<String, dynamic>> createPayment({
    required int? bookingId,
    required double amount,
    required String paymentMethod,
    String? transactionId,
  }) async {
    final response = await _dio.post('/payments', data: {
      'booking_id': bookingId,
      'amount': amount,
      'payment_method': paymentMethod,
      'transaction_id': transactionId,
      'paid_at': DateTime.now().toIso8601String(),
    });
    return response.data;
  }
}