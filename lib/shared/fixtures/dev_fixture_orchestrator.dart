import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/features/authentication/data/fixtures/user_fixture_service.dart';
import 'package:tauzero/features/route/data/fixtures/route_fixture_service.dart';
import 'package:tauzero/features/route/data/fixtures/trading_points_fixture_service.dart';
import 'package:tauzero/features/tracking/data/fixtures/track_fixtures.dart';
import 'package:get_it/get_it.dart';
import '../../features/authentication/domain/repositories/iuser_repository.dart';
import '../../features/route/domain/repositories/iroute_repository.dart';
import '../infrastructure/database/app_database.dart';

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
  final RouteFixtureService _routeFixtureService;
  final TradingPointsFixtureService _tradingPointsService;
  
  DevFixtureOrchestrator(
    this._userFixtureService,
    this._routeFixtureService,
    this._tradingPointsService,
  );

  /// Создает полный набор dev данных
  Future<DevFixturesResult> createFullDevDataset() async {    
    try {
      await _clearAllData();
      
      // Сначала создаем торговые точки (глобально)
      print('🏪 Создаем базовые торговые точки...');
      await _tradingPointsService.createBaseTradingPoints();
      
      final users = await _createUsers();
      await _createRoutesForSalesReps(users);
      await _createTestTracks();

      return DevFixturesResult(
        users: users,
        success: true,
        message: 'Все dev фикстуры созданы успешно',
      );
      
    } catch (e) {
      return DevFixturesResult(
        users: DevUsers.empty(),
        success: false,
        message: 'Ошибка: $e',
      );
    }
  }

  Future<DevUsers> createUsersOnly() async {
    return await _createUsers();
  }

  Future<void> createRoutesForExistingUsers(List<User> salesReps) async {
    await _createRoutesForSalesReps(DevUsers(
      admin: _createEmptyUser(),
      manager: _createEmptyUser(),
      salesReps: salesReps,
    ));
  }

  User _createEmptyUser() {
    final phoneResult = PhoneNumber.create('+7-999-999-9999');
    final userResult = User.create(
      externalId: 'empty',
      lastName: 'Empty',
      firstName: 'User',
      role: UserRole.user,
      phoneNumber: phoneResult.fold((l) => throw Exception(l), (r) => r),
      hashedPassword: 'empty',
    );
    return userResult.fold((l) => throw Exception(l), (r) => r);
  }

  Future<void> _clearAllData() async {
    // В dev режиме полностью очищаем базу данных
    print('🧹 Начинаем очистку dev базы данных...');
    
    try {
      // Принудительно получаем экземпляр базы данных (создает если не существует)
      final database = GetIt.instance<AppDatabase>();
      await database.clearAllData();
      print('✅ База данных полностью очищена (dev режим)');
    } catch (e) {
      print('❌ Ошибка очистки базы данных: $e');
      rethrow;
    }
    
    await _userFixtureService.clearAllUsers();
  }

  Future<DevUsers> _createUsers() async {
    final admin = await _userFixtureService.createAdmin();
    final manager = await _userFixtureService.createManager();
    final salesReps = <User>[];
    
    final salesRep1 = await _userFixtureService.createSalesRep(
      name: 'Алексей Торговый',
      email: 'salesrep1@tauzero.dev',
      phone: '+7-999-111-2233',
    );
    salesReps.add(salesRep1);
    
    final salesRep2 = await _userFixtureService.createSalesRep(
      name: 'Мария Продажкина',
      email: 'salesrep2@tauzero.dev', 
      phone: '+7-999-444-5566',
    );
    salesReps.add(salesRep2);
    
    return DevUsers(
      admin: admin,
      manager: manager,
      salesReps: salesReps,
    );
  }

  /// Создает маршруты для всех торговых представителей
  Future<void> _createRoutesForSalesReps(DevUsers users) async {
    for (final salesRep in users.salesReps) {
      await _routeFixtureService.createDevFixtures(salesRep);
    }
  }

  /// Создает тестовые треки с привязкой к сегодняшним маршрутам
  /// Для каждого торгового представителя создает активный трек с реальными GPS данными,
  /// привязанный к его сегодняшнему маршруту из _createTodayRoute
  Future<void> _createTestTracks() async {
    print('🚗 Создаем тестовые треки с привязкой к маршрутам...');
    
    final userRepository = GetIt.instance<IUserRepository>();
    final routeRepository = GetIt.instance<IRouteRepository>();
    
    // Получаем всех пользователей и находим торговых представителей
    final usersResult = await userRepository.getAllUsers();
    if (usersResult.isLeft()) {
      print('❌ Не удалось получить пользователей для создания треков');
      return;
    }
    
    final allUsers = usersResult.fold((l) => <User>[], (r) => r);
    final salesReps = allUsers.where((u) => u.role == UserRole.user).toList();
    
    print('📍 Найдено ${salesReps.length} торговых представителей для создания треков');
    
    for (final salesRep in salesReps) {
      try {
        // Получаем все маршруты пользователя
        final routesStream = routeRepository.watchUserRoutes(salesRep);
        final routes = await routesStream.first;
        
        if (routes.isEmpty) {
          print('⚠️ У пользователя ${salesRep.fullName} нет маршрутов');
          continue;
        }
        
        // Находим активный маршрут (сегодняшний) - это должен быть маршрут из _createTodayRoute
        final todayRoute = routes.firstWhere(
          (route) => route.status.name == 'active',
          orElse: () => routes.first,
        );
        
        print('🗺️ Создаем трек для маршрута "${todayRoute.name}" пользователя ${salesRep.fullName}');
        
        // Создаем трек с реальными GPS данными, связанный с конкретным маршрутом
        final userTrack = await TrackFixtures.createCurrentDayTrack(
          user: salesRep,
          route: todayRoute,
        );
        
        if (userTrack != null) {
          print('✅ Трек создан: ${userTrack.totalPoints} GPS точек, '
                '${userTrack.totalDistanceKm.toStringAsFixed(2)} км, '
                'привязан к маршруту ID: ${todayRoute.id}');
        } else {
          print('❌ Не удалось создать трек для пользователя ${salesRep.fullName}');
        }
        
      } catch (e) {
        print('❌ Ошибка при создании трека для ${salesRep.fullName}: $e');
      }
    }
    
    print('🏁 Завершено создание тестовых треков');
  }
}

class DevFixturesResult {
  final DevUsers users;
  final bool success;
  final String message;

  DevFixturesResult({
    required this.users,
    required this.success,
    required this.message,
  });
}

/// Группа созданных пользователей
class DevUsers {
  final User admin;
  final User manager;
  final List<User> salesReps; // Торговые представители

  DevUsers({
    required this.admin,
    required this.manager,
    required this.salesReps,
  });

  factory DevUsers.empty() => DevUsers(
    admin: _createEmptyUser(),
    manager: _createEmptyUser(), 
    salesReps: [],
  );

  static User _createEmptyUser() {
    final phoneResult = PhoneNumber.create('+7-999-999-9999');
    final userResult = User.create(
      externalId: 'empty',
      lastName: 'Empty',
      firstName: 'User',
      role: UserRole.user,
      phoneNumber: phoneResult.fold((l) => throw Exception(l), (r) => r),
      hashedPassword: 'empty',
    );
    return userResult.fold((l) => throw Exception(l), (r) => r);
  }

  int get length => 1 + 1 + salesReps.length; // admin + manager + salesReps
}

/// Factory для создания DevFixtureOrchestrator
class DevFixtureOrchestratorFactory {
  static DevFixtureOrchestrator create() {
    final userFixtureService = UserFixtureServiceFactory.create();
    final routeFixtureService = RouteFixtureServiceFactory.create();
    final tradingPointsService = TradingPointsFixtureServiceFactory.create();
    
    return DevFixtureOrchestrator(
      userFixtureService,
      routeFixtureService,
      tradingPointsService,
    );
  }
}
