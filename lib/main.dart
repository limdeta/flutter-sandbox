import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
// import 'package:tauzero/app/presentation/pages/admin_page.dart'; // Закомментировано до исправления
import 'package:tauzero/app/presentation/pages/main_menu_page.dart';
import 'package:tauzero/app/presentation/pages/sales_rep_home_page.dart';
import 'package:tauzero/app/presentation/pages/splash_page.dart';
import 'package:tauzero/app/presentation/pages/login_page.dart';
import 'package:tauzero/app/presentation/widgets/dev_data_loading_overlay.dart';
import 'app/config/app_config.dart';
import 'app/service_locator.dart';
import 'app/fixtures/dev_fixture_orchestrator.dart';
import 'app/fixtures/app_user_fixture_service.dart';
import 'app/providers/selected_route_provider.dart';
import 'features/navigation/tracking/presentation/providers/user_tracks_provider.dart';
import 'app/services/app_lifecycle_manager.dart';
import 'app/services/simple_update_service.dart';
import 'features/authentication/data/fixtures/user_fixture_service.dart';
import 'features/authentication/domain/repositories/user_repository.dart';
import 'features/shop/presentation/routes_page.dart';
import 'features/shop/data/fixtures/route_fixture_service.dart';
import 'features/shop/data/fixtures/trading_points_fixture_service.dart';
import 'features/shop/domain/repositories/route_repository.dart';
import 'features/shop/domain/repositories/employee_repository.dart';
import 'app/domain/repositories/app_user_repository.dart';
import 'features/shop/presentation/product_catalog_page.dart';
import 'features/shop/presentation/product_categories_page.dart';
import 'features/shop/presentation/promotions_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Настраиваем dependency injection
  await setupServiceLocator();
  
  // Инициализируем менеджер жизненного цикла для GPS трекинга
  final lifecycleManager = GetIt.instance<AppLifecycleManager>();
  await lifecycleManager.initialize();
  
  if (AppConfig.isDev) {
    print('🔧 Dev режим - создаем тестовые данные...');
    // Создаем dev данные напрямую в основном потоке для корректной работы с базой
    try {
      final orchestrator = DevFixtureOrchestrator(
        UserFixtureService(GetIt.instance<UserRepository>()),
        AppUserFixtureService(
          employeeRepository: GetIt.instance<EmployeeRepository>(),
          appUserRepository: GetIt.instance<AppUserRepository>(),
        ),
        RouteFixtureService(GetIt.instance<RouteRepository>()),
        TradingPointsFixtureService(),
      );
      await orchestrator.createFullDevDataset();
      print('✅ Dev данные созданы');
    } catch (error) {
      print('❌ Ошибка создания dev данных: $error');
    }
  }
  
  runApp(const TauZeroApp());
}

class TauZeroApp extends StatelessWidget {
  const TauZeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SelectedRouteProvider()),
        ChangeNotifierProvider(create: (context) => GetIt.instance<UserTracksProvider>()),
      ],
      child: DevDataLoadingOverlay(
        child: UpgraderWrapper(
          child: MaterialApp(
            title: 'TauZero',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            initialRoute: '/',
            routes: {
            '/': (context) => const SplashPage(),
            '/login': (context) => const LoginPage(),
            // '/home': (context) => const HomePage(),
            '/sales-home': (context) => const SalesRepHomePage(),
            '/menu': (context) => const MainMenuPage(),
            // '/admin': (context) => const AdminDashboardPage(), // Закомментировано до исправления
            '/routes': (context) => const RoutesPage(),
            '/products/catalog': (context) => const ProductCatalogPage(),
            '/products/categories': (context) => const ProductCategoriesPage(),
            '/products/promotions': (context) => const PromotionsPage(),
          },
          ),
        ),
      ),
    );
  }
}
