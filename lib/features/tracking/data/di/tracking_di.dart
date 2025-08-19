import 'package:get_it/get_it.dart';

import '../repositories/user_track_repository.dart';
import '../../domain/repositories/iuser_track_repository.dart';
import '../../../../shared/infrastructure/database/app_database.dart';

/// Dependency Injection для Tracking feature
/// 
/// Регистрирует все зависимости для работы с GPS треками:
/// - Repository
/// - Services
class TrackingDI {
  
  /// Регистрация всех зависимостей
  static void registerDependencies() {
    final GetIt getIt = GetIt.instance;
    
    // =====================================================
    // DATA LAYER - Слой данных
    // =====================================================
    
    // Repository - реализация через Drift (использует общую базу)
    if (!getIt.isRegistered<IUserTrackRepository>()) {
      getIt.registerLazySingleton<IUserTrackRepository>(
        () => UserTrackRepository(getIt<AppDatabase>()),
      );
    }
  }
  
  /// Выгрузка зависимостей
  static void unregisterDependencies() {
    final GetIt getIt = GetIt.instance;
    
    if (getIt.isRegistered<IUserTrackRepository>()) {
      getIt.unregister<IUserTrackRepository>();
    }
  }
}
