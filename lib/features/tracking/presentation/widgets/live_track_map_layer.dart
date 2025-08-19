import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/entities/track_point.dart';
import '../../domain/services/location_tracking_service.dart';

/// Виджет для отображения трека пользователя на карте в реальном времени
class LiveTrackMapLayer extends StatefulWidget {
  /// Сервис трекинга местоположения
  final LocationTrackingService trackingService;
  
  /// Контроллер карты
  final MapController? mapController;
  
  /// Цвет линии трека
  final Color trackColor;
  
  /// Толщина линии трека
  final double trackWidth;
  
  /// Цвет текущей позиции
  final Color currentPositionColor;
  
  /// Размер маркера текущей позиции
  final double currentPositionSize;
  
  /// Автоматически центрировать карту на текущей позиции
  final bool autoCenter;
  
  /// Показывать информацию о треке
  final bool showTrackInfo;

  const LiveTrackMapLayer({
    super.key,
    required this.trackingService,
    this.mapController,
    this.trackColor = Colors.blue,
    this.trackWidth = 4.0,
    this.currentPositionColor = Colors.red,
    this.currentPositionSize = 12.0,
    this.autoCenter = false,
    this.showTrackInfo = true,
  });

  @override
  State<LiveTrackMapLayer> createState() => _LiveTrackMapLayerState();
}

class _LiveTrackMapLayerState extends State<LiveTrackMapLayer> {
  UserTrack? _currentTrack;
  TrackPoint? _currentPosition;

  @override
  void initState() {
    super.initState();
    _currentTrack = widget.trackingService.currentTrack;
    _listenToTrackUpdates();
  }

  void _listenToTrackUpdates() {
    // Слушаем обновления трека
    widget.trackingService.trackUpdateStream.listen((track) {
      if (mounted) {
        setState(() {
          _currentTrack = track;
        });
      }
    });

    // Слушаем новые точки
    widget.trackingService.trackPointStream.listen((point) {
      if (mounted) {
        setState(() {
          _currentPosition = point;
        });

        // Автоцентрирование карты
        if (widget.autoCenter && widget.mapController != null) {
          widget.mapController!.move(
            LatLng(point.latitude, point.longitude),
            widget.mapController!.camera.zoom,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Слои карты для трека
        if (_currentTrack != null) ..._buildMapLayers(),
        
        // Информационная панель
        if (widget.showTrackInfo && _currentTrack != null)
          _buildTrackInfoPanel(),
      ],
    );
  }

  /// Создает слои карты для отображения трека
  List<Widget> _buildMapLayers() {
    final track = _currentTrack!;
    final layers = <Widget>[];

    // Слой с линией трека
    if (track.points.length > 1) {
      layers.add(_buildTrackPolyline(track));
    }

    // Слой с текущей позицией
    if (_currentPosition != null) {
      layers.add(_buildCurrentPositionMarker(_currentPosition!));
    }

    // Слой с маркерами начала и конца
    layers.add(_buildStartEndMarkers(track));

    return layers;
  }

  /// Создает полилинию трека
  Widget _buildTrackPolyline(UserTrack track) {
    final points = track.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    return PolylineLayer(
      polylines: [
        Polyline(
          points: points,
          color: widget.trackColor,
          strokeWidth: widget.trackWidth,
          pattern: track.status == TrackStatus.paused 
              ? StrokePattern.dashed(segments: [5, 5]) 
              : StrokePattern.solid(),
        ),
      ],
    );
  }

  /// Создает маркер текущей позиции
  Widget _buildCurrentPositionMarker(TrackPoint position) {
    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(position.latitude, position.longitude),
          width: widget.currentPositionSize,
          height: widget.currentPositionSize,
          child: Container(
            decoration: BoxDecoration(
              color: widget.currentPositionColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: widget.currentPositionColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: position.isMoving
                ? Icon(
                    Icons.navigation,
                    color: Colors.white,
                    size: widget.currentPositionSize * 0.6,
                  )
                : Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: widget.currentPositionSize * 0.6,
                  ),
          ),
        ),
      ],
    );
  }

  /// Создает маркеры начала и конца трека
  Widget _buildStartEndMarkers(UserTrack track) {
    final markers = <Marker>[];

    // Маркер начала
    if (track.points.isNotEmpty) {
      final startPoint = track.points.first;
      markers.add(
        Marker(
          point: LatLng(startPoint.latitude, startPoint.longitude),
          width: 24,
          height: 24,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(color: Colors.white, width: 2),
              ),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      );
    }

    // Маркер конца (только для завершенных треков)
    if (track.isCompleted && track.points.length > 1) {
      final endPoint = track.points.last;
      markers.add(
        Marker(
          point: LatLng(endPoint.latitude, endPoint.longitude),
          width: 24,
          height: 24,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(color: Colors.white, width: 2),
              ),
            ),
            child: const Icon(
              Icons.stop,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      );
    }

    return MarkerLayer(markers: markers);
  }

  /// Создает информационную панель трека
  Widget _buildTrackInfoPanel() {
    final track = _currentTrack!;

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Статус трека
              Row(
                children: [
                  Icon(
                    _getStatusIcon(track.status),
                    color: _getStatusColor(track.status),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    track.status.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(track.status),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDuration(Duration(seconds: track.totalTimeSeconds)),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Статистика
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Расстояние',
                    '${track.totalDistanceKm.toStringAsFixed(2)} км',
                    Icons.straighten,
                  ),
                  _buildStatItem(
                    'Скорость',
                    '${_currentPosition?.speedKmh?.toStringAsFixed(1) ?? '0'} км/ч',
                    Icons.speed,
                  ),
                  _buildStatItem(
                    'Средняя',
                    '${track.averageSpeedKmh.toStringAsFixed(1)} км/ч',
                    Icons.trending_up,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(TrackStatus status) {
    switch (status) {
      case TrackStatus.active:
        return Icons.radio_button_checked;
      case TrackStatus.paused:
        return Icons.pause_circle;
      case TrackStatus.completed:
        return Icons.check_circle;
      case TrackStatus.cancelled:
        return Icons.cancel;
    }
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

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
             '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    }
  }
}
