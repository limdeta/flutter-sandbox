import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'route_database.g.dart';

/// Главный класс базы данных для маршрутов
/// 
/// Drift автоматически генерирует:
/// - DAO классы для каждой таблицы
/// - Type-safe методы для запросов
/// - Reactive streams для обновлений
@DriftDatabase(
  tables: [
    RoutesTable,
    TradingPointsTable, 
    PointsOfInterestTable,
    PointStatusHistoryTable,
  ],
)
class RouteDatabase extends _$RouteDatabase {
  RouteDatabase() : super(_openConnection());

  /// Конструктор для тестирования с in-memory базой
  RouteDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2; // Updated for autoincrement IDs + created_at/updated_at
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        // Migration from String IDs to autoincrement int IDs
        // For simplicity in dev, we'll drop and recreate all tables
        await customStatement('DROP TABLE IF EXISTS points_of_interest');
        await customStatement('DROP TABLE IF EXISTS routes');  
        await customStatement('DROP TABLE IF EXISTS trading_points');
        await customStatement('DROP TABLE IF EXISTS point_status_history');
        
        await m.createAll();
      }
    },
  );

  // =====================================================
  // ROUTES - Операции с маршрутами
  // =====================================================
  
  /// Получить все маршруты пользователя
  Stream<List<RoutesTableData>> watchUserRoutes(int userId) {
    return (select(routesTable)
      ..where((route) => route.userId.equals(userId))
      ..orderBy([(route) => OrderingTerm.desc(route.createdAt)]))
        .watch();
  }
  
  /// Получить маршрут по ID
  Future<RoutesTableData?> getRouteById(int routeId) {
    return (select(routesTable)
      ..where((route) => route.id.equals(routeId)))
        .getSingleOrNull();
  }
  
  /// Создать новый маршрут
  Future<int> createRoute(RoutesTableCompanion route) {
    return into(routesTable).insert(route);
  }
  
  /// Обновить маршрут
  Future<bool> updateRoute(RoutesTableCompanion route) {
    return update(routesTable).replace(route);
  }
  
  Future<int> deleteRoute(int routeId) async {
    // Сначала удаляем все точки маршрута
    await (delete(pointsOfInterestTable)
      ..where((point) => point.routeId.equals(routeId)))
        .go();
    
    return (delete(routesTable)
      ..where((route) => route.id.equals(routeId)))
        .go();
  }

  // =====================================================
  // POINTS OF INTEREST - Операции с точками
  // =====================================================
  
  /// Получить все точки маршрута (отсортированные)
  Stream<List<PointsOfInterestTableData>> watchRoutePoints(int routeId) {
    return (select(pointsOfInterestTable)
      ..where((point) => point.routeId.equals(routeId))
      ..orderBy([(point) => OrderingTerm.asc(point.orderIndex)]))
        .watch();
  }
  
  /// Создать точку интереса
  Future<int> createPoint(PointsOfInterestTableCompanion point) {
    return into(pointsOfInterestTable).insert(point);
  }
  
  /// Обновить точку интереса
  Future<bool> updatePoint(PointsOfInterestTableCompanion point) {
    return update(pointsOfInterestTable).replace(point);
  }
  
  /// Обновить статус точки (с записью в историю)
  Future<void> updatePointStatus({
    required int pointId,
    required String newStatus,
    required String changedBy,
    String? reason,
  }) async {
    // Получаем текущий статус
    final point = await (select(pointsOfInterestTable)
      ..where((p) => p.id.equals(pointId)))
        .getSingleOrNull();
    
    if (point == null) return;
    
    // Обновляем статус точки
    await (update(pointsOfInterestTable)
      ..where((p) => p.id.equals(pointId)))
        .write(PointsOfInterestTableCompanion(
          status: Value(newStatus),
        ));
    
    // Записываем в историю
    await into(pointStatusHistoryTable).insert(
      PointStatusHistoryTableCompanion.insert(
        pointId: pointId,
        fromStatus: point.status,
        toStatus: newStatus,
        changedBy: changedBy,
        reason: Value(reason),
      ),
    );
  }

  // =====================================================
  // TRADING POINTS - Операции с торговыми точками
  // =====================================================
  
  /// Получить торговую точку по внешнему ID
  Future<TradingPointsTableData?> getTradingPoint(String externalId) {
    return (select(tradingPointsTable)
      ..where((tp) => tp.externalId.equals(externalId)))
        .getSingleOrNull();
  }
  
  /// Создать или обновить торговую точку
  Future<void> upsertTradingPoint(TradingPointsTableCompanion tradingPoint) {
    return into(tradingPointsTable).insert(
      tradingPoint,
      onConflict: DoUpdate.withExcluded(
        (old, excluded) => tradingPoint,
        target: [tradingPointsTable.externalId], // Конфликт по external_id
      ),
    );
  }

  // =====================================================
  // COMPLEX QUERIES - Сложные запросы с JOIN
  // =====================================================
  
  /// Получить полную информацию о маршруте с точками
  /// Это демонстрация LEFT JOIN между таблицами
  /// Получить полную информацию о маршруте с точками
  /// Это демонстрация LEFT JOIN между таблицами
  Future<List<RouteWithPointsResult>> getRouteWithPoints(int routeId) {
    final query = select(routesTable).join([
      leftOuterJoin(
        pointsOfInterestTable,
        pointsOfInterestTable.routeId.equalsExp(routesTable.id),
      ),
      leftOuterJoin(
        tradingPointsTable,
        tradingPointsTable.id.equalsExp(pointsOfInterestTable.tradingPointId),
      ),
    ])
      ..where(routesTable.id.equals(routeId))
      ..orderBy([OrderingTerm.asc(pointsOfInterestTable.orderIndex)]);

    return query.map((row) {
      return RouteWithPointsResult(
        route: row.readTable(routesTable),
        point: row.readTableOrNull(pointsOfInterestTable),
        tradingPoint: row.readTableOrNull(tradingPointsTable),
      );
    }).get();
  }
  
  /// Получить статистику по маршрутам пользователя
  Future<List<RouteStatsResult>> getUserRouteStats(int userId) {
    // Пример агрегирующего запроса
    final query = selectOnly(routesTable)
      ..addColumns([
        routesTable.status,
        countAll(),
      ])
      ..where(routesTable.userId.equals(userId))
      ..groupBy([routesTable.status]);

    return query.map((row) {
      return RouteStatsResult(
        status: row.read(routesTable.status)!,
        count: row.read(countAll())!,
      );
    }).get();
  }
}

/// Результат JOIN запроса маршрута с точками
class RouteWithPointsResult {
  final RoutesTableData route;
  final PointsOfInterestTableData? point;
  final TradingPointsTableData? tradingPoint;
  
  RouteWithPointsResult({
    required this.route,
    this.point,
    this.tradingPoint,
  });
}

/// Результат статистики по маршрутам
class RouteStatsResult {
  final String status;
  final int count;
  
  RouteStatsResult({
    required this.status,
    required this.count,
  });
}

/// Функция для создания подключения к базе данных
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Получаем папку для базы данных
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'routes.db'));
    
    return NativeDatabase.createInBackground(file);
  });
}
