import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

/// Виджет для отображения маршрута на карте
class RoutePolyline extends StatelessWidget {
  final List<LatLng> points;
  final Color color;
  final double width;
  const RoutePolyline({
    required this.points,
    this.color = Colors.blue,
    this.width = 6,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Убираем избыточные логи для dev режима
    // print('🛣️ RoutePolyline.build() вызван с ${points.length} точками');
    if (points.isEmpty) return const SizedBox.shrink();
    
    return PolylineLayer(
      polylines: [
        Polyline(
          points: points,
          color: color,
          strokeWidth: width,
          pattern: StrokePattern.solid(),
          useStrokeWidthInMeter: false,
        ),
      ],
    );
  }

  /// Создает маркеры-стрелочки для показа направления
  List<Marker> buildDirectionMarkers() {
    if (points.length < 2) return [];
    
    final markers = <Marker>[];
    
    // Добавляем стрелочки через каждые несколько точек
    for (int i = 1; i < points.length; i += 3) {
      final prevPoint = points[i - 1];
      final currentPoint = points[i];
      
      // Вычисляем угол между точками
      final angle = _calculateBearing(prevPoint, currentPoint);
      
      markers.add(
        Marker(
          point: currentPoint,
          width: 20,
          height: 20,
          child: Transform.rotate(
            angle: angle,
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 16,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return markers;
  }

  /// Вычисляет угол направления между двумя точками
  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * (math.pi / 180);
    final lat2 = to.latitude * (math.pi / 180);
    final deltaLon = (to.longitude - from.longitude) * (math.pi / 180);

    final x = math.sin(deltaLon) * math.cos(lat2);
    final y = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(deltaLon);

    return math.atan2(x, y);
  }
}
