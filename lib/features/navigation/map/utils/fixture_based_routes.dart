import 'package:flutter/material.dart' hide Route;
import 'package:latlong2/latlong.dart';
import 'package:get_it/get_it.dart';
import 'package:tauzero/features/shop/employee/domain/employee.dart';
import 'package:tauzero/features/shop/route/domain/repositories/route_repository.dart';
import 'package:tauzero/features/shop/route/domain/entities/route.dart';
import 'package:tauzero/features/shop/route/domain/entities/point_of_interest.dart';
import 'route_point.dart';

/// Утилиты для получения реальных маршрутов из централизованных фикстур
/// 
/// Этот класс заменяет старые хардкодированные маршруты и использует
/// данные, созданные системой фикстур
class FixtureBasedRoutes {
  static final RouteRepository _routeRepository = GetIt.instance<RouteRepository>();

  /// Получает все доступные маршруты для отображения на карте
  static Future<List<MapDisplayRoute>> getAllRoutesForMap() async {
    final routes = <MapDisplayRoute>[];
    
    try {
      // Получаем все маршруты из системы
      final allRoutes = await _routeRepository.getAllRoutes();
      
      for (final route in allRoutes) {
        final mapRoute = await convertRouteToMapDisplayRoute(route);
        routes.add(mapRoute);
      }
      
      return routes;
      
    } catch (e) {
      return _getFallbackRoutes(); // Возвращаем резервные маршруты
    }
  }

  /// Получает маршруты конкретного торгового представителя
  static Future<List<MapDisplayRoute>> getRoutesForSalesRep(Employee salesRep) async {
    try {
      final userRoutes = await _routeRepository.watchEmployeeRoutes(salesRep).first;
      
      final mapRoutes = <MapDisplayRoute>[];
      for (final route in userRoutes) {
        final mapRoute = await convertRouteToMapDisplayRoute(route);
        mapRoutes.add(mapRoute);
      }
      
      return mapRoutes;
    } catch (e) {
      return [];
    }
  }

  /// Получает активный (сегодняшний) маршрут для демонстрации
  static Future<MapDisplayRoute?> getTodaysActiveRoute() async {
    try {
      final allRoutes = await _routeRepository.getAllRoutes();
      
      // Ищем активный маршрут на сегодня
      final today = DateTime.now();
      final activeRoute = allRoutes.where((route) {
        return route.status == RouteStatus.active &&
               route.startTime != null &&
               _isSameDay(route.startTime!, today);
      }).firstOrNull;
      
      if (activeRoute != null) {
        return await convertRouteToMapDisplayRoute(activeRoute);
      }
      
      // Если нет активного, берем любой сегодняшний
      final todayRoute = allRoutes.where((route) {
        return route.startTime != null &&
               _isSameDay(route.startTime!, today);
      }).firstOrNull;
      
      if (todayRoute != null) {
        return await convertRouteToMapDisplayRoute(todayRoute);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Конвертирует Route в MapDisplayRoute для отображения на карте
  static Future<MapDisplayRoute> convertRouteToMapDisplayRoute(Route route) async {
    final points = <RoutePoint>[];
    
    for (int i = 0; i < route.pointsOfInterest.length; i++) {
      final poi = route.pointsOfInterest[i];
      
      // Определяем время для точки
      DateTime? timestamp;
      if (poi.actualArrivalTime != null) {
        timestamp = poi.actualArrivalTime;
      } else if (poi.plannedArrivalTime != null) {
        timestamp = poi.plannedArrivalTime;
      }
      
      // Определяем тип точки
      RoutePointType pointType;
      if (i == 0) {
        pointType = RoutePointType.start;
      } else if (i == route.pointsOfInterest.length - 1) {
        pointType = RoutePointType.end;
      } else {
        switch (poi.type) {
          case PointType.warehouse:
            pointType = RoutePointType.warehouse;
            break;
          case PointType.break_:
            pointType = RoutePointType.stop;
            break;
          default:
            pointType = RoutePointType.checkpoint;
        }
      }
      
      // Создаем описание
      String description = poi.displayName;
      if (poi.notes?.isNotEmpty == true) {
        description += '\n${poi.notes!}';
      }
      
      // Добавляем статус
      description += '\n📊 Статус: ${_getStatusEmoji(poi.status)} ${_getStatusName(poi.status)}';
      
      points.add(RoutePoint(
        location: poi.coordinates,
        timestamp: timestamp ?? DateTime.now(),
        description: description,
        type: pointType,
        status: poi.status,
      ));
    }
    
    return MapDisplayRoute(
      id: route.id?.toString() ?? 'unknown',
      name: route.name,
      description: route.description ?? '',
      points: points,
      status: route.status,
      startTime: route.startTime,
      endTime: route.endTime,
      color: _getRouteColor(route.status),
    );
  }

  /// Получает резервные маршруты на случай ошибки
  static List<MapDisplayRoute> _getFallbackRoutes() {
    final now = DateTime.now();
    final startTime = DateTime(now.year, now.month, now.day, 9, 0);
    
    return [
      MapDisplayRoute(
        id: 'fallback_1',
        name: 'Резервный маршрут - Центр',
        description: 'Резервный маршрут для демонстрации',
        points: [
          RoutePoint(
            location: const LatLng(43.1198, 131.8869), // Центр Владивостока
            timestamp: startTime,
            description: '🏢 Офис (резерв)',
            type: RoutePointType.start,
          ),
          RoutePoint(
            location: const LatLng(43.1150, 131.8820), // Ocean Plaza
            timestamp: startTime.add(const Duration(hours: 1)),
            description: '🛍️ Ocean Plaza (резерв)',
            type: RoutePointType.checkpoint,
          ),
          RoutePoint(
            location: const LatLng(43.1320, 131.9100), // Fan Plaza
            timestamp: startTime.add(const Duration(hours: 3)),
            description: '🛒 Fan Plaza (резерв)',
            type: RoutePointType.end,
          ),
        ],
        status: RouteStatus.active,
        startTime: startTime,
        color: Colors.blue,
      ),
    ];
  }

  /// Определяет цвет маршрута по статусу
  static Color _getRouteColor(RouteStatus status) {
    switch (status) {
      case RouteStatus.active:
        return Colors.green;
      case RouteStatus.completed:
        return Colors.grey;
      case RouteStatus.planned:
        return Colors.blue;
      case RouteStatus.cancelled:
        return Colors.red;
      case RouteStatus.paused:
        return Colors.orange;
    }
  }

  /// Получает эмодзи для статуса точки
  static String _getStatusEmoji(VisitStatus status) {
    switch (status) {
      case VisitStatus.planned:
        return '📅';
      case VisitStatus.enRoute:
        return '🚗';
      case VisitStatus.arrived:
        return '📍';
      case VisitStatus.completed:
        return '✅';
      case VisitStatus.skipped:
        return '⏭️';
    }
  }

  /// Получает название статуса точки
  static String _getStatusName(VisitStatus status) {
    switch (status) {
      case VisitStatus.planned:
        return 'Запланировано';
      case VisitStatus.enRoute:
        return 'В пути';
      case VisitStatus.arrived:
        return 'Прибыл';
      case VisitStatus.completed:
        return 'Завершено';
      case VisitStatus.skipped:
        return 'Пропущено';
    }
  }

  /// Проверяет, что даты в один день
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}

/// Маршрут для отображения на карте
class MapDisplayRoute {
  final String id;
  final String name;
  final String description;
  final List<RoutePoint> points;
  final RouteStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final Color color;

  MapDisplayRoute({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.status,
    this.startTime,
    this.endTime,
    required this.color,
  });

  /// Получает общую длительность маршрута
  Duration get totalDuration {
    if (points.isEmpty) return Duration.zero;
    
    final start = points.first.timestamp;
    final end = points.last.timestamp;
    return end.difference(start);
  }

  /// Получает процент выполнения маршрута
  double get completionPercentage {
    if (points.isEmpty) return 0.0;
    
    final completedPoints = points.where((p) => 
        p.status == VisitStatus.completed || p.status == VisitStatus.skipped).length;
    
    return completedPoints / points.length;
  }
}
