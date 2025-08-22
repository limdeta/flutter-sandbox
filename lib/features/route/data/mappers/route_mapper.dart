import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';

import '../../domain/entities/route.dart';
import '../../domain/entities/ipoint_of_interest.dart';
import '../../domain/entities/trading_point_of_interest.dart';
import '../../domain/entities/regular_point_of_interest.dart';
import '../../domain/entities/trading_point.dart';
import '../../../../shared/infrastructure/database/app_database.dart';

/// Mapper для преобразования между Domain и Database моделями
/// 
/// Это critical компонент Clean Architecture:
/// Domain никогда не знает о Database, только через mappers
class RouteMapper {
  
  // =====================================================
  // ROUTE MAPPINGS - Маршруты
  // =====================================================
  
  /// Domain Route → Database RoutesTableCompanion
  static Future<RoutesTableCompanion> toDatabase(Route route, User user) async {
    // Получаем все пользователи из базы для поиска внутреннего ID
    final database = GetIt.instance<AppDatabase>();
    final allUsers = await database.getAllUsers();
    final dbUser = allUsers.where((u) => u.externalId == user.externalId).firstOrNull;
    
    final userIdInt = dbUser != null ? allUsers.indexOf(dbUser) + 1 : 0;
    print('🔗 Создание маршрута для пользователя ${user.firstName} с ID: $userIdInt');
    
    return RoutesTableCompanion(
      // НЕ устанавливаем id - пусть база данных сама создаст autoincrement
      // Только при обновлении существующего route устанавливаем id
      id: route.id != null ? Value(route.id!) : const Value.absent(),
      name: Value(route.name),
      description: Value(route.description),
      createdAt: Value(route.createdAt),
      startTime: Value(route.startTime),
      endTime: Value(route.endTime),
      status: Value(route.status.name), // Enum → String
      pathJson: Value(_encodePathToJson(route.path)),
      userId: Value(userIdInt),
    );
  }
  
  /// Database RoutesTableData → Domain Route  
  static Route fromDatabase(
    RoutesTableData routeData,
    List<IPointOfInterest> points,
  ) {
    return Route(
      id: routeData.id,
      name: routeData.name,
      description: routeData.description,
      createdAt: routeData.createdAt,
      startTime: routeData.startTime,
      endTime: routeData.endTime,
      pointsOfInterest: points,
      path: _decodePathFromJson(routeData.pathJson),
      status: RouteStatus.values.byName(routeData.status),
    );
  }

  // =====================================================
  // POINT OF INTEREST MAPPINGS - Точки интереса
  // =====================================================
  
  /// Domain IPointOfInterest → Database PointsOfInterestTableCompanion
  static PointsOfInterestTableCompanion pointToDatabase(
  IPointOfInterest point,
  int routeId,
  int orderIndex, {
    int? tradingPointDatabaseId, // Реальный ID из таблицы trading_points
  }) {
    return PointsOfInterestTableCompanion(
      // id: Value(point.id), // Для insert не указываем!
      routeId: Value(routeId),
      name: Value(point.displayName),
      description: Value(point.notes ?? ''),
      latitude: Value(point.coordinates.latitude),
      longitude: Value(point.coordinates.longitude),
      plannedArrivalTime: Value(point.plannedArrivalTime),
      plannedDepartureTime: Value(point.plannedDepartureTime),
      actualArrivalTime: Value(point.actualArrivalTime),
      actualDepartureTime: Value(point.actualDepartureTime),
      type: Value(point.type.name),
      status: Value(point.status.name),
      notes: Value(point.notes),
      tradingPointId: Value(tradingPointDatabaseId), // Используем реальный DB ID
      orderIndex: Value(point.order ?? orderIndex),
      createdAt: Value(point.createdAt),
      updatedAt: Value(point.updatedAt),
    );
  }
  
  /// Database PointsOfInterestTableData → Domain IPointOfInterest
  static IPointOfInterest pointFromDatabase(
    PointsOfInterestTableData pointData,
    TradingPointsTableData? tradingPointData,
  ) {
    final coordinates = LatLng(pointData.latitude, pointData.longitude);
    final type = PointType.values.byName(pointData.type);
    final status = VisitStatus.values.byName(pointData.status);
    
    // Если есть связанная торговая точка, создаем TradingPointOfInterest
    if (tradingPointData != null) {
      final tradingPoint = TradingPoint(
        externalId: tradingPointData.externalId,
        name: tradingPointData.name,
        inn: tradingPointData.inn,
      );
      return TradingPointOfInterest(
        id: pointData.id,
        name: pointData.name,
        tradingPoint: tradingPoint,
        coordinates: coordinates,
        plannedArrivalTime: pointData.plannedArrivalTime,
        plannedDepartureTime: pointData.plannedDepartureTime,
        actualArrivalTime: pointData.actualArrivalTime,
        actualDepartureTime: pointData.actualDepartureTime,
        status: status,
        notes: pointData.notes,
        order: pointData.orderIndex,
      );
    }
    // Иначе создаем обычную точку
    return RegularPointOfInterest(
      id: pointData.id,
      name: pointData.name,
      description: pointData.description,
      coordinates: coordinates,
      type: type,
      plannedArrivalTime: pointData.plannedArrivalTime,
      plannedDepartureTime: pointData.plannedDepartureTime,
      actualArrivalTime: pointData.actualArrivalTime,
      actualDepartureTime: pointData.actualDepartureTime,
      status: status,
      notes: pointData.notes,
      order: pointData.orderIndex,
    );
  }

  // =====================================================
  // TRADING POINT MAPPINGS - Торговые точки
  // =====================================================
  
  /// Domain TradingPoint → Database TradingPointsTableCompanion
  static TradingPointsTableCompanion tradingPointToDatabase(TradingPoint point) {
    return TradingPointsTableCompanion(
      externalId: Value(point.externalId),
      name: Value(point.name),
      inn: Value(point.inn),
      updatedAt: Value(DateTime.now()),
    );
  }
  
  /// Database TradingPointsTableData → Domain TradingPoint
  static TradingPoint tradingPointFromDatabase(TradingPointsTableData data) {
    return TradingPoint(
      externalId: data.externalId,
      name: data.name,
      inn: data.inn,
    );
  }

  // =====================================================
  // PRIVATE HELPERS - Вспомогательные методы
  // =====================================================
  
  /// Кодирует путь в JSON для сохранения в БД
  static String? _encodePathToJson(List<LatLng> path) {
    if (path.isEmpty) return null;
    
    final List<Map<String, double>> pathList = path.map((latLng) => {
      'lat': latLng.latitude,
      'lng': latLng.longitude,
    }).toList();
    
    return json.encode(pathList);
  }
  
  /// Декодирует путь из JSON после загрузки из БД
  static List<LatLng> _decodePathFromJson(String? pathJson) {
    if (pathJson == null || pathJson.isEmpty) return [];
    
    try {
      final List<dynamic> pathList = json.decode(pathJson);
      return pathList.map((point) => LatLng(
        point['lat'] as double,
        point['lng'] as double,
      )).toList();
    } catch (e) {
      // Если произошла ошибка декодирования, возвращаем пустой путь
      return [];
    }
  }
}

/// Extension для удобной работы с bulk операциями
extension RouteMapperExtensions on RouteMapper {
  
  /// Преобразует список точек в Companions для batch вставки
  static List<PointsOfInterestTableCompanion> pointsToDatabase(
    List<IPointOfInterest> points,
    int routeId, {
    Map<String, int>? tradingPointDatabaseIds, // Маппинг externalId -> databaseId
  }) {
    return points.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      
      int? tradingPointId;
      if (point is TradingPointOfInterest && tradingPointDatabaseIds != null) {
        tradingPointId = tradingPointDatabaseIds[point.tradingPoint.externalId];
      }
      
      return RouteMapper.pointToDatabase(
        point, 
        routeId, 
        index,
        tradingPointDatabaseId: tradingPointId,
      );
    }).toList();
  }
  
  // TODO: Восстановить этот метод когда определим RouteWithPointsResult в AppDatabase
  // /// Группирует результаты JOIN запроса в удобную структуру
  // static Map<int, List<RouteWithPointsResult>> groupRouteResults(
  //   List<RouteWithPointsResult> results,
  // ) {
  //   final Map<int, List<RouteWithPointsResult>> grouped = {};
  //   
  //   for (final result in results) {
  //     final routeId = result.route.id;
  //     if (!grouped.containsKey(routeId)) {
  //       grouped[routeId] = [];
  //     }
  //     grouped[routeId]!.add(result);
  //   }
  //   
  //   return grouped;
  // }
}
