import 'package:flutter/material.dart';

/// Демонстрация архитектуры GPS Tracking System
class TrackingArchitectureDemo extends StatelessWidget {
  const TrackingArchitectureDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Tracking Architecture'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Real-time GPS Tracking',
              'Архитектура для обработки GPS данных в реальном времени',
              Icons.gps_fixed,
              Colors.blue,
            ),
            const SizedBox(height: 20),
            
            _buildSection(
              'Слои отображения',
              '• HistoricalTracksLayer - завершенные треки\n'
              '• ActiveTrackLayer - текущий трек\n'
              '• TrackingStatusIndicators - статус GPS',
              Icons.layers,
              Colors.green,
            ),
            const SizedBox(height: 20),
            
            _buildSection(
              'Проблемы Real-time систем',
              '• Частые обновления (каждую секунду)\n'
              '• Потеря связи (5+ минут без сигнала)\n'
              '• Множественные подписчики\n'
              '• Батарея и производительность',
              Icons.warning,
              Colors.orange,
            ),
            const SizedBox(height: 20),
            
            _buildSection(
              'Решения',
              '• Throttling обновлений (каждые 5 метров)\n'
              '• Timeout механизм для потери сигнала\n'
              '• Broadcast Streams для подписчиков\n'
              '• Батчинг сохранений (каждые 30 сек)',
              Icons.check_circle,
              Colors.green,
            ),
            const SizedBox(height: 20),
            
            _buildSection(
              'Изоляция архитектуры',
              'GPS tracking изолирован в отдельной feature,\n'
              'не смешивается с логикой карты или маршрутов',
              Icons.architecture,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
