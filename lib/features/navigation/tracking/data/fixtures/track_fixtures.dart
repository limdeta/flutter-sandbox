import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get_it/get_it.dart';
import 'package:tauzero/features/navigation/tracking/domain/entities/navigation_user.dart';
import '../../../../shop/route/domain/entities/route.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/entities/compact_track_builder.dart';
import '../../domain/enums/track_status.dart';
import '../../domain/repositories/user_track_repository.dart';

/// Фикстуры для создания тестовых GPS треков (ОПТИМИЗИРОВАНО)
/// 
/// Использует реальные GPS данные из current_day_track.json (OSRM маршрут)
/// для создания активного трека текущего дня, связанного с конкретным маршрутом
class TrackFixtures {
  static final UserTrackRepository _repository = GetIt.instance<UserTrackRepository>();
  
  // Кэш для GPS данных
  static Map<String, dynamic>? _cachedOsrmData;
  static String? _cachedDataKey;

  /// Создает активный трек для текущего дня из реального OSRM маршрута (ОПТИМИЗИРОВАНО)
  /// Связывает трек с конкретным маршрутом для полной интеграции данных
  static Future<UserTrack?> createCurrentDayTrack({
    required NavigationUser user,
    required Route route,
  }) async {
    try {
      // Кэширование GPS данных для избежания повторной загрузки
      const dataKey = 'current_day_track';
      Map<String, dynamic> osrmResponse;
      
      if (_cachedOsrmData != null && _cachedDataKey == dataKey) {
        osrmResponse = _cachedOsrmData!;
      } else {
        final jsonString = await rootBundle.loadString('assets/data/tracks/current_day_track.json');
        osrmResponse = jsonDecode(jsonString) as Map<String, dynamic>;
        
        _cachedOsrmData = osrmResponse;
        _cachedDataKey = dataKey;
      }

      final now = DateTime.now();
      final startTime = DateTime(now.year, now.month, now.day, 9, 0);

      // Обрабатываем данные асинхронно для лучшей производительности
      final compactTrack = CompactTrackFactory.fromOSRMResponse(
        osrmResponse,
        startTime: startTime,
        baseSpeed: 45.0, // Базовая скорость движения
        baseAccuracy: 4.0, // GPS точность
      );

      if (compactTrack.isEmpty) {
        print('❌ TrackFixtures: CompactTrack пустой после создания');
        return null;
      }

      final userTrack = UserTrack.fromSingleTrack(
        id: 0,
        user: user,
        track: compactTrack,
        status: TrackStatus.active,
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
      print('🚀 TrackFixtures: Попытка сохранить трек для пользователя ${user.id} (${user.fullName})');
      print('🚀 TrackFixtures: Трек содержит ${compactTrack.pointCount} точек');
      
      final result = await _repository.saveUserTrack(userTrack);
      
      return result.fold(
        (failure) {
          print('❌ TrackFixtures: Ошибка сохранения трека: ${failure.message}');
          return null;
        },
        (savedTrack) {
          print('✅ TrackFixtures: Трек успешно сохранен с ID: ${savedTrack.id}');
          return savedTrack;
        },
      );

    } catch (e) {
      print('❌ TrackFixtures: Исключение при создании трека: $e');
      return null;
    }
  }

  /// Создает тестовые треки для пользователя
  /// Привязывает активный трек к сегодняшнему маршруту пользователя
  static Future<UserTrack?> createTestTracksForUser({
    required NavigationUser user,
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