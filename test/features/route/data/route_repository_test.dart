import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:latlong2/latlong.dart';
import 'package:tauzero/features/route/data/database/route_database.dart';
import 'package:tauzero/features/route/data/repositories/route_repository.dart';
import 'package:tauzero/features/route/domain/entities/ipoint_of_interest.dart';
import 'package:tauzero/features/route/domain/entities/regular_point_of_interest.dart';
import 'package:tauzero/features/route/domain/entities/route.dart';
import 'package:tauzero/features/route/domain/entities/trading_point.dart';
import 'package:tauzero/features/route/domain/entities/trading_point_of_interest.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';

void main() {
  group('Route Data Layer Integration Tests', () {
    late RouteDatabase database;
    late RouteRepository repository;
    late User testUser;

    setUp(() async {
      // Создаем тестовую in-memory базу данных
      database = RouteDatabase.forTesting(NativeDatabase.memory());
      repository = RouteRepository(database);
      
      // Создаем тестового пользователя
      final phoneResult = PhoneNumber.create('+79991234567');
      final phoneNumber = phoneResult.fold(
        (failure) => throw Exception('Phone number invalid: $failure'),
        (value) => value,
      );
      
      testUser = User(
        externalId: '1', // Используем числовой ID для совместимости с БД
        lastName: 'Test',
        firstName: 'User',
        role: UserRole.user,
        phoneNumber: phoneNumber,
        hashedPassword: 'test_hash',
      );
    });

    tearDown(() async {
      await database.close();
    });

    group('Database Operations', () {
      test('should create and retrieve route with points', () async {
        // Arrange
        final route = _createTestRoute(tradingPointId: 'tp_create_test');

        // Act - создаем маршрут
        final createResult = await repository.createRoute(route, testUser);

        // Assert - проверяем что создался успешно
        expect(createResult.isRight(), isTrue);
        final createdRoute = createResult.fold(
          (failure) => throw Exception('Failed to create route: $failure'),
          (route) => route,
        );

        // Act - получаем маршрут обратно
        final retrieveResult = await repository.getRouteById(createdRoute);

        // Assert - проверяем что данные корректные
        expect(retrieveResult.isRight(), isTrue);
        final retrievedRoute = retrieveResult.fold(
          (failure) => throw Exception('Failed to retrieve route: $failure'),
          (route) => route,
        );
        
        expect(retrievedRoute.id, equals(createdRoute.id));
        expect(retrievedRoute.name, equals(route.name));
        expect(retrievedRoute.pointsOfInterest.length, equals(3));
        expect(retrievedRoute.status, equals(RouteStatus.planned));
      });

      test('should update route status and track history', () async {
        // Arrange
        final route = _createTestRoute(tradingPointId: 'tp_update_test');
        
        // Act - создаем маршрут
        final createResult = await repository.createRoute(route, testUser);
        final createdRoute = createResult.fold(
          (failure) => throw Exception('Failed to create route: $failure'),
          (route) => route,
        );

        final updatedRoute = createdRoute.copyWith(status: RouteStatus.active);

        // Act - обновляем маршрут
        final updateResult = await repository.updateRoute(updatedRoute, testUser);

        // Assert - проверяем что обновилось
        expect(updateResult.isRight(), isTrue);
        final retrieveResult = await repository.getRouteById(createdRoute);
        expect(retrieveResult.isRight(), isTrue);
        final retrievedRoute = retrieveResult.fold(
          (failure) => throw Exception('Failed to retrieve route: $failure'),
          (route) => route,
        );
        
        expect(retrievedRoute.status, equals(RouteStatus.active));
      });

      test('should update point status with history tracking', () async {
        // Arrange
        final route = _createTestRoute(tradingPointId: 'tp_point_update_test');
        
        // Act - создаем маршрут
        final createResult = await repository.createRoute(route, testUser);
        final createdRoute = createResult.fold(
          (failure) => throw Exception('Failed to create route: $failure'),
          (route) => route,
        );
        
        final pointId = createdRoute.pointsOfInterest.first.id!;

        // Act - обновляем статус точки
        await repository.updatePointStatus(
          pointId: pointId,
          newStatus: VisitStatus.completed.name,
          changedBy: testUser.externalId,
          reason: 'Test update',
        );

        // Assert - проверяем что обновилось
        final retrieveResult = await repository.getRouteById(createdRoute);
        expect(retrieveResult.isRight(), isTrue);
        final updatedRoute = retrieveResult.fold(
          (failure) => throw Exception('Failed to retrieve route: $failure'),
          (route) => route,
        );
        final updatedPoint = updatedRoute.pointsOfInterest
            .firstWhere((p) => p.id == pointId);
        expect(updatedPoint.status, equals(VisitStatus.completed));
      });

      test('should delete route and cascade delete points', () async {
        // Arrange
        final route = _createTestRoute(tradingPointId: 'tp_delete_cascade_test');
        
        // Act - создаем маршрут
        final createResult = await repository.createRoute(route, testUser);
        final createdRoute = createResult.fold(
          (failure) => throw Exception('Failed to create route: $failure'),
          (route) => route,
        );

        // Act - удаляем маршрут
        await repository.deleteRoute(createdRoute);

        // Assert - проверяем что удалился
        final deletedResult = await repository.getRouteById(createdRoute);
        expect(deletedResult.isLeft(), isTrue);
      });
    });

    group('Reactive Streams', () {
      test('should watch user routes reactively and reflect changes', () async {
        // Arrange - подписываемся на поток
        final stream = repository.watchUserRoutes(testUser);
        final events = <List<Route>>[];
        final subscription = stream.listen(events.add);
        
        // Ждем первое событие (база пуста)
        await Future.delayed(const Duration(milliseconds: 100));
        expect(events.length, greaterThanOrEqualTo(1));
        expect(events.last, isEmpty);
        
        // Act - создаем первый маршрут
        final route1 = _createTestRoute(name: 'Reactive Route 1', tradingPointId: 'tp_reactive_1');
        await repository.createRoute(route1, testUser);
        
        // Ждем событие
        await Future.delayed(const Duration(milliseconds: 100));
        expect(events.last.length, equals(1));
        expect(events.last.first.name, equals('Reactive Route 1'));
        
        // Act - создаем второй маршрут
        final route2 = _createTestRoute(name: 'Reactive Route 2', tradingPointId: 'tp_reactive_2');
        await repository.createRoute(route2, testUser);
        
        // Ждем событие
        await Future.delayed(const Duration(milliseconds: 100));
        expect(events.last.length, equals(2));
        
        await subscription.cancel();
      });
    });

    group('Trading Points Integration', () {
      test('should save and link trading points correctly', () async {
        // Arrange
        final tradingPoint = TradingPoint(
          externalId: 'ext_001',
          name: 'Торговая точка Рога и Копыта',
          inn: '1234567890',
        );

        final route = Route(
          name: 'Test Route',
          pointsOfInterest: [
            TradingPointOfInterest(
              name: 'Визит к клиенту',
              tradingPoint: tradingPoint,
              coordinates: const LatLng(55.7558, 37.6176),
            ),
          ],
        );

        // Act - создаем маршрут
        final createResult = await repository.createRoute(route, testUser);
        final createdRoute = createResult.fold(
          (failure) => throw Exception('Failed to create route: $failure'),
          (route) => route,
        );

        // Assert - проверяем что торговая точка сохранилась
        final savedTradingPoint = await database.getTradingPoint('ext_001');
        expect(savedTradingPoint, isNotNull);
        expect(savedTradingPoint!.name, equals(tradingPoint.name));
        expect(savedTradingPoint.inn, equals(tradingPoint.inn));

        // Assert - проверяем связь с точкой интереса
        final retrieveResult = await repository.getRouteById(createdRoute);
        expect(retrieveResult.isRight(), isTrue);
        final retrievedRoute = retrieveResult.fold(
          (failure) => throw Exception('Failed to retrieve route: $failure'),
          (route) => route,
        );
        final point = retrievedRoute.pointsOfInterest.first as TradingPointOfInterest;
        expect(point.tradingPoint.externalId, equals('ext_001'));
      });
    });

    group('Data Mapping', () {
      test('should correctly map domain entities to database and back', () async {
        // Arrange
        final originalRoute = _createTestRoute(tradingPointId: 'tp_trading_test');

        // Act - сохраняем и загружаем
        final createResult = await repository.createRoute(originalRoute, testUser);
        final createdRoute = createResult.fold(
          (failure) => throw Exception('Failed to create route: $failure'),
          (route) => route,
        );
        
        final retrieveResult = await repository.getRouteById(createdRoute);
        expect(retrieveResult.isRight(), isTrue);
        final retrievedRoute = retrieveResult.fold(
          (failure) => throw Exception('Failed to retrieve route: $failure'),
          (route) => route,
        );

        // Assert - проверяем что все поля корректно mapped
        expect(retrievedRoute.id, equals(createdRoute.id));
        expect(retrievedRoute.name, equals(originalRoute.name));
        expect(retrievedRoute.description, equals(originalRoute.description));
        // DateTime comparison with second precision (DB не хранит микросекунды/миллисекунды)
        expect(
          retrievedRoute.createdAt.millisecondsSinceEpoch ~/ 1000,
          equals(originalRoute.createdAt.millisecondsSinceEpoch ~/ 1000),
        );
        expect(retrievedRoute.status, equals(originalRoute.status));
        expect(retrievedRoute.pointsOfInterest.length, 
               equals(originalRoute.pointsOfInterest.length));

        // Проверяем точки
        for (int i = 0; i < originalRoute.pointsOfInterest.length; i++) {
          final original = originalRoute.pointsOfInterest[i];
          final retrieved = retrievedRoute.pointsOfInterest[i];
          
          expect(retrieved.id, isNotNull);
          expect(retrieved.displayName, equals(original.displayName));
          expect(retrieved.coordinates.latitude, 
                 closeTo(original.coordinates.latitude, 0.000001));
          expect(retrieved.coordinates.longitude, 
                 closeTo(original.coordinates.longitude, 0.000001));
          expect(retrieved.type, equals(original.type));
          expect(retrieved.status, equals(original.status));
        }
      });
    });

    group('Complex Queries', () {
      // TODO: Реализовать getUserRouteStats в репозитории
      // test('should get route stats correctly', () async {
      //   // Arrange
      //   const userId = 'test_user';
      //   final route1 = _createTestRoute(id: 'r1', status: RouteStatus.completed);
      //   final route2 = _createTestRoute(id: 'r2', status: RouteStatus.active);
      //   final route3 = _createTestRoute(id: 'r3', status: RouteStatus.planned);

      //   await repository.createRoute(route1, testUser);
      //   await repository.createRoute(route2, testUser);
      //   await repository.createRoute(route3, testUser);

      //   // Act
      //   final stats = await repository.getUserRouteStats(userId);

      //   // Assert
      //   expect(stats.totalRoutes, equals(3));
      //   expect(stats.statusCounts['completed'], equals(1));
      //   expect(stats.statusCounts['active'], equals(1));
      //   expect(stats.statusCounts['planned'], equals(1));
      // });
    });
  });
}

/// Создает тестовый маршрут с разными типами точек
Route _createTestRoute({
  String name = 'Test Route',
  RouteStatus status = RouteStatus.planned,
  String tradingPointId = 'client_001', // Уникальный ID для торговой точки
}) {
  return Route(
    // НЕ устанавливаем id - пусть база данных сама создаст autoincrement
    name: name,
    description: 'Test route description',
    status: status,
    pointsOfInterest: [
      // Обычная точка (склад)
      RegularPointOfInterest(
        name: 'Склад отправления',
        description: 'Главный склад компании',
        coordinates: const LatLng(55.7558, 37.6176), // Москва
        type: PointType.warehouse,
        status: VisitStatus.planned,
      ),
      
      // Торговая точка (клиент) - используем уникальный ID
      TradingPointOfInterest(
        name: 'Визит к клиенту',
        tradingPoint: TradingPoint(
          externalId: tradingPointId, // Уникальный ID для каждого теста
          name: 'ООО "Рога и Копыта ($tradingPointId)"',
          inn: '1234567890',
        ),
        coordinates: const LatLng(55.7512, 37.6184), // Красная площадь
        status: VisitStatus.planned,
      ),
      
      // Еще одна обычная точка
      RegularPointOfInterest(
        name: 'Точка доставки',
        description: 'Пункт выдачи заказов',
        coordinates: const LatLng(55.7539, 37.6208), // Кремль
        type: PointType.regular,
        status: VisitStatus.planned,
      ),
    ],
  );
}
