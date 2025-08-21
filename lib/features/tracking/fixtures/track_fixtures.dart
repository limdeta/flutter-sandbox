import 'dart:math' as math;
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import '../domain/repositories/iuser_track_repository.dart';
import '../domain/entities/user_track.dart';
import '../domain/entities/track_point.dart';
import '../../route/domain/entities/route.dart' as domain;
import '../../authentication/domain/entities/user.dart';
import '../../authentication/domain/repositories/iuser_repository.dart';

/// Фикстуры для создания тестовых GPS треков
class TrackFixtures {
  static Future<void> createTestTracksForUser({
    required User user,
    required List<domain.Route> routes,
  }) async {
    final trackRepository = GetIt.instance<IUserTrackRepository>();
    final userRepository = GetIt.instance<IUserRepository>();
    
    try {
      // Получаем внутренний ID пользователя из базы данных
      final usersResult = await userRepository.getAllUsers();
      if (usersResult.isLeft()) {
        print('❌ Не удалось получить пользователей из БД: ${usersResult.fold((l) => l, (r) => '')}');
        return;
      }
      
      final allUsers = usersResult.fold((l) => <User>[], (r) => r);
      final dbUser = allUsers.where((u) => u.externalId == user.externalId).firstOrNull;
      
      if (dbUser == null) {
        print('❌ Пользователь ${user.firstName} не найден в БД');
        return;
      }
      
      // Получаем внутренний userId (предполагаем что это порядковый номер в списке + 1)
      final userId = allUsers.indexOf(dbUser) + 1;
      
      // Находим маршруты по названиям
      final yesterdayRoute = routes.where((r) => r.name.contains('30 июля')).firstOrNull;
      final todayRoute = routes.where((r) => r.name.contains('31 июля')).firstOrNull;
      
      // Создаем треки
      if (yesterdayRoute?.id != null) {
        await _createCompletedTrack(trackRepository, user, yesterdayRoute!);
      }
      
      if (todayRoute?.id != null) {
        await _createActiveTrack(trackRepository, user, todayRoute!);
      }
      
      print('🎯 Тестовые GPS треки для ${user.firstName} созданы (userId: $userId)');
      
    } catch (e) {
      print('❌ Ошибка при создании тестовых треков для ${user.firstName}: $e');
    }
  }
  
  /// Создает завершенный трек для вчерашнего маршрута
  static Future<void> _createCompletedTrack(
    IUserTrackRepository repo, 
    User user, 
    domain.Route route,
  ) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    
    final track = UserTrack(
      id: 0, // Будет назначен автоматически
      user: user,
      route: route,
      startTime: yesterday.copyWith(hour: 9, minute: 0),
      endTime: yesterday.copyWith(hour: 17, minute: 30),
      totalDistanceMeters: 15240.0,
      movingTimeSeconds: 7200, // 2 часа движения
      totalTimeSeconds: 30600, // 8.5 часов общего времени
      averageSpeedKmh: 25.4,
      maxSpeedKmh: 55.0,
      status: TrackStatus.completed,
      points: _generateTrackPointsFromRoute(route, yesterday, isCompleted: true),
    );
    
    await repo.saveTrack(track);
    print('📍 Создан завершенный трек (${track.points.length} точек) для маршрута ${route.id}');
  }
  
  /// Создает активный трек для сегодняшнего маршрута
  static Future<void> _createActiveTrack(
    IUserTrackRepository repo, 
    User user, 
    domain.Route route,
  ) async {
    final today = DateTime.now();
    
    final track = UserTrack(
      id: 0,
      user: user,
      route: route,
      startTime: today.copyWith(hour: 8, minute: 30),
      endTime: null, // Активный трек
      totalDistanceMeters: 5680.0,
      movingTimeSeconds: 2400, // 40 минут движения
      totalTimeSeconds: 7200, // 2 часа общего времени
      averageSpeedKmh: 28.4,
      maxSpeedKmh: 60.0,
      status: TrackStatus.active,
      points: _generateTrackPointsFromRoute(route, today, isCompleted: false),
    );
    
    await repo.saveTrack(track);
    print('📍 Создан активный трек (${track.points.length} точек) для маршрута ${route.id}');
  }
  
  /// Генерирует GPS трек на основе точек маршрута
  static List<TrackPoint> _generateTrackPointsFromRoute(
    domain.Route route, 
    DateTime baseDate, 
    {required bool isCompleted}
  ) {
    final points = <TrackPoint>[];
    final routePoints = route.pointsOfInterest;
    
    if (routePoints.isEmpty) {
      return points;
    }
    
    // Определяем сколько точек обрабатывать (все для завершенного, часть для активного)
    final pointsToProcess = isCompleted ? routePoints.length : (routePoints.length * 0.6).round();
    
    for (int i = 0; i < pointsToProcess; i++) {
      final poi = routePoints[i];
      
      // Время прибытия к точке (с интервалом 30-60 минут)
      final arrivalTime = baseDate.copyWith(
        hour: 9 + (i * 1), // каждый час новая точка
        minute: 15 + (i * 5), // небольшие вариации
      );
      
      // Добавляем основную точку POI
      points.add(TrackPoint(
        latitude: poi.coordinates.latitude,
        longitude: poi.coordinates.longitude,
        altitude: 50.0 + (i * 3), // имитируем изменение высоты
        accuracy: 2.0 + (i % 3), // точность GPS 2-5 метров
        speedKmh: i == 0 ? 0.0 : 30.0 + (i * 2), // скорость движения
        bearing: i * 45.0, // направление движения
        timestamp: arrivalTime,
      ));
      
      // Добавляем промежуточные точки между POI для реалистичности
      if (i < pointsToProcess - 1) {
        final nextPoi = routePoints[i + 1];
        final intermediatePoints = _generateIntermediatePoints(
          poi.coordinates, 
          nextPoi.coordinates, 
          arrivalTime.add(const Duration(minutes: 10)), // отъезд через 10 минут
          3, // 3 промежуточные точки
        );
        points.addAll(intermediatePoints);
      }
    }
    
    return points;
  }
  
  /// Генерирует промежуточные точки между двумя POI
  static List<TrackPoint> _generateIntermediatePoints(
    LatLng start,
    LatLng end,
    DateTime departureTime,
    int numberOfPoints,
  ) {
    final points = <TrackPoint>[];
    
    for (int i = 1; i <= numberOfPoints; i++) {
      final progress = i / (numberOfPoints + 1);
      
      // Интерполируем координаты между начальной и конечной точкой
      final lat = start.latitude + (end.latitude - start.latitude) * progress;
      final lng = start.longitude + (end.longitude - start.longitude) * progress;
      
      // Добавляем небольшое случайное отклонение для реалистичности
      final latOffset = (math.Random().nextDouble() - 0.5) * 0.0005; // ~50 метров
      final lngOffset = (math.Random().nextDouble() - 0.5) * 0.0005;
      
      points.add(TrackPoint(
        latitude: lat + latOffset,
        longitude: lng + lngOffset,
        altitude: 45.0 + (i * 2),
        accuracy: 3.0,
        speedKmh: 25.0 + (i * 5), // варьируем скорость
        bearing: _calculateBearing(start, end),
        timestamp: departureTime.add(Duration(minutes: i * 5)), // каждые 5 минут
      ));
    }
    
    return points;
  }
  
  /// Вычисляет направление (bearing) между двумя точками
  static double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * math.pi / 180;
    final lat2 = end.latitude * math.pi / 180;
    final deltaLng = (end.longitude - start.longitude) * math.pi / 180;
    
    final y = math.sin(deltaLng) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(deltaLng);
    
    final bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360; // нормализуем к 0-360
  }
}
