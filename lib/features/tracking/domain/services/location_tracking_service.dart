import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../entities/track_point.dart';
import '../entities/user_track.dart';

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
  
  /// Текущий активный трек
  UserTrack? _currentTrack;
  
  /// Подписка на обновления местоположения
  StreamSubscription<Position>? _positionSubscription;
  
  /// Контроллер для стрима новых точек трека
  final StreamController<TrackPoint> _trackPointController = 
      StreamController<TrackPoint>.broadcast();
  
  /// Контроллер для стрима обновлений трека
  final StreamController<UserTrack> _trackUpdateController = 
      StreamController<UserTrack>.broadcast();
  
  /// Буфер точек для batch сохранения
  final List<TrackPoint> _pointsBuffer = [];
  
  /// Последняя записанная точка
  TrackPoint? _lastRecordedPoint;
  
  /// Время последнего обновления
  DateTime? _lastUpdateTime;
  
  /// Счетчик неподвижности (для определения остановок)
  int _stationaryCount = 0;
  
  /// Флаг автоматической паузы при остановке
  final bool _autoPauseEnabled = true;
  
  /// Настройки трекинга
  LocationTrackingSettings _settings = const LocationTrackingSettings();

  /// Получает поток новых точек трека
  Stream<TrackPoint> get trackPointStream => _trackPointController.stream;
  
  /// Получает поток обновлений трека
  Stream<UserTrack> get trackUpdateStream => _trackUpdateController.stream;
  
  /// Получает текущий активный трек
  UserTrack? get currentTrack => _currentTrack;
  
  /// Проверяет, активен ли трекинг
  bool get isTracking => _currentTrack?.isActive == true;
  
  /// Проверяет, есть ли разрешения на геолокацию
  Future<bool> get hasLocationPermissions async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse;
  }

  /// Проверяет и запрашивает разрешения на геолокацию
  Future<bool> requestLocationPermissions() async {
    // Проверяем включена ли геолокация
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _log('Сервис геолокации отключен');
      return false;
    }

    // Проверяем текущие разрешения
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

  /// Начинает новый трек
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

    // Проверяем разрешения
    if (!await requestLocationPermissions()) {
      return false;
    }

    try {
      // Применяем настройки
      if (settings != null) {
        _settings = settings;
      }

      // Создаем новый трек
      _currentTrack = UserTrack.create(
        userId: userId,
        routeId: routeId,
        metadata: metadata,
      );

      // Сбрасываем состояние
      _lastRecordedPoint = null;
      _lastUpdateTime = null;
      _stationaryCount = 0;
      _pointsBuffer.clear();

      // Начинаем отслеживание местоположения
      await _startLocationTracking();

      _log('Трекинг начат для пользователя $userId');
      return true;
    } catch (e) {
      _log('Ошибка начала трекинга: $e');
      return false;
    }
  }

  /// Приостанавливает трекинг
  Future<void> pauseTracking() async {
    if (!isTracking) return;

    _currentTrack = _currentTrack!.pause();
    await _stopLocationTracking();
    await _flushPointsBuffer();

    _trackUpdateController.add(_currentTrack!);
    _log('Трекинг приостановлен');
  }

  /// Возобновляет трекинг
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

  /// Завершает трекинг
  Future<UserTrack?> stopTracking() async {
    if (_currentTrack == null) return null;

    // Сохраняем все оставшиеся точки
    await _flushPointsBuffer();

    // Завершаем трек
    final completedTrack = _currentTrack!.complete();
    _currentTrack = null;

    // Останавливаем отслеживание местоположения
    await _stopLocationTracking();

    _trackUpdateController.add(completedTrack);
    _log('Трекинг завершен. Расстояние: ${completedTrack.totalDistanceKm.toStringAsFixed(2)} км');

    return completedTrack;
  }

  /// Начинает отслеживание местоположения
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

  /// Останавливает отслеживание местоположения
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

  /// Обрабатывает новую точку трека
  void _processTrackPoint(TrackPoint point) {
    // Проверяем валидность точки
    if (!point.isValid) {
      _log('Невалидная GPS точка: $point');
      return;
    }

    // Фильтруем плохую точность
    if (point.accuracy != null && point.accuracy! > _settings.maxAccuracyMeters) {
      _log('Точка с плохой точностью пропущена: ${point.accuracy}м');
      return;
    }

    // Проверяем значимость точки
    if (_lastRecordedPoint != null) {
      if (!point.isSignificantlyDifferentFrom(
        _lastRecordedPoint!,
        minDistanceMeters: _settings.minDistanceMeters,
        minTimeSeconds: _settings.minTimeSeconds,
      )) {
        // Увеличиваем счетчик неподвижности
        _stationaryCount++;
        
        // Автоматическая пауза при длительной остановке
        if (_autoPauseEnabled && 
            _stationaryCount >= _settings.stationaryThreshold) {
          _log('Автоматическая пауза: длительная остановка');
          pauseTracking();
        }
        return;
      }
    }

    // Сбрасываем счетчик неподвижности
    _stationaryCount = 0;

    // Добавляем связь с предыдущей точкой
    final processedPoint = point.withPreviousPointData(_lastRecordedPoint);

    // Добавляем точку в буфер
    _pointsBuffer.add(processedPoint);
    _lastRecordedPoint = processedPoint;
    _lastUpdateTime = DateTime.now();

    // Отправляем уведомление о новой точке
    _trackPointController.add(processedPoint);

    // Обновляем трек
    _updateCurrentTrack();

    // Сохраняем буфер если он заполнен
    if (_pointsBuffer.length >= _settings.bufferSize) {
      _flushPointsBuffer();
    }

    _log('Записана точка: ${processedPoint.latitude.toStringAsFixed(6)}, '
         '${processedPoint.longitude.toStringAsFixed(6)}, '
         'скорость: ${processedPoint.speedKmh?.toStringAsFixed(1) ?? 'unknown'} км/ч');
  }

  /// Обновляет текущий трек с новыми точками
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
  /// Точность GPS
  final LocationAccuracy accuracy;
  
  /// Минимальное расстояние между точками в метрах
  final double minDistanceMeters;
  
  /// Минимальное время между точками в секундах
  final int minTimeSeconds;
  
  /// Максимальная допустимая точность GPS в метрах
  final double maxAccuracyMeters;
  
  /// Интервал обновления GPS
  final Duration updateInterval;
  
  /// Размер буфера точек перед сохранением
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
