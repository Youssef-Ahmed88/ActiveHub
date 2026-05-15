import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/helpers/constants.dart';
import 'package:flutter_complete_project/core/helpers/shared_pref_helper.dart';
import 'package:flutter_complete_project/core/networking/dio_factory.dart';
import 'package:flutter/material.dart'; // للوصول إلى Navigator
import '../data/user.dart';
import 'package:dio/dio.dart';

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
class ProfileUnauthorized extends ProfileState {} // حالة جديدة للتوجيه إلى login

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  User? _currentUser;

  Future<void> loadUserProfile(BuildContext context) async { // تمرير context للتوجيه
    emit(ProfileLoading());
    try {
      final dio = DioFactory.getDio();
      // طباعة التوكن قبل الطلب (للتأكد)
      final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
      print('🔑 Token being used for profile: ${token.substring(0, 10)}...'); // جزء فقط

      final response = await dio.get('/user');

      print('=== Profile API Response ===');
      print('Status code: ${response.statusCode}');
      print('Full data: ${response.data}');

      if (response.statusCode != 200) {
        throw Exception('Server returned ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      Map<String, dynamic> userData;
      if (response.data['data'] != null) {
        userData = response.data['data'];
      } else if (response.data['user'] != null) {
        userData = response.data['user'];
      } else if (response.data['id'] != null) {
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
      // إذا كان الخطأ بسبب 401، أصدر حالة Unauthorized لتوجيه المستخدم
      if (e.toString().contains('401') || (e is DioException && e.response?.statusCode == 401)) {
        await DioFactory.clearToken(); // امسح التوكن الفاسد
        emit(ProfileUnauthorized()); // حالة خاصة
      } else {
        emit(ProfileError("Failed to load profile: $e"));
      }
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