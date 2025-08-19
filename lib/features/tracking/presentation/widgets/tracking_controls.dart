import 'package:flutter/material.dart';

import '../../domain/entities/user_track.dart';
import '../../data/services/gps_tracking_service.dart';

/// Элементы управления GPS трекингом
class TrackingControls extends StatelessWidget {
  final VoidCallback onStartTracking;
  final VoidCallback onPauseTracking;
  final VoidCallback onResumeTracking;
  final VoidCallback onStopTracking;
  final GpsTrackingState trackingState;
  final UserTrack? currentTrack;

  const TrackingControls({
    super.key,
    required this.onStartTracking,
    required this.onPauseTracking,
    required this.onResumeTracking,
    required this.onStopTracking,
    required this.trackingState,
    this.currentTrack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Информация о текущем треке
          if (currentTrack != null) _buildTrackInfo(),
          
          const SizedBox(height: 12),
          
          // Кнопки управления
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildControlButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackInfo() {
    if (currentTrack == null) return const SizedBox.shrink();

    final duration = currentTrack!.totalTimeSeconds;
    final distance = currentTrack!.totalDistanceMeters;
    final points = currentTrack!.points.length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.timer,
            label: 'Время',
            value: _formatDuration(duration),
          ),
          _buildStatItem(
            icon: Icons.straighten,
            label: 'Расстояние',
            value: _formatDistance(distance),
          ),
          _buildStatItem(
            icon: Icons.location_on,
            label: 'Точки',
            value: '$points',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
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

  List<Widget> _buildControlButtons() {
    switch (trackingState) {
      case GpsTrackingState.idle:
        return [
          _buildButton(
            icon: Icons.play_arrow,
            label: 'Начать',
            onPressed: onStartTracking,
            color: Colors.green,
          ),
        ];
        
      case GpsTrackingState.starting:
        return [
          _buildButton(
            icon: Icons.hourglass_empty,
            label: 'Запуск...',
            onPressed: null,
            color: Colors.orange,
          ),
        ];
        
      case GpsTrackingState.active:
        return [
          _buildButton(
            icon: Icons.pause,
            label: 'Пауза',
            onPressed: onPauseTracking,
            color: Colors.orange,
          ),
          _buildButton(
            icon: Icons.stop,
            label: 'Стоп',
            onPressed: onStopTracking,
            color: Colors.red,
          ),
        ];
        
      case GpsTrackingState.paused:
        return [
          _buildButton(
            icon: Icons.play_arrow,
            label: 'Продолжить',
            onPressed: onResumeTracking,
            color: Colors.green,
          ),
          _buildButton(
            icon: Icons.stop,
            label: 'Стоп',
            onPressed: onStopTracking,
            color: Colors.red,
          ),
        ];
        
      case GpsTrackingState.disconnected:
        return [
          _buildButton(
            icon: Icons.signal_wifi_off,
            label: 'Нет сигнала',
            onPressed: null,
            color: Colors.grey,
          ),
          _buildButton(
            icon: Icons.stop,
            label: 'Стоп',
            onPressed: onStopTracking,
            color: Colors.red,
          ),
        ];
    }
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '$hoursч $minutesм';
    } else if (minutes > 0) {
      return '$minutesм $secsс';
    } else {
      return '$secsс';
    }
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toInt()}м';
    } else {
      final kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(1)}км';
    }
  }
}
