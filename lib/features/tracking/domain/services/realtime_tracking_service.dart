import 'dart:async';
import '../entities/user_track.dart';
import '../entities/track_point.dart';
import '../repositories/iuser_track_repository.dart';

/// Сервис для управления real-time GPS трекингом
class RealtimeTrackingService {
  final IUserTrackRepository _trackRepository;
  
  /// Таймер для периодической проверки обновлений
  Timer? _trackUpdateTimer;
  
  /// Таймер для определения потери связи
  Timer? _connectionTimeoutTimer;
  
  final StreamController<UserTrack> _trackUpdateController = StreamController<UserTrack>.broadcast();
  final StreamController<ConnectionEvent> _connectionController = StreamController<ConnectionEvent>.broadcast();
  final StreamController<TrackPointEvent> _trackPointController = StreamController<TrackPointEvent>.broadcast();
  
  UserTrack? _currentActiveTrack;
  DateTime? _lastUpdateTime;

  final int updateIntervalSeconds;
  final int connectionTimeoutSeconds;
  final int maxTrackPoints;

  RealtimeTrackingService(
    this._trackRepository, {
    this.updateIntervalSeconds = 5,
    this.connectionTimeoutSeconds = 300, // 5 минут
    this.maxTrackPoints = 10000,
  });

  /// Стрим обновлений треков
  Stream<UserTrack> get trackUpdateStream => _trackUpdateController.stream;
  
  /// Стрим событий соединения
  Stream<ConnectionEvent> get connectionStream => _connectionController.stream;
  
  Stream<TrackPointEvent> get trackPointStream => _trackPointController.stream;
  
  UserTrack? get currentActiveTrack => _currentActiveTrack;

  DateTime? get lastUpdateTime => _lastUpdateTime;
  
  bool get isConnected => _connectionTimeoutTimer?.isActive == true;

  Future<void> startTrackingUser(int userId) async {
    await stopTracking(); // Останавливаем предыдущий трекинг
    
    try {
      _currentActiveTrack = await _trackRepository.getActiveTrackByUserId(userId);
      
      if (_currentActiveTrack != null) {
        _lastUpdateTime = DateTime.now();
        _startPeriodicUpdates(userId);
        _startConnectionMonitoring();
        
        // Уведомляем о начале трекинга
        _connectionController.add(ConnectionEvent.connected());
        _trackUpdateController.add(_currentActiveTrack!);
      } else {
        _connectionController.add(ConnectionEvent.noActiveTrack());
      }
    } catch (e) {
      _connectionController.add(ConnectionEvent.error(e.toString()));
    }
  }

  Future<void> stopTracking() async {
    _trackUpdateTimer?.cancel();
    _connectionTimeoutTimer?.cancel();
    _currentActiveTrack = null;
    _lastUpdateTime = null;
  }

  Future<void> forceRefresh(int userId) async {
    await _updateTrack(userId);
  }

  Future<void> addTrackPoint(TrackPoint point) async {
    if (_currentActiveTrack == null) return;
    
    try {
      await _trackRepository.saveTrackPoints(_currentActiveTrack!.id, [point]);
      
      final updatedPoints = List<TrackPoint>.from(_currentActiveTrack!.points);
      updatedPoints.add(point);
      
      if (updatedPoints.length > maxTrackPoints) {
        updatedPoints.removeRange(0, updatedPoints.length - maxTrackPoints);
      }
      
      _currentActiveTrack = _currentActiveTrack!.copyWith(points: updatedPoints);
      _lastUpdateTime = DateTime.now();
      
      _resetConnectionTimeout();

      _trackPointController.add(TrackPointEvent.newPoint(point));
      _trackUpdateController.add(_currentActiveTrack!);
      
    } catch (e) {
      _connectionController.add(ConnectionEvent.error('Ошибка добавления точки: $e'));
    }
  }

  Future<void> updateTrackStatus(TrackStatus newStatus) async {
    if (_currentActiveTrack == null) return;
    
    try {
      final updatedTrack = _currentActiveTrack!.copyWith(status: newStatus);
      await _trackRepository.updateTrack(updatedTrack);
      
      _currentActiveTrack = updatedTrack;
      _lastUpdateTime = DateTime.now();
      
      _trackUpdateController.add(_currentActiveTrack!);
      _connectionController.add(ConnectionEvent.statusChanged(newStatus));
      
    } catch (e) {
      _connectionController.add(ConnectionEvent.error('Ошибка обновления статуса: $e'));
    }
  }

  void _startPeriodicUpdates(int userId) {
    _trackUpdateTimer = Timer.periodic(
      Duration(seconds: updateIntervalSeconds),
      (_) => _updateTrack(userId),
    );
  }

  void _startConnectionMonitoring() {
    _resetConnectionTimeout();
  }

  void _resetConnectionTimeout() {
    _connectionTimeoutTimer?.cancel();
    _connectionTimeoutTimer = Timer(
      Duration(seconds: connectionTimeoutSeconds),
      () => _onConnectionTimeout(),
    );
  }

  void _onConnectionTimeout() {
    _connectionController.add(ConnectionEvent.connectionLost());
  }

  Future<void> _updateTrack(int userId) async {
    try {
      final latestTrack = await _trackRepository.getActiveTrackByUserId(userId);
      
      if (latestTrack != null) {
        // Проверяем, есть ли новые точки
        final currentPointsCount = _currentActiveTrack?.points.length ?? 0;
        final newPointsCount = latestTrack.points.length;
        
        if (newPointsCount > currentPointsCount) {
          // Есть новые точки
          final newPoints = latestTrack.points.skip(currentPointsCount).toList();
          for (final point in newPoints) {
            _trackPointController.add(TrackPointEvent.newPoint(point));
          }
        }
        
        // Обновляем трек только если есть изменения
        if (_hasTrackChanged(latestTrack)) {
          _currentActiveTrack = latestTrack;
          _lastUpdateTime = DateTime.now();
          _resetConnectionTimeout();
          _trackUpdateController.add(_currentActiveTrack!);
        }
        
      } else if (_currentActiveTrack != null) {
        // Трек больше не активен
        _currentActiveTrack = null;
        _connectionController.add(ConnectionEvent.trackEnded());
      }
      
    } catch (e) {
      _connectionController.add(ConnectionEvent.error('Ошибка обновления: $e'));
    }
  }

  bool _hasTrackChanged(UserTrack newTrack) {
    if (_currentActiveTrack == null) return true;
    
    return _currentActiveTrack!.points.length != newTrack.points.length ||
           _currentActiveTrack!.status != newTrack.status ||
           _currentActiveTrack!.totalDistanceMeters != newTrack.totalDistanceMeters ||
           _currentActiveTrack!.endTime != newTrack.endTime;
  }

  void dispose() {
    _trackUpdateTimer?.cancel();
    _connectionTimeoutTimer?.cancel();
    _trackUpdateController.close();
    _connectionController.close();
    _trackPointController.close();
  }
}

class ConnectionEvent {
  final ConnectionEventType type;
  final String? message;
  final TrackStatus? trackStatus;

  const ConnectionEvent._(this.type, {this.message, this.trackStatus});

  factory ConnectionEvent.connected() => const ConnectionEvent._(ConnectionEventType.connected);
  factory ConnectionEvent.connectionLost() => const ConnectionEvent._(ConnectionEventType.connectionLost);
  factory ConnectionEvent.reconnected() => const ConnectionEvent._(ConnectionEventType.reconnected);
  factory ConnectionEvent.error(String message) => ConnectionEvent._(ConnectionEventType.error, message: message);
  factory ConnectionEvent.noActiveTrack() => const ConnectionEvent._(ConnectionEventType.noActiveTrack);
  factory ConnectionEvent.trackEnded() => const ConnectionEvent._(ConnectionEventType.trackEnded);
  factory ConnectionEvent.statusChanged(TrackStatus status) => 
    ConnectionEvent._(ConnectionEventType.statusChanged, trackStatus: status);
}

enum ConnectionEventType {
  connected,
  connectionLost,
  reconnected,
  error,
  noActiveTrack,
  trackEnded,
  statusChanged,
}
class TrackPointEvent {
  final TrackPointEventType type;
  final TrackPoint? point;
  final String? message;

  const TrackPointEvent._(this.type, {this.point, this.message});

  factory TrackPointEvent.newPoint(TrackPoint point) => TrackPointEvent._(TrackPointEventType.newPoint, point: point);
  factory TrackPointEvent.error(String message) => TrackPointEvent._(TrackPointEventType.error, message: message);
}

enum TrackPointEventType {
  newPoint,
  error,
}
