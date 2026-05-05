import '../models/sport.dart';

abstract class SportsRepo {
  Future<List<Sport>> getSports();
}