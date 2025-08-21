import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';

import '../../domain/entities/user_track.dart';
import '../../domain/entities/track_point.dart';
import '../repositories/user_track_repository.dart';

/// Состояния GPS трекинга
enum GpsTrackingState {
  idle,        // не активен
  starting,    // запускается
  active,      // активен и получает данные
  paused,      // приостановлен
  disconnected // потеря сигнала GPS
}

/// Сервис для управления real-time GPS трекингом
class GpsTrackingService {
  final UserTrackRepository _repository;
  
  // Streams для real-time обновлений
  final _stateController = StreamController<GpsTrackingState>.broadcast();
  final _positionController = StreamController<LatLng>.broadcast();
  final _currentTrackController = StreamController<UserTrack?>.broadcast();
  
  // Текущее состояние
  GpsTrackingState _currentState = GpsTrackingState.idle;
  UserTrack? _currentTrack;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _connectionTimer;
  
  // Настройки
  static const Duration _connectionTimeout = Duration(minutes: 5);
  static const Duration _saveInterval = Duration(seconds: 30); // Сохраняем каждые 30 сек
  
  GpsTrackingService(this._repository);
  
  // Getters для streams
  Stream<GpsTrackingState> get stateStream => _stateController.stream;
  Stream<LatLng> get positionStream => _positionController.stream;
  Stream<UserTrack?> get currentTrackStream => _currentTrackController.stream;
  
  // Getters для текущего состояния
  GpsTrackingState get currentState => _currentState;
  UserTrack? get currentTrack => _currentTrack;
  bool get isActive => _currentState == GpsTrackingState.active;
  bool get hasConnectionIssues => _currentState == GpsTrackingState.disconnected;
  
  /// Запуск GPS трекинга
  Future<void> startTracking(User user) async {
    if (_currentState != GpsTrackingState.idle) {
      throw StateError('Трекинг уже активен или запускается');
    }
    
    try {
      _updateState(GpsTrackingState.starting);
      
      // Проверяем разрешения
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestedPermission = await Geolocator.requestPermission();
        if (requestedPermission == LocationPermission.denied) {
          throw Exception('GPS разрешения отклонены');
        }
      }
      
      // Создаем новый трек
      _currentTrack = UserTrack(
        id: 0, // будет установлен при сохранении
        user: user,
        startTime: DateTime.now(),
        status: TrackStatus.active,
        points: [],
        totalDistanceMeters: 0.0,
        movingTimeSeconds: 0,
        totalTimeSeconds: 0,
        averageSpeedKmh: 0.0,
        maxSpeedKmh: 0.0,
      );
      
      // Запускаем мониторинг позиции
      _startPositionMonitoring();
      
      _updateState(GpsTrackingState.active);
      _currentTrackController.add(_currentTrack);
      
    } catch (e) {
      _updateState(GpsTrackingState.idle);
      rethrow;
    }
  }
  
  /// Приостановка трекинга
  Future<void> pauseTracking() async {
    if (_currentState != GpsTrackingState.active) return;
    
    _updateState(GpsTrackingState.paused);
    await _pausePositionMonitoring();
    
    // Обновляем статус трека
    if (_currentTrack != null) {
      _currentTrack = _currentTrack!.copyWith(status: TrackStatus.paused);
      _currentTrackController.add(_currentTrack);
    }
  }
  
  /// Возобновление трекинга
  Future<void> resumeTracking() async {
    if (_currentState != GpsTrackingState.paused) return;
    
    _startPositionMonitoring();
    _updateState(GpsTrackingState.active);
    
    // Обновляем статус трека
    if (_currentTrack != null) {
      _currentTrack = _currentTrack!.copyWith(status: TrackStatus.active);
      _currentTrackController.add(_currentTrack);
    }
  }
  
  /// Завершение трекинга
  Future<UserTrack?> stopTracking() async {
    if (_currentState == GpsTrackingState.idle) return null;
    
    await _stopPositionMonitoring();
    
    // Сохраняем финальный трек
    if (_currentTrack != null && _currentTrack!.points.isNotEmpty) {
      final completedTrack = _currentTrack!.copyWith(
        status: TrackStatus.completed,
        endTime: DateTime.now(),
      );
      
      final savedTrack = await _repository.saveTrack(completedTrack);
      _currentTrack = null;
      _currentTrackController.add(null);
      _updateState(GpsTrackingState.idle);
      
      return savedTrack;
    }
    
    _currentTrack = null;
    _currentTrackController.add(null);
    _updateState(GpsTrackingState.idle);
    return null;
  }
  
  /// Запуск мониторинга позиции
  void _startPositionMonitoring() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // обновления каждые 5 метров
    );
    
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      _onPositionUpdate,
      onError: _onPositionError,
    );
    
    _startConnectionTimer();
  }
  
  /// Обработка обновления позиции
  void _onPositionUpdate(Position position) {
    if (_currentTrack == null) return;
    
    final latLng = LatLng(position.latitude, position.longitude);
    _positionController.add(latLng);
    
    // Добавляем точку к треку
    final trackPoint = TrackPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      accuracy: position.accuracy,
      altitude: position.altitude,
      speedKmh: position.speed * 3.6, // м/с в км/ч
    );
    
    // Обновляем трек
    final updatedPoints = List<TrackPoint>.from(_currentTrack!.points)..add(trackPoint);
    final totalDistanceMeters = _calculateTotalDistance(updatedPoints);
    final totalTimeSeconds = DateTime.now().difference(_currentTrack!.startTime).inSeconds;
    
    _currentTrack = _currentTrack!.copyWith(
      points: updatedPoints,
      totalDistanceMeters: totalDistanceMeters,
      totalTimeSeconds: totalTimeSeconds,
      movingTimeSeconds: totalTimeSeconds, // упрощенно, без учета остановок
      averageSpeedKmh: totalTimeSeconds > 0 ? (totalDistanceMeters / 1000) / (totalTimeSeconds / 3600) : 0.0,
    );
    
    _currentTrackController.add(_currentTrack);
    
    // Сбрасываем таймер соединения
    _resetConnectionTimer();
    
    if (_currentState == GpsTrackingState.disconnected) {
      _updateState(GpsTrackingState.active);
    }
  }
  
  /// Обработка ошибки GPS
  void _onPositionError(Object error) {
    print('GPS Error: $error');
    if (_currentState == GpsTrackingState.active) {
      _updateState(GpsTrackingState.disconnected);
    }
  }
  
  /// Приостановка мониторинга позиции
  Future<void> _pausePositionMonitoring() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _stopConnectionTimer();
  }
  
  /// Остановка мониторинга позиции
  Future<void> _stopPositionMonitoring() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _stopConnectionTimer();
  }
  
  /// Запуск таймера соединения
  void _startConnectionTimer() {
    _connectionTimer = Timer(_connectionTimeout, () {
      if (_currentState == GpsTrackingState.active) {
        _updateState(GpsTrackingState.disconnected);
      }
    });
  }
  
  /// Сброс таймера соединения
  void _resetConnectionTimer() {
    _connectionTimer?.cancel();
    _startConnectionTimer();
  }
  
  /// Остановка таймера соединения
  void _stopConnectionTimer() {
    _connectionTimer?.cancel();
    _connectionTimer = null;
  }
  
  /// Обновление состояния
  void _updateState(GpsTrackingState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }
  
  /// Вычисление общего расстояния трека
  double _calculateTotalDistance(List<TrackPoint> points) {
    if (points.length < 2) return 0.0;
    
    double totalDistance = 0.0;
    for (int i = 1; i < points.length; i++) {
      final distance = Geolocator.distanceBetween(
        points[i - 1].latitude,
        points[i - 1].longitude,
        points[i].latitude,
        points[i].longitude,
      );
      totalDistance += distance;
    }
    
    return totalDistance;
  }
  
  /// Очистка ресурсов
  void dispose() {
    _stopPositionMonitoring();
    _stateController.close();
    _positionController.close();
    _currentTrackController.close();
  }
}
