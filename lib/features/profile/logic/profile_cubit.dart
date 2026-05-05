import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/helpers/constants.dart';
import 'package:flutter_complete_project/core/helpers/shared_pref_helper.dart';
import 'package:flutter_complete_project/core/networking/dio_factory.dart';
import '../data/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final User user;
  ProfileLoaded(this.user);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  User? _currentUser;

  Future<void> loadUserProfile() async {
    emit(ProfileLoading());
    try {
      final dio = DioFactory.getDio();
      final response = await dio.get('/user');

      // ✅ طباعة كاملة للاستجابة (لتظهر في Terminal)
      print('=== Profile API Response ===');
      print('Status code: ${response.statusCode}');
      print('Full data: ${response.data}');

      // التحقق من نجاح الـ status code
      if (response.statusCode != 200) {
        throw Exception('Server returned ${response.statusCode}');
      }

      // التحقق من أن response.data موجود وليس null
      if (response.data == null) {
        throw Exception('Response data is null');
      }

      // محاولة استخراج البيانات بمرونة (تجربة أكثر من هيكل)
      Map<String, dynamic> userData;
      if (response.data['data'] != null) {
        // الحالة 1: { "success": true, "data": { ... } }
        userData = response.data['data'];
      } else if (response.data['user'] != null) {
        // الحالة 2: { "user": { ... } }
        userData = response.data['user'];
      } else if (response.data['id'] != null) {
        // الحالة 3: البيانات مباشرة { "id": ..., "full_name": ... }
        userData = response.data;
      } else {
        throw Exception('Unknown response structure: ${response.data}');
      }

      _currentUser = User(
        name: userData['full_name'] ?? userData['name'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'] ?? '',
        bookings: [],
      );
      emit(ProfileLoaded(_currentUser!));
    } catch (e) {
      print('Profile load error: $e');
      emit(ProfileError("Failed to load profile: $e"));
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (_currentUser == null) return;

    try {
      final dio = DioFactory.getDio();
      await dio.put('/user', data: {
        'full_name': name,
        'email': email,
        'phone': phone,
      });
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phone: phone,
      );
      emit(ProfileLoaded(_currentUser!));
    } catch (e) {
      emit(ProfileError("Failed to update profile: $e"));
    }
  }

  void logout() async {
    try {
      final dio = DioFactory.getDio();
      await dio.post('/auth/logout');
    } catch (e) {
      // تجاهل فشل الـ API
    } finally {
      await DioFactory.clearToken();
      _currentUser = null;
      emit(ProfileInitial());
    }
  }
}