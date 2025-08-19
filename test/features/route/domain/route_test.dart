import 'package:flutter_test/flutter_test.dart';
import 'package:tauzero/features/route/domain/factories/route_factory.dart';
import 'package:tauzero/features/route/domain/entities/ipoint_of_interest.dart';
import 'package:tauzero/features/route/domain/entities/route.dart';
import 'package:tauzero/features/route/domain/services/route_service.dart';

void main() {
  late RouteService routeService;

  setUp(() {
    routeService = RouteService();
  });

  group('RouteFactory Tests', () {
    test('should create simple route for user', () {
      // Arrange
      const userId = 'user_123';
      final testDate = DateTime(2025, 7, 31);

      // Act
      final route = RouteFactory.createSimpleRoute(
        userId: userId,
        startDate: testDate,
      );

      // Assert
      expect(route.id, isNotNull);
      expect(route.name, contains('Простой маршрут'));
      expect(route.description, contains(userId));
      expect(route.pointsOfInterest.length, equals(4));
      expect(route.status, equals(RouteStatus.active));
      
      // Проверяем типы точек
      expect(route.pointsOfInterest[0].type, equals(PointType.startPoint));
      expect(route.pointsOfInterest[1].type, equals(PointType.client));
      expect(route.pointsOfInterest[2].type, equals(PointType.client));
      expect(route.pointsOfInterest[3].type, equals(PointType.endPoint));
    });

    test('should create medium route with different statuses', () {
      // Arrange
      const userId = 'user_456';

      // Act
      final route = RouteFactory.createMediumRoute(userId: userId);

      // Assert
      expect(route.pointsOfInterest.length, equals(8));
      expect(route.name, contains('Средний маршрут'));
      
      // Проверяем разные статусы
      final statuses = route.pointsOfInterest.map((p) => p.status).toSet();
      expect(statuses.contains(VisitStatus.completed), isTrue);
      expect(statuses.contains(VisitStatus.arrived), isTrue);
      expect(statuses.contains(VisitStatus.skipped), isTrue);
      expect(statuses.contains(VisitStatus.planned), isTrue);
      
      // Проверяем что есть перерыв
      final breakPoints = route.pointsOfInterest.where((p) => p.type == PointType.break_);
      expect(breakPoints.length, equals(1));
    });

    test('should create complex route with many trading points', () {
      // Arrange
      const userId = 'user_789';

      // Act
      final route = RouteFactory.createComplexRoute(userId: userId);

      // Assert
      expect(route.pointsOfInterest.length, greaterThan(10));
      expect(route.name, contains('Сложный маршрут'));
      
      // Проверяем что есть торговые точки
      final tradingPoints = route.pointsOfInterest.where((p) => p.externalId != null);
      expect(tradingPoints.length, greaterThan(5));
      
      // Проверяем что есть склад
      final warehousePoints = route.pointsOfInterest.where((p) => p.type == PointType.warehouse);
      expect(warehousePoints.length, greaterThan(0));
    });
  });

  group('RouteService with Factory Tests', () {
    test('should start route and update point status', () {
      // Arrange
      final route = RouteFactory.createSimpleRoute(userId: 'test_user');
      
      // Переводим все точки в planned для честного тестирования
      final plannedPoints = route.pointsOfInterest.map((point) => 
        point.copyWith(status: VisitStatus.planned)
      ).toList();
      
      final cleanRoute = route.copyWith(
        pointsOfInterest: plannedPoints,
        status: RouteStatus.planned,
      );
      
      // Act
      final activeRoute = routeService.startRoute(cleanRoute);
      
      // Assert
      expect(activeRoute.status, equals(RouteStatus.active));
      expect(activeRoute.startTime, isNotNull);
      
      // Первая точка должна стать "в пути"
      final firstPoint = activeRoute.pointsOfInterest.first;
      expect(firstPoint.status, equals(VisitStatus.enRoute));
    });

    test('should complete visit and move to next point', () {
      // Arrange
      final route = RouteFactory.createMediumRoute(userId: 'test_user');
      
      // Переводим все точки в planned для честного тестирования
      final plannedPoints = route.pointsOfInterest.map((point) => 
        point.copyWith(status: VisitStatus.planned)
      ).toList();
      
      final cleanRoute = route.copyWith(
        pointsOfInterest: plannedPoints,
        status: RouteStatus.planned,
      );
      
      final activeRoute = routeService.startRoute(cleanRoute);
      final firstPointId = activeRoute.pointsOfInterest.first.id?.toString() ?? '';
      
      // Act - прибываем в первую точку
      final arrivedRoute = routeService.arriveAtPoint(activeRoute, firstPointId);
      
      // Act - завершаем визит
      final completedRoute = routeService.completeVisit(arrivedRoute, firstPointId);
      
      // Assert
      final firstPoint = completedRoute.pointsOfInterest.first;
      expect(firstPoint.status, equals(VisitStatus.completed));
      expect(firstPoint.actualDepartureTime, isNotNull);
      
      // Следующая точка должна стать "в пути"
      if (completedRoute.pointsOfInterest.length > 1) {
        final secondPoint = completedRoute.pointsOfInterest[1];
        expect(secondPoint.status, equals(VisitStatus.enRoute));
      }
    });

    test('should skip point with reason', () {
      // Arrange
      final route = RouteFactory.createSimpleRoute(userId: 'test_user');
      
      // Переводим все точки в planned для честного тестирования
      final plannedPoints = route.pointsOfInterest.map((point) => 
        point.copyWith(status: VisitStatus.planned)
      ).toList();
      
      final cleanRoute = route.copyWith(
        pointsOfInterest: plannedPoints,
        status: RouteStatus.planned,
      );
      
      final pointToSkip = cleanRoute.pointsOfInterest[1];
      
      // Act
      final skippedRoute = routeService.skipPoint(
        cleanRoute, 
        pointToSkip.id?.toString() ?? '', 
        'Клиент не отвечает'
      );
      
      // Assert
      final skippedPoint = skippedRoute.pointsOfInterest[1];
      expect(skippedPoint.status, equals(VisitStatus.skipped));
      expect(skippedPoint.notes, contains('Клиент не отвечает'));
      
      // Следующая точка должна стать активной
      if (skippedRoute.pointsOfInterest.length > 2) {
        final nextPoint = skippedRoute.pointsOfInterest[2];
        expect(nextPoint.status, equals(VisitStatus.enRoute));
      }
    });

    test('should calculate route statistics correctly', () {
      // Arrange - используем маршрут с готовыми данными для проверки статистики
      final route = RouteFactory.createMediumRoute(userId: 'test_user');
      
      // Act
      final stats = routeService.getRouteStatistics(route);
      
      // Assert
      expect(stats.totalPoints, equals(route.pointsOfInterest.length));
      expect(stats.completionPercentage, greaterThanOrEqualTo(0.0));
      expect(stats.completionPercentage, lessThanOrEqualTo(1.0));
      expect(stats.completedPoints, equals(route.pointsOfInterest.where((p) => p.isVisited).length));
      expect(stats.skippedPoints, equals(route.pointsOfInterest.where((p) => p.status == VisitStatus.skipped).length));
    });

    test('should get current and next points correctly', () {
      // Arrange - используем маршрут с готовыми данными для проверки логики
      final route = RouteFactory.createMediumRoute(userId: 'test_user');
      
      // Act
      final currentPoint = route.currentPoint;
      final nextPoint = route.getNextPoint();
      
      // Assert
      if (currentPoint != null) {
        expect([VisitStatus.arrived, VisitStatus.enRoute].contains(currentPoint.status), isTrue);
      }
      
      if (nextPoint != null) {
        expect([VisitStatus.planned, VisitStatus.enRoute].contains(nextPoint.status), isTrue);
      }
    });

    test('should create timeline frames for route playback', () {
      // Arrange
      final route = RouteFactory.createSimpleRoute(userId: 'test_user');
      
      // Act
      final timeline = routeService.createTimeline(
        route, 
        frameInterval: const Duration(minutes: 30)
      );
      
      // Assert
      expect(timeline, isNotEmpty);
      
      // Проверяем что кадры упорядочены по времени
      for (int i = 1; i < timeline.length; i++) {
        expect(timeline[i].timestamp.isAfter(timeline[i-1].timestamp), isTrue);
      }
      
      // Проверяем что прогресс растет
      expect(timeline.first.routeProgress, lessThanOrEqualTo(timeline.last.routeProgress));
    });
  });

  group('Integration Tests', () {
    test('should handle complete route lifecycle', () {
      // Arrange - создаем маршрут с planned статусами для всех точек
      final route = RouteFactory.createSimpleRoute(userId: 'integration_test');
      
      // Переводим все точки в planned статус для честного тестирования
      final plannedPoints = route.pointsOfInterest.map((point) => 
        point.copyWith(status: VisitStatus.planned)
      ).toList();
      
      final cleanRoute = route.copyWith(
        pointsOfInterest: plannedPoints,
        status: RouteStatus.planned,
      );
      
      // Act & Assert - полный жизненный цикл маршрута
      
      // 1. Начинаем маршрут
      var activeRoute = routeService.startRoute(cleanRoute);
      expect(activeRoute.status, equals(RouteStatus.active));
      
      // 2. Проходим все точки по порядку
      for (int i = 0; i < activeRoute.pointsOfInterest.length; i++) {
        final point = activeRoute.pointsOfInterest[i];
        final pointId = point.id?.toString() ?? '';
        
        // Пропускаем уже завершенные точки
        if (point.status != VisitStatus.completed && point.status != VisitStatus.skipped) {
          // Прибываем в точку
          activeRoute = routeService.arriveAtPoint(activeRoute, pointId);
          
          // Завершаем визит
          activeRoute = routeService.completeVisit(activeRoute, pointId);
        }
      }
      
      // 3. Проверяем что маршрут завершен
      expect(activeRoute.status, equals(RouteStatus.completed));
      expect(activeRoute.completionPercentage, equals(1.0));
      expect(activeRoute.endTime, isNotNull);
    });
  });
}
