import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tauzero/features/map/domain/entities/map_point.dart';
import 'ipath_prediction_service.dart';

class OsrmPathPredictionService implements IPathPredictionService {
  @override
  Future<List<MapPoint>> predictPaths(List<MapPoint> points) async {
    if (points.length < 2) {
      throw ArgumentError('At least two points are required');
    }

    // Формируем строку координат: lon,lat;lon,lat;...
    final coords = points.map((p) => '${p.longitude},${p.latitude}').join(';');
    final url = Uri.parse(
      'https://router.project-osrm.org/trip/v1/driving/$coords?source=first&destination=last&roundtrip=false&overview=false',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch route: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (data['code'] != 'Ok') {
      throw Exception('OSRM error: ${data['message']}');
    }

    // waypoints[i]['waypoint_index'] — индекс в оптимальном порядке
    // waypoints[i]['location'] — [lon, lat]
    // waypoints[i]['waypoint_index'] — индекс в trips[].waypoints
    // waypoints[i]['original_index'] — индекс в исходном списке

    // Сопоставляем оптимальный порядок с исходными точками
    final List<dynamic> waypoints = data['waypoints'];
    // Сортируем по waypoint_index
    waypoints.sort((a, b) => (a['waypoint_index'] as int).compareTo(b['waypoint_index'] as int));
    // Берём исходные точки по original_index
    final sortedPoints = waypoints.map<MapPoint>((wp) => points[wp['original_index'] as int]).toList();

    return sortedPoints;
  }
}