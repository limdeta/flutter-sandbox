import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../../features/authentication/domain/entities/user.dart' as domain;
import 'tables/user_tables.dart';
import 'tables/tracking_tables.dart';
import 'tables/route_tables.dart';
import 'mappers/user_mapper.dart';
import '../../config/app_config.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  // User tables
  UserEntries, 
  // Tracking tables
  UserTracks, 
  CompactTracks,
  // Route tables
  RoutesTable,
  TradingPointsTable, 
  PointsOfInterestTable,
  PointStatusHistoryTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // Конструктор для тестов
  AppDatabase.forTesting(DatabaseConnection super.connection);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Включаем foreign key constraints
      await customStatement('PRAGMA foreign_keys = ON');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Включаем foreign key constraints при обновлении
      await customStatement('PRAGMA foreign_keys = ON');
      
      // Миграция с версии 2 до 3: добавляем таблицы маршрутов
      if (from <= 2 && to >= 3) {
        await m.createTable($RoutesTableTable(attachedDatabase));
        await m.createTable($TradingPointsTableTable(attachedDatabase));
        await m.createTable($PointsOfInterestTableTable(attachedDatabase));
        await m.createTable($PointStatusHistoryTableTable(attachedDatabase));
      }
    },
  );

  // User queries returning domain entities
  Future<List<domain.User>> getAllUsers() async {
    final usersData = await select(userEntries).get();
    return UserMapper.fromUserEntryList(usersData);
  }

  Future<domain.User?> getUserById(int id) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return userData != null ? UserMapper.fromUserEntry(userData) : null;
  }

  Future<domain.User?> getUserByExternalId(String externalId) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.externalId.equals(externalId))).getSingleOrNull();
    return userData != null ? UserMapper.fromUserEntry(userData) : null;
  }

  Future<domain.User?> getUserByPhoneNumber(String phoneNumber) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.phoneNumber.equals(phoneNumber))).getSingleOrNull();
    return userData != null ? UserMapper.fromUserEntry(userData) : null;
  }

  Future<void> insertUser(domain.User user) async {
    await into(userEntries).insert(UserMapper.toInsertCompanion(user));
  }

  Future<void> updateUser(domain.User user) async {
    await (update(userEntries)..where((tbl) => tbl.externalId.equals(user.externalId.toString()))).write(UserMapper.toUpdateCompanion(user));
  }

  Future<void> deleteUser(int id) async {
    await (delete(userEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Удобные методы для работы с ID
  Future<int?> getInternalUserIdByExternalId(String externalId) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.externalId.equals(externalId))).getSingleOrNull();
    return userData?.id;
  }

  Future<String?> getExternalUserIdByInternalId(int internalId) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.id.equals(internalId))).getSingleOrNull();
    return userData?.externalId;
  }

  // ===========================
  // МЕТОДЫ ДЛЯ РАБОТЫ С МАРШРУТАМИ
  // ===========================

  /// Получает маршруты пользователя (reactive stream)
  Stream<List<RoutesTableData>> watchUserRoutes(int userId) {
    return (select(routesTable)..where((tbl) => tbl.userId.equals(userId))).watch();
  }

  /// Получает один маршрут по ID
  Future<RoutesTableData?> getRouteById(int routeId) {
    return (select(routesTable)..where((tbl) => tbl.id.equals(routeId))).getSingleOrNull();
  }

  /// Создает новый маршрут
  Future<int> createRoute(RoutesTableCompanion route) {
    return into(routesTable).insert(route);
  }

  /// Обновляет существующий маршрут
  Future<bool> updateRoute(RoutesTableCompanion route) {
    return update(routesTable).replace(route);
  }

  /// Удаляет маршрут
  Future<int> deleteRoute(int routeId) async {
    // Сначала удаляем все точки маршрута
    await (delete(pointsOfInterestTable)..where((tbl) => tbl.routeId.equals(routeId))).go();
    
    // Потом удаляем сам маршрут
    return await (delete(routesTable)..where((tbl) => tbl.id.equals(routeId))).go();
  }

  /// Получает точки маршрута (reactive stream)
  Stream<List<PointsOfInterestTableData>> watchRoutePoints(int routeId) {
    return (select(pointsOfInterestTable)
      ..where((tbl) => tbl.routeId.equals(routeId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)])).watch();
  }

  /// Создает новую точку в маршруте
  Future<int> createPoint(PointsOfInterestTableCompanion point) {
    return into(pointsOfInterestTable).insert(point);
  }

  /// Обновляет точку маршрута
  Future<bool> updatePoint(PointsOfInterestTableCompanion point) {
    return update(pointsOfInterestTable).replace(point);
  }

  /// Обновляет статус точки маршрута
  Future<void> updatePointStatus({
    required int pointId,
    required String fromStatus,
    required String toStatus,
    required String changedBy,
    String? reason,
    DateTime? arrivalTime,
    DateTime? departureTime,
  }) async {
    await transaction(() async {
      // Обновляем основную запись точки
      await (update(pointsOfInterestTable)..where((tbl) => tbl.id.equals(pointId))).write(
        PointsOfInterestTableCompanion(
          status: Value(toStatus),
          actualArrivalTime: arrivalTime != null ? Value(arrivalTime) : const Value.absent(),
          actualDepartureTime: departureTime != null ? Value(departureTime) : const Value.absent(),
        ),
      );
      
      // Добавляем запись в историю статусов
      await into(pointStatusHistoryTable).insert(
        PointStatusHistoryTableCompanion.insert(
          pointId: pointId,
          fromStatus: fromStatus,
          toStatus: toStatus,
          changedBy: changedBy,
          reason: Value(reason),
        ),
      );
    });
  }

  /// Получает торговую точку по внешнему ID
  Future<TradingPointsTableData?> getTradingPoint(String externalId) {
    return (select(tradingPointsTable)..where((tbl) => tbl.externalId.equals(externalId))).getSingleOrNull();
  }

  /// Создает или обновляет торговую точку
  Future<void> upsertTradingPoint(TradingPointsTableCompanion tradingPoint) {
    return into(tradingPointsTable).insertOnConflictUpdate(tradingPoint);
  }
  
  /// Полная очистка базы данных (только для dev окружения!)
  Future<void> clearAllData() async {
    if (!AppConfig.isDev) {
      throw Exception('clearAllData() можно вызывать только в dev окружении!');
    }
    
    // Очищаем все таблицы
    await delete(userTracks).go();
    await delete(compactTracks).go();
    await delete(pointStatusHistoryTable).go();
    await delete(pointsOfInterestTable).go();
    await delete(tradingPointsTable).go();
    await delete(routesTable).go();
    await delete(userEntries).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    File file;
    
    if (AppConfig.isDev) {
      // В dev режиме создаем базу в application support directory
      // Это работает на всех платформах, включая Android
      final appSupportDir = await getApplicationSupportDirectory();
      file = File(p.join(appSupportDir.path, AppConfig.databaseName));
      print('🗄️ Dev база данных: ${file.path}');
    } else {
      // В prod режиме используем стандартную папку приложения
      final dbFolder = await getApplicationDocumentsDirectory();
      file = File(p.join(dbFolder.path, AppConfig.databaseName));
    }

    // Make sure sqlite3 is properly initialized on Android
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
