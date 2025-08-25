import 'package:latlong2/latlong.dart';
import 'package:tauzero/shared/geopoint.dart';
import 'trading_point.dart';

/// Точка интереса на маршруте
class PointOfInterestImpl implements GeoPoint {
  final int? order;
  @override
  double get latitude => coordinates.latitude;
  @override
  double get longitude => coordinates.longitude;
  final String id;
  final String name;
  final String? description;
  final LatLng coordinates;
  final DateTime? plannedArrivalTime;
  final DateTime? plannedDepartureTime;
  final DateTime? actualArrivalTime;
  final DateTime? actualDepartureTime;
  final PointType type;
  final VisitStatus status;
  final String? notes;
  final TradingPoint? tradingPoint; // Связь с торговой точкой
  final String? externalId; // ID во внешней системе (для интеграции)

  const PointOfInterestImpl({
    required this.id,
    required this.name,
    required this.coordinates,
    this.description,
    this.plannedArrivalTime,
    this.plannedDepartureTime,
    this.actualArrivalTime,
    this.actualDepartureTime,
    this.type = PointType.regular,
    this.status = VisitStatus.planned,
    this.notes,
    this.tradingPoint,
    this.externalId,
    this.order,
  });

  /// Создает копию с измененными параметрами
  PointOfInterestImpl copyWith({
    String? id,
    String? name,
    String? description,
    LatLng? coordinates,
    DateTime? plannedArrivalTime,
    DateTime? plannedDepartureTime,
    DateTime? actualArrivalTime,
    DateTime? actualDepartureTime,
    PointType? type,
    VisitStatus? status,
    String? notes,
    TradingPoint? tradingPoint,
    String? externalId,
    int? order,
  }) {
    return PointOfInterestImpl(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coordinates: coordinates ?? this.coordinates,
      plannedArrivalTime: plannedArrivalTime ?? this.plannedArrivalTime,
      plannedDepartureTime: plannedDepartureTime ?? this.plannedDepartureTime,
      actualArrivalTime: actualArrivalTime ?? this.actualArrivalTime,
      actualDepartureTime: actualDepartureTime ?? this.actualDepartureTime,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      tradingPoint: tradingPoint ?? this.tradingPoint,
      externalId: externalId ?? this.externalId,
      order: order ?? this.order,
    );
  }

  /// Проверяет, была ли точка посещена
  bool get isVisited => status == VisitStatus.completed;

  /// Проверяет, находится ли пользователь в точке
  bool get isCurrentlyAt => status == VisitStatus.arrived;

  /// Получает фактическую длительность пребывания в точке
  Duration? get actualDuration {
    if (actualArrivalTime != null && actualDepartureTime != null) {
      return actualDepartureTime!.difference(actualArrivalTime!);
    }
    return null;
  }

  /// Получает плановую длительность пребывания в точке
  Duration? get plannedDuration {
    if (plannedArrivalTime != null && plannedDepartureTime != null) {
      return plannedDepartureTime!.difference(plannedArrivalTime!);
    }
    return null;
  }

  /// Проверяет, прибыл ли пользователь вовремя
  bool get isOnTime {
    if (plannedArrivalTime == null || actualArrivalTime == null) {
      return true; // Если нет плана, считаем что все хорошо
    }
    return actualArrivalTime!.isBefore(plannedArrivalTime!.add(const Duration(minutes: 15))); // 15 мин допуск
  }

  /// Получает опоздание (если есть)
  Duration? get delay {
    if (plannedArrivalTime == null || actualArrivalTime == null) {
      return null;
    }
    if (actualArrivalTime!.isAfter(plannedArrivalTime!)) {
      return actualArrivalTime!.difference(plannedArrivalTime!);
    }
    return null;
  }

  @override
  String toString() {
    return 'PointOfInterest(id: $id, name: $name, type: $type, status: $status, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PointOfInterestImpl && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Типы точек интереса
enum PointType {
  startPoint,     // Начальная точка (офис, дом)
  client,         // Клиент
  meeting,        // Встреча/переговоры
  break_,         // Перерыв (обед, кофе) - break с _ т.к. break зарезервированное слово
  warehouse,      // Склад
  office,         // Офис
  endPoint,       // Конечная точка
  regular,        // Обычная точка
}

/// Статусы посещения точки
enum VisitStatus {
  planned,        // Запланировано
  enRoute,        // В пути к точке
  arrived,        // Прибыл в точку
  completed,      // Посещение завершено
  skipped,        // Пропущено
}
