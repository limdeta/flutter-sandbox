import '../../domain/entities/user_track.dart';
import '../../domain/entities/track_point.dart';

class UserTrackFixtures {
  static const int alexeyUserId = 3; // ID пользователя Алексей из auth фикстур
  
  /// Создает GPS трек для вчерашнего маршрута (завершенный)
  static UserTrack createYesterdayCompletedTrack([int? userId]) {
    final actualUserId = userId ?? alexeyUserId;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final startTime = DateTime(yesterday.year, yesterday.month, yesterday.day, 9, 0);
    final endTime = DateTime(yesterday.year, yesterday.month, yesterday.day, 17, 30);
    
    // Имитация движения по маршруту Владивостока
    final points = <TrackPoint>[
      // Начало в центре города
      TrackPoint.fromGPS(
        latitude: 43.1056, 
        longitude: 131.8735,
        timestamp: startTime,
        accuracy: 5.0,
        speedMps: 0.0,
      ),
      
      // Движение к первой точке
      TrackPoint.fromGPS(
        latitude: 43.1045, 
        longitude: 131.8755,
        timestamp: startTime.add(const Duration(minutes: 15)),
        accuracy: 4.0,
        speedMps: 25.0 / 3.6, // 25 км/ч в м/с
      ),
      
      // Остановка у клиента (Магазин "Продукты")
      TrackPoint.fromGPS(
        latitude: 43.1045, 
        longitude: 131.8755,
        timestamp: startTime.add(const Duration(minutes: 45)),
        accuracy: 3.0,
        speedMps: 0.0,
      ),
      
      // Движение ко второй точке
      TrackPoint.fromGPS(
        latitude: 43.1025, 
        longitude: 131.8785,
        timestamp: startTime.add(const Duration(hours: 1, minutes: 30)),
        accuracy: 5.0,
        speedMps: 30.0 / 3.6, // 30 км/ч в м/с
      ),
      
      // Остановка у клиента (ООО "Морпродукт")
      TrackPoint.fromGPS(
        latitude: 43.1025, 
        longitude: 131.8785,
        timestamp: startTime.add(const Duration(hours: 2)),
        accuracy: 4.0,
        speedMps: 0.0,
      ),
      
      // Движение к третьей точке
      TrackPoint.fromGPS(
        latitude: 43.0995, 
        longitude: 131.8815,
        timestamp: startTime.add(const Duration(hours: 3)),
        accuracy: 6.0,
        speedMps: 28.0 / 3.6, // 28 км/ч в м/с
      ),
      
      // Остановка у клиента (Ресторан "Дальневосточный")
      TrackPoint.fromGPS(
        latitude: 43.0995, 
        longitude: 131.8815,
        timestamp: startTime.add(const Duration(hours: 3, minutes: 45)),
        accuracy: 3.0,
        speedMps: 0.0,
      ),
      
      // Движение к четвертой точке
      TrackPoint.fromGPS(
        latitude: 43.0975, 
        longitude: 131.8845,
        timestamp: startTime.add(const Duration(hours: 4, minutes: 30)),
        accuracy: 5.0,
        speedMps: 32.0 / 3.6, // 32 км/ч в м/с
      ),
      
      // Остановка у клиента (Кафе "Уютное")
      TrackPoint.fromGPS(
        latitude: 43.0975, 
        longitude: 131.8845,
        timestamp: startTime.add(const Duration(hours: 5, minutes: 15)),
        accuracy: 4.0,
        speedMps: 0.0,
      ),
      
      // Движение к пятой точке
      TrackPoint.fromGPS(
        latitude: 43.0955, 
        longitude: 131.8875,
        timestamp: startTime.add(const Duration(hours: 6)),
        accuracy: 7.0,
        speedMps: 27.0 / 3.6, // 27 км/ч в м/с
      ),
      
      // Остановка у клиента (Супермаркет "Свежий")
      TrackPoint.fromGPS(
        latitude: 43.0955, 
        longitude: 131.8875,
        timestamp: startTime.add(const Duration(hours: 6, minutes: 30)),
        accuracy: 3.0,
        speedMps: 0.0,
      ),
      
      // Возвращение в офис
      TrackPoint.fromGPS(
        latitude: 43.1056, 
        longitude: 131.8735,
        timestamp: endTime,
        accuracy: 4.0,
        speedMps: 35.0 / 3.6, // 35 км/ч в м/с
      ),
    ];
    
    
    final track = UserTrack.create(
      userId: actualUserId,
      routeId: 54, // ID вчерашнего маршрута из роут фикстур
      startTime: startTime,
      metadata: {
        'source': 'fixture',
        'description': 'Completed track for yesterday route',
        'totalClients': 5,
        'completedVisits': 5,
      },
    );
    
    return track.addPoints(points).copyWith(
      endTime: endTime,
      status: TrackStatus.completed,
    );
  }
  
  /// Создает GPS трек для сегодняшнего маршрута (активный)
  static UserTrack createTodayActiveTrack([int? userId]) {
    final actualUserId = userId ?? alexeyUserId;
    final today = DateTime.now();
    final startTime = DateTime(today.year, today.month, today.day, 9, 15);
    final currentTime = DateTime.now();
    
    // Если сейчас рано утром, делаем трек более коротким
    final Duration elapsedTime = currentTime.difference(startTime);
    final bool isEarlyMorning = currentTime.hour < 12;
    
    final points = <TrackPoint>[
      // Начало в центре города
      TrackPoint.fromGPS(
        latitude: 43.1065, 
        longitude: 131.8745,
        timestamp: startTime,
        accuracy: 4.0,
        speedMps: 0.0,
      ),
    ];
    
    // Добавляем точки в зависимости от времени
    if (elapsedTime.inMinutes > 15) {
      points.add(TrackPoint.fromGPS(
        latitude: 43.1055, 
        longitude: 131.8765,
        timestamp: startTime.add(const Duration(minutes: 15)),
        accuracy: 5.0,
        speedMps: 22.0 / 3.6, // 22 км/ч в м/с
      ));
    }
    
    if (elapsedTime.inMinutes > 45) {
      // Остановка у первого клиента
      points.add(TrackPoint.fromGPS(
        latitude: 43.1055, 
        longitude: 131.8765,
        timestamp: startTime.add(const Duration(minutes: 45)),
        accuracy: 3.0,
        speedMps: 0.0,
      ));
    }
    
    if (elapsedTime.inHours >= 1 && elapsedTime.inMinutes > 90) {
      // Движение ко второму клиенту
      points.add(TrackPoint.fromGPS(
        latitude: 43.1035, 
        longitude: 131.8795,
        timestamp: startTime.add(const Duration(hours: 1, minutes: 30)),
        accuracy: 6.0,
        speedMps: 29.0 / 3.6, // 29 км/ч в м/с
      ));
    }
    
    if (elapsedTime.inHours >= 2) {
      // Остановка у второго клиента
      points.add(TrackPoint.fromGPS(
        latitude: 43.1035, 
        longitude: 131.8795,
        timestamp: startTime.add(const Duration(hours: 2)),
        accuracy: 4.0,
        speedMps: 0.0,
      ));
    }
    
    if (elapsedTime.inHours >= 3 && !isEarlyMorning) {
      // Движение к третьему клиенту
      points.add(TrackPoint.fromGPS(
        latitude: 43.1005, 
        longitude: 131.8825,
        timestamp: startTime.add(const Duration(hours: 2, minutes: 45)),
        accuracy: 5.0,
        speedMps: 31.0 / 3.6, // 31 км/ч в м/с
      ));
      
      // Текущая позиция (в движении или у клиента)
      points.add(TrackPoint.fromGPS(
        latitude: 43.1005, 
        longitude: 131.8825,
        timestamp: currentTime.subtract(const Duration(minutes: 5)),
        accuracy: 4.0,
        speedMps: 0.0,
      ));
    }
    
    
    final track = UserTrack.create(
      userId: actualUserId,
      routeId: 55, // ID сегодняшнего маршрута из роут фикстур
      startTime: startTime,
      metadata: {
        'source': 'fixture',
        'description': 'Active track for today route',
        'totalClients': 6,
        'completedVisits': points.length > 4 ? 2 : (points.length > 2 ? 1 : 0),
        'isLive': true,
      },
    );
    
    return track.addPoints(points).copyWith(
      status: TrackStatus.active,
    );
  }
  
  /// Создает старый завершенный трек (для статистики)
  static UserTrack createOldCompletedTrack() {
    final oldDate = DateTime.now().subtract(const Duration(days: 7));
    final startTime = DateTime(oldDate.year, oldDate.month, oldDate.day, 8, 30);
    final endTime = DateTime(oldDate.year, oldDate.month, oldDate.day, 18, 0);
    
    final points = <TrackPoint>[
      TrackPoint.fromGPS(
        latitude: 43.1075, 
        longitude: 131.8715,
        timestamp: startTime,
        accuracy: 5.0,
        speedMps: 0.0,
      ),
      TrackPoint.fromGPS(
        latitude: 43.1045, 
        longitude: 131.8755,
        timestamp: startTime.add(const Duration(minutes: 20)),
        accuracy: 4.0,
        speedMps: 24.0 / 3.6, // 24 км/ч в м/с
      ),
      TrackPoint.fromGPS(
        latitude: 43.1015, 
        longitude: 131.8805,
        timestamp: startTime.add(const Duration(hours: 1)),
        accuracy: 6.0,
        speedMps: 28.0 / 3.6, // 28 км/ч в м/с
      ),
      TrackPoint.fromGPS(
        latitude: 43.0985, 
        longitude: 131.8855,
        timestamp: startTime.add(const Duration(hours: 2)),
        accuracy: 5.0,
        speedMps: 26.0 / 3.6, // 26 км/ч в м/с
      ),
      TrackPoint.fromGPS(
        latitude: 43.1075, 
        longitude: 131.8715,
        timestamp: endTime,
        accuracy: 4.0,
        speedMps: 33.0 / 3.6, // 33 км/ч в м/с
      ),
    ];
    
    
    final track = UserTrack.create(
      userId: alexeyUserId,
      routeId: null, // Старый маршрут без привязки
      startTime: startTime,
      metadata: {
        'source': 'fixture',
        'description': 'Old completed track for statistics',
        'totalClients': 4,
        'completedVisits': 4,
      },
    );
    
    return track.addPoints(points).copyWith(
      endTime: endTime,
      status: TrackStatus.completed,
    );
  }
  
  /// Возвращает все фикстуры треков для Алексея
  static List<UserTrack> getAllFixtures() {
    return [
      createYesterdayCompletedTrack(),
      createTodayActiveTrack(),
      createOldCompletedTrack(),
    ];
  }
  
  /// Создает реалистичные координаты движения по Владивостоку
  static List<TrackPoint> generateRealisticPath({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    required DateTime startTime,
    required DateTime endTime,
    int pointCount = 10,
    double averageSpeedKmh = 25.0,
  }) {
    final points = <TrackPoint>[];
    final totalDuration = endTime.difference(startTime);
    final durationPerPoint = Duration(milliseconds: totalDuration.inMilliseconds ~/ pointCount);
    
    for (int i = 0; i <= pointCount; i++) {
      final progress = i / pointCount;
      final lat = startLat + (endLat - startLat) * progress;
      final lng = startLng + (endLng - startLng) * progress;
      final timestamp = startTime.add(Duration(milliseconds: (durationPerPoint.inMilliseconds * i).round()));
      
      // Варьируем скорость (остановки, разная скорость)
      double speed = averageSpeedKmh;
      if (i == 0 || i == pointCount) {
        speed = 0.0; // Остановки в начале и конце
      } else if (i % 3 == 0) {
        speed = averageSpeedKmh * 0.3; // Медленное движение
      } else if (i % 5 == 0) {
        speed = 0.0; // Остановки
      } else {
        speed = averageSpeedKmh + (i % 2 == 0 ? 5.0 : -3.0); // Вариация скорости
      }
      
      points.add(TrackPoint.fromGPS(
        latitude: lat,
        longitude: lng,
        timestamp: timestamp,
        accuracy: 3.0 + (i % 3), // Варьируем точность GPS
        speedMps: speed / 3.6, // Конвертируем км/ч в м/с
      ));
    }
    
    return points;
  }
}
