import 'dart:async';
import 'dart:math';
import 'package:latlong2/latlong.dart';

/// Сервис для эмуляции движения по маршруту в режиме разработки
class MockLocationService {
  Timer? _timer;
  int _currentPointIndex = 0;
  late List<LatLng> _routePoints;
  late Function(LatLng) _onLocationUpdate;
  
  /// Создает маршрут от точки A до точки B с указанным количеством промежуточных точек
  static List<LatLng> generateRoute({
    required LatLng start,
    required LatLng end,
    int numberOfPoints = 20,
  }) {
    final points = <LatLng>[];
    
    for (int i = 0; i <= numberOfPoints; i++) {
      final ratio = i / numberOfPoints;
      final lat = start.latitude + (end.latitude - start.latitude) * ratio;
      final lng = start.longitude + (end.longitude - start.longitude) * ratio;
      
      // Добавляем небольшую случайность для реалистичности
      final randomLat = lat + (Random().nextDouble() - 0.5) * 0.001;
      final randomLng = lng + (Random().nextDouble() - 0.5) * 0.001;
      
      points.add(LatLng(randomLat, randomLng));
    }
    
    return points;
  }
  
  /// Генерирует маршрут по Владивостоку (от центра к ДВФУ)
  static List<LatLng> generateVladivostokRoute() {
    return generateRoute(
      start: const LatLng(43.1198, 131.8869), // Центр Владивостока
      end: const LatLng(43.0245, 131.8938),   // ДВФУ
      numberOfPoints: 30,
    );
  }
  
  /// Генерирует кольцевой маршрут вокруг центра
  static List<LatLng> generateCircularRoute({
    required LatLng center,
    double radiusKm = 2.0,
    int numberOfPoints = 20,
  }) {
    final points = <LatLng>[];
    final radiusInDegrees = radiusKm / 111.0; // Примерное преобразование км в градусы
    
    for (int i = 0; i <= numberOfPoints; i++) {
      final angle = (i * 2 * pi) / numberOfPoints;
      final lat = center.latitude + radiusInDegrees * cos(angle);
      final lng = center.longitude + radiusInDegrees * sin(angle);
      
      points.add(LatLng(lat, lng));
    }
    
    return points;
  }
  
  /// Запускает эмуляцию движения по маршруту
  void startRouteSimulation({
    required List<LatLng> route,
    required Function(LatLng) onLocationUpdate,
    Duration interval = const Duration(seconds: 2),
  }) {
    _routePoints = route;
    _onLocationUpdate = onLocationUpdate;
    _currentPointIndex = 0;
    
    _timer = Timer.periodic(interval, (timer) {
      if (_currentPointIndex < _routePoints.length) {
        _onLocationUpdate(_routePoints[_currentPointIndex]);
        _currentPointIndex++;
      } else {
        // Маршрут завершен
        stopSimulation();
      }
    });
  }
  
  /// Запускает циклическую эмуляцию (маршрут повторяется)
  void startLoopingSimulation({
    required List<LatLng> route,
    required Function(LatLng) onLocationUpdate,
    Duration interval = const Duration(seconds: 2),
  }) {
    _routePoints = route;
    _onLocationUpdate = onLocationUpdate;
    _currentPointIndex = 0;
    
    _timer = Timer.periodic(interval, (timer) {
      _onLocationUpdate(_routePoints[_currentPointIndex]);
      _currentPointIndex = (_currentPointIndex + 1) % _routePoints.length;
    });
  }
  
  /// Останавливает эмуляцию
  void stopSimulation() {
    _timer?.cancel();
    _timer = null;
  }
  
  /// Проверяет, запущена ли эмуляция
  bool get isRunning => _timer?.isActive ?? false;
  
  /// Получает текущий прогресс маршрута (0.0 - 1.0)
  double get progress {
    if (_routePoints.isEmpty) return 0.0;
    return _currentPointIndex / _routePoints.length;
  }
  
  /// Освобождает ресурсы
  void dispose() {
    stopSimulation();
  }
}
