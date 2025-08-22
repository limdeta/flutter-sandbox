import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/shared/domain/either.dart';
import 'package:tauzero/shared/domain/failures.dart';
import 'package:drift/drift.dart';

import '../../../../shared/infrastructure/database/app_database.dart';
import '../mappers/route_mapper.dart';
import '../../domain/entities/route.dart';
import '../../domain/entities/ipoint_of_interest.dart';
import '../../domain/entities/trading_point_of_interest.dart';
import '../../domain/repositories/iroute_repository.dart';

/// Реализация репозитория маршрутов через Drift database
/// 
/// Это implementation слой в Clean Architecture:
/// - Знает о Drift и SQL
/// - Реализует domain interface
/// - Использует mappers для преобразования данных
class RouteRepository implements IRouteRepository {
  final AppDatabase _database;
  
  RouteRepository(this._database);

  // =====================================================
  // ROUTE OPERATIONS - Операции с маршрутами
  // =====================================================
  
  @override
  Future<List<Route>> getAllRoutes() async {
    try {
      final allRoutes = await _database.select(_database.routesTable).get();
      final routesList = <Route>[];
      
      for (final routeData in allRoutes) {
        final points = await _loadRoutePoints(routeData.id);
        final route = RouteMapper.fromDatabase(routeData, points);
        routesList.add(route);
      }
      
      return routesList;
    } catch (e) {
      return [];
    }
  }
  
  @override
  Stream<List<Route>> watchUserRoutes(User user) async* {
    // Получаем все пользователи и находим внутренний ID для текущего пользователя
    final allUsers = await _database.getAllUsers();
    final dbUser = allUsers.where((u) => u.externalId == user.externalId).firstOrNull;
    
    if (dbUser == null) {
      print('❌ Пользователь ${user.firstName} не найден в БД');
      yield [];
      return;
    }
    
    // Получаем внутренний userId (предполагаем что это порядковый номер в списке + 1)
    final userIdInt = allUsers.indexOf(dbUser) + 1;
    
    yield* _database.watchUserRoutes(userIdInt).asyncMap((routeDataList) async {
      final List<Route> routes = [];
      
      for (final routeData in routeDataList) {
        final points = await _loadRoutePoints(routeData.id);
        final route = RouteMapper.fromDatabase(routeData, points);
        routes.add(route);
      }
      
      return routes;
    });
  }
  
  @override
  Future<Either<NotFoundFailure, Route>> getRouteById(Route route) async {
    if (route.id == null) {
      return const Left(NotFoundFailure('Route ID is null'));
    }
    
    final routeData = await _database.getRouteById(route.id!);
    if (routeData == null) {
      return const Left(NotFoundFailure('Route not found'));
    }
    
    final points = await _loadRoutePoints(route.id!);
    final foundRoute = RouteMapper.fromDatabase(routeData, points);
    return Right(foundRoute);
  }
  
  @override
  Future<Either<NotFoundFailure, Route>> getRouteByInternalId(int routeId) async {
    final routeData = await _database.getRouteById(routeId);
    if (routeData == null) {
      return const Left(NotFoundFailure('Route not found'));
    }
    
    final points = await _loadRoutePoints(routeId);
    final foundRoute = RouteMapper.fromDatabase(routeData, points);
    return Right(foundRoute);
  }
  
  @override
  Future<Either<EntityCreationFailure, Route>> createRoute(Route route, User? user) async {
    try {
      if (user == null) {
        return const Left(EntityCreationFailure('User is required'));
      }
      
      // Создаем маршрут
      final routeCompanion = await RouteMapper.toDatabase(route, user);
      final routeId = await _database.createRoute(routeCompanion);
      
      // Сохраняем торговые точки и создаем точки маршрута
      final tradingPointIds = await _saveTradingPoints(route.pointsOfInterest);
      final pointCompanions = RouteMapperExtensions.pointsToDatabase(
        route.pointsOfInterest,
        routeId,
        tradingPointDatabaseIds: tradingPointIds,
      );
      
      for (final pointCompanion in pointCompanions) {
        await _database.createPoint(pointCompanion);
      }
      
      // Загружаем созданный маршрут из базы данных
      final tempRoute = route.copyWith(id: routeId);
      final createdRouteResult = await getRouteById(tempRoute);
      return createdRouteResult.fold(
        (failure) => Left(EntityCreationFailure('Failed to load created route: ${failure.message}')),
        (createdRoute) => Right(createdRoute),
      );
    } catch (e) {
      print('❌ Ошибка создания маршрута: $e');
      return Left(EntityCreationFailure('Failed to create route: $e'));
    }
  }
  
  @override
  Future<Either<EntityUpdateFailure, Route>> updateRoute(Route route, User? user) async {
    try {
      if (user == null) {
        return const Left(EntityUpdateFailure('User is required'));
      }
      
      if (route.id == null) {
        return const Left(EntityUpdateFailure('Route ID is required for update'));
      }
      
      // Удаляем старые точки и пересоздаем маршрут с новыми данными
      // TODO: Оптимизировать - обновлять только измененные точки
      await _database.deleteRoute(route.id!);
      final createResult = await createRoute(route, user);
      return createResult.fold(
        (failure) => Left(EntityUpdateFailure('Failed to recreate route: ${failure.message}')),
        (updatedRoute) => Right(updatedRoute),
      );
    } catch (e) {
      return Left(EntityUpdateFailure('Failed to update route: $e'));
    }
  }
  
  @override
  Future<void> deleteRoute(Route route) async {
    if (route.id != null) {
      await _database.deleteRoute(route.id!);
    }
  }

  // =====================================================
  // POINT OPERATIONS - Операции с точками
  // =====================================================
  
  @override
  Future<void> updatePointStatus({
    required int pointId,
    required String newStatus,
    required String changedBy,
    String? reason,
  }) async {
    // TODO: Нужно получить текущий статус точки, чтобы передать fromStatus
    // Пока передаем placeholder значения
    await _database.updatePointStatus(
      pointId: pointId,
      fromStatus: 'planned', // TODO: получить текущий статус
      toStatus: newStatus,
      changedBy: changedBy,
      reason: reason,
    );
  }

  // =====================================================
  // PRIVATE HELPERS - Вспомогательные методы
  // =====================================================
  
  /// Загружает все точки маршрута с торговыми точками
  Future<List<IPointOfInterest>> _loadRoutePoints(int routeId) async {
    // Получаем все точки маршрута отсортированные по order
    final query = _database.select(_database.pointsOfInterestTable)
        ..where((tbl) => tbl.routeId.equals(routeId));
    query.orderBy([(tbl) => OrderingTerm(expression: tbl.orderIndex)]);
    final pointsData = await query.get();
    
    final List<IPointOfInterest> points = [];
    
    for (final pointData in pointsData) {
      // Для каждой точки получаем торговую точку (если есть)
      TradingPointsTableData? tradingPointData;
      if (pointData.tradingPointId != null) {
        tradingPointData = await (_database.select(_database.tradingPointsTable)
            ..where((tbl) => tbl.id.equals(pointData.tradingPointId!))).getSingleOrNull();
      }
      
      final point = RouteMapper.pointFromDatabase(
        pointData,
        tradingPointData,
      );
      points.add(point);
    }
    
    return points;
  }
  
  /// Получает ID торговых точек из базы данных (НЕ создает их!)
  Future<Map<String, int>> _saveTradingPoints(List<IPointOfInterest> points) async {
    final Map<String, int> tradingPointIds = {};
    
    for (final point in points) {
      if (point is TradingPointOfInterest) {
        final tradingPointData = await _database.getTradingPoint(point.tradingPoint.externalId);
        if (tradingPointData != null) {
          tradingPointIds[point.tradingPoint.externalId] = tradingPointData.id;
        } else {
          print('⚠️ Торговая точка ${point.tradingPoint.externalId} не найдена в БД! Убедитесь что торговые точки созданы перед маршрутами.');
        }
      }
    }
    
    return tradingPointIds;
  }
  
  @override
  Future<void> clearAllTradingPoints() async {
    print('🧹 Очищаем все торговые точки...');
    final count = await _database.delete(_database.tradingPointsTable).go();
    print('✅ Удалено торговых точек: $count');
  }
}
