import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/repositories/iuser_track_repository.dart';
import '../../domain/services/location_tracking_service.dart';
import '../../domain/services/realtime_tracking_service.dart';
import 'track_history_map_layer.dart';
import 'live_track_map_layer.dart';

/// Композитный виджет для отображения всех треков пользователя на карте
/// 
/// Объединяет:
/// - Исторические треки (TrackHistoryMapLayer)
/// - Текущий live трек (LiveTrackMapLayer) 
/// - Real-time обновления через RealtimeTrackingService
class ComprehensiveTrackMapLayer extends StatefulWidget {
  /// Репозиторий для получения треков
  final IUserTrackRepository trackRepository;
  
  /// ID пользователя
  final int userId;
  
  /// Сервис live трекинга (опционально)
  final LocationTrackingService? liveTrackingService;
  
  /// Контроллер карты
  final MapController? mapController;
  
  /// Показывать ли исторические треки
  final bool showHistoricalTracks;
  
  /// Показывать ли текущий live трек
  final bool showLiveTrack;
  
  /// Автоматически центрировать карту на текущей позиции
  final bool autoCenter;
  
  /// Максимальное количество исторических треков
  final int maxHistoricalTracks;
  
  /// Период для показа исторических треков (дни назад)
  final int historicalTracksDays;

  const ComprehensiveTrackMapLayer({
    super.key,
    required this.trackRepository,
    required this.userId,
    this.liveTrackingService,
    this.mapController,
    this.showHistoricalTracks = true,
    this.showLiveTrack = true,
    this.autoCenter = false,
    this.maxHistoricalTracks = 5,
    this.historicalTracksDays = 7,
  });

  @override
  State<ComprehensiveTrackMapLayer> createState() => _ComprehensiveTrackMapLayerState();
}

class _ComprehensiveTrackMapLayerState extends State<ComprehensiveTrackMapLayer> {
  RealtimeTrackingService? _realtimeService;
  UserTrack? _currentLiveTrack;
  bool _isConnected = true;
  String? _connectionError;

  @override
  void initState() {
    super.initState();
    _initializeRealtimeTracking();
  }

  @override
  void didUpdateWidget(ComprehensiveTrackMapLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Перезапускаем сервис если изменился userId
    if (oldWidget.userId != widget.userId) {
      _initializeRealtimeTracking();
    }
  }

  @override
  void dispose() {
    _realtimeService?.dispose();
    super.dispose();
  }

  void _initializeRealtimeTracking() {
    _realtimeService?.dispose();
    
    _realtimeService = RealtimeTrackingService(
      widget.trackRepository,
      updateIntervalSeconds: 10, // Обновляем каждые 10 секунд
      connectionTimeoutSeconds: 300, // 5 минут таймаут
    );
    
    // Слушаем обновления треков
    _realtimeService!.trackUpdateStream.listen((track) {
      if (mounted) {
        setState(() {
          _currentLiveTrack = track;
        });
      }
    });
    
    // Слушаем события соединения
    _realtimeService!.connectionStream.listen((event) {
      if (mounted) {
        setState(() {
          switch (event.type) {
            case ConnectionEventType.connected:
            case ConnectionEventType.reconnected:
              _isConnected = true;
              _connectionError = null;
              break;
            case ConnectionEventType.connectionLost:
              _isConnected = false;
              _connectionError = 'Связь потеряна. Последнее обновление: ${_formatTime(_realtimeService!.lastUpdateTime)}';
              break;
            case ConnectionEventType.error:
              _isConnected = false;
              _connectionError = event.message ?? 'Неизвестная ошибка';
              break;
            case ConnectionEventType.noActiveTrack:
              _currentLiveTrack = null;
              break;
            case ConnectionEventType.trackEnded:
              _currentLiveTrack = null;
              // Обновляем исторические треки когда трек завершается
              _refreshHistoricalTracks();
              break;
            case ConnectionEventType.statusChanged:
              // Трек изменил статус, возможно нужно обновить отображение
              break;
          }
        });
      }
    });
    
    // Запускаем мониторинг
    _realtimeService!.startTrackingUser(widget.userId);
  }

  void _refreshHistoricalTracks() {
    // Принудительно обновляем исторические треки
    setState(() {}); // Это приведет к пересозданию TrackHistoryMapLayer
  }

  String _formatTime(DateTime? time) {
    if (time == null) return 'неизвестно';
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) {
      return 'менее минуты назад';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} мин назад';
    } else {
      return '${diff.inHours} ч ${diff.inMinutes % 60} мин назад';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: widget.historicalTracksDays));
    
    return Stack(
      children: [
        // Исторические треки (отображаются под live треком)
        if (widget.showHistoricalTracks)
          TrackHistoryMapLayer(
            trackRepository: widget.trackRepository,
            userId: widget.userId,
            startDate: startDate,
            endDate: now,
            maxTracksToShow: widget.maxHistoricalTracks,
            defaultTrackColor: Colors.grey.withOpacity(0.7),
            trackWidth: 2.0,
            showStartEndMarkers: false, // Убираем маркеры чтобы не загромождать карту
            showOnlyActiveTracks: true,
          ),
        
        // Live трек (отображается поверх исторических)
        if (widget.showLiveTrack && widget.liveTrackingService != null)
          LiveTrackMapLayer(
            trackingService: widget.liveTrackingService!,
            mapController: widget.mapController,
            autoCenter: widget.autoCenter,
            trackColor: Colors.blue,
            trackWidth: 4.0,
            showTrackInfo: false, // Информацию показываем через ConnectionStatusWidget
          ),
        
        // Индикатор статуса соединения
        if (!_isConnected || _connectionError != null)
          Positioned(
            top: 10,
            right: 10,
            child: ConnectionStatusWidget(
              isConnected: _isConnected,
              error: _connectionError,
              onRetry: () => _realtimeService?.forceRefresh(widget.userId),
            ),
          ),
        
        // Информационная панель текущего трека
        if (_currentLiveTrack != null && widget.showLiveTrack)
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: CurrentTrackInfoWidget(
              track: _currentLiveTrack!,
              isConnected: _isConnected,
            ),
          ),
      ],
    );
  }
}

/// Виджет для отображения статуса соединения
class ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;
  final String? error;
  final VoidCallback? onRetry;

  const ConnectionStatusWidget({
    super.key,
    required this.isConnected,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConnected ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            isConnected ? 'Онлайн' : 'Оффлайн',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!isConnected && onRetry != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRetry,
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Виджет для отображения информации о текущем треке
class CurrentTrackInfoWidget extends StatelessWidget {
  final UserTrack track;
  final bool isConnected;

  const CurrentTrackInfoWidget({
    super.key,
    required this.track,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getStatusColor(track.status),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _getStatusText(track.status),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (!isConnected)
                const Icon(
                  Icons.signal_wifi_off,
                  color: Colors.orange,
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Расстояние', '${track.totalDistanceKm.toStringAsFixed(1)} км'),
              _buildStatItem('Время', _formatDuration(track.totalTimeSeconds)),
              _buildStatItem('Скорость', '${track.averageSpeedKmh.toStringAsFixed(1)} км/ч'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TrackStatus status) {
    switch (status) {
      case TrackStatus.active:
        return Colors.green;
      case TrackStatus.paused:
        return Colors.orange;
      case TrackStatus.completed:
        return Colors.blue;
      case TrackStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(TrackStatus status) {
    switch (status) {
      case TrackStatus.active:
        return 'Активный трек';
      case TrackStatus.paused:
        return 'Трек приостановлен';
      case TrackStatus.completed:
        return 'Трек завершен';
      case TrackStatus.cancelled:
        return 'Трек отменен';
    }
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '$hoursч $minutesм';
    } else {
      return '$minutesм';
    }
  }
}
