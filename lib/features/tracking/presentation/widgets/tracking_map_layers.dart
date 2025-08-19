import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/user_track.dart';

/// Композитный виджет для отображения всех типов треков на карте
class TrackingMapLayers extends StatelessWidget {
  final List<UserTrack> historicalTracks;
  final UserTrack? currentTrack;
  final LatLng? currentPosition;
  final bool isLiveTrackingActive;
  final bool hasConnectionIssues;

  const TrackingMapLayers({
    super.key,
    required this.historicalTracks,
    this.currentTrack,
    this.currentPosition,
    this.isLiveTrackingActive = false,
    this.hasConnectionIssues = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Исторические треки (снизу)
        HistoricalTracksLayer(tracks: historicalTracks),
        
        // 2. Текущий активный трек (сверху)
        if (currentTrack != null)
          ActiveTrackLayer(
            track: currentTrack!,
            currentPosition: currentPosition,
          ),
        
        // 3. Индикаторы статуса
        TrackingStatusIndicators(
          isActive: isLiveTrackingActive,
          hasConnectionIssues: hasConnectionIssues,
        ),
      ],
    );
  }
}

/// Слой для отображения исторических (завершенных) треков
class HistoricalTracksLayer extends StatelessWidget {
  final List<UserTrack> tracks;

  const HistoricalTracksLayer({
    super.key,
    required this.tracks,
  });

  @override
  Widget build(BuildContext context) {
    final polylines = <Polyline>[];
    final markers = <Marker>[];

    for (final track in tracks) {
      if (track.points.isEmpty) continue;

      // Создаем polyline для трека
      final points = track.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      
      polylines.add(
        Polyline(
          points: points,
          strokeWidth: 3.0,
          color: _getTrackColor(track),
          pattern: track.status == TrackStatus.completed 
            ? StrokePattern.solid() 
            : StrokePattern.dotted(),
        ),
      );

      // Маркеры начала и конца трека
      if (track.points.isNotEmpty) {
        final firstPoint = track.points.first;
        final lastPoint = track.points.last;

        markers.addAll([
          // Начало трека
          Marker(
            point: LatLng(firstPoint.latitude, firstPoint.longitude),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.green,
              size: 20,
            ),
          ),
          // Конец трека (только для завершенных)
          if (track.status == TrackStatus.completed)
            Marker(
              point: LatLng(lastPoint.latitude, lastPoint.longitude),
              child: const Icon(
                Icons.stop,
                color: Colors.red,
                size: 20,
              ),
            ),
        ]);
      }
    }

    return Stack(
      children: [
        // Polylines для треков
        if (polylines.isNotEmpty)
          PolylineLayer(polylines: polylines),
        
        // Маркеры начала/конца
        if (markers.isNotEmpty)
          MarkerLayer(markers: markers),
      ],
    );
  }

  Color _getTrackColor(UserTrack track) {
    // Разные цвета для разных пользователей или статусов
    switch (track.status) {
      case TrackStatus.active:
        return Colors.blue;
      case TrackStatus.paused:
        return Colors.orange;
      case TrackStatus.completed:
        return Colors.grey;
      case TrackStatus.cancelled:
        return Colors.red;
    }
  }
}

/// Слой для отображения активного трека в реальном времени
class ActiveTrackLayer extends StatelessWidget {
  final UserTrack track;
  final LatLng? currentPosition;

  const ActiveTrackLayer({
    super.key,
    required this.track,
    this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    final polylines = <Polyline>[];
    final markers = <Marker>[];

    // Polyline для пройденного пути
    if (track.points.isNotEmpty) {
      final points = track.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      
      polylines.add(
        Polyline(
          points: points,
          strokeWidth: 4.0,
          color: Colors.blue,
          pattern: StrokePattern.solid(),
        ),
      );
    }

    // Текущая позиция пользователя
    if (currentPosition != null) {
      markers.add(
        Marker(
          point: currentPosition!,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        if (polylines.isNotEmpty)
          PolylineLayer(polylines: polylines),
        if (markers.isNotEmpty)
          MarkerLayer(markers: markers),
      ],
    );
  }
}

/// Индикаторы статуса трекинга
class TrackingStatusIndicators extends StatelessWidget {
  final bool isActive;
  final bool hasConnectionIssues;

  const TrackingStatusIndicators({
    super.key,
    required this.isActive,
    required this.hasConnectionIssues,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children: [
          // Индикатор активного трекинга
          if (isActive)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hasConnectionIssues ? Colors.orange : Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasConnectionIssues ? Icons.signal_wifi_off : Icons.gps_fixed,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hasConnectionIssues ? 'Связь потеряна' : 'Трекинг активен',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
