import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/networking/api_service.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';
import '../data/models/booking_model.dart';
import '../data/models/time_slot_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingModel> bookings;
  BookingLoaded(this.bookings);
}

class SlotsLoaded extends BookingState {
  final List<TimeSlotModel> slots;
  SlotsLoaded(this.slots);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class BookingSuccess extends BookingState {
  final BookingModel booking;
  BookingSuccess(this.booking);
}

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  // ✅ احتفظ بالـ slots عشان نقدر نوصلها من الـ screen
  List<TimeSlotModel> cachedSlots = [];

  Future<void> getMyBookings() async {
    emit(BookingLoading());
    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getMyBookings();
      final List<dynamic> data = response as List<dynamic>;
      final bookings = data.map((e) => BookingModel.fromJson(e)).toList();
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError("Failed to load bookings: $e"));
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      final apiService = getIt<ApiService>();
      await apiService.cancelBooking(bookingId);
      await getMyBookings();
    } catch (e) {
      emit(BookingError("Failed to cancel booking: $e"));
    }
  }

  Future<void> getAvailableSlots(int courtId, String date) async {
    emit(BookingLoading());
    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getAvailableSlots(courtId, date);
      final List<dynamic> data = response as List<dynamic>;
      final slots = data.map((e) => TimeSlotModel.fromJson(e)).toList();
      cachedSlots = slots; // ✅ احفظ الـ slots
      emit(SlotsLoaded(slots));
    } catch (e) {
      emit(BookingError("Failed to load slots: $e"));
    }
  }

  // ✅ createBooking مع دعم الـ duration
  Future<void> createBooking({
    required int courtId,
    required int timeSlotId,
    required int duration,
  }) async {
    emit(BookingLoading());
    try {
      final apiService = getIt<ApiService>();

      // ابحث عن الـ slot المختار في الـ cachedSlots
      final startIndex = cachedSlots.indexWhere((s) => s.id == timeSlotId);
      if (startIndex == -1) {
        emit(BookingError("Selected slot not found"));
        return;
      }

      // تأكد إن في slots كفاية
      if (startIndex + duration > cachedSlots.length) {
        emit(BookingError("Not enough consecutive slots available"));
        return;
      }

      // تأكد إن كل الـ slots المطلوبة متاحة
      for (int i = startIndex; i < startIndex + duration; i++) {
        if (!cachedSlots[i].isAvailable) {
          emit(
            BookingError("Slot ${cachedSlots[i].startTime} is not available"),
          );
          return;
        }
      }

      // احجز كل الـ slots
      BookingModel? lastBooking;
      for (int i = startIndex; i < startIndex + duration; i++) {
        final response = await apiService.createBooking({
          'court_id': courtId,
          'time_slot_id': cachedSlots[i].id,
        });
        lastBooking = BookingModel.fromJson(response['data']);
      }

      emit(BookingSuccess(lastBooking!));
      await getMyBookings();
    } catch (e) {
      emit(BookingError("Failed to create booking: $e"));
    }
  }
}
