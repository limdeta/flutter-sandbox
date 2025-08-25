import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get_it/get_it.dart';
import 'package:tauzero/app/config/app_config.dart';
import 'package:tauzero/features/app/database/app_database.dart';
import 'package:tauzero/features/navigation/tracking/data/fixtures/track_fixtures.dart';
import 'package:tauzero/features/shop/route/data/fixtures/route_fixture_service.dart';
import 'package:tauzero/features/shop/route/data/repositories/route_repository_drift.dart';
import 'package:tauzero/features/shop/route/domain/repositories/route_repository.dart';
import 'package:tauzero/features/authentication/data/fixtures/user_fixture_service.dart';
import 'package:tauzero/features/authentication/data/repositories/user_repository_impl.dart';
import 'package:tauzero/features/authentication/domain/repositories/user_repository.dart';
import 'package:tauzero/app/infra/database/repositories/user_track_repository_drift.dart';
import 'package:tauzero/features/navigation/tracking/domain/repositories/user_track_repository.dart';

void main() {
  group('Dev Infrastructure Tests', () {
    test('должен создать трек с привязкой к маршруту из реальных GPS данных', () async {
      // Инициализация Flutter bindings для тестов
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Установка dev окружения
      AppConfig.setEnvironment(Environment.dev);
      
      // Очистка GetIt
      await GetIt.instance.reset();
      
      // Создание in-memory базы данных для теста
      final database = AppDatabase.forTesting(drift.DatabaseConnection(NativeDatabase.memory()));
      GetIt.instance.registerSingleton<AppDatabase>(database);
      
      // Регистрация зависимостей
      final userRepository = UserRepository(database: database);
      final routeRepository = RouteRepository(database);
      final trackRepository = UserTrackRepository(database, userRepository, routeRepository);
      
      GetIt.instance.registerSingleton<IUserRepository>(userRepository);
      GetIt.instance.registerSingleton<IRouteRepository>(routeRepository);
      GetIt.instance.registerSingleton<IUserTrackRepository>(trackRepository);
      
      // Создание тестового пользователя
      final userFixtureService = UserFixtureService(userRepository);
      final testUser = await userFixtureService.createSalesRep(
        name: 'Тестовый Пользователь',
        email: 'test@example.com',
        phone: '+7-999-123-4567',
      );
      
      // Создание тестового маршрута
      final routeFixtureService = RouteFixtureService(routeRepository);
      await routeFixtureService.createDevFixtures(testUser);
      
      // Получение созданного маршрута (должен быть активный)
      final routesStream = routeRepository.watchUserRoutes(testUser);
      final routes = await routesStream.first;
      final todayRoute = routes.firstWhere((route) => route.status.name == 'active');
      
      // Создание трека с реальными GPS данными
      final userTrack = await TrackFixtures.createCurrentDayTrack(
        user: testUser,
        route: todayRoute,
      );
      
      // Проверка результата
      expect(userTrack, isNotNull, reason: 'Трек должен быть создан');
      expect(userTrack!.route?.id, equals(todayRoute.id), reason: 'Трек должен быть привязан к маршруту');
      expect(userTrack.totalPoints, greaterThan(400), reason: 'Должно быть много GPS точек из OSRM файла');
      expect(userTrack.totalDistanceKm, greaterThan(5), reason: 'Дистанция должна быть разумной');
      
      print('✅ Тест успешно выполнен:');
      print('   Пользователь: ${testUser.fullName}');
      print('   Маршрут: ${todayRoute.name} (ID: ${todayRoute.id})');
      print('   Трек: ${userTrack.totalPoints} GPS точек, ${userTrack.totalDistanceKm.toStringAsFixed(2)} км');
      print('   Статус трека: ${userTrack.status.name}');
      print('   Привязан к маршруту: ${userTrack.route?.id == todayRoute.id ? "ДА" : "НЕТ"}');
    });
  });
}
