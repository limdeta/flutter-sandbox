import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/shared/domain/either.dart';
import 'package:tauzero/shared/domain/failures.dart';

import '../database/route_database.dart';
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
  final RouteDatabase _database;
  
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
  Stream<List<Route>> watchUserRoutes(User user) {
    // TODO: Изменить схему БД для поддержки String userId
    final userIdInt = int.tryParse(user.externalId) ?? 0;
    return _database.watchUserRoutes(userIdInt).asyncMap((routeDataList) async {
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
  Future<Either<EntityCreationFailure, Route>> createRoute(Route route, User? user) async {
    try {
      if (user == null) {
        return const Left(EntityCreationFailure('User is required'));
      }
      
      // Создаем маршрут
      final routeCompanion = RouteMapper.toDatabase(route, user);
      final routeId = await _database.createRoute(routeCompanion);
      
      // Сначала сохраняем торговые точки и получаем их ID
      final tradingPointIds = await _saveTradingPoints(route.pointsOfInterest);
      
      // Затем создаем все точки маршрута с правильными ID торговых точек
      final pointCompanions = RouteMapperExtensions.pointsToDatabase(
        route.pointsOfInterest,
        routeId,
        tradingPointDatabaseIds: tradingPointIds,
      );
      
      for (final pointCompanion in pointCompanions) {
        await _database.createPoint(pointCompanion);
      }
      
      // Загружаем созданный маршрут из базы данных чтобы получить правильные ID точек
      final tempRoute = route.copyWith(id: routeId);
      final createdRouteResult = await getRouteById(tempRoute);
      return createdRouteResult.fold(
        (failure) => Left(EntityCreationFailure('Failed to load created route: ${failure.message}')),
        (createdRoute) => Right(createdRoute),
      );
    } catch (e) {
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
    await _database.updatePointStatus(
      pointId: pointId,
      newStatus: newStatus,
      changedBy: changedBy,
      reason: reason,
    );
  }

  // =====================================================
  // PRIVATE HELPERS - Вспомогательные методы
  // =====================================================
  
  /// Загружает все точки маршрута с торговыми точками
  Future<List<IPointOfInterest>> _loadRoutePoints(int routeId) async {
    final results = await _database.getRouteWithPoints(routeId);
    final List<IPointOfInterest> points = [];
    
    for (final result in results) {
      if (result.point != null) {
        final point = RouteMapper.pointFromDatabase(
          result.point!,
          result.tradingPoint,
        );
        points.add(point);
      }
    }
    
    return points;
  }
  
  /// Сохраняет торговые точки в базу данных и возвращает мапу externalId -> databaseId
  Future<Map<String, int>> _saveTradingPoints(List<IPointOfInterest> points) async {
    final Map<String, int> tradingPointIds = {};
    
    for (final point in points) {
      if (point is TradingPointOfInterest) {
        final companion = RouteMapper.tradingPointToDatabase(point.tradingPoint);
        
        // Сохраняем/обновляем торговую точку
        await _database.upsertTradingPoint(companion);
        
        // Получаем ID из базы данных
        final tradingPointData = await _database.getTradingPoint(point.tradingPoint.externalId);
        if (tradingPointData != null) {
          tradingPointIds[point.tradingPoint.externalId] = tradingPointData.id;
        }
      }
    }
    
    return tradingPointIds;
  }
}
