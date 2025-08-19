import 'package:get_it/get_it.dart';
import 'package:tauzero/features/authentication/data/repositories/user_repository.dart';
import 'package:tauzero/features/authentication/data/repositories/session_repository_impl.dart';
import 'package:tauzero/features/authentication/data/fixtures/user_fixture_service.dart';
import 'package:tauzero/features/authentication/domain/repositories/iuser_repository.dart';
import 'package:tauzero/features/authentication/domain/repositories/session_repository.dart';
import 'package:tauzero/features/authentication/domain/services/authentication_service.dart';
import 'package:tauzero/features/authentication/domain/usecases/login_usecase.dart';
import 'package:tauzero/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:tauzero/features/authentication/domain/usecases/get_current_session_usecase.dart';
import 'package:tauzero/features/route/data/di/route_di.dart';
import 'package:tauzero/features/tracking/data/di/tracking_di.dart';
import 'package:tauzero/features/tracking/domain/services/location_tracking_service.dart';
import 'package:tauzero/shared/config/app_config.dart';
import 'package:tauzero/shared/infrastructure/database/app_database.dart';
import 'package:tauzero/shared/services/app_lifecycle_manager.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Configure app from command line arguments
  AppConfig.configureFromArgs();
  
  if (AppConfig.enableDetailedLogging) {
    AppConfig.printConfig();
  }

  if (AppConfig.enableDetailedLogging) {
    print('⚡ Registering database (lazy creation)...');
  }

  getIt.registerLazySingleton<AppDatabase>(() {
    if (AppConfig.enableDetailedLogging) {
      print('🗄️ Creating AppDatabase instance...');
    }
    return AppDatabase();
  });
  
  getIt.registerLazySingleton<SessionRepository>(() => SessionRepositoryImpl());

  getIt.registerLazySingleton<LocationTrackingService>(() => LocationTrackingService());

  getIt.registerLazySingleton<IUserRepository>(
    () => UserRepository(
      database: getIt(),
    ),
  );
  
  // Services
  getIt.registerLazySingleton<AuthenticationService>(
    () => AuthenticationService(
      userRepository: getIt(), // Используем IUserRepository вместо AuthRepository
      sessionRepository: getIt(),
    ),
  );
  
  // Fixture services for development/testing
  getIt.registerLazySingleton<UserFixtureService>(
    () => UserFixtureService(getIt()),
  );
  
  // Use cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt()),
  );
  
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(authenticationService: getIt()),
  );
  
  getIt.registerLazySingleton<GetCurrentSessionUseCase>(
    () => GetCurrentSessionUseCase(sessionRepository: getIt()),
  );
  
  // App Lifecycle Manager for GPS tracking
  getIt.registerLazySingleton<AppLifecycleManager>(
    () => AppLifecycleManager(),
  );
  
  // Route dependencies
  RouteDI.registerDependencies();
  
  // Tracking dependencies
  TrackingDI.registerDependencies();
  
  if (AppConfig.enableDetailedLogging) {
    print('Service locator setup completed!');
  }
}
