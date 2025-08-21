import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../entities/track_point.dart';
import '../entities/user_track.dart';
import '../../../authentication/domain/repositories/iuser_repository.dart';
import '../../../route/domain/repositories/iroute_repository.dart';
import '../../../route/domain/entities/route.dart';

/// Сервис для энергоэффективного трекинга местоположения пользователя
/// 
/// Особенности:
/// - Адаптивная частота обновлений GPS
/// - Фильтрация GPS шума и дубликатов
/// - Автоматическая приостановка при остановке
/// - Оптимизация энергопотребления
/// - Буферизация точек для batch сохранения
class LocationTrackingService {
  static const String _tag = 'LocationTracking';
  
  final IUserRepository _userRepository;
  final IRouteRepository _routeRepository;
  
  UserTrack? _currentTrack;
  
  StreamSubscription<Position>? _positionSubscription;
  
  final StreamController<TrackPoint> _trackPointController = 
      StreamController<TrackPoint>.broadcast();
  
  final StreamController<UserTrack> _trackUpdateController = 
      StreamController<UserTrack>.broadcast();
  
  final List<TrackPoint> _pointsBuffer = [];
  
  TrackPoint? _lastRecordedPoint;
  
  DateTime? _lastUpdateTime;
  
  int _stationaryCount = 0;
  
  final bool _autoPauseEnabled = true;
  
  LocationTrackingSettings _settings = const LocationTrackingSettings();

  LocationTrackingService(this._userRepository, this._routeRepository);

  Stream<TrackPoint> get trackPointStream => _trackPointController.stream;
  
  Stream<UserTrack> get trackUpdateStream => _trackUpdateController.stream;
  
  UserTrack? get currentTrack => _currentTrack;
  
  bool get isTracking => _currentTrack?.isActive == true;
  
  Future<bool> get hasLocationPermissions async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse;
  }

  Future<bool> requestLocationPermissions() async {
    // Проверяем включена ли геолокация
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _log('Сервис геолокации отключен');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _log('Разрешение на геолокацию отклонено');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _log('Разрешение на геолокацию отклонено навсегда');
      return false;
    }

    // Для Android: запрашиваем разрешение на фоновое отслеживание
    if (Platform.isAndroid && permission == LocationPermission.whileInUse) {
      _log('Разрешение только при использовании приложения. Рекомендуется "Всегда"');
    }

    _log('Разрешения на геолокацию получены: $permission');
    return true;
  }

  Future<bool> startTracking({
    required int userId,
    int? routeId,
    LocationTrackingSettings? settings,
    Map<String, dynamic>? metadata,
  }) async {
    if (isTracking) {
      _log('Трекинг уже активен');
      return false;
    }

    if (!await requestLocationPermissions()) {
      return false;
    }

    try {
      if (settings != null) {
        _settings = settings;
      }

      // Загружаем объект User по ID
      final userResult = await _userRepository.getUserByInternalId(userId);
      final user = userResult.fold(
        (failure) => throw Exception('User not found for ID $userId: $failure'),
        (user) => user,
      );

      // Загружаем объект Route, если указан
      Route? route;
      if (routeId != null) {
        final routeResult = await _routeRepository.getRouteByInternalId(routeId);
        route = routeResult.fold(
          (failure) => null, // Если маршрут не найден, продолжаем без него
          (route) => route,
        );
      }

      _currentTrack = UserTrack.create(
        user: user,
        route: route,
        metadata: metadata,
      );

      _lastRecordedPoint = null;
      _lastUpdateTime = null;
      _stationaryCount = 0;
      _pointsBuffer.clear();

      await _startLocationTracking();

      _log('Трекинг начат для пользователя $userId');
      return true;
    } catch (e) {
      _log('Ошибка начала трекинга: $e');
      return false;
    }
  }

  Future<void> pauseTracking() async {
    if (!isTracking) return;

    _currentTrack = _currentTrack!.pause();
    await _stopLocationTracking();
    await _flushPointsBuffer();

    _trackUpdateController.add(_currentTrack!);
    _log('Трекинг приостановлен');
  }

  Future<bool> resumeTracking() async {
    if (_currentTrack == null || !_currentTrack!.isPaused) return false;

    if (!await requestLocationPermissions()) {
      return false;
    }

    _currentTrack = _currentTrack!.resume();
    await _startLocationTracking();

    _trackUpdateController.add(_currentTrack!);
    _log('Трекинг возобновлен');
    return true;
  }

  Future<UserTrack?> stopTracking() async {
    if (_currentTrack == null) return null;

    await _flushPointsBuffer();

    final completedTrack = _currentTrack!.complete();
    _currentTrack = null;

    await _stopLocationTracking();

    _trackUpdateController.add(completedTrack);
    _log('Трекинг завершен. Расстояние: ${completedTrack.totalDistanceKm.toStringAsFixed(2)} км');

    return completedTrack;
  }

  Future<void> _startLocationTracking() async {
    final locationSettings = _getLocationSettings();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      _onPositionUpdate,
      onError: (error) {
        _log('Ошибка геолокации: $error');
      },
    );
  }

  Future<void> _stopLocationTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Обрабатывает обновление позиции
  void _onPositionUpdate(Position position) {
    if (!isTracking) return;

    final now = DateTime.now();
    final point = TrackPoint.fromGPS(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: now,
      accuracy: position.accuracy,
      altitude: position.altitude,
      altitudeAccuracy: position.altitudeAccuracy,
      speedMps: position.speed,
      bearing: position.heading,
      metadata: {
        'provider': 'gps',
        'isMocked': position.isMocked,
      },
    );

    _processTrackPoint(point);
  }

  void _processTrackPoint(TrackPoint point) {
    if (!point.isValid) {
      _log('Невалидная GPS точка: $point');
      return;
    }

    if (point.accuracy != null && point.accuracy! > _settings.maxAccuracyMeters) {
      _log('Точка с плохой точностью пропущена: ${point.accuracy}м');
      return;
    }

    if (_lastRecordedPoint != null) {
      if (!point.isSignificantlyDifferentFrom(
        _lastRecordedPoint!,
        minDistanceMeters: _settings.minDistanceMeters,
        minTimeSeconds: _settings.minTimeSeconds,
      )) {
        _stationaryCount++;
        
        if (_autoPauseEnabled && 
            _stationaryCount >= _settings.stationaryThreshold) {
          _log('Автоматическая пауза: длительная остановка');
          pauseTracking();
        }
        return;
      }
    }

    _stationaryCount = 0;

    final processedPoint = point.withPreviousPointData(_lastRecordedPoint);

    _pointsBuffer.add(processedPoint);
    _lastRecordedPoint = processedPoint;
    _lastUpdateTime = DateTime.now();

    _trackPointController.add(processedPoint);

    _updateCurrentTrack();

    if (_pointsBuffer.length >= _settings.bufferSize) {
      _flushPointsBuffer();
    }

    _log('Записана точка: ${processedPoint.latitude.toStringAsFixed(6)}, '
         '${processedPoint.longitude.toStringAsFixed(6)}, '
         'скорость: ${processedPoint.speedKmh?.toStringAsFixed(1) ?? 'unknown'} км/ч');
  }

  void _updateCurrentTrack() {
    if (_currentTrack == null || _pointsBuffer.isEmpty) return;

    _currentTrack = _currentTrack!.addPoints(_pointsBuffer);
    _trackUpdateController.add(_currentTrack!);
  }

  /// Сохраняет буфер точек (здесь должна быть интеграция с БД)
  Future<void> _flushPointsBuffer() async {
    if (_pointsBuffer.isEmpty) return;

    try {
      // TODO: Интеграция с репозиторием для сохранения точек в БД
      _log('Сохранение ${_pointsBuffer.length} точек в БД');
      
      _pointsBuffer.clear();
    } catch (e) {
      _log('Ошибка сохранения точек: $e');
    }
  }

  /// Получает настройки местоположения для платформы
  LocationSettings _getLocationSettings() {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: _settings.accuracy,
        distanceFilter: _settings.minDistanceMeters.toInt(),
        intervalDuration: _settings.updateInterval,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: 'Запись маршрута в фоновом режиме',
          notificationTitle: 'TauZero трекинг',
          enableWakeLock: true,
        ),
      );
    } else if (Platform.isIOS) {
      return AppleSettings(
        accuracy: _settings.accuracy,
        distanceFilter: _settings.minDistanceMeters.toInt(),
        activityType: ActivityType.automotiveNavigation,
        pauseLocationUpdatesAutomatically: _autoPauseEnabled,
        showBackgroundLocationIndicator: true,
      );
    } else {
      return LocationSettings(
        accuracy: _settings.accuracy,
        distanceFilter: _settings.minDistanceMeters.toInt(),
      );
    }
  }

  /// Логирование
  void _log(String message) {
    if (kDebugMode) {
      print('$_tag: $message');
    }
  }

  /// Освобождает ресурсы
  Future<void> dispose() async {
    await stopTracking();
    await _trackPointController.close();
    await _trackUpdateController.close();
  }
}

/// Настройки трекинга местоположения
class LocationTrackingSettings {
  final LocationAccuracy accuracy;
  
  final double minDistanceMeters;
  final int minTimeSeconds;
  final double maxAccuracyMeters;
  final Duration updateInterval;
  final int bufferSize;
  
  /// Порог неподвижности для автопаузы (количество подряд отфильтрованных точек)
  final int stationaryThreshold;

  const LocationTrackingSettings({
    this.accuracy = LocationAccuracy.high,
    this.minDistanceMeters = 5.0,
    this.minTimeSeconds = 10,
    this.maxAccuracyMeters = 50.0,
    this.updateInterval = const Duration(seconds: 15),
    this.bufferSize = 10,
    this.stationaryThreshold = 6, // ~1.5 минуты при 15сек интервале
  });

  /// Настройки для высокой точности (больше расход батареи)
  factory LocationTrackingSettings.highAccuracy() {
    return const LocationTrackingSettings(
      accuracy: LocationAccuracy.best,
      minDistanceMeters: 3.0,
      minTimeSeconds: 5,
      maxAccuracyMeters: 20.0,
      updateInterval: Duration(seconds: 10),
      bufferSize: 15,
    );
  }

  /// Настройки для экономии батареи
  factory LocationTrackingSettings.batteryOptimized() {
    return const LocationTrackingSettings(
      accuracy: LocationAccuracy.medium,
      minDistanceMeters: 10.0,
      minTimeSeconds: 30,
      maxAccuracyMeters: 100.0,
      updateInterval: Duration(seconds: 60),
      bufferSize: 5,
    );
  }
}
