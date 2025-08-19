import 'package:flutter/material.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/services/location_tracking_service.dart';

/// Виджет с кнопками управления трекингом
class TrackingControlsWidget extends StatefulWidget {
  /// Сервис трекинга
  final LocationTrackingService trackingService;
  
  /// ID пользователя
  final int userId;
  
  /// ID маршрута (опционально)
  final int? routeId;
  
  /// Колбэк при изменении состояния трекинга
  final Function(UserTrack?)? onTrackingStateChanged;
  
  /// Компактный режим (меньше кнопок)
  final bool compact;

  const TrackingControlsWidget({
    super.key,
    required this.trackingService,
    required this.userId,
    this.routeId,
    this.onTrackingStateChanged,
    this.compact = false,
  });

  @override
  State<TrackingControlsWidget> createState() => _TrackingControlsWidgetState();
}

class _TrackingControlsWidgetState extends State<TrackingControlsWidget> {
  UserTrack? _currentTrack;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentTrack = widget.trackingService.currentTrack;
    _listenToTrackUpdates();
  }

  void _listenToTrackUpdates() {
    widget.trackingService.trackUpdateStream.listen((track) {
      if (mounted) {
        setState(() {
          _currentTrack = track;
        });
        widget.onTrackingStateChanged?.call(track);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      return _buildCompactControls();
    } else {
      return _buildFullControls();
    }
  }

  Widget _buildCompactControls() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.trackingService.isTracking)
            _buildStartButton()
          else if (_currentTrack?.isActive == true)
            _buildPauseButton()
          else if (_currentTrack?.isPaused == true)
            _buildResumeButton(),
          
          if (widget.trackingService.isTracking) ...[
            const SizedBox(width: 8),
            _buildStopButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildFullControls() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Запись маршрута',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildStatusIndicator(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Кнопки управления
            if (!widget.trackingService.isTracking)
              _buildStartSection()
            else
              _buildActiveTrackingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    if (!widget.trackingService.isTracking) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Остановлен',
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    final status = _currentTrack?.status;
    Color color;
    String text;

    switch (status) {
      case TrackStatus.active:
        color = Colors.green;
        text = 'Запись';
        break;
      case TrackStatus.paused:
        color = Colors.orange;
        text = 'Пауза';
        break;
      default:
        color = Colors.grey;
        text = 'Неизвестно';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStartSection() {
    return Column(
      children: [
        const Text(
          'Начните запись маршрута для отслеживания\nвашего пути и расчета статистики',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: _buildStartButton(),
        ),
      ],
    );
  }

  Widget _buildActiveTrackingSection() {
    return Column(
      children: [
        // Статистика трека
        if (_currentTrack != null) _buildTrackStats(),
        
        const SizedBox(height: 16),
        
        // Кнопки управления
        Row(
          children: [
            if (_currentTrack?.isActive == true)
              Expanded(child: _buildPauseButton())
            else if (_currentTrack?.isPaused == true)
              Expanded(child: _buildResumeButton()),
            
            const SizedBox(width: 12),
            Expanded(child: _buildStopButton()),
          ],
        ),
      ],
    );
  }

  Widget _buildTrackStats() {
    final track = _currentTrack!;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(
            'Расстояние',
            '${track.totalDistanceKm.toStringAsFixed(2)} км',
            Icons.straighten,
          ),
          _buildStatColumn(
            'Время',
            _formatDuration(Duration(seconds: track.totalTimeSeconds)),
            Icons.timer,
          ),
          _buildStatColumn(
            'Скорость',
            '${track.averageSpeedKmh.toStringAsFixed(1)} км/ч',
            Icons.speed,
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.blue),
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

  Widget _buildStartButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _startTracking,
      icon: _isLoading 
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.play_arrow),
      label: Text(_isLoading ? 'Запуск...' : 'Начать'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildPauseButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _pauseTracking,
      icon: const Icon(Icons.pause),
      label: const Text('Пауза'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildResumeButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _resumeTracking,
      icon: const Icon(Icons.play_arrow),
      label: const Text('Продолжить'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildStopButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _showStopDialog,
      icon: const Icon(Icons.stop),
      label: const Text('Остановить'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _startTracking() async {
    setState(() => _isLoading = true);
    
    try {
      final success = await widget.trackingService.startTracking(
        userId: widget.userId,
        routeId: widget.routeId,
        metadata: {
          'startedAt': DateTime.now().toIso8601String(),
          'routeId': widget.routeId,
        },
      );

      if (!success && mounted) {
        _showErrorDialog('Не удалось начать трекинг. Проверьте разрешения на геолокацию.');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Ошибка при запуске трекинга: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _pauseTracking() async {
    setState(() => _isLoading = true);
    try {
      await widget.trackingService.pauseTracking();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _resumeTracking() async {
    setState(() => _isLoading = true);
    try {
      final success = await widget.trackingService.resumeTracking();
      if (!success && mounted) {
        _showErrorDialog('Не удалось возобновить трекинг.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showStopDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Остановить запись?'),
        content: const Text(
          'Вы уверены, что хотите остановить запись маршрута? '
          'Данные будут сохранены.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _stopTracking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Остановить'),
          ),
        ],
      ),
    );
  }

  void _stopTracking() async {
    setState(() => _isLoading = true);
    try {
      final completedTrack = await widget.trackingService.stopTracking();
      if (completedTrack != null && mounted) {
        _showCompletionDialog(completedTrack);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showCompletionDialog(UserTrack track) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Маршрут записан!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Расстояние: ${track.totalDistanceKm.toStringAsFixed(2)} км'),
            Text('Время: ${_formatDuration(Duration(seconds: track.totalTimeSeconds))}'),
            Text('Средняя скорость: ${track.averageSpeedKmh.toStringAsFixed(1)} км/ч'),
            Text('Точек: ${track.points.length}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
