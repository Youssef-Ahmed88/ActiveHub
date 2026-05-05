import 'package:dio/dio.dart';
import 'models/sport.dart';

class SportApi {
  final Dio _dio;
  SportApi(this._dio);

  Future<List<Sport>> getSports() async {
    final response = await _dio.get('/sports');
    final List data = response.data['data'];
    return data.map((s) => Sport.fromJson(s)).toList();
  }
}