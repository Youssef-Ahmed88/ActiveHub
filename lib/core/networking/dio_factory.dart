import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/helpers/constants.dart';
import 'package:flutter_complete_project/core/networking/api_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../helpers/shared_pref_helper.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

static void resetDio() {
  _dio = null;
  print('🔄 Dio has been reset');
}
  static Dio getDio() {
    // ⏱️ زيادة المهلة إلى 120 ثانية لحل مشكلة timeout
    const timeout = Duration(seconds: 120);

    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        headers: {
          'Accept': 'application/json',
        },
      ));
      print('✅ Dio initialized with baseUrl: ${ApiConstants.apiBaseUrl}'); // تأكد من الرابط
      _addInterceptors();
    }
    return _dio!;
  }

  static Future<void> saveToken(String token) async {
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
    _dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  static Future<void> clearToken() async {
    await SharedPrefHelper.deleteSecuredString(SharedPrefKeys.userToken);
    _dio?.options.headers.remove('Authorization');
  }
  static void setTokenIntoHeaderAfterLogin(String token) {
  _dio?.options.headers['Authorization'] = 'Bearer $token';
}

static void _addInterceptors() {
  _dio?.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
        print('🔍 Interceptor: Path=${options.path}, Token exists=${token.isNotEmpty}');
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          print('✅ Token added to request: ${options.path}');
        } else {
          print('❌ No token found for request: ${options.path}');
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          print('🚨 401 on ${error.requestOptions.path}');
        }
        return handler.next(error);
      },

      ),
    );
    _dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
  }
}