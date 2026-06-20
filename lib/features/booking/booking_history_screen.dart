import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theming/colors.dart';
import '../../../core/networking/dio_factory.dart';
import '../../../core/routing/routes.dart';
import 'package:flutter_complete_project/features/booking/logic/booking_cubit.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case "confirmed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  // ✅ دالة الدفع — بتكلم الـ backend وتفتح Paymob
  Future<void> _payNow(BuildContext context, dynamic booking) async {
    try {
      // بيظهر loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final dio = DioFactory.getDio();
      final response = await dio.post(
        '/paymob/pay',
        data: {'booking_id': booking.id},
      );

      Navigator.pop(context); // اقفل الـ loading

      if (response.data['success'] == true) {
        final iframeUrl = response.data['data']['iframe_url'];
        final amount =
            double.tryParse(response.data['data']['amount'].toString()) ?? 0.0;

        Navigator.pushNamed(
          context,
          Routes.paymobWebView,
          arguments: {
            'iframe_url': iframeUrl,
            'booking_id': booking.id,
            'amount': amount,
          },
        );
      } else {
        _showError(context, 'Failed to initiate payment');
      }
    } catch (e) {
      Navigator.pop(context); // اقفل الـ loading لو في error
      _showError(context, 'Payment error: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit()..getMyBookings(),
      child: Scaffold(
        backgroundColor: ColorsManager.darkBg,
        appBar: AppBar(
          title: const Text("Booking History"),
          backgroundColor: ColorsManager.cardBg,
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.primaryBlue,
                ),
              );
            } else if (state is BookingLoaded) {
              if (state.bookings.isEmpty) {
                return const Center(
                  child: Text(
                    "No bookings found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  return Card(
                    color: ColorsManager.cardBg,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.sports,
                        color: _statusColor(booking.status),
                      ),
                      title: Text(
                        booking.court?.name ?? 'Unknown Court',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.court?.address ?? '',
                            style: const TextStyle(
                              color: ColorsManager.mutedText,
                            ),
                          ),
                          Text(
                            "From: ${booking.startTime}",
                            style: const TextStyle(
                              color: ColorsManager.mutedText,
                            ),
                          ),
                          Text(
                            "Price: ${booking.totalPrice} EGP",
                            style: const TextStyle(
                              color: ColorsManager.mutedText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              // ✅ زرار Pay Now للـ pending
                              if (booking.status == 'pending')
                                ElevatedButton.icon(
                                  onPressed: () => _payNow(context, booking),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    "Pay Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              // زرار Cancel للـ confirmed
                              if (booking.status == 'confirmed')
                                TextButton(
                                  onPressed: () {
                                    context.read<BookingCubit>().cancelBooking(
                                      booking.id,
                                    );
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(booking.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          booking.status,
                          style: TextStyle(
                            color: _statusColor(booking.status),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is BookingError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
