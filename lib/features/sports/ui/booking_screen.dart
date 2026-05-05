import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/features/venues/data/models/venue.dart';
import 'package:flutter_complete_project/features/booking/logic/booking_cubit.dart';
import 'package:flutter_complete_project/features/booking/data/models/time_slot_model.dart';
import 'package:flutter_complete_project/features/booking/data/models/booking_model.dart';
import '../../../core/theming/colors.dart';
import '../../../core/routing/routes.dart';

class BookingScreen extends StatefulWidget {
  final Venue venue;

  const BookingScreen({super.key, required this.venue});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeSlotModel? selectedSlot;
  int duration = 1;
  final double depositPercent = 0.30;
  late BookingCubit _bookingCubit;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _bookingCubit = BookingCubit();
    _loadSlots();
  }

  void _loadSlots() {
    if (widget.venue.id != null) {
      _bookingCubit.getAvailableSlots(widget.venue.id!);
    }
  }

  @override
  void dispose() {
    _bookingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pricePerHour = widget.venue.pricePerHour ?? 0;
    final totalPrice = duration * pricePerHour;
    final depositAmount = totalPrice * depositPercent;

    return BlocProvider.value(
      value: _bookingCubit,
      child: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            // Navigate to confirmation screen on success
            Navigator.pushNamed(
              context,
              Routes.bookingConfirmationScreen,
              arguments: {
                'venue': widget.venue,
                'date': selectedDate,
                'timeSlot': selectedSlot!.startTime,
                'duration': duration,
                'totalPrice': totalPrice.toDouble(),
                'depositAmount': depositAmount,
                'booking_id': state.booking.id,
              },
            );
            setState(() => _isBooking = false);
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Booking Failed: ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
            setState(() => _isBooking = false);
          }
        },
        child: Scaffold(
          backgroundColor: ColorsManager.darkBg,
          appBar: AppBar(
            backgroundColor: ColorsManager.darkBg,
            elevation: 0,
            title: Text(widget.venue.name ?? 'Booking',
                style: const TextStyle(color: Colors.white)),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Venue info card (unchanged)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsManager.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ColorsManager.borderColor, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorsManager.primaryBlue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.sports, color: ColorsManager.primaryBlue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.venue.name ?? '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(widget.venue.address ?? '',
                                style: const TextStyle(
                                    color: ColorsManager.mutedText, fontSize: 13)),
                          ],
                        ),
                      ),
                      Text('EGP ${pricePerHour.toInt()}/hr',
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Date picker (unchanged)
                const Text('Select Date',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                      builder: (context, child) => Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                              primary: ColorsManager.primaryBlue),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                        selectedSlot = null;
                      });
                      _loadSlots();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: ColorsManager.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorsManager.borderColor, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: ColorsManager.lightBlue, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Time slots (unchanged)
                const Text('Select Time Slot',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),

                BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    if (state is BookingLoading && !_isBooking) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: ColorsManager.primaryBlue),
                      );
                    } else if (state is SlotsLoaded) {
                      final slots = state.slots;
                      if (slots.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.event_busy, color: Colors.red, size: 18),
                              SizedBox(width: 8),
                              Text('No available slots for this date',
                                  style: TextStyle(color: Colors.red, fontSize: 13)),
                            ],
                          ),
                        );
                      }
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: slots.map((slot) {
                          final isSelected = selectedSlot?.id == slot.id;
                          final isBooked = !slot.isAvailable;

                          return GestureDetector(
                            onTap: isBooked
                                ? null
                                : () => setState(() => selectedSlot = slot),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isBooked
                                    ? Colors.red.withOpacity(0.08)
                                    : isSelected
                                        ? ColorsManager.primaryBlue
                                        : ColorsManager.cardBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isBooked
                                      ? Colors.red.withOpacity(0.4)
                                      : isSelected
                                          ? ColorsManager.primaryBlue
                                          : ColorsManager.borderColor,
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                slot.startTime,
                                style: TextStyle(
                                  color: isBooked
                                      ? Colors.red.withOpacity(0.6)
                                      : isSelected
                                          ? Colors.white
                                          : ColorsManager.mutedText,
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  decoration: isBooked
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else if (state is BookingError && !_isBooking) {
                      return Text(state.message,
                          style: const TextStyle(color: Colors.red));
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 24),

                // Duration slider (unchanged)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Duration',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    Text('$duration ${duration == 1 ? 'hour' : 'hours'}',
                        style: const TextStyle(
                            color: ColorsManager.lightBlue, fontSize: 14)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: ColorsManager.primaryBlue,
                    inactiveTrackColor: ColorsManager.borderColor,
                    thumbColor: ColorsManager.primaryBlue,
                    overlayColor: ColorsManager.primaryBlue.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: duration.toDouble(),
                    min: 1,
                    max: 4,
                    divisions: 3,
                    label: '$duration hr',
                    onChanged: (val) => setState(() => duration = val.toInt()),
                  ),
                ),
                const SizedBox(height: 24),

                // Price summary (unchanged)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsManager.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ColorsManager.borderColor, width: 0.5),
                  ),
                  child: Column(
                    children: [
                      _priceRow('Price per hour', 'EGP ${pricePerHour.toInt()}'),
                      const SizedBox(height: 8),
                      _priceRow('Duration', '$duration hr'),
                      const Divider(color: ColorsManager.borderColor),
                      _priceRow('Total', 'EGP ${totalPrice.toInt()}', isTotal: true),
                      const SizedBox(height: 8),
                      _priceRow('Deposit (30%)', 'EGP ${depositAmount.toInt()}',
                          color: ColorsManager.lightBlue),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorsManager.cardBg,
              border: Border(top: BorderSide(color: ColorsManager.borderColor)),
            ),
            child: ElevatedButton(
              onPressed: (selectedSlot == null || _isBooking)
                  ? null
                  : () async {
                      setState(() {
                        _isBooking = true;
                      });
                      // Use the cubit's createBooking method (requires courtId and timeSlotId)
                      context.read<BookingCubit>().createBooking(
                            courtId: widget.venue.id!,
                            timeSlotId: selectedSlot!.id,
                          );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryBlue,
                disabledBackgroundColor: ColorsManager.borderColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isBooking
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Continue to Payment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              color: isTotal ? Colors.white : ColorsManager.mutedText,
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            )),
        Text(value,
            style: TextStyle(
              color: color ?? (isTotal ? Colors.white : ColorsManager.mutedText),
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            )),
      ],
    );
  }
}