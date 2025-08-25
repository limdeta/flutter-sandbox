import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get_it/get_it.dart';
import 'package:tauzero/features/app/database/app_database.dart';
import 'package:tauzero/features/shop/route/data/repositories/route_repository_drift.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'factories/user_factory.dart';

/// Помощник для создания изолированной тестовой среды
/// 
/// Обеспечивает чистую базу данных для каждого теста
/// и предоставляет готовые зависимости
class TestDatabaseHelper {
  late AppDatabase database;
  late RouteRepository repository;
  late User testUser;

  /// Инициализация чистой тестовой среды
  Future<void> setUp() async {
    // Очищаем GetIt перед каждым тестом
    if (GetIt.instance.isRegistered<AppDatabase>()) {
      await GetIt.instance.unregister<AppDatabase>();
    }
    
    // Создаем чистую in-memory базу для каждого теста
    database = AppDatabase.forTesting(drift.DatabaseConnection(NativeDatabase.memory()));
    
    // Регистрируем базу данных в GetIt для mapper'ов
    GetIt.instance.registerSingleton<AppDatabase>(database);
    
    repository = RouteRepository(database);
    
    // Создаем тестового пользователя с предсказуемыми данными
    testUser = UserFactory()
      .externalId('1') // Используем числовой ID для совместимости с БД
      .firstName('Тест')
      .lastName('Пользователь')
      .build();
  }

  /// Очистка после теста
  Future<void> tearDown() async {
    await database.close();
    
    // Очищаем GetIt после теста
    if (GetIt.instance.isRegistered<AppDatabase>()) {
      await GetIt.instance.unregister<AppDatabase>();
    }
  }

  /// Создает дополнительного пользователя для тестов с несколькими пользователями
  User createSecondUser() {
    return UserFactory()
      .externalId('2') // Используем числовой ID для совместимости с БД
      .firstName('Второй')
      .lastName('Пользователь')
      .build();
  }

  /// Создает пользователя с определенным ID (для связанных тестов)
  User createUserWithId(String id) {
    return UserFactory()
      .externalId(id)
      .build();
  }

  /// Сброс фабрик (для предсказуемости тестов)
  void resetFactories() {
    UserFactory.resetCounter();
  }
}

/// Extension для удобного использования в тестах
extension TestDatabaseHelperExtension on TestDatabaseHelper {
  /// Быстрая проверка что база данных пуста
  Future<void> expectEmptyDatabase() async {
    final routes = await repository.watchUserRoutes(testUser).first;
    expect(routes, isEmpty, reason: 'База данных должна быть пустой');
  }

  /// Быстрая проверка количества маршрутов
  Future<void> expectRouteCount(int expectedCount) async {
    final routes = await repository.watchUserRoutes(testUser).first;
    expect(routes.length, equals(expectedCount), 
        reason: 'Ожидается $expectedCount маршрутов');
  }
}
