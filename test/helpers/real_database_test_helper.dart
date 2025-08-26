import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:tauzero/app/database/database.dart';


/// Помощник для РЕАЛЬНЫХ интеграционных тестов с файловой базой данных
/// 
/// Создает файл test_integration.db который можно открыть в DB Browser
/// или любом другом SQLite клиенте для проверки данных
class RealDatabaseTestHelper {
  late AppDatabase database;
  late String databasePath;
  late UserRepositoryImpl userRepository;
  late RouteRepository routeRepository;
  late UserTrackRepository userTrackRepository;
  late CompactTrackRepository compactTrackRepository;

  /// Инициализация реальной файловой базы данных для интеграционных тестов
  Future<void> initialize() async {
    // Очищаем GetIt перед каждым тестом
    if (GetIt.instance.isRegistered<AppDatabase>()) {
      await GetIt.instance.unregister<AppDatabase>();
    }
    
    // Создаем путь к тестовой базе данных
    final testDbDir = Directory('test_db');
    if (!await testDbDir.exists()) {
      await testDbDir.create();
    }
    
    databasePath = path.join(testDbDir.path, 'test_integration.db');
    
    // Удаляем старую базу если есть, чтобы начать с чистого листа
    final dbFile = File(databasePath);
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
    
    // Создаем реальную файловую базу данных
    final connection = drift.DatabaseConnection(
      NativeDatabase(File(databasePath))
    );
    
    database = AppDatabase.forTesting(connection);
    
    // Регистрируем базу данных в GetIt для mapper'ов
    GetIt.instance.registerSingleton<AppDatabase>(database);
    
    // Инициализируем все репозитории
    userRepository = UserRepository(database: database);
    routeRepository = RouteRepository(database);
    userTrackRepository = UserTrackRepository(database, userRepository, routeRepository);
    compactTrackRepository = CompactTrackRepository(database);
    
    print('✅ Создана тестовая база данных: $databasePath');
    print('📁 Вы можете открыть этот файл в DB Browser for SQLite для проверки данных');
  }

  /// Очистка после теста (НЕ удаляем файл БД для инспекции!)
  Future<void> dispose() async {
    await database.close();
    
    // Очищаем GetIt после теста
    if (GetIt.instance.isRegistered<AppDatabase>()) {
      await GetIt.instance.unregister<AppDatabase>();
    }
    
    print('💾 База данных закрыта, файл сохранен: $databasePath');
    print('🔍 Откройте файл в DB Browser для инспекции данных');
  }

  /// Очистка всех таблиц (для подготовки к следующему тесту)
  Future<void> clearAllTables() async {
    await database.transaction(() async {
      // Очищаем все таблицы в правильном порядке (с учетом foreign keys)
      await database.delete(database.compactTracks).go();
      await database.delete(database.userTracks).go();
      await database.delete(database.pointStatusHistoryTable).go();
      await database.delete(database.pointsOfInterestTable).go();
      await database.delete(database.tradingPointsTable).go();
      await database.delete(database.routesTable).go();
      await database.delete(database.userEntries).go();
    });
    
    print('🧹 Все таблицы очищены');
  }

  /// Показать статистику таблиц для дебага
  Future<void> showTableStats() async {
    final usersCount = await database.select(database.userEntries).get().then((rows) => rows.length);
    final routesCount = await database.select(database.routesTable).get().then((rows) => rows.length);
    final userTracksCount = await database.select(database.userTracks).get().then((rows) => rows.length);
    final compactTracksCount = await database.select(database.compactTracks).get().then((rows) => rows.length);
    
    print('📊 Статистика базы данных:');
    print('   Users: $usersCount записей');
    print('   Routes: $routesCount записей');
    print('   UserTracks: $userTracksCount записей');
    print('   CompactTracks: $compactTracksCount записей');
  }
}
