import 'package:latlong2/latlong.dart';
import 'package:tauzero/features/shop/route/domain/entities/route.dart';
import 'package:tauzero/features/shop/route/domain/entities/point_of_interest.dart';
import 'package:tauzero/features/shop/route/domain/entities/regular_point_of_interest.dart';
import 'package:tauzero/features/shop/route/domain/entities/trading_point_of_interest.dart';
import 'package:tauzero/features/shop/route/domain/entities/trading_point.dart';

/// Фабрика для создания тестовых маршрутов
/// 
/// Предоставляет удобные методы для создания маршрутов с различными сценариями
class RouteFactory {
  static int _counter = 1;
  
  String? _name;
  String? _description;
  RouteStatus? _status;
  DateTime? _createdAt;
  DateTime? _startTime;
  DateTime? _endTime;
  List<IPointOfInterest>? _pointsOfInterest;
  List<LatLng>? _path;

  RouteFactory();

  RouteFactory name(String name) {
    _name = name;
    return this;
  }

  RouteFactory description(String description) {
    _description = description;
    return this;
  }

  RouteFactory status(RouteStatus status) {
    _status = status;
    return this;
  }

  RouteFactory createdAt(DateTime createdAt) {
    _createdAt = createdAt;
    return this;
  }

  RouteFactory startTime(DateTime startTime) {
    _startTime = startTime;
    return this;
  }

  RouteFactory endTime(DateTime endTime) {
    _endTime = endTime;
    return this;
  }

  RouteFactory pointsOfInterest(List<IPointOfInterest> points) {
    _pointsOfInterest = points;
    return this;
  }

  RouteFactory path(List<LatLng> path) {
    _path = path;
    return this;
  }

  /// Добавляет точку интереса к маршруту
  RouteFactory addPoint(IPointOfInterest point) {
    _pointsOfInterest ??= [];
    _pointsOfInterest!.add(point);
    return this;
  }

  /// Создает маршрут с указанными параметрами
  Route build() {
    final currentCounter = _counter++;
    
    return Route(
      name: _name ?? 'Тестовый маршрут $currentCounter',
      description: _description ?? 'Описание тестового маршрута $currentCounter',
      status: _status ?? RouteStatus.planned,
      createdAt: _createdAt ?? DateTime.now(),
      startTime: _startTime,
      endTime: _endTime,
      pointsOfInterest: _pointsOfInterest ?? _createDefaultPoints(currentCounter),
      path: _path ?? const [],
    );
  }

  /// Создает набор точек по умолчанию для тестов
  List<IPointOfInterest> _createDefaultPoints(int counter) {
    return [
      PointFactory.createWarehouse(counter),
      PointFactory.createTradingPoint(counter),
      PointFactory.createRegularPoint(counter),
    ];
  }

  // =====================================================
  // ПРЕДУСТАНОВЛЕННЫЕ СЦЕНАРИИ
  // =====================================================

  /// Простой маршрут для базовых тестов
  static Route createSimple() => RouteFactory().build();

  /// Завершенный маршрут (вчерашний)
  static Route createCompleted() => RouteFactory()
    .status(RouteStatus.completed)
    .startTime(DateTime.now().subtract(const Duration(days: 1, hours: 8)))
    .endTime(DateTime.now().subtract(const Duration(days: 1, hours: 16)))
    .name('Завершенный маршрут')
    .build();

  /// Активный маршрут (сегодняшний)
  static Route createActive() => RouteFactory()
    .status(RouteStatus.active)
    .startTime(DateTime.now().subtract(const Duration(hours: 2)))
    .name('Активный маршрут')
    .build();

  /// Маршрут только с торговыми точками
  static Route createTradingOnly() => RouteFactory()
    .name('Маршрут по торговым точкам')
    .pointsOfInterest([
      PointFactory.createTradingPoint(1),
      PointFactory.createTradingPoint(2),
      PointFactory.createTradingPoint(3),
    ])
    .build();

  /// Маршрут с различными статусами точек
  static Route createMixedStatuses() => RouteFactory()
    .name('Маршрут со смешанными статусами')
    .pointsOfInterest([
      PointFactory.createCompletedPoint(1),
      PointFactory.createActivePoint(2),
      PointFactory.createPlannedPoint(3),
      PointFactory.createSkippedPoint(4),
    ])
    .build();

  /// Маршрут без точек (для тестов валидации)
  static Route createEmpty() => RouteFactory()
    .name('Пустой маршрут')
    .pointsOfInterest([])
    .build();

  /// Маршрут с уникальным префиксом (для изоляции тестов)
  static Route createWithPrefix(String prefix) => RouteFactory()
    .name('$prefix маршрут')
    .pointsOfInterest([
      PointFactory.createTradingPointWithId('${prefix}_tp_1'),
      PointFactory.createRegularPoint(_counter),
    ])
    .build();

  /// Сброс счетчика (для предсказуемости в тестах)
  static void resetCounter() {
    _counter = 1;
  }
}

/// Фабрика для создания тестовых точек интереса
class PointFactory {
  static int _counter = 1;

  /// Склад отправления
  static RegularPointOfInterest createWarehouse(int counter) {
    return RegularPointOfInterest(
      name: 'Склад $counter',
      description: 'Главный склад компании $counter',
      coordinates: LatLng(43.1056 + counter * 0.001, 131.8735 + counter * 0.001),
      type: PointType.warehouse,
      status: VisitStatus.planned,
    );
  }

  /// Торговая точка
  static TradingPointOfInterest createTradingPoint(int counter) {
    return TradingPointOfInterest(
      name: 'Клиент $counter',
      tradingPoint: TradingPoint(
        externalId: 'tp_$counter',
        name: 'ООО "Торговая точка $counter"',
        inn: '${1234567890 + counter}',
      ),
      coordinates: LatLng(43.1156 + counter * 0.001, 131.8835 + counter * 0.001),
      status: VisitStatus.planned,
    );
  }

  /// Торговая точка с конкретным ID
  static TradingPointOfInterest createTradingPointWithId(String externalId) {
    final counter = _counter++;
    return TradingPointOfInterest(
      name: 'Клиент $externalId',
      tradingPoint: TradingPoint(
        externalId: externalId,
        name: 'ООО "Торговая точка $externalId"',
        inn: '${1234567890 + counter}',
      ),
      coordinates: LatLng(43.1156 + counter * 0.001, 131.8835 + counter * 0.001),
      status: VisitStatus.planned,
    );
  }

  /// Обычная точка
  static RegularPointOfInterest createRegularPoint(int counter) {
    return RegularPointOfInterest(
      name: 'Точка доставки $counter',
      description: 'Пункт выдачи заказов $counter',
      coordinates: LatLng(43.1256 + counter * 0.001, 131.8935 + counter * 0.001),
      type: PointType.regular,
      status: VisitStatus.planned,
    );
  }

  /// Точка со статусом "завершено"
  static RegularPointOfInterest createCompletedPoint(int counter) {
    return RegularPointOfInterest(
      name: 'Завершенная точка $counter',
      description: 'Выполненная задача $counter',
      coordinates: LatLng(43.1156 + counter * 0.001, 131.8835 + counter * 0.001),
      type: PointType.regular,
      status: VisitStatus.completed,
      actualArrivalTime: DateTime.now().subtract(Duration(hours: counter)),
      actualDepartureTime: DateTime.now().subtract(Duration(hours: counter - 1)),
    );
  }

  /// Точка со статусом "активная"
  static RegularPointOfInterest createActivePoint(int counter) {
    return RegularPointOfInterest(
      name: 'Активная точка $counter',
      description: 'Текущая задача $counter',
      coordinates: LatLng(43.1156 + counter * 0.001, 131.8835 + counter * 0.001),
      type: PointType.regular,
      status: VisitStatus.arrived,
      actualArrivalTime: DateTime.now().subtract(Duration(minutes: 30)),
    );
  }

  /// Точка со статусом "планируемая"
  static RegularPointOfInterest createPlannedPoint(int counter) {
    return RegularPointOfInterest(
      name: 'Планируемая точка $counter',
      description: 'Будущая задача $counter',
      coordinates: LatLng(43.1156 + counter * 0.001, 131.8835 + counter * 0.001),
      type: PointType.regular,
      status: VisitStatus.planned,
      plannedArrivalTime: DateTime.now().add(Duration(hours: counter)),
    );
  }

  /// Точка со статусом "пропущена"
  static RegularPointOfInterest createSkippedPoint(int counter) {
    return RegularPointOfInterest(
      name: 'Пропущенная точка $counter',
      description: 'Пропущенная задача $counter',
      coordinates: LatLng(43.1156 + counter * 0.001, 131.8835 + counter * 0.001),
      type: PointType.regular,
      status: VisitStatus.skipped,
      notes: 'Пропущена по причине X',
    );
  }
}
