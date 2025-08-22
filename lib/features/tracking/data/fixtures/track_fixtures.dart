import 'dart:convert';
import 'dart:io';
import 'package:get_it/get_it.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../route/domain/entities/route.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/entities/compact_track_builder.dart';
import '../../domain/enums/track_status.dart';
import '../../domain/repositories/iuser_track_repository.dart';

/// Фикстуры для создания тестовых GPS треков
/// 
/// Использует реальные GPS данные из current_day_track.json (OSRM маршрут)
/// для создания активного трека текущего дня, связанного с конкретным маршрутом
class TrackFixtures {
  static final IUserTrackRepository _repository = GetIt.instance<IUserTrackRepository>();

  /// Создает активный трек для текущего дня из реального OSRM маршрута
  /// Связывает трек с конкретным маршрутом для полной интеграции данных
  static Future<UserTrack?> createCurrentDayTrack({
    required User user,
    required Route route,
  }) async {
    try {
      // Загружаем реальные GPS данные из JSON файла
      final jsonFile = File('lib/features/tracking/data/fixtures/current_day_track.json');
      if (!await jsonFile.exists()) {
        return null;
      }

      final jsonString = await jsonFile.readAsString();
      final osrmResponse = jsonDecode(jsonString) as Map<String, dynamic>;

      final now = DateTime.now();
      final startTime = DateTime(now.year, now.month, now.day, 9, 0);

      // Используем готовый метод fromOSRMResponse из CompactTrackFactory
      final compactTrack = CompactTrackFactory.fromOSRMResponse(
        osrmResponse,
        startTime: startTime,
        baseSpeed: 45.0, // Базовая скорость движения
        baseAccuracy: 4.0, // GPS точность
      );

      if (compactTrack.isEmpty) {
        return null;
      }

      // Создаем UserTrack с реальными GPS данными, привязанный к маршруту
      final userTrack = UserTrack.fromSingleTrack(
        id: 0, // Будет присвоен при сохранении
        user: user,
        route: route, // Связываем с конкретным маршрутом
        track: compactTrack,
        status: TrackStatus.active, // Активный трек
        metadata: {
          'type': 'current_day_real_gps',
          'created_at': startTime.toIso8601String(),
          'route_id': route.id?.toString() ?? 'unknown',
          'route_name': route.name,
          'data_source': 'osrm_real_route',
          'total_coordinates': compactTrack.pointCount.toString(),
          'distance_km': (compactTrack.getTotalDistance() / 1000).toStringAsFixed(2),
          'duration_minutes': compactTrack.getDuration().inMinutes.toString(),
          'current_status': 'active_tracking',
          'route_points_total': route.pointsOfInterest.length.toString(),
          'route_points_completed': route.pointsOfInterest.where((p) => p.status.name == 'completed').length.toString(),
          'estimated_completion': DateTime(now.year, now.month, now.day, 17, 30).toIso8601String(),
        },
      );

      // Сохраняем в базу данных
      final result = await _repository.saveUserTrack(userTrack);
      
      return result.fold(
        (failure) => null,
        (savedTrack) => savedTrack,
      );

    } catch (e) {
      return null;
    }
  }

  /// Создает тестовые треки для пользователя
  /// Привязывает активный трек к сегодняшнему маршруту пользователя
  static Future<UserTrack?> createTestTracksForUser({
    required User user,
    required List<Route> routes,
  }) async {
    if (routes.isEmpty) return null;

    // Ищем активный маршрут (сегодняшний)
    final todayRoute = routes.firstWhere(
      (route) => route.status.name == 'active',
      orElse: () => routes.first,
    );

    // Создаем активный трек для сегодняшнего маршрута с реальными GPS данными
    return await createCurrentDayTrack(
      user: user,
      route: todayRoute,
    );
  }
}
