import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'shared/config/app_config.dart';
import 'shared/di/service_locator.dart';
import 'shared/fixtures/dev_fixture_orchestrator.dart';
import 'shared/providers/selected_route_provider.dart';
import 'shared/services/app_lifecycle_manager.dart';
import 'shared/widgets/dev_data_loading_overlay.dart';
import 'features/app/presentation/pages/splash_page.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/authentication/data/fixtures/user_fixture_service.dart';
import 'features/authentication/domain/repositories/iuser_repository.dart';
import 'features/app/presentation/pages/home_page.dart';
import 'features/app/presentation/pages/sales_rep_home_page.dart';
import 'features/app/presentation/pages/main_menu_page.dart';
import 'features/admin/presentation/pages/admin_dashboard_page.dart';
import 'features/route/presentation/pages/routes_page.dart';
import 'features/route/data/fixtures/route_fixture_service.dart';
import 'features/route/data/fixtures/trading_points_fixture_service.dart';
import 'features/route/domain/repositories/iroute_repository.dart';
import 'features/products/presentation/pages/product_catalog_page.dart';
import 'features/products/presentation/pages/product_categories_page.dart';
import 'features/products/presentation/pages/promotions_page.dart';

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
        UserFixtureService(GetIt.instance<IUserRepository>()),
        RouteFixtureService(GetIt.instance<IRouteRepository>()),
        TradingPointsFixtureService(),
      );
      await orchestrator.createFullDevDataset();
      print('✅ Dev данные созданы успешно');
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
      ],
      child: DevDataLoadingOverlay(
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
          '/home': (context) => const HomePage(),
          '/sales-home': (context) => const SalesRepHomePage(),
          '/menu': (context) => const MainMenuPage(),
          '/admin': (context) => const AdminDashboardPage(),
          '/routes': (context) => const RoutesPage(),
          '/products/catalog': (context) => const ProductCatalogPage(),
          '/products/categories': (context) => const ProductCategoriesPage(),
          '/products/promotions': (context) => const PromotionsPage(),
        },
        ),
      ),
    );
  }
}
