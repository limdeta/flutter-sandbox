import 'dart:math';

/// Точка трека пользователя с GPS координатами и временной меткой
/// 
/// Представляет единичную GPS точку в пути пользователя.
/// Содержит координаты, время, скорость и другие метрики.
class TrackPoint {
  /// Широта в градусах
  final double latitude;
  
  /// Долгота в градусах
  final double longitude;
  
  /// Временная метка когда была записана точка
  final DateTime timestamp;
  
  /// Точность GPS в метрах (чем меньше, тем точнее)
  final double? accuracy;
  
  /// Высота над уровнем моря в метрах
  final double? altitude;
  
  /// Точность высоты в метрах
  final double? altitudeAccuracy;
  
  /// Скорость в км/ч
  final double? speedKmh;
  
  /// Направление движения в градусах (0-360, где 0 = север)
  final double? bearing;
  
  /// Расстояние от предыдущей точки в метрах
  final double? distanceFromPrevious;
  
  /// Время от предыдущей точки в секундах
  final int? timeFromPrevious;
  
  /// Дополнительные метаданные (например, состояние батареи, сила сигнала)
  final Map<String, dynamic>? metadata;

  const TrackPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.altitude,
    this.altitudeAccuracy,
    this.speedKmh,
    this.bearing,
    this.distanceFromPrevious,
    this.timeFromPrevious,
    this.metadata,
  });

  /// Создает точку трека из GPS координат
  factory TrackPoint.fromGPS({
    required double latitude,
    required double longitude,
    DateTime? timestamp,
    double? accuracy,
    double? altitude,
    double? altitudeAccuracy,
    double? speedMps, // скорость в м/с (преобразуется в км/ч)
    double? bearing,
    Map<String, dynamic>? metadata,
  }) {
    return TrackPoint(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp ?? DateTime.now(),
      accuracy: accuracy,
      altitude: altitude,
      altitudeAccuracy: altitudeAccuracy,
      speedKmh: speedMps != null ? speedMps * 3.6 : null, // м/с в км/ч
      bearing: bearing,
      metadata: metadata,
    );
  }

  /// Создает тестовую точку для разработки
  factory TrackPoint.test({
    required double latitude,
    required double longitude,
    DateTime? timestamp,
    double? speedKmh,
  }) {
    return TrackPoint(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp ?? DateTime.now(),
      accuracy: 5.0, // Хорошая точность для тестов
      speedKmh: speedKmh,
    );
  }

  /// Проверяет, является ли точка валидной
  bool get isValid {
    return latitude >= -90 && latitude <= 90 &&
           longitude >= -180 && longitude <= 180 &&
           (accuracy == null || accuracy! >= 0);
  }

  /// Проверяет, имеет ли точка хорошую точность GPS (< 10 метров)
  bool get hasGoodAccuracy {
    return accuracy != null && accuracy! < 10.0;
  }

  /// Проверяет, движется ли пользователь (скорость > 0.5 км/ч)
  bool get isMoving {
    return speedKmh != null && speedKmh! > 0.5;
  }

  /// Вычисляет расстояние до другой точки в метрах (формула Haversine)
  double distanceTo(TrackPoint other) {
    const double earthRadius = 6371000; // Радиус Земли в метрах

    final double lat1Rad = latitude * pi / 180;
    final double lat2Rad = other.latitude * pi / 180;
    final double deltaLatRad = (other.latitude - latitude) * pi / 180;
    final double deltaLngRad = (other.longitude - longitude) * pi / 180;

    final double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(deltaLngRad / 2) * sin(deltaLngRad / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Вычисляет направление (азимут) к другой точке в градусах
  double bearingTo(TrackPoint other) {
    final double lat1Rad = latitude * pi / 180;
    final double lat2Rad = other.latitude * pi / 180;
    final double deltaLngRad = (other.longitude - longitude) * pi / 180;

    final double y = sin(deltaLngRad) * cos(lat2Rad);
    final double x = cos(lat1Rad) * sin(lat2Rad) -
        sin(lat1Rad) * cos(lat2Rad) * cos(deltaLngRad);

    final double bearing = atan2(y, x) * 180 / pi;
    return (bearing + 360) % 360; // Нормализуем к 0-360°
  }

  /// Создает копию точки с дополнительными данными от предыдущей точки
  TrackPoint withPreviousPointData(TrackPoint? previousPoint) {
    if (previousPoint == null) {
      return this;
    }

    final distance = previousPoint.distanceTo(this);
    final timeDiff = timestamp.difference(previousPoint.timestamp).inSeconds;

    return copyWith(
      distanceFromPrevious: distance,
      timeFromPrevious: timeDiff,
    );
  }

  /// Проверяет, значительно ли отличается от другой точки
  /// (используется для фильтрации дубликатов и шума GPS)
  bool isSignificantlyDifferentFrom(TrackPoint other, {
    double minDistanceMeters = 5.0,
    int minTimeSeconds = 10,
  }) {
    final distance = distanceTo(other);
    final timeDiff = timestamp.difference(other.timestamp).inSeconds.abs();

    return distance >= minDistanceMeters || timeDiff >= minTimeSeconds;
  }

  /// Создает копию точки с измененными полями
  TrackPoint copyWith({
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    double? accuracy,
    double? altitude,
    double? altitudeAccuracy,
    double? speedKmh,
    double? bearing,
    double? distanceFromPrevious,
    int? timeFromPrevious,
    Map<String, dynamic>? metadata,
  }) {
    return TrackPoint(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      altitudeAccuracy: altitudeAccuracy ?? this.altitudeAccuracy,
      speedKmh: speedKmh ?? this.speedKmh,
      bearing: bearing ?? this.bearing,
      distanceFromPrevious: distanceFromPrevious ?? this.distanceFromPrevious,
      timeFromPrevious: timeFromPrevious ?? this.timeFromPrevious,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrackPoint &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.timestamp == timestamp &&
        other.accuracy == accuracy &&
        other.altitude == altitude &&
        other.altitudeAccuracy == altitudeAccuracy &&
        other.speedKmh == speedKmh &&
        other.bearing == bearing &&
        other.distanceFromPrevious == distanceFromPrevious &&
        other.timeFromPrevious == timeFromPrevious;
  }

  @override
  int get hashCode {
    return Object.hash(
      latitude,
      longitude,
      timestamp,
      accuracy,
      altitude,
      altitudeAccuracy,
      speedKmh,
      bearing,
      distanceFromPrevious,
      timeFromPrevious,
    );
  }

  @override
  String toString() {
    return 'TrackPoint(lat: ${latitude.toStringAsFixed(6)}, '
        'lng: ${longitude.toStringAsFixed(6)}, '
        'time: $timestamp, '
        'speed: ${speedKmh?.toStringAsFixed(1) ?? 'unknown'} km/h, '
        'accuracy: ${accuracy?.toStringAsFixed(1) ?? 'unknown'}m)';
  }
}

/// Расширения для работы с коллекциями точек трека
extension TrackPointListExtensions on List<TrackPoint> {
  /// Фильтрует точки, оставляя только значимые (убирает GPS шум)
  List<TrackPoint> filterSignificant({
    double minDistanceMeters = 5.0,
    int minTimeSeconds = 10,
    double maxAccuracyMeters = 50.0,
  }) {
    if (isEmpty) return [];

    final filtered = <TrackPoint>[first]; // Всегда включаем первую точку

    for (int i = 1; i < length; i++) {
      final current = this[i];
      final previous = filtered.last;

      // Пропускаем точки с плохой точностью
      if (current.accuracy != null && current.accuracy! > maxAccuracyMeters) {
        continue;
      }

      // Добавляем только значимо отличающиеся точки
      if (current.isSignificantlyDifferentFrom(
        previous,
        minDistanceMeters: minDistanceMeters,
        minTimeSeconds: minTimeSeconds,
      )) {
        filtered.add(current.withPreviousPointData(previous));
      }
    }

    return filtered;
  }

  /// Вычисляет общее расстояние для списка точек
  double getTotalDistance() {
    if (length < 2) return 0.0;

    double total = 0.0;
    for (int i = 1; i < length; i++) {
      total += this[i - 1].distanceTo(this[i]);
    }
    return total;
  }

  /// Получает временной диапазон точек
  Duration get timeSpan {
    if (isEmpty) return Duration.zero;
    if (length == 1) return Duration.zero;
    
    return last.timestamp.difference(first.timestamp);
  }
}
