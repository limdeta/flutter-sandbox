import 'package:get_it/get_it.dart';
import 'package:tauzero/app/database/app_database.dart';
import 'package:tauzero/app/database/repositories/user_repository_drift.dart';
import 'package:tauzero/app/database/repositories/session_repository_impl.dart';
import 'package:tauzero/app/database/repositories/employee_repository_drift.dart';
import 'package:tauzero/app/database/repositories/app_user_repository_drift.dart';
import 'package:tauzero/app/database/repositories/user_track_repository_drift.dart';
import 'package:tauzero/app/services/app_user_login_service.dart';
import 'package:tauzero/app/services/app_user_logout_service.dart';
import 'package:tauzero/app/services/simple_update_service.dart';
import 'package:tauzero/features/authentication/data/fixtures/user_fixture_service.dart';
import 'package:tauzero/features/authentication/domain/repositories/user_repository.dart';
import 'package:tauzero/features/authentication/domain/repositories/session_repository.dart';
import 'package:tauzero/features/authentication/domain/services/authentication_service.dart';
import 'package:tauzero/features/authentication/domain/usecases/login_usecase.dart';
import 'package:tauzero/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:tauzero/features/authentication/domain/usecases/get_current_session_usecase.dart';
import 'package:tauzero/features/shop/domain/repositories/employee_repository.dart';
import 'package:tauzero/features/shop/domain/repositories/trading_point_repository.dart';
import 'package:tauzero/features/shop/domain/usecases/get_employee_trading_points_usecase.dart';
import 'package:tauzero/app/database/repositories/drift_trading_point_repository.dart';
import 'package:tauzero/app/domain/repositories/app_user_repository.dart';
import 'package:tauzero/features/shop/data/di/route_di.dart';
import 'package:tauzero/features/navigation/tracking/domain/services/location_tracking_service.dart';
import 'package:tauzero/features/navigation/tracking/domain/repositories/user_track_repository.dart';
import 'package:tauzero/features/navigation/tracking/presentation/usecases/get_user_tracks_usecase.dart';
import 'package:tauzero/features/navigation/tracking/presentation/providers/user_tracks_provider.dart';
import 'package:tauzero/features/navigation/path_predictor/osrm_path_prediction_service.dart';
import 'package:tauzero/app/config/app_config.dart';
import 'package:tauzero/app/services/app_lifecycle_manager.dart';

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

  // Path prediction services
  getIt.registerLazySingleton<OsrmPathPredictionService>(() => OsrmPathPredictionService());

  getIt.registerLazySingleton<UserRepositoryImpl>(
    () => UserRepositoryImpl(
      database: getIt(),
    ),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => getIt<UserRepositoryImpl>(),
  );

  getIt.registerLazySingleton<EmployeeRepositoryDrift>(
    () => EmployeeRepositoryDrift(getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton<EmployeeRepository>(
    () => getIt<EmployeeRepositoryDrift>(),
  );

  // Trading Point Repository
  getIt.registerLazySingleton<TradingPointRepository>(
    () => DriftTradingPointRepository(),
  );

  // App User Repository  
  getIt.registerLazySingleton<AppUserRepository>(
    () => AppUserRepositoryDrift(
      database: getIt<AppDatabase>(),
      employeeRepository: getIt<EmployeeRepositoryDrift>(),
      userRepository: getIt<UserRepositoryImpl>(),
    ),
  );
  
  // Services
  getIt.registerLazySingleton<AuthenticationService>(
    () => AuthenticationService(
      userRepository: getIt(),
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

  getIt.registerLazySingleton<GetEmployeeTradingPointsUseCase>(
    () => GetEmployeeTradingPointsUseCase(getIt<TradingPointRepository>()),
  );
  
  // App User Login Service (wrapper around LoginUseCase)
  getIt.registerLazySingleton<AppUserLoginService>(
    () => AppUserLoginService(),
  );
  
  // App User Logout Service (wrapper around LogoutUseCase)
  getIt.registerLazySingleton<AppUserLogoutService>(
    () => AppUserLogoutService(),
  );
  
  // Simple Update Service 
  getIt.registerLazySingleton<SimpleUpdateService>(
    () => SimpleUpdateService(),
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

  getIt.registerLazySingleton<UserTrackRepository>(
    () => UserTrackRepositoryDrift(
      getIt<AppDatabase>(), 
      getIt<EmployeeRepositoryDrift>(),
    ),
  );

  getIt.registerLazySingleton<LocationTrackingService>(() => LocationTrackingService());
  
  // Tracking presentation layer
  getIt.registerLazySingleton<GetUserTracksUseCase>(
    () => GetUserTracksUseCase(getIt<UserTrackRepository>()),
  );
  
  getIt.registerFactory<UserTracksProvider>(
    () => UserTracksProvider(getIt<GetUserTracksUseCase>()),
  );
  
  if (AppConfig.enableDetailedLogging) {
    print('Service locator setup completed!');
  }
}
