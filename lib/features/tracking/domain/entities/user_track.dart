import 'track_point.dart';

/// Трек (путь) пользователя за определенный период времени
/// 
/// Представляет собой последовательность GPS точек с временными метками,
/// которые показывают где и когда находился пользователь.
/// Используется для:
/// - Отображения пройденного пути на карте
/// - Расчета пройденного расстояния
/// - Анализа времени в пути
/// - Оптимизации маршрутов
class UserTrack {
  final int id;
  final int userId;
  final int? routeId;
  
  final DateTime startTime;
  final DateTime? endTime;
  
  /// Список точек трека в хронологическом порядке
  final List<TrackPoint> points;
  
  final double totalDistanceMeters;
  
  /// Общее время в движении в секундах (исключая остановки)
  final int movingTimeSeconds;
  
  /// Общее время трека в секундах (включая остановки)
  final int totalTimeSeconds;
  

  final double averageSpeedKmh;
  final double maxSpeedKmh;

  final TrackStatus status;

  final Map<String, dynamic>? metadata;

  const UserTrack({
    required this.id,
    required this.userId,
    this.routeId,
    required this.startTime,
    this.endTime,
    required this.points,
    required this.totalDistanceMeters,
    required this.movingTimeSeconds,
    required this.totalTimeSeconds,
    required this.averageSpeedKmh,
    required this.maxSpeedKmh,
    required this.status,
    this.metadata,
  });

  /// Создает новый трек
  factory UserTrack.create({
    required int userId,
    int? routeId,
    DateTime? startTime,
    Map<String, dynamic>? metadata,
  }) {
    final now = startTime ?? DateTime.now();
    return UserTrack(
      id: 0, // Будет установлен при сохранении в БД
      userId: userId,
      routeId: routeId,
      startTime: now,
      endTime: null,
      points: [],
      totalDistanceMeters: 0.0,
      movingTimeSeconds: 0,
      totalTimeSeconds: 0,
      averageSpeedKmh: 0.0,
      maxSpeedKmh: 0.0,
      status: TrackStatus.active,
      metadata: metadata,
    );
  }

  bool get isActive => status == TrackStatus.active;
  bool get isCompleted => status == TrackStatus.completed;
  bool get isPaused => status == TrackStatus.paused;
  TrackPoint? get lastPoint => points.isNotEmpty ? points.last : null;
  TrackPoint? get firstPoint => points.isNotEmpty ? points.first : null;
  double get totalDistanceKm => totalDistanceMeters / 1000.0;
  double get movingTimeMinutes => movingTimeSeconds / 60.0;
  double get totalTimeMinutes => totalTimeSeconds / 60.0;

  UserTrack addPoint(TrackPoint point) {
    final newPoints = List<TrackPoint>.from(points)..add(point);
    return _recalculateStats(newPoints);
  }

  UserTrack addPoints(List<TrackPoint> newPoints) {
    final allPoints = List<TrackPoint>.from(points)..addAll(newPoints);
    return _recalculateStats(allPoints);
  }

  UserTrack complete({DateTime? endTime}) {
    return copyWith(
      endTime: endTime ?? DateTime.now(),
      status: TrackStatus.completed,
    );
  }

  UserTrack pause() {
    return copyWith(status: TrackStatus.paused);
  }

  UserTrack resume() {
    return copyWith(status: TrackStatus.active);
  }

  /// Пересчитывает статистику трека на основе точек
  UserTrack _recalculateStats(List<TrackPoint> newPoints) {
    if (newPoints.isEmpty) {
      return copyWith(points: newPoints);
    }

    // Сортируем точки по времени
    final sortedPoints = List<TrackPoint>.from(newPoints)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    double totalDistance = 0.0;
    double maxSpeed = 0.0;
    int movingTime = 0;
    
    for (int i = 1; i < sortedPoints.length; i++) {
      final prevPoint = sortedPoints[i - 1];
      final currentPoint = sortedPoints[i];
      
      // Рассчитываем расстояние между точками
      final distance = prevPoint.distanceTo(currentPoint);
      totalDistance += distance;
      
      // Обновляем максимальную скорость
      if (currentPoint.speedKmh != null && currentPoint.speedKmh! > maxSpeed) {
        maxSpeed = currentPoint.speedKmh!;
      }
      
      // Рассчитываем время в движении (исключаем остановки)
      final timeDiff = currentPoint.timestamp.difference(prevPoint.timestamp).inSeconds;
      if (currentPoint.speedKmh != null && currentPoint.speedKmh! > 0.5) { // Движение если скорость > 0.5 км/ч
        movingTime += timeDiff;
      }
    }

    final totalTime = sortedPoints.last.timestamp.difference(sortedPoints.first.timestamp).inSeconds;
    final averageSpeed = movingTime > 0 ? (totalDistance / 1000.0) / (movingTime / 3600.0) : 0.0;

    return copyWith(
      points: sortedPoints,
      totalDistanceMeters: totalDistance,
      movingTimeSeconds: movingTime,
      totalTimeSeconds: totalTime,
      averageSpeedKmh: averageSpeed,
      maxSpeedKmh: maxSpeed,
    );
  }

  /// Создает копию трека с измененными полями
  UserTrack copyWith({
    int? id,
    int? userId,
    int? routeId,
    DateTime? startTime,
    DateTime? endTime,
    List<TrackPoint>? points,
    double? totalDistanceMeters,
    int? movingTimeSeconds,
    int? totalTimeSeconds,
    double? averageSpeedKmh,
    double? maxSpeedKmh,
    TrackStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return UserTrack(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      routeId: routeId ?? this.routeId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      points: points ?? this.points,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      movingTimeSeconds: movingTimeSeconds ?? this.movingTimeSeconds,
      totalTimeSeconds: totalTimeSeconds ?? this.totalTimeSeconds,
      averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'UserTrack(id: $id, userId: $userId, routeId: $routeId, '
        'startTime: $startTime, distance: ${totalDistanceKm.toStringAsFixed(2)}km, '
        'status: $status, points: ${points.length})';
  }
}

/// Статус трека
enum TrackStatus {
  active,
  paused,
  completed,
  cancelled,
}

/// Расширения для TrackStatus
extension TrackStatusExtension on TrackStatus {
  /// Получает отображаемое название статуса
  String get displayName {
    switch (this) {
      case TrackStatus.active:
        return 'Активный';
      case TrackStatus.paused:
        return 'Приостановлен';
      case TrackStatus.completed:
        return 'Завершен';
      case TrackStatus.cancelled:
        return 'Отменен';
    }
  }

  bool get canAddPoints {
    return this == TrackStatus.active;
  }
}
