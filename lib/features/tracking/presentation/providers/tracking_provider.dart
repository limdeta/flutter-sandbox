import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';

import '../../domain/entities/user_track.dart';
import '../../data/services/gps_tracking_service.dart';
import '../../data/repositories/user_track_repository.dart';

/// Провайдер для управления состоянием GPS трекинга
class TrackingProvider extends ChangeNotifier {
  final UserTrackRepository _repository;
  final GpsTrackingService _trackingService;

  TrackingProvider(this._repository, this._trackingService) {
    // Подписываемся на изменения GPS сервиса
    _trackingService.stateStream.listen((_) => notifyListeners());
    _trackingService.positionStream.listen((_) => notifyListeners());
    _trackingService.currentTrackStream.listen((_) => notifyListeners());
  }

  // Getters для текущего состояния
  List<UserTrack> _historicalTracks = [];
  bool _isLoading = false;
  String? _error;

  List<UserTrack> get historicalTracks => _historicalTracks;
  UserTrack? get currentTrack => _trackingService.currentTrack;
  LatLng? get currentPosition => _currentPosition;
  GpsTrackingState get trackingState => _trackingService.currentState;
  bool get isActive => _trackingService.isActive;
  bool get hasConnectionIssues => _trackingService.hasConnectionIssues;
  bool get isLoading => _isLoading;
  String? get error => _error;

  LatLng? _currentPosition;

  /// Загрузка исторических треков
  Future<void> loadHistoricalTracks(int userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _historicalTracks = await _repository.getTracksByUserId(userId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка загрузки треков: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Запуск трекинга
  Future<void> startTracking(User user) async {
    try {
      _error = null;
      await _trackingService.startTracking(user);
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка запуска трекинга: $e';
      notifyListeners();
    }
  }

  /// Приостановка трекинга
  Future<void> pauseTracking() async {
    try {
      _error = null;
      await _trackingService.pauseTracking();
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка приостановки трекинга: $e';
      notifyListeners();
    }
  }

  /// Возобновление трекинга
  Future<void> resumeTracking() async {
    try {
      _error = null;
      await _trackingService.resumeTracking();
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка возобновления трекинга: $e';
      notifyListeners();
    }
  }

  /// Остановка трекинга
  Future<void> stopTracking() async {
    try {
      _error = null;
      final completedTrack = await _trackingService.stopTracking();
      
      if (completedTrack != null) {
        _historicalTracks = [..._historicalTracks, completedTrack];
      }
      
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка остановки трекинга: $e';
      notifyListeners();
    }
  }

  /// Очистка ошибки
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _trackingService.dispose();
    super.dispose();
  }
}
