import 'dart:math' as math;

/// Географическая точка на карте
class MapPoint {
  final double latitude;
  final double longitude;
  final double? altitude;
  final DateTime? timestamp;
  final Map<String, dynamic>? metadata;

  const MapPoint({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.timestamp,
    this.metadata,
  });

  /// Создает точку из координат
  factory MapPoint.fromCoordinates(double lat, double lon) {
    return MapPoint(latitude: lat, longitude: lon);
  }

  /// Создает точку из POI маршрута
  factory MapPoint.fromRoutePoint(dynamic routePoint) {
    // TODO: Интеграция с RoutePoint из domain
    return MapPoint(
      latitude: routePoint.latitude ?? 0.0,
      longitude: routePoint.longitude ?? 0.0,
      metadata: {
        'name': routePoint.name,
        'type': routePoint.type?.toString(),
        'status': routePoint.status?.toString(),
      },
    );
  }

  /// Вычисляет расстояние до другой точки (в метрах)
  double distanceTo(MapPoint other) {
    const double earthRadius = 6371000; // радиус Земли в метрах
    
    final double lat1Rad = latitude * (math.pi / 180);
    final double lat2Rad = other.latitude * (math.pi / 180);
    final double deltaLatRad = (other.latitude - latitude) * (math.pi / 180);
    final double deltaLonRad = (other.longitude - longitude) * (math.pi / 180);

    final double a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLonRad / 2) * math.sin(deltaLonRad / 2);
    final double c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  @override
  String toString() => 'MapPoint($latitude, $longitude)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapPoint &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
