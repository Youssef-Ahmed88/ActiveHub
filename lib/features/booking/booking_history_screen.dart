import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theming/colors.dart';
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
                child: CircularProgressIndicator(color: ColorsManager.primaryBlue),
              );
            } else if (state is BookingLoaded) {
              if (state.bookings.isEmpty) {
                return const Center(
                  child: Text("No bookings found",
                      style: TextStyle(color: Colors.white)),
                );
              }
              return ListView.builder(
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  return Card(
                    color: ColorsManager.cardBg,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(Icons.sports,
                          color: _statusColor(booking.status)),
                      title: Text(
                        booking.court?.name ?? 'Unknown Court',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.court?.address ?? '',
                            style: const TextStyle(color: ColorsManager.mutedText),
                          ),
                          Text(
                            "From: ${booking.startTime}",
                            style: const TextStyle(color: ColorsManager.mutedText),
                          ),
                          Text(
                            "Price: ${booking.totalPrice} EGP",
                            style: const TextStyle(color: ColorsManager.mutedText),
                          ),
                          if (booking.status == 'confirmed')
                            TextButton(
                              onPressed: () {
                                context.read<BookingCubit>().cancelBooking(booking.id);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(booking.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          booking.status,
                          style: TextStyle(
                              color: _statusColor(booking.status),
                              fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is BookingError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}