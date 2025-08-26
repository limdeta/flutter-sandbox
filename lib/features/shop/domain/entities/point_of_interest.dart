import 'package:latlong2/latlong.dart';

/// Интерфейс для любой точки на маршруте
/// Сервисы работают только с этим контрактом
abstract interface class PointOfInterest {
  int? get order;
  int? get id; // autoincrement primary key
  String get name;
  String? get description;
  LatLng get coordinates;
  DateTime get createdAt;
  DateTime? get updatedAt;
  
  DateTime? get plannedArrivalTime;
  DateTime? get plannedDepartureTime;
  DateTime? get actualArrivalTime;
  DateTime? get actualDepartureTime;
  
  PointType get type;
  VisitStatus get status;
  String? get notes;
  
  String? get externalId;
  
  String get displayName;
  
  /// Создает копию с новым статусом
  PointOfInterest copyWith({
    VisitStatus? status,
    DateTime? actualArrivalTime,
    DateTime? actualDepartureTime,
    String? notes,
  });
  

  bool get isVisited;
  bool get isCurrentlyAt;
  bool get isOnTime;
  Duration? get delay;
}

/// Типы точек интереса
enum PointType {
  startPoint,
  client,
  meeting,
  break_,
  warehouse,
  office,
  endPoint,
  regular,
}

/// Статусы посещения точки
enum VisitStatus {
  planned,        // Запланировано
  enRoute,        // В пути к точке
  arrived,        // Прибыл в точку
  completed,      // Посещение завершено
  skipped,        // Пропущено
}
