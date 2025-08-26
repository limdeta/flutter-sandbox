import 'package:flutter_test/flutter_test.dart';
import 'package:tauzero/features/shop/route/domain/entities/route.dart';
import 'package:tauzero/features/shop/domain/entities/point_of_interest.dart';
import 'package:tauzero/features/shop/route/domain/entities/trading_point_of_interest.dart';
import 'package:tauzero/shared/either.dart';

import '../../../helpers/test_database_helper.dart';
import '../../../helpers/factories/route_factory.dart';

/// Интеграционные тесты репозитория маршрутов
/// 
/// Использует лучшие практики Flutter/Dart тестирования:
/// - Каждый тест изолирован с чистой базой данных
/// - Фабрики для создания тестовых данных
/// - Группировка по функциональности
/// - Понятные имена тестов в стиле BDD
/// - Подготовка к переходу на полноценный BDD
void main() {
  group('RouteRepository Integration Tests', () {
    final dbHelper = TestDatabaseHelper();

    setUp(() async {
      await dbHelper.setUp();
      dbHelper.resetFactories(); // Обеспечиваем предсказуемость
    });

    tearDown(() async {
      await dbHelper.tearDown();
    });

    group('Создание маршрутов', () {
      test('должен успешно создать простой маршрут', () async {
        // Given: простой тестовый маршрут
        final route = RouteFactory.createSimple();
        
        // When: создаем маршрут в репозитории
        final result = await dbHelper.repository.createRoute(route, dbHelper.testUser);
        
        // Then: маршрут должен быть создан успешно
        expect(result.isRight(), isTrue);
        
        final createdRoute = result.fold(
          (failure) => throw Exception('Неожиданная ошибка: ${failure.message}'),
          (route) => route,
        );
        
        expect(createdRoute.id, isNotNull);
        expect(createdRoute.name, equals(route.name));
        expect(createdRoute.status, equals(RouteStatus.planned));
        expect(createdRoute.pointsOfInterest.length, equals(3));
        
        // Проверяем что ID точек установлены
        for (final point in createdRoute.pointsOfInterest) {
          expect(point.id, isNotNull, reason: 'ID точки должен быть установлен');
        }
      });

      test('должен создать маршрут с торговыми точками и правильно связать их', () async {
        // Given: маршрут только с торговыми точками
        final route = RouteFactory.createTradingOnly();
        
        // When: создаем маршрут
        final result = await dbHelper.repository.createRoute(route, dbHelper.testUser);
        
        // Then: торговые точки должны быть правильно сохранены и связаны
        expect(result.isRight(), isTrue);
        
        final createdRoute = result.getRight();
        expect(createdRoute.pointsOfInterest.length, equals(3));
        
        // Проверяем что все точки - торговые
        for (final point in createdRoute.pointsOfInterest) {
          expect(point, isA<TradingPointOfInterest>());
          final tradingPoint = point as TradingPointOfInterest;
          expect(tradingPoint.tradingPoint.externalId, isNotEmpty);
          expect(tradingPoint.tradingPoint.name, isNotEmpty);
        }
      });

      test('должен создать уникальные ID для всех сущностей', () async {
        // Given: два разных маршрута
        final route1 = RouteFactory.createWithPrefix('first');
        final route2 = RouteFactory.createWithPrefix('second');
        
        // When: создаем оба маршрута
        final result1 = await dbHelper.repository.createRoute(route1, dbHelper.testUser);
        final result2 = await dbHelper.repository.createRoute(route2, dbHelper.testUser);
        
        // Then: все ID должны быть уникальными
        expect(result1.isRight(), isTrue);
        expect(result2.isRight(), isTrue);
        
        final createdRoute1 = result1.getRight();
        final createdRoute2 = result2.getRight();
        
        // ID маршрутов разные
        expect(createdRoute1.id, isNot(equals(createdRoute2.id)));
        
        // ID точек разные
        final allPointIds = <int>[];
        for (final point in [...createdRoute1.pointsOfInterest, ...createdRoute2.pointsOfInterest]) {
          expect(point.id, isNotNull);
          expect(allPointIds, isNot(contains(point.id)));
          allPointIds.add(point.id);
        }
      });
    });

    group('Получение маршрутов', () {
      test('должен получить маршрут по ID с полными данными', () async {
        // Given: созданный маршрут
        final originalRoute = RouteFactory.createSimple();
        final createResult = await dbHelper.repository.createRoute(originalRoute, dbHelper.testUser);
        final createdRoute = createResult.getRight();
        
        // When: получаем маршрут по ID
        final result = await dbHelper.repository.getRouteById(createdRoute);
        
        // Then: должны получить полные данные
        expect(result.isRight(), isTrue);
        
        final retrievedRoute = result.getRight();
        expect(retrievedRoute.id, equals(createdRoute.id));
        expect(retrievedRoute.name, equals(originalRoute.name));
        expect(retrievedRoute.description, equals(originalRoute.description));
        expect(retrievedRoute.status, equals(originalRoute.status));
        expect(retrievedRoute.pointsOfInterest.length, equals(originalRoute.pointsOfInterest.length));
        
        // Проверяем что время сохранилось с точностью до секунд
        expect(
          retrievedRoute.createdAt.millisecondsSinceEpoch ~/ 1000,
          equals(originalRoute.createdAt.millisecondsSinceEpoch ~/ 1000),
        );
      });

      test('должен вернуть ошибку для несуществующего маршрута', () async {
        // Given: несуществующий маршрут
        final nonExistentRoute = RouteFactory.createSimple().copyWith(id: 99999);
        
        // When: пытаемся получить несуществующий маршрут
        final result = await dbHelper.repository.getRouteById(nonExistentRoute);
        
        // Then: должна быть ошибка NotFound
        expect(result.isLeft(), isTrue);
      });
    });

    group('Обновление маршрутов', () {
      test('должен обновить статус маршрута', () async {
        // Given: созданный маршрут
        final route = RouteFactory.createSimple();
        final createResult = await dbHelper.repository.createRoute(route, dbHelper.testUser);
        final createdRoute = createResult.getRight();
        
        // When: обновляем статус на "активный"
        final updatedRoute = createdRoute.copyWith(status: RouteStatus.active);
        final updateResult = await dbHelper.repository.updateRoute(updatedRoute, dbHelper.testUser);
        
        // Then: статус должен быть обновлен
        expect(updateResult.isRight(), isTrue);
        
        final retrieveResult = await dbHelper.repository.getRouteById(createdRoute);
        final retrievedRoute = retrieveResult.getRight();
        
        expect(retrievedRoute.status, equals(RouteStatus.active));
      });

      test('должен обновить точки маршрута', () async {
        // Given: маршрут с начальными точками
        final route = RouteFactory.createSimple();
        final createResult = await dbHelper.repository.createRoute(route, dbHelper.testUser);
        final createdRoute = createResult.getRight();
        
        // When: обновляем маршрут с новыми точками
        final newPoints = [
          PointFactory.createWarehouse(1),
          PointFactory.createTradingPointWithId('updated_tp'),
        ];
        final updatedRoute = createdRoute.copyWith(pointsOfInterest: newPoints);
        final updateResult = await dbHelper.repository.updateRoute(updatedRoute, dbHelper.testUser);
        
        // Then: точки должны быть обновлены
        expect(updateResult.isRight(), isTrue);
        
        final retrieveResult = await dbHelper.repository.getRouteById(createdRoute);
        final retrievedRoute = retrieveResult.getRight();
        
        expect(retrievedRoute.pointsOfInterest.length, equals(2));
      });
    });

    group('Удаление маршрутов', () {
      test('должен удалить маршрут и связанные точки', () async {
        // Given: созданный маршрут
        final route = RouteFactory.createSimple();
        final createResult = await dbHelper.repository.createRoute(route, dbHelper.testUser);
        final createdRoute = createResult.getRight();
        
        // When: удаляем маршрут
        await dbHelper.repository.deleteRoute(createdRoute);
        
        // Then: маршрут должен быть удален
        final retrieveResult = await dbHelper.repository.getRouteById(createdRoute);
        expect(retrieveResult.isLeft(), isTrue);
        
        // И база данных должна быть пуста
        await dbHelper.expectEmptyDatabase();
      });
    });

    group('Работа с точками интереса', () {
      test('должен обновить статус точки', () async {
        // Given: маршрут с точками
        final route = RouteFactory.createSimple();
        final createResult = await dbHelper.repository.createRoute(route, dbHelper.testUser);
        final createdRoute = createResult.getRight();
        final firstPoint = createdRoute.pointsOfInterest.first;
        
        // When: обновляем статус первой точки
        await dbHelper.repository.updatePointStatus(
          pointId: firstPoint.id!,
          newStatus: VisitStatus.completed.name,
          changedBy: dbHelper.testUser.externalId,
          reason: 'Тестовое обновление',
        );
        
        // Then: статус точки должен быть обновлен
        final retrieveResult = await dbHelper.repository.getRouteById(createdRoute);
        final updatedRoute = retrieveResult.getRight();
        final updatedPoint = updatedRoute.pointsOfInterest
            .firstWhere((p) => p.id == firstPoint.id);
        
        expect(updatedPoint.status, equals(VisitStatus.completed));
      });
    });

    group('Реактивные потоки', () {
      test('должен отслеживать изменения маршрутов пользователя', () async {
        // Given: поток маршрутов пользователя
        final stream = dbHelper.repository.watchUserRoutes(dbHelper.testUser);
        final events = <List<Route>>[];
        
        // Подписываемся на поток
        final subscription = stream.listen(events.add);
        
        // Ждем первое событие (пустой список)
        await Future.delayed(const Duration(milliseconds: 100));
        
        // When: создаем первый маршрут
        final route1 = RouteFactory.createWithPrefix('stream_test_1');
        await dbHelper.repository.createRoute(route1, dbHelper.testUser);
        
        // Ждем событие
        await Future.delayed(const Duration(milliseconds: 100));
        
        // When: создаем второй маршрут
        final route2 = RouteFactory.createWithPrefix('stream_test_2');
        await dbHelper.repository.createRoute(route2, dbHelper.testUser);
        
        // Ждем событие
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Then: должны быть корректные события
        expect(events.length, greaterThanOrEqualTo(3));
        expect(events.first, isEmpty); // Начинаем с пустого списка
        expect(events[1].length, equals(1)); // После первого маршрута
        expect(events[2].length, equals(2)); // После второго маршрута
        
        await subscription.cancel();
      });
    });

    group('Многопользовательская работа', () {
      test('должен изолировать маршруты между пользователями', () async {
        // Given: два разных пользователя
        final user1 = dbHelper.testUser;
        final user2 = dbHelper.createSecondUser();
        
        // When: каждый создает свой маршрут
        final route1 = RouteFactory.createWithPrefix('user1');
        final route2 = RouteFactory.createWithPrefix('user2');
        
        await dbHelper.repository.createRoute(route1, user1);
        await dbHelper.repository.createRoute(route2, user2);
        
        // Then: каждый видит только свои маршруты
        final user1Routes = await dbHelper.repository.watchUserRoutes(user1).first;
        final user2Routes = await dbHelper.repository.watchUserRoutes(user2).first;
        
        expect(user1Routes.length, equals(1));
        expect(user2Routes.length, equals(1));
        expect(user1Routes.first.name, contains('user1'));
        expect(user2Routes.first.name, contains('user2'));
      });
    });

    group('Граничные случаи', () {
      test('должен корректно обработать пустой маршрут', () async {
        // Given: маршрут без точек
        final emptyRoute = RouteFactory.createEmpty();
        
        // When: создаем пустой маршрут
        final result = await dbHelper.repository.createRoute(emptyRoute, dbHelper.testUser);
        
        // Then: маршрут должен быть создан
        expect(result.isRight(), isTrue);
        
        final createdRoute = result.getRight();
        expect(createdRoute.pointsOfInterest, isEmpty);
        expect(createdRoute.completionPercentage, equals(0.0));
      });

      test('должен корректно обработать повторное создание торговых точек', () async {
        // Given: два маршрута с одинаковыми торговыми точками
        final route1 = RouteFactory()
          .name('Первый маршрут')
          .addPoint(PointFactory.createTradingPointWithId('same_tp'))
          .build();
          
        final route2 = RouteFactory()
          .name('Второй маршрут')
          .addPoint(PointFactory.createTradingPointWithId('same_tp'))
          .build();
        
        // When: создаем оба маршрута
        final result1 = await dbHelper.repository.createRoute(route1, dbHelper.testUser);
        final result2 = await dbHelper.repository.createRoute(route2, dbHelper.testUser);
        
        // Then: оба должны быть созданы успешно (торговая точка переиспользуется)
        expect(result1.isRight(), isTrue);
        expect(result2.isRight(), isTrue);
        
        await dbHelper.expectRouteCount(2);
      });
    });
  });
}

/// Extension для удобства работы с Either в тестах
extension EitherTestExtensions<L, R> on Either<L, R> {
  R getRight() {
    return fold(
      (left) => throw Exception('Ожидался Right, получен Left: $left'),
      (right) => right,
    );
  }
  
  L getLeft() {
    return fold(
      (left) => left,
      (right) => throw Exception('Ожидался Left, получен Right: $right'),
    );
  }
}
