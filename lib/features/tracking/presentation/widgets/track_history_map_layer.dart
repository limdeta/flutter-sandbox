import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/repositories/iuser_track_repository.dart';

/// Виджет для отображения исторических треков пользователя на карте
class TrackHistoryMapLayer extends StatefulWidget {
  /// Репозиторий для получения треков
  final IUserTrackRepository trackRepository;
  
  /// ID пользователя для показа треков
  final int userId;
  
  /// Фильтр по датам (опционально)
  final DateTime? startDate;
  final DateTime? endDate;
  
  /// Цвет треков (по умолчанию)
  final Color defaultTrackColor;
  
  /// Толщина линии трека
  final double trackWidth;
  
  /// Показывать ли маркеры начала/конца
  final bool showStartEndMarkers;
  
  /// Показывать ли только активные треки
  final bool showOnlyActiveTracks;
  
  /// Максимальное количество треков для отображения
  final int maxTracksToShow;

  const TrackHistoryMapLayer({
    super.key,
    required this.trackRepository,
    required this.userId,
    this.startDate,
    this.endDate,
    this.defaultTrackColor = Colors.blue,
    this.trackWidth = 3.0,
    this.showStartEndMarkers = true,
    this.showOnlyActiveTracks = false,
    this.maxTracksToShow = 10,
  });

  @override
  State<TrackHistoryMapLayer> createState() => _TrackHistoryMapLayerState();
}

class _TrackHistoryMapLayerState extends State<TrackHistoryMapLayer> {
  List<UserTrack> _tracks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  @override
  void didUpdateWidget(TrackHistoryMapLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Перезагружаем треки если изменились параметры
    if (oldWidget.userId != widget.userId ||
        oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate ||
        oldWidget.showOnlyActiveTracks != widget.showOnlyActiveTracks) {
      _loadTracks();
    }
  }

  Future<void> _loadTracks() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<UserTrack> tracks;
      
      if (widget.startDate != null && widget.endDate != null) {
        tracks = await widget.trackRepository.getTracksByUserIdAndDateRange(
          userId: widget.userId,
          startDate: widget.startDate!,
          endDate: widget.endDate!,
        );
      } else {
        tracks = await widget.trackRepository.getTracksByUserId(widget.userId);
      }

      // Фильтруем по статусу если нужно
      if (widget.showOnlyActiveTracks) {
        tracks = tracks.where((track) => 
          track.status == TrackStatus.active || 
          track.status == TrackStatus.completed).toList();
      }

      // Ограничиваем количество треков
      if (tracks.length > widget.maxTracksToShow) {
        tracks = tracks.take(widget.maxTracksToShow).toList();
      }

      if (mounted) {
        setState(() {
          _tracks = tracks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (_error != null) {
      print('❌ Ошибка загрузки треков: $_error');
      return const SizedBox.shrink();
    }

    if (_tracks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Полилинии треков
        ..._buildTrackPolylines(),
        
        // Маркеры начала/конца если включены
        if (widget.showStartEndMarkers) ..._buildStartEndMarkers(),
      ],
    );
  }

  /// Создает полилинии для всех треков
  List<Widget> _buildTrackPolylines() {
    return _tracks.map((track) => _buildTrackPolyline(track)).toList();
  }

  /// Создает полилинию для одного трека
  Widget _buildTrackPolyline(UserTrack track) {
    if (track.points.length < 2) {
      return const SizedBox.shrink();
    }

    final points = track.points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    final color = _getTrackColor(track);
    final pattern = _getTrackPattern(track);

    return PolylineLayer(
      polylines: [
        Polyline(
          points: points,
          color: color,
          strokeWidth: widget.trackWidth,
          pattern: pattern,
        ),
      ],
    );
  }

  /// Создает маркеры начала и конца треков
  List<Widget> _buildStartEndMarkers() {
    final markers = <Marker>[];
    
    for (final track in _tracks) {
      if (track.points.isEmpty) continue;
      
      final startPoint = track.points.first;
      final endPoint = track.points.last;
      
      // Маркер начала (зеленый)
      markers.add(Marker(
        point: LatLng(startPoint.latitude, startPoint.longitude),
        width: 12,
        height: 12,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
      ));
      
      // Маркер конца (красный) - только если трек завершен
      if (track.status == TrackStatus.completed && track.points.length > 1) {
        markers.add(Marker(
          point: LatLng(endPoint.latitude, endPoint.longitude),
          width: 12,
          height: 12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
          ),
        ));
      }
    }
    
    return [
      MarkerLayer(markers: markers),
    ];
  }

  /// Определяет цвет трека в зависимости от его свойств
  Color _getTrackColor(UserTrack track) {
    switch (track.status) {
      case TrackStatus.active:
        return Colors.blue;
      case TrackStatus.completed:
        return Colors.green;
      case TrackStatus.paused:
        return Colors.orange;
      case TrackStatus.cancelled:
        return Colors.red.withOpacity(0.5);
    }
  }

  /// Определяет паттерн линии трека
  StrokePattern _getTrackPattern(UserTrack track) {
    switch (track.status) {
      case TrackStatus.paused:
        return StrokePattern.dashed(segments: [5, 5]);
      case TrackStatus.cancelled:
        return StrokePattern.dotted();
      case TrackStatus.active:
      case TrackStatus.completed:
        return StrokePattern.solid();
    }
  }

  /// Публичный метод для обновления треков
  void refreshTracks() {
    _loadTracks();
  }
}
