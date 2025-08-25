import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get_it/get_it.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/features/app/database/app_database.dart';
import 'package:tauzero/features/shop/route/data/fixtures/route_fixture_service.dart';
import 'package:tauzero/features/shop/route/data/repositories/route_repository_drift.dart';
import 'package:tauzero/features/shop/route/domain/entities/point_of_interest.dart';
import 'package:tauzero/features/shop/route/domain/entities/regular_point_of_interest.dart';
import 'package:tauzero/features/shop/route/domain/entities/route.dart';
import 'package:tauzero/features/shop/route/domain/entities/trading_point_of_interest.dart';
import 'package:tauzero/features/shop/route/domain/repositories/route_repository.dart';


/// Интеграционный тест для проверки создания dev фикстур
/// 
/// Этот тест проверяет весь процесс создания реалистичных данных:
/// - Создание базы данных в памяти
/// - Регистрация зависимостей
/// - Создание фикстур без ошибок
/// - Валидация созданных данных
/// - Проверка бизнес-логики (завершенность, статусы и т.д.)
void main() {
  group('DevFixtures Integration Tests', () {

    late AppDatabase database;
    late IRouteRepository repository;
    late RouteFixtureService fixtureService;

    final phoneResult = PhoneNumber.create('+79991234567');
    late User testUser;

    setUp(() async {
      // Очищаем GetIt перед каждым тестом
      await GetIt.instance.reset();

      // Создаем чистую in-memory базу для каждого теста
      database = AppDatabase.forTesting(drift.DatabaseConnection(NativeDatabase.memory()));
      repository = RouteRepository(database);
      fixtureService = RouteFixtureService(repository);

      // Получаем phoneNumber из Either (или кидаем исключение для теста)
      final phoneNumber = phoneResult.fold(
        (failure) => throw Exception('Phone number invalid: $failure'),
        (value) => value,
      );

      testUser = User(
        externalId: 'test-user-1',
        lastName: 'Иванов',
        firstName: 'Тест',
        middleName: 'Тестович',
        role: UserRole.user,
        phoneNumber: phoneNumber,
        hashedPassword: 'test_hash',
      );

      // Регистрируем в DI для совместимости
      GetIt.instance.registerSingleton<AppDatabase>(database);
      GetIt.instance.registerSingleton<IRouteRepository>(repository);
    });

    test('должен создать dev фикстуры без ошибок', () async {
      // Act - создаем фикстуры
      await fixtureService.createDevFixtures(testUser);
      
      // Assert - проверяем что создались маршруты
      final routes = await repository.watchUserRoutes(testUser).first;
      
      expect(routes, isNotEmpty, reason: 'Должны быть созданы маршруты');
      expect(routes.length, equals(2), reason: 'Должно быть ровно 2 маршрута (вчера + сегодня)');
    });

    test('должен создать корректные вчерашний и сегодняшний маршруты', () async {
      // Act
      await fixtureService.createDevFixtures(testUser);
      final routes = await repository.watchUserRoutes(testUser).first;
      
      // Assert - проверяем структуру маршрутов
      expect(routes.length, equals(2));
      // Проверяем что id у маршрутов — int и не null
      for (final route in routes) {
        expect(route.id, isNotNull, reason: 'id маршрута не должен быть null');
        expect(route.id, isA<int>(), reason: 'id маршрута должен быть int');
        for (final point in route.pointsOfInterest) {
          expect(point.id, isNotNull, reason: 'id точки интереса не должен быть null');
          expect(point.id, isA<int>(), reason: 'id точки интереса должен быть int');
        }
      }
      // Найдем вчерашний и сегодняшний маршруты
      final yesterdayRoute = routes.firstWhere((r) => r.name.contains('Маршрут от'));
      final todayRoute = routes.firstWhere((r) => r.name.contains('Текущий'));
      
      // Проверяем вчерашний маршрут
      expect(yesterdayRoute.status, equals(RouteStatus.completed), 
          reason: 'Вчерашний маршрут должен быть завершен');
      expect(yesterdayRoute.startTime, isNotNull, 
          reason: 'Вчерашний маршрут должен иметь время начала');
      expect(yesterdayRoute.endTime, isNotNull, 
          reason: 'Вчерашний маршрут должен иметь время окончания');
      expect(yesterdayRoute.completionPercentage, greaterThan(0.7), 
          reason: 'Вчерашний маршрут должен быть завершен > 70%');
      
      // Проверяем сегодняшний маршрут
      expect(todayRoute.status, equals(RouteStatus.active), 
          reason: 'Сегодняшний маршрут должен быть активен');
      expect(todayRoute.startTime, isNotNull, 
          reason: 'Сегодняшний маршрут должен иметь время начала');
      expect(todayRoute.endTime, isNull, 
          reason: 'Сегодняшний маршрут не должен иметь время окончания');
      expect(todayRoute.completionPercentage, lessThan(0.7), 
          reason: 'Сегодняшний маршрут должен быть завершен < 70%');
    });

    test('должен создать точки интереса с корректными статусами', () async {
      // Act
      await fixtureService.createDevFixtures(testUser);
      final routes = await repository.watchUserRoutes(testUser).first;
      
      // Assert - проверяем точки интереса
      for (final route in routes) {
        expect(route.pointsOfInterest, isNotEmpty, 
            reason: 'Каждый маршрут должен иметь точки интереса');
        
        // Проверяем что есть разные типы точек
        final hasTrading = route.pointsOfInterest.any((p) => p is TradingPointOfInterest);
        final hasRegular = route.pointsOfInterest.any((p) => p is RegularPointOfInterest);
        
        expect(hasTrading, isTrue, reason: 'Должны быть торговые точки');
        expect(hasRegular, isTrue, reason: 'Должны быть обычные точки (заправки, кафе)');
        
        // Проверяем статусы
        final processedCount = route.pointsOfInterest.where((p) => 
            p.isVisited || p.status == VisitStatus.skipped).length;
        final totalCount = route.pointsOfInterest.length;
        final actualCompletion = processedCount / totalCount;
        
        expect((route.completionPercentage - actualCompletion).abs(), lessThan(0.01), 
            reason: 'Процент завершенности должен соответствовать реальным данным');
      }
    });

    test('должен корректно обрабатывать повторное создание фикстур', () async {
      // Act - создаем фикстуры дважды
      await fixtureService.createDevFixtures(testUser);
      final routesFirst = await repository.watchUserRoutes(testUser).first;
      
      await fixtureService.createDevFixtures(testUser);
      final routesSecond = await repository.watchUserRoutes(testUser).first;
      
      // Assert - должно быть одинаковое количество (старые удаляются)
      expect(routesFirst.length, equals(routesSecond.length));
      expect(routesSecond.length, equals(2), 
          reason: 'После повторного создания должно быть 2 маршрута');
    });

    test('должен создать уникальные ID для всех сущностей', () async {
      // Act
      await fixtureService.createDevFixtures(testUser);
      final routes = await repository.watchUserRoutes(testUser).first;
      
      // Assert - проверяем уникальность ID маршрутов
      final routeIds = routes.map((r) => r.id).toList();
      expect(routeIds.toSet().length, equals(routeIds.length), 
          reason: 'ID маршрутов должны быть уникальными');
      
      // Проверяем уникальность ID точек интереса
      final allPointIds = <String>[];
      for (final route in routes) {
        for (final point in route.pointsOfInterest) {
          allPointIds.add(point.id?.toString() ?? '');
        }
      }
      expect(allPointIds.toSet().length, equals(allPointIds.length), 
          reason: 'ID точек интереса должны быть уникальными');
    });

    test('должен создать реалистичные координаты Владивостока', () async {
      // Act
      await fixtureService.createDevFixtures(testUser);
      final routes = await repository.watchUserRoutes(testUser).first;
      
      // Assert - проверяем координаты
      const vladivostokLatMin = 43.0;
      const vladivostokLatMax = 43.3;
      const vladivostokLngMin = 131.8;
      const vladivostokLngMax = 132.1;
      
      for (final route in routes) {
        for (final point in route.pointsOfInterest) {
          expect(point.coordinates.latitude, 
              inInclusiveRange(vladivostokLatMin, vladivostokLatMax),
              reason: 'Широта должна быть в пределах Владивостока');
          expect(point.coordinates.longitude, 
              inInclusiveRange(vladivostokLngMin, vladivostokLngMax),
              reason: 'Долгота должна быть в пределах Владивостока');
        }
      }
    });

    test('должен создать торговые точки с валидными данными', () async {
      // Act
      await fixtureService.createDevFixtures(testUser);
      final routes = await repository.watchUserRoutes(testUser).first;
      
      // Assert - проверяем торговые точки
      final allTradingPoints = <TradingPointOfInterest>[];
      for (final route in routes) {
        allTradingPoints.addAll(
          route.pointsOfInterest.whereType<TradingPointOfInterest>()
        );
      }
      
      expect(allTradingPoints, isNotEmpty, reason: 'Должны быть торговые точки');
      
      for (final tradingPoint in allTradingPoints) {
        expect(tradingPoint.tradingPoint.name, isNotEmpty, 
            reason: 'Торговая точка должна иметь название');
        expect(tradingPoint.tradingPoint.externalId, isNotEmpty, 
            reason: 'Торговая точка должна иметь external ID');
      }
    });

    group('Performance Tests', () {
      test('создание фикстур должно завершаться быстро', () async {
        final stopwatch = Stopwatch()..start();
        
        // Act
        await fixtureService.createDevFixtures(testUser);
        
        stopwatch.stop();
        
        // Assert - должно быть быстрее 5 секунд
        expect(stopwatch.elapsedMilliseconds, lessThan(5000), 
            reason: 'Создание фикстур должно быть быстрым');
      });
    });
  });
}
