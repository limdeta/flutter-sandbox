import 'package:get_it/get_it.dart';

import '../../../../shared/infrastructure/database/app_database.dart';
import '../repositories/route_repository.dart';
import '../../domain/repositories/iroute_repository.dart';
import '../../domain/services/route_service.dart';

/// Dependency Injection для Route feature
/// 
/// Регистрирует все зависимости для работы с маршрутами:
/// - Repository (использует общую AppDatabase)
/// - Services
class RouteDI {
  
  /// Регистрация всех зависимостей
  static void registerDependencies() {
    final GetIt getIt = GetIt.instance;
    
    // =====================================================
    // DATA LAYER - Слой данных
    // =====================================================
    
    // Repository - использует общую AppDatabase
    
    // Repository - использует общую AppDatabase
    if (!getIt.isRegistered<IRouteRepository>()) {
      getIt.registerLazySingleton<IRouteRepository>(
        () => RouteRepository(getIt<AppDatabase>()),
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
  }
}

/// Extension для удобного доступа к зависимостям
extension RouteDIExtensions on GetIt {
  
  /// Получить Route Repository
  IRouteRepository get routeRepository => get<IRouteRepository>();
  
  /// Получить Route Service
  RouteService get routeService => get<RouteService>();
}
