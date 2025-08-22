import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/shared/domain/either.dart';
import 'package:tauzero/shared/domain/failures.dart';

import '../../domain/entities/route.dart';

/// Интерфейс репозитория для маршрутов
/// 
/// Определяет контракт для работы с данными маршрутов.
/// Будет реализован в data слое через Drift database.
abstract class IRouteRepository {
  
  // =====================================================
  // ROUTE OPERATIONS - Операции с маршрутами
  // =====================================================
  
  /// Получить все маршруты пользователя (reactive stream)
  Stream<List<Route>> watchUserRoutes(User user);
  
  /// Получить все маршруты в системе (для администраторов и отладки)
  Future<List<Route>> getAllRoutes();
  
  /// Получить маршрут по ID
  Future<Either<NotFoundFailure, Route>> getRouteById(Route route);
  
  /// Получить маршрут по внутреннему ID
  Future<Either<NotFoundFailure, Route>> getRouteByInternalId(int routeId);
  
  Future<Either<EntityCreationFailure, Route>> createRoute(Route route, User? user);
  Future<Either<EntityUpdateFailure, Route>> updateRoute(Route route, User? user);
  Future<void> deleteRoute(Route route);

  // =====================================================
  // POINT OPERATIONS - Операции с точками
  // =====================================================
  
  /// Обновить статус точки интереса
  Future<void> updatePointStatus({
    required int pointId,
    required String newStatus,
    required String changedBy,
    String? reason,
  });
  
  /// Очистить все торговые точки (для dev режима)
  Future<void> clearAllTradingPoints();
  
  /// Получить историю изменений точки
  // Future<List<PointStatusChange>> getPointStatusHistory(int pointId);

  // =====================================================
  // ANALYTICS & TRANSFER - Аналитика и переносы
  // =====================================================
  
  // Future<RouteStats> getUserRouteStats(int userId);
  
  /// Найти проблемные маршруты (с низкой завершаемостью)
  // Future<List<Route>> getProblematicRoutes(int userId, {double threshold = 0.8});
  
  /// Перенести незавершенные точки в новый маршрут
  /// TODO: Реализация переноса точек на следующий день
  // Future<Route> transferUncompletedPoints({
  //   required int fromRouteId,
  //   required int toRouteId,
  //   required List<int> pointIds,
  // });
}

/// Модель изменения статуса точки
// class PointStatusChange {
//   final int pointId;
//   final String fromStatus;
//   final String toStatus;
//   final DateTime changedAt;
//   final String changedBy;
//   final String? reason;
  
//   PointStatusChange({
//     required this.pointId,
//     required this.fromStatus,
//     required this.toStatus,
//     required this.changedAt,
//     required this.changedBy,
//     this.reason,
//   });
// }

/// Статистика по маршрутам пользователя
// class RouteStats {
//   final Map<String, int> statusCounts;
//   final double averageCompletionRate;
//   final int totalRoutes;
//   final int problematicRoutes;
  
//   RouteStats({
//     required this.statusCounts,
//     required this.averageCompletionRate,
//     required this.totalRoutes,
//     required this.problematicRoutes,
//   });
