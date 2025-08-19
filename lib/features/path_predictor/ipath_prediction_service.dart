import 'package:tauzero/features/map/domain/entities/map_point.dart';

abstract class IPathPredictionService {
  Future<List<MapPoint>> predictPaths(List<MapPoint> points);
}