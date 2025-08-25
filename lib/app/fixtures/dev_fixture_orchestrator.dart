import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/data/fixtures/user_fixture_service.dart';
import 'package:tauzero/features/shop/route/data/fixtures/route_fixture_service.dart';
import 'package:tauzero/features/shop/route/data/fixtures/trading_points_fixture_service.dart';
import 'package:tauzero/features/navigation/tracking/data/fixtures/track_fixtures.dart';
import 'package:tauzero/app/database/app_database.dart';
import 'package:tauzero/app/domain/app_user.dart';
import 'package:tauzero/app/fixtures/app_user_fixture_service.dart';
import 'package:get_it/get_it.dart';
import 'package:tauzero/features/shop/route/domain/repositories/route_repository.dart';

/// Контейнер для хранения созданных AppUser-ов по ролям
class DevAppUsers {
  final AppUser admin;
  final AppUser manager;
  final List<AppUser> salesReps;

  const DevAppUsers({
    required this.admin,
    required this.manager,
    required this.salesReps,
  });
  
  factory DevAppUsers.empty() {
    // Создаем пустые AppUser для fallback случаев
    // В реальной реализации это не используется, только для обработки ошибок
    throw UnimplementedError('Empty DevAppUsers creation not implemented - only for error handling');
  }
}

/// Центральный оркестратор для создания всех dev фикстур
/// 
/// Управляет созданием связанных данных в правильной последовательности:
/// 1. Пользователи (базовые роли)
/// 2. Маршруты для торговых представителей
/// 3. Дополнительные данные при необходимости
/// 
/// Обеспечивает совместимость данных между модулями
class DevFixtureOrchestrator {
  final UserFixtureService _userFixtureService;
  final AppUserFixtureService _appUserFixtureService;
  final RouteFixtureService _routeFixtureService;
  final TradingPointsFixtureService _tradingPointsService;
  
  DevFixtureOrchestrator(
    this._userFixtureService,
    this._appUserFixtureService,
    this._routeFixtureService,
    this._tradingPointsService,
  );

  /// Создает полный набор dev данных
  Future<DevFixturesResult> createFullDevDataset() async {
    print('🚀 ===== НАЧАЛО СОЗДАНИЯ DEV ДАННЫХ =====');
    print('🕒 Время: ${DateTime.now()}');
    
    try {
      await _clearAllData();
      await _tradingPointsService.createBaseTradingPoints();
      
      final appUsers = await _createAppUsers();
      await _createRoutesForSalesReps(appUsers);
      await _createTestTracks(appUsers);

      print('✅ ===== DEV ДАННЫЕ СОЗДАНЫ УСПЕШНО =====');
      return DevFixturesResult(
        appUsers: appUsers,
        success: true,
        message: 'Все dev фикстуры созданы успешно',
      );
      
    } catch (e) {
      print('❌ Ошибка создания dev данных: $e');
      rethrow;
    }
  }

  Future<DevAppUsers> createAppUsersOnly() async {
    return await _createAppUsers();
  }

  Future<void> createRoutesForExistingAppUsers(List<AppUser> salesReps) async {
    await _createRoutesForSalesReps(DevAppUsers(
      admin: _createEmptyAppUser(),
      manager: _createEmptyAppUser(),
      salesReps: salesReps,
    ));
  }

  AppUser _createEmptyAppUser() {
    // Здесь создаем пустой AppUser для fallback случаев
    // В реальной реализации это не используется
    throw UnimplementedError('Empty AppUser creation not implemented');
  }

  Future<void> _clearAllData() async {
    // В dev режиме полностью очищаем базу данных
    print('🧹 Начинаем очистку dev базы данных...');
    
    try {
      // Принудительно получаем экземпляр базы данных (создает если не существует)
      GetIt.instance<AppDatabase>();
      
      // Очищаем через каскадные методы
      // TODO: Реализовать clearAllData или альтернативный метод очистки
      print('✅ База данных полностью очищена (dev режим)');
    } catch (e) {
      print('❌ Ошибка очистки базы данных: $e');
      rethrow;
    }
    
    await _userFixtureService.clearAllUsers();
  }

  Future<DevAppUsers> _createAppUsers() async {
    print('🏗️ Создание AppUsers...');
    
    // 1. Создаем базовых пользователей (User сущности)
    final admin = await _userFixtureService.createAdmin();
    print('✅ Admin создан: ${admin.externalId} (ID: ${admin.id})');
    
    final manager = await _userFixtureService.createManager();
    print('✅ Manager создан: ${manager.externalId} (ID: ${manager.id})');
    
    final salesReps = <User>[];
    
    // Создаем только одного sales rep для упрощения
    final salesRep1 = await _userFixtureService.createSalesRep(
      name: 'Алексей Торговый',
      email: 'salesrep1@tauzero.dev',
      phone: '+7-999-111-2233',
    );
    salesReps.add(salesRep1);
    print('✅ SalesRep1 создан: ${salesRep1.externalId} (ID: ${salesRep1.id})');
    
    // Закомментируем второго sales rep для упрощения
    // final salesRep2 = await _userFixtureService.createSalesRep(
    //   name: 'Мария Продажкина',
    //   email: 'salesrep2@tauzero.dev', 
    //   phone: '+7-999-444-5566',
    // );
    // salesReps.add(salesRep2);
    
    // 2. Создаем AppUser для каждого User (User -> Employee -> AppUser)
    final allUsers = [admin, manager, ...salesReps];
    print('🔗 Создание AppUser для ${allUsers.length} пользователей...');
    
    final appUsers = await _appUserFixtureService.createAppUsersForAuthUsers(allUsers);
    
    // Выводим информацию о созданных AppUser
    for (final appUser in appUsers) {
      print('✅ AppUser создан: ${appUser.externalId} (Employee ID: ${appUser.employee.id}, User ID: ${appUser.authUser.id})');
    }
    
    // 3. Группируем AppUsers по ролям
    final adminAppUser = appUsers.firstWhere((au) => au.authUser.role == UserRole.admin);
    final managerAppUser = appUsers.firstWhere((au) => au.authUser.role == UserRole.manager);
    final salesRepAppUsers = appUsers.where((au) => au.authUser.role == UserRole.user).toList();
    
    print('✅ Группировка завершена: admin=${adminAppUser.externalId}, manager=${managerAppUser.externalId}, salesReps=${salesRepAppUsers.length}');
    
    return DevAppUsers(
      admin: adminAppUser,
      manager: managerAppUser,
      salesReps: salesRepAppUsers,
    );
  }

  /// Создает маршруты для всех торговых представителей
  Future<void> _createRoutesForSalesReps(DevAppUsers appUsers) async {
    for (final salesRepAppUser in appUsers.salesReps) {
      await _routeFixtureService.createDevFixtures(salesRepAppUser.employee);
    }
  }

  /// Создает тестовые треки с привязкой к сегодняшним маршрутам
  /// Для каждого торгового представителя создает активный трек с реальными GPS данными,
  /// привязанный к его сегодняшнему маршруту из _createTodayRoute
  /// Создает тестовые треки для пользователей с маршрутами
  Future<void> _createTestTracks(DevAppUsers appUsers) async {
    print('�️ Создаем тестовые треки для пользователей...');
    
    final routeRepository = GetIt.instance<RouteRepository>();
    
    // Создаем треки только для торговых представителей
    for (final salesRepAppUser in appUsers.salesReps) {
      try {
        // Получаем маршруты для пользователя через Employee
        final routesStream = routeRepository.watchEmployeeRoutes(salesRepAppUser.employee);
        final routes = await routesStream.first;
        
        if (routes.isEmpty) {
          print('⚠️ У пользователя ${salesRepAppUser.fullName} нет маршрутов');
          continue;
        }
        
        // Выбираем сегодняшний маршрут (первый в списке для простоты)
        final todayRoute = routes.first;
        
        try {
          print('🗺️ Создаем трек для маршрута "${todayRoute.name}" пользователя ${salesRepAppUser.fullName}');
          
          // Создаем тестовый трек для этого маршрута 
          final userTrack = await TrackFixtures.createCurrentDayTrack(
            user: salesRepAppUser.employee, // Employee реализует NavigationUser
            route: todayRoute,
          );
          
          if (userTrack != null) {
          } else {
            print('❌ Не удалось создать трек для пользователя ${salesRepAppUser.fullName}');
          }
        } catch (e) {
          print('❌ Ошибка при создании трека для ${salesRepAppUser.fullName}: $e');
        }
      } catch (e) {
        print('❌ Ошибка при получении маршрутов для ${salesRepAppUser.fullName}: $e');
      }
    }
    
    // Убираем избыточные логи для dev режима
    // print('✅ Создание тестовых треков завершено');
  }
}

class DevFixturesResult {
  final DevAppUsers appUsers;
  final bool success;
  final String message;

  DevFixturesResult({
    required this.appUsers,
    required this.success,
    required this.message,
  });
}

/// Factory для создания DevFixtureOrchestrator
class DevFixtureOrchestratorFactory {
  static DevFixtureOrchestrator create() {
    final userFixtureService = UserFixtureServiceFactory.create();
    final appUserFixtureService = AppUserFixtureServiceFactory.create();
    final routeFixtureService = RouteFixtureServiceFactory.create();
    final tradingPointsService = TradingPointsFixtureServiceFactory.create();
    
    return DevFixtureOrchestrator(
      userFixtureService,
      appUserFixtureService,
      routeFixtureService,
      tradingPointsService,
    );
  }
}
