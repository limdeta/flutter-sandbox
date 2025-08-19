import 'package:get_it/get_it.dart';

import '../database/route_database.dart';
import '../repositories/route_repository.dart';
import '../../domain/repositories/iroute_repository.dart';
import '../../domain/services/route_service.dart';

/// Dependency Injection для Route feature
/// 
/// Регистрирует все зависимости для работы с маршрутами:
/// - Database
/// - Repository
/// - Services
class RouteDI {
  
  /// Регистрация всех зависимостей
  static void registerDependencies() {
    final GetIt getIt = GetIt.instance;
    
    // =====================================================
    // DATA LAYER - Слой данных
    // =====================================================
    
    // Database - Singleton, одна база для всего приложения
    if (!getIt.isRegistered<RouteDatabase>()) {
      getIt.registerLazySingleton<RouteDatabase>(
        () => RouteDatabase(),
        dispose: (database) => database.close(),
      );
    }
    
    // Repository - реализация через Drift
    if (!getIt.isRegistered<IRouteRepository>()) {
      getIt.registerLazySingleton<IRouteRepository>(
        () => RouteRepository(getIt<RouteDatabase>()),
      );
    }

    // =====================================================
    // DOMAIN LAYER - Бизнес логика
    // =====================================================
    
    // Route Service - бизнес операции
    if (!getIt.isRegistered<RouteService>()) {
      getIt.registerLazySingleton<RouteService>(
        () => RouteService(),
      );
    }
  }
  
  /// Очистка зависимостей (для тестов)
  static void clearDependencies() {
    final GetIt getIt = GetIt.instance;
    
    if (getIt.isRegistered<RouteService>()) {
      getIt.unregister<RouteService>();
    }
    
    if (getIt.isRegistered<IRouteRepository>()) {
      getIt.unregister<IRouteRepository>();
    }
    
    if (getIt.isRegistered<RouteDatabase>()) {
      getIt.unregister<RouteDatabase>();
    }
  }
}

/// Extension для удобного доступа к зависимостям
extension RouteDIExtensions on GetIt {
  
  /// Получить Route Database
  RouteDatabase get routeDatabase => get<RouteDatabase>();
  
  /// Получить Route Repository
  IRouteRepository get routeRepository => get<IRouteRepository>();
  
  /// Получить Route Service
  RouteService get routeService => get<RouteService>();
}
