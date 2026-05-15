import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/networking/api_service.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';
import '../data/models/booking_model.dart';
import '../data/models/time_slot_model.dart';

<<<<<<< HEAD
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

=======
// States
abstract class BookingState {}

class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
class BookingLoaded extends BookingState {
  final List<BookingModel> bookings;
  BookingLoaded(this.bookings);
}
<<<<<<< HEAD

=======
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
class SlotsLoaded extends BookingState {
  final List<TimeSlotModel> slots;
  SlotsLoaded(this.slots);
}
<<<<<<< HEAD

=======
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
<<<<<<< HEAD

=======
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
class BookingSuccess extends BookingState {
  final BookingModel booking;
  BookingSuccess(this.booking);
}

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

<<<<<<< HEAD
  // ✅ احتفظ بالـ slots عشان نقدر نوصلها من الـ screen
  List<TimeSlotModel> cachedSlots = [];

=======
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
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
<<<<<<< HEAD
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
=======
  emit(BookingLoading());
  try {
    final apiService = getIt<ApiService>();
    final response = await apiService.getAvailableSlots(courtId, date);
    final List<dynamic> data = response as List<dynamic>;
    final slots = data.map((e) => TimeSlotModel.fromJson(e)).toList();
    emit(SlotsLoaded(slots));
  } catch (e) {
    emit(BookingError("Failed to load slots: $e"));
  }
}

  // New: create booking using time_slot_id
  Future<void> createBooking({
    required int courtId,
    required int timeSlotId,
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
  }) async {
    emit(BookingLoading());
    try {
      final apiService = getIt<ApiService>();
<<<<<<< HEAD

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
=======
      final response = await apiService.createBooking({
        'court_id': courtId,
        'time_slot_id': timeSlotId,
      });
      final booking = BookingModel.fromJson(response['data']);
      emit(BookingSuccess(booking));
      await getMyBookings(); // refresh list
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
    } catch (e) {
      emit(BookingError("Failed to create booking: $e"));
    }
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> c50fa394e477a91bc69d11ae70fd51e8028e8eb6
