import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:tauzero/features/route/domain/entities/route.dart';
import 'package:tauzero/features/route/domain/entities/regular_point_of_interest.dart';
import 'package:tauzero/features/route/domain/entities/trading_point_of_interest.dart';
import 'package:tauzero/features/route/domain/entities/trading_point.dart';
import 'package:tauzero/features/route/domain/entities/ipoint_of_interest.dart';
import '../../../helpers/test_database_helper.dart';

void main() {
  group('Route Points Integration Tests', () {
    final dbHelper = TestDatabaseHelper();

    setUp(() async {
      await dbHelper.setUp();
      dbHelper.resetFactories();
    });

    tearDown(() async {
      await dbHelper.tearDown();
    });

    test('должен создать маршрут с точками и корректно загрузить его из БД', () async {
      print('🧪 ТЕСТ: Создание и загрузка маршрута с точками');
      
      // 1. Создаем маршрут с разными типами точек
      final route = Route(
        name: 'Тестовый маршрут',
        description: 'Маршрут для проверки сохранения точек',
        createdAt: DateTime.now(),
        startTime: DateTime.now(),
        status: RouteStatus.planned,
        pointsOfInterest: [
          // Обычная точка
          RegularPointOfInterest(
            name: 'Склад',
            description: 'Точка загрузки товара',
            coordinates: const LatLng(43.1158, 131.8858),
            type: PointType.warehouse,
            plannedArrivalTime: DateTime.now(),
            plannedDepartureTime: DateTime.now().add(const Duration(minutes: 30)),
            status: VisitStatus.planned,
            order: 1,
          ),
          
          // Торговая точка
          TradingPointOfInterest(
            name: 'Визит к клиенту',
            tradingPoint: TradingPoint(
              externalId: 'CLIENT_TEST_001',
              name: 'ООО "Тестовый клиент"',
              inn: '1234567890',
            ),
            coordinates: const LatLng(43.1356, 131.9113),
            plannedArrivalTime: DateTime.now().add(const Duration(hours: 1)),
            plannedDepartureTime: DateTime.now().add(const Duration(hours: 2)),
            status: VisitStatus.planned,
            order: 2,
          ),
          
          // Еще одна обычная точка
          RegularPointOfInterest(
            name: 'Обеденный перерыв',
            description: 'Кафе в центре города',
            coordinates: const LatLng(43.1200, 131.9000),
            type: PointType.break_,
            plannedArrivalTime: DateTime.now().add(const Duration(hours: 3)),
            plannedDepartureTime: DateTime.now().add(const Duration(hours: 4)),
            status: VisitStatus.planned,
            order: 3,
          ),
        ],
      );
      
      print('📝 Создаем маршрут с ${route.pointsOfInterest.length} точками:');
      for (var point in route.pointsOfInterest) {
        print('  - ${point.name} (order: ${point.order})');
      }
      
      // 2. Сохраняем маршрут через репозиторий
      final createResult = await dbHelper.repository.createRoute(route, dbHelper.testUser);
      
      expect(createResult.isRight(), true, reason: 'Маршрут должен быть создан успешно');
      
      final createdRoute = createResult.fold((l) => throw Exception(l), (r) => r);
      print('✅ Маршрут создан с ID: ${createdRoute.id}');
      
      // 3. Проверяем что маршрут сохранился с правильным количеством точек
      expect(createdRoute.pointsOfInterest.length, equals(3), 
             reason: 'Созданный маршрут должен содержать 3 точки');
      
      // 4. Загружаем маршрут по ID из БД
      final loadResult = await dbHelper.repository.getRouteByInternalId(createdRoute.id!);
      
      expect(loadResult.isRight(), true, reason: 'Маршрут должен быть найден по ID');
      
      final loadedRoute = loadResult.fold((l) => throw Exception(l), (r) => r);
      print('📋 Загружен маршрут с ${loadedRoute.pointsOfInterest.length} точками');
      
      // 5. Проверяем что загруженный маршрут содержит все точки
      expect(loadedRoute.pointsOfInterest.length, equals(3), 
             reason: 'Загруженный маршрут должен содержать 3 точки');
      
      // 6. Проверяем детали каждой точки
      final points = loadedRoute.pointsOfInterest..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
      
      // Проверяем первую точку (склад)
      expect(points[0].name, equals('Склад'));
      expect(points[0].order, equals(1));
      expect(points[0] is RegularPointOfInterest, true);
      if (points[0] is RegularPointOfInterest) {
        final regPoint = points[0] as RegularPointOfInterest;
        expect(regPoint.type, equals(PointType.warehouse));
      }
      
      // Проверяем вторую точку (торговая точка)
      expect(points[1].name, equals('Визит к клиенту'));
      expect(points[1].order, equals(2));
      expect(points[1] is TradingPointOfInterest, true);
      if (points[1] is TradingPointOfInterest) {
        final tradingPoint = points[1] as TradingPointOfInterest;
        expect(tradingPoint.tradingPoint.name, equals('ООО "Тестовый клиент"'));
        expect(tradingPoint.tradingPoint.externalId, equals('CLIENT_TEST_001'));
      }
      
      // Проверяем третью точку (перерыв)
      expect(points[2].name, equals('Обеденный перерыв'));
      expect(points[2].order, equals(3));
      expect(points[2] is RegularPointOfInterest, true);
      
      print('✅ Все точки корректно сохранены и загружены из БД');
      
      // 7. Проверяем загрузку через watchUserRoutes
      final routesStream = dbHelper.repository.watchUserRoutes(dbHelper.testUser);
      final userRoutes = await routesStream.first;
      
      expect(userRoutes.length, equals(1), reason: 'Должен быть найден 1 маршрут пользователя');
      
      final userRoute = userRoutes.first;
      expect(userRoute.pointsOfInterest.length, equals(3), 
             reason: 'Маршрут из watchUserRoutes должен содержать 3 точки');
      
      print('✅ Маршрут корректно загружается через watchUserRoutes с ${userRoute.pointsOfInterest.length} точками');
      
      print('🎉 ТЕСТ ПРОЙДЕН: Цикл создания/сохранения/загрузки маршрутов работает корректно');
    });
  });
}
