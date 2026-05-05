import '../models/sport.dart';
import '../repos/sports_repo.dart';
import '../sport_api.dart';

class SportRepository implements SportsRepo {
  final SportApi _sportApi;
  SportRepository(this._sportApi);

  @override
  Future<List<Sport>> getSports() {
    return _sportApi.getSports();
  }
}