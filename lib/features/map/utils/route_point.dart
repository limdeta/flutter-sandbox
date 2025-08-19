import 'package:latlong2/latlong.dart';
import 'package:tauzero/features/route/domain/entities/ipoint_of_interest.dart';

/// Точка маршрута с временной меткой
class RoutePoint {
  final LatLng location;
  final DateTime timestamp;
  final String? description;
  final RoutePointType type;
  final VisitStatus? status;

  const RoutePoint({
    required this.location,
    required this.timestamp,
    this.description,
    this.type = RoutePointType.regular,
    this.status,
  });

  /// Создает точку с текущим временем
  factory RoutePoint.now({
    required LatLng location,
    String? description,
    RoutePointType type = RoutePointType.regular,
    VisitStatus? status,
  }) {
    return RoutePoint(
      location: location,
      timestamp: DateTime.now(),
      description: description,
      type: type,
      status: status,
    );
  }

  /// Создает копию с измененными параметрами
  RoutePoint copyWith({
    LatLng? location,
    DateTime? timestamp,
    String? description,
    RoutePointType? type,
    VisitStatus? status,
  }) {
    return RoutePoint(
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'RoutePoint(${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}, ${timestamp.toIso8601String()})';
  }
}

/// Типы точек маршрута
enum RoutePointType {
  start,        // Начальная точка дня
  checkpoint,   // Чек-поинт (клиент, важное место)
  regular,      // Обычная точка трека
  stop,         // Остановка (кофе, обед)
  warehouse,    // Склад
  end,          // Конечная точка дня
}

/// Маршрут рабочего дня
class WorkDayRoute {
  final List<RoutePoint> points;
  final DateTime startTime;
  final DateTime? endTime;
  final String? description;

  const WorkDayRoute({
    required this.points,
    required this.startTime,
    this.endTime,
    this.description,
  });

  /// Получить общую продолжительность маршрута
  Duration get totalDuration {
    if (points.isEmpty) return Duration.zero;
    final end = endTime ?? points.last.timestamp;
    return end.difference(startTime);
  }

  /// Получить пройденное расстояние (примерно)
  double get totalDistanceKm {
    if (points.length < 2) return 0.0;
    
    double totalDistance = 0.0;
    final Distance distance = Distance();
    
    for (int i = 1; i < points.length; i++) {
      totalDistance += distance.as(
        LengthUnit.Kilometer,
        points[i-1].location,
        points[i].location,
      );
    }
    
    return totalDistance;
  }

  /// Получить список только координат для отображения на карте
  List<LatLng> get coordinates => points.map((p) => p.location).toList();

  /// Получить чек-поинты
  List<RoutePoint> get checkpoints => 
      points.where((p) => p.type == RoutePointType.checkpoint).toList();

  /// Получить процент выполнения маршрута по времени
  double getProgressAtTime(DateTime time) {
    if (points.isEmpty || time.isBefore(startTime)) return 0.0;
    
    final end = endTime ?? points.last.timestamp;
    if (time.isAfter(end)) return 1.0;
    
    final elapsed = time.difference(startTime);
    final total = end.difference(startTime);
    
    return elapsed.inMilliseconds / total.inMilliseconds;
  }

  /// Найти ближайшую точку к указанному времени
  RoutePoint? getPointAtTime(DateTime time) {
    if (points.isEmpty) return null;
    
    // Ищем точку с ближайшим временем
    RoutePoint? closest;
    Duration minDifference = Duration(days: 1);
    
    for (final point in points) {
      final difference = (point.timestamp.difference(time)).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closest = point;
      }
    }
    
    return closest;
  }
}
