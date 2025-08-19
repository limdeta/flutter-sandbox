import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/features/authentication/data/fixtures/user_fixture_service.dart';
import 'package:tauzero/features/route/data/fixtures/route_fixture_service.dart';
import 'package:tauzero/features/tracking/fixtures/track_fixtures.dart';
import 'package:get_it/get_it.dart';
import '../../features/authentication/domain/repositories/iuser_repository.dart';
import '../../features/route/domain/repositories/iroute_repository.dart';

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
  
  DevFixtureOrchestrator(
    this._userFixtureService,
    this._routeFixtureService,
  );

  /// Создает полный набор dev данных
  Future<DevFixturesResult> createFullDevDataset() async {    
    try {
      await _clearAllData();
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

  Future<void> _createTestTracks() async {
      final userRepository = GetIt.instance<IUserRepository>();
      final routeRepository = GetIt.instance<IRouteRepository>();
      
      // Получаем всех пользователей и находим торговых представителей
      final usersResult = await userRepository.getAllUsers();
      if (usersResult.isLeft()) {
        return;
      }
      
      final allUsers = usersResult.fold((l) => <User>[], (r) => r);
      final salesReps = allUsers.where((u) => u.role == UserRole.user).toList();
      
      for (final salesRep in salesReps) {
        final routesStream = routeRepository.watchUserRoutes(salesRep);
        final routes = await routesStream.first;
        
        await TrackFixtures.createTestTracksForUser(
          user: salesRep,
          routes: routes,
        );
      }
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
    
    return DevFixtureOrchestrator(
      userFixtureService,
      routeFixtureService,
    );
  }
}
