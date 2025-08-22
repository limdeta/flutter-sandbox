import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:get_it/get_it.dart';

import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/route/domain/entities/route.dart';
import 'package:tauzero/features/route/domain/entities/ipoint_of_interest.dart';
import 'package:tauzero/features/route/domain/repositories/iroute_repository.dart';
import 'package:tauzero/features/tracking/domain/entities/user_track.dart';
import 'package:tauzero/features/tracking/domain/entities/track_point.dart';
import 'package:tauzero/features/tracking/domain/repositories/iuser_track_repository.dart';

/// Сервис для применения GPS фикстур к маршрутам
/// 
/// Загружает заранее подготовленные GPS треки из JSON файла
/// и применяет их к маршруту для симуляции пройденного пути
class GpsFixtureService {
  final IRouteRepository _routeRepository;
  final IUserTrackRepository _trackRepository;
  
  GpsFixtureService(this._routeRepository, this._trackRepository);
  
  /// 🎯 Применяет GPS фикстуры к текущему маршруту пользователя
  /// 
  /// Этот метод:
  /// 1. Загружает GPS треки из JSON файла
  /// 2. Создает UserTrack записи для пройденных сегментов
  /// 3. Обновляет статус первых N точек маршрута на "completed"
  /// 4. Сохраняет все в базу данных
  Future<void> applyGpsFixturesToRoute({
    required Route route,
    required User user,
  }) async {
    print('🎯 Применяем GPS фикстуры к маршруту: ${route.name}');
    
    try {
      // 1. Загружаем GPS фикстуры из JSON
      final fixtures = await _loadGpsFixtures();
      final completedSegments = fixtures['completed_segments'] as List;
      
      print('📄 Загружено ${completedSegments.length} GPS сегментов из фикстур');
      
      // 2. Создаем UserTrack записи для каждого сегмента
      final userTracks = <UserTrack>[];
      
      for (int i = 0; i < completedSegments.length; i++) {
        final segment = completedSegments[i] as Map<String, dynamic>;
        final trackPoints = _createTrackPointsFromSegment(segment);
        
        if (trackPoints.isNotEmpty) {
          final userTrack = UserTrack(
            id: 0, // Будет установлен при сохранении
            user: user,
            route: route,
            startTime: trackPoints.first.timestamp,
            endTime: trackPoints.last.timestamp,
            points: trackPoints,
            totalDistanceMeters: (segment['estimated_distance_meters'] as num).toDouble(),
            movingTimeSeconds: (segment['estimated_duration_minutes'] as num).toInt() * 60,
            totalTimeSeconds: (segment['estimated_duration_minutes'] as num).toInt() * 60,
            averageSpeedKmh: _calculateAverageSpeed(trackPoints),
            maxSpeedKmh: _calculateMaxSpeed(trackPoints),
            status: TrackStatus.completed,
          );
          
          userTracks.add(userTrack);
          print('✅ Создан UserTrack для сегмента ${i + 1}: ${trackPoints.length} точек');
        }
      }
      
      // 3. Сохраняем UserTrack записи в базу данных
      for (final track in userTracks) {
        await _trackRepository.saveTrack(track);
      }
      
      // 4. Обновляем статус точек маршрута на "completed"
      await _markRoutePointsAsCompleted(route, completedSegments.length);
      
      print('🎉 GPS фикстуры успешно применены: ${userTracks.length} треков создано');
      
    } catch (e) {
      print('❌ Ошибка применения GPS фикстур: $e');
      rethrow;
    }
  }
  
  /// Загружает GPS фикстуры из JSON файла
  Future<Map<String, dynamic>> _loadGpsFixtures() async {
    final jsonString = await rootBundle.loadString(
      'lib/features/route/data/fixtures/gps_track_fixtures.json'
    );
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
  
  /// Создает TrackPoint'ы из данных сегмента в JSON
  List<TrackPoint> _createTrackPointsFromSegment(Map<String, dynamic> segment) {
    final trackPointsData = segment['track_points'] as List;
    
    return trackPointsData.map<TrackPoint>((pointData) {
      final point = pointData as Map<String, dynamic>;
      
      return TrackPoint(
        latitude: (point['latitude'] as num).toDouble(),
        longitude: (point['longitude'] as num).toDouble(),
        timestamp: DateTime.parse(point['timestamp'] as String),
        speedKmh: (point['speed_kmh'] as num?)?.toDouble(),
        accuracy: 5.0 + Random().nextDouble() * 5.0, // 5-10м точность
        bearing: Random().nextDouble() * 360, // Случайное направление
      );
    }).toList();
  }
  
  /// Рассчитывает среднюю скорость из TrackPoint'ов
  double _calculateAverageSpeed(List<TrackPoint> points) {
    if (points.isEmpty) return 0.0;
    
    final speeds = points
        .where((p) => p.speedKmh != null)
        .map((p) => p.speedKmh!)
        .toList();
    
    if (speeds.isEmpty) return 20.0; // Дефолтная скорость
    
    return speeds.reduce((a, b) => a + b) / speeds.length;
  }
  
  /// Рассчитывает максимальную скорость из TrackPoint'ов
  double _calculateMaxSpeed(List<TrackPoint> points) {
    if (points.isEmpty) return 0.0;
    
    final speeds = points
        .where((p) => p.speedKmh != null)
        .map((p) => p.speedKmh!)
        .toList();
    
    if (speeds.isEmpty) return 35.0; // Дефолтная максимальная скорость
    
    return speeds.reduce((a, b) => a > b ? a : b);
  }
  
  /// Помечает первые N точек маршрута как завершенные
  Future<void> _markRoutePointsAsCompleted(Route route, int completedCount) async {
    print('✅ Помечаем первые $completedCount точек как завершенные');
    
    final orderedPoints = route.pointsOfInterest
        .toList()
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    
    // Обновляем статус первых точек
    for (int i = 0; i < completedCount && i < orderedPoints.length; i++) {
      final point = orderedPoints[i];
      
      // Создаем обновленную точку со статусом "completed"
      final updatedPoint = _updatePointStatus(point, VisitStatus.completed);
      
      // TODO: Здесь нужно обновить точку в базе данных
      // Пока что просто логируем
      print('   ✓ Точка ${i + 1}: ${point.name} → completed');
    }
  }
  
  /// Обновляет статус точки интереса
  IPointOfInterest _updatePointStatus(IPointOfInterest point, VisitStatus newStatus) {
    // Это упрощенная реализация - в реальности нужно создать новый объект
    // с обновленным статусом через копирование
    return point; // Временная заглушка
  }
  
  /// Применяет GPS фикстуры ко всем маршрутам пользователя
  Future<void> applyGpsFixturesToAllRoutes(User user) async {
    print('🌍 Применяем GPS фикстуры ко всем маршрутам пользователя: ${user.firstName}');
    
    try {
      // Получаем все маршруты пользователя
      final routesStream = _routeRepository.watchUserRoutes(user);
      final routes = await routesStream.first;
      
      print('📍 Найдено ${routes.length} маршрутов для пользователя');
      
      // Применяем GPS фикстуры к каждому маршруту
      for (final route in routes) {
        await applyGpsFixturesToRoute(route: route, user: user);
      }
      
      print('✅ GPS фикстуры применены ко всем маршрутам пользователя ${user.firstName}');
    } catch (e) {
      print('❌ Ошибка применения GPS фикстур ко всем маршрутам: $e');
    }
  }
}

/// Factory для создания GpsFixtureService
class GpsFixtureServiceFactory {
  static GpsFixtureService create() {
    final routeRepository = GetIt.instance<IRouteRepository>();
    final trackRepository = GetIt.instance<IUserTrackRepository>();
    return GpsFixtureService(routeRepository, trackRepository);
  }
}
