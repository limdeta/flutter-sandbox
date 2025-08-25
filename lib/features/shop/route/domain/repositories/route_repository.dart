import 'package:tauzero/features/shop/employee/domain/employee.dart';
import 'package:tauzero/shared/either.dart';
import 'package:tauzero/shared/failures.dart';

import '../entities/route.dart';

/// Интерфейс репозитория для маршрутов
/// 
/// Определяет контракт для работы с данными маршрутов.
/// Будет реализован в data слое через Drift database.
abstract class RouteRepository {
  Stream<List<Route>> watchEmployeeRoutes(Employee employee);
  Future<List<Route>> getAllRoutes();
  Future<Either<NotFoundFailure, Route>> getRouteById(int routeId);
  Future<Either<EntityCreationFailure, Route>> saveRoute(Route route, Employee? employee);
  Future<Either<EntityUpdateFailure, Route>> updateRoute(Route route, Employee? employee);
  Future<void> deleteRoute(Route route);

  /// (для dev режима)
  Future<void> clearAllTradingPoints();
  
  /// TODO: Реализация переноса точек на следующий день
  // Future<Route> transferUncompletedPoints({
  //   required int fromRouteId,
  //   required int toRouteId,
  //   required List<int> pointIds,
  // });
}

