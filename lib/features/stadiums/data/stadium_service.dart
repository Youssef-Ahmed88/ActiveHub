import 'package:flutter_complete_project/core/networking/api_service.dart';

class StadiumService {
  final ApiService _apiService;

  StadiumService(this._apiService);

  Future<Map<String, dynamic>> getStadium(int id) async {
    final response = await _apiService.getStadium(id);
    return response as Map<String, dynamic>;
  }

  // لو مفيش owner → data هتحتوي على ownerEmail و ownerPassword
  Future<Map<String, dynamic>> updateStadium(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiService.updateStadium(id, data);
    return response as Map<String, dynamic>;
  }
}
