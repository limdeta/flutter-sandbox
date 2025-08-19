import 'package:latlong2/latlong.dart';
import '../entities/ipoint_of_interest.dart';
import '../entities/regular_point_of_interest.dart';
import '../entities/trading_point_of_interest.dart';
import '../entities/trading_point.dart';
import '../entities/route.dart';


/// Фабрика для создания тестовых маршрутов разной сложности
class RouteFactory {
  static int _routeIdCounter = 1;
  static int _pointIdCounter = 1;
  static int _generateRouteId() => _routeIdCounter++;
  static int _generatePointId() => _pointIdCounter++;

  /// Создает простой маршрут (3-4 точки, без сложной логики)
  static Route createSimpleRoute({
    String? userId,
    DateTime? startDate,
  }) {
    final date = startDate ?? DateTime.now();
    final startTime = DateTime(date.year, date.month, date.day, 9, 0);
    
    final points = <IPointOfInterest>[
      // Начальная точка - офис
      RegularPointOfInterest(
        name: 'Офис компании',
        description: 'Главный офис',
        coordinates: const LatLng(55.7558, 37.6176), // Москва центр
        type: PointType.startPoint,
        plannedArrivalTime: startTime,
        plannedDepartureTime: startTime.add(const Duration(minutes: 15)),
        status: VisitStatus.completed,
        actualArrivalTime: startTime,
        actualDepartureTime: startTime.add(const Duration(minutes: 12)),
      ),

      // Клиент 1
      TradingPointOfInterest(
        name: 'Магазин "У дома"',
        coordinates: const LatLng(55.7600, 37.6200),
        tradingPoint: TradingPoint(
          externalId: 'tp_001',
          name: 'Магазин "У дома"',
          inn: '1234567890',
        ),
        plannedArrivalTime: startTime.add(const Duration(hours: 1)),
        plannedDepartureTime: startTime.add(const Duration(hours: 1, minutes: 30)),
        status: VisitStatus.completed,
        actualArrivalTime: startTime.add(const Duration(hours: 1, minutes: 5)),
        actualDepartureTime: startTime.add(const Duration(hours: 1, minutes: 35)),
      ),

      // Клиент 2 - текущая точка
      TradingPointOfInterest(
        name: 'Супермаркет "Центральный"',
        coordinates: const LatLng(55.7520, 37.6300),
        tradingPoint: TradingPoint(
          externalId: 'tp_002',
          name: 'Супермаркет "Центральный"',
          inn: '0987654321',
        ),
        plannedArrivalTime: startTime.add(const Duration(hours: 2)),
        plannedDepartureTime: startTime.add(const Duration(hours: 2, minutes: 45)),
        status: VisitStatus.arrived,
        actualArrivalTime: startTime.add(const Duration(hours: 2, minutes: 3)),
      ),

      // Возврат в офис
      RegularPointOfInterest(
        name: 'Возврат в офис',
        coordinates: const LatLng(55.7558, 37.6176),
        type: PointType.endPoint,
        plannedArrivalTime: startTime.add(const Duration(hours: 3, minutes: 30)),
        plannedDepartureTime: startTime.add(const Duration(hours: 3, minutes: 40)),
        status: VisitStatus.planned,
      ),
    ];

    return Route(
      id: _generateRouteId(),
      name: 'Простой маршрут ${_formatDate(date)}',
      description: 'Тестовый простой маршрут для пользователя ${userId ?? 'demo'}',
      pointsOfInterest: points,
      status: RouteStatus.active,
      startTime: startTime,
    );
  }

  /// Создает средний маршрут (6-8 точек, с перерывом и разными статусами)
  static Route createMediumRoute({
    String? userId,
    DateTime? startDate,
  }) {
    final date = startDate ?? DateTime.now();
    final startTime = DateTime(date.year, date.month, date.day, 8, 30);
    
    final points = <IPointOfInterest>[
      // Начальная точка
      RegularPointOfInterest(
        name: 'Дом',
        coordinates: const LatLng(55.7400, 37.6000),
        type: PointType.startPoint,
        plannedArrivalTime: startTime,
        plannedDepartureTime: startTime.add(const Duration(minutes: 20)),
        status: VisitStatus.completed,
        actualArrivalTime: startTime,
        actualDepartureTime: startTime.add(const Duration(minutes: 18)),
      ),

      // Клиент 1 - завершен
      TradingPointOfInterest(
        name: 'Аптека "Здоровье"',
        coordinates: const LatLng(55.7450, 37.6100),
        tradingPoint: TradingPoint(
          externalId: 'tp_101',
          name: 'Аптека "Здоровье"',
          inn: '1111222233',
        ),
        plannedArrivalTime: startTime.add(const Duration(hours: 1)),
        plannedDepartureTime: startTime.add(const Duration(hours: 1, minutes: 40)),
        status: VisitStatus.completed,
        actualArrivalTime: startTime.add(const Duration(hours: 1, minutes: 8)),
        actualDepartureTime: startTime.add(const Duration(hours: 1, minutes: 45)),
      ),

      // Клиент 2 - завершен с опозданием
      TradingPointOfInterest(
        name: 'Кафе "Встреча"',
        coordinates: const LatLng(55.7500, 37.6150),
        tradingPoint: TradingPoint(
          externalId: 'tp_102',
          name: 'Кафе "Встреча"',
          inn: '2222333344',
        ),
        plannedArrivalTime: startTime.add(const Duration(hours: 2, minutes: 15)),
        plannedDepartureTime: startTime.add(const Duration(hours: 3)),
        status: VisitStatus.completed,
        actualArrivalTime: startTime.add(const Duration(hours: 2, minutes: 35)), // Опоздание на 20 мин
        actualDepartureTime: startTime.add(const Duration(hours: 3, minutes: 10)),
      ),

      // Обеденный перерыв
      RegularPointOfInterest(
        name: 'Ресторан "Обед"',
        description: 'Обеденный перерыв',
        coordinates: LatLng(55.7480, 37.6180),
        type: PointType.break_,
        plannedArrivalTime: startTime.add(const Duration(hours: 3, minutes: 30)),
        plannedDepartureTime: startTime.add(const Duration(hours: 4, minutes: 30)),
        status: VisitStatus.completed,
        actualArrivalTime: startTime.add(const Duration(hours: 3, minutes: 40)),
        actualDepartureTime: startTime.add(const Duration(hours: 4, minutes: 25)),
      ),

      // Клиент 3 - текущий
      TradingPointOfInterest(
        name: 'Офис "БизнесСервис"',
        coordinates: const LatLng(55.7550, 37.6250),
        tradingPoint: TradingPoint(
          externalId: 'tp_103',
          name: 'Офис "БизнесСервис"',
          inn: '3333444455',
        ),
        plannedArrivalTime: startTime.add(const Duration(hours: 5)),
        plannedDepartureTime: startTime.add(const Duration(hours: 6)),
        status: VisitStatus.arrived,
        actualArrivalTime: startTime.add(const Duration(hours: 5, minutes: 2)),
      ),

      // Клиент 4 - пропущен
      TradingPointOfInterest(
        name: 'Склад "Логистика+"',
        coordinates: const LatLng(55.7350, 37.6350),
        tradingPoint: TradingPoint(
          externalId: 'tp_104',
          name: 'Склад "Логистика+"',
          inn: '4444555566',
        ),
        plannedArrivalTime: startTime.add(const Duration(hours: 6, minutes: 30)),
        plannedDepartureTime: startTime.add(const Duration(hours: 7)),
        status: VisitStatus.skipped,
        notes: 'Клиент отменил встречу',
      ),

      // Клиент 5 - запланирован
      TradingPointOfInterest(
        name: 'Магазин "Техноцентр"',
        coordinates: const LatLng(55.7600, 37.6080),
        tradingPoint: TradingPoint(
          externalId: 'tp_105',
          name: 'Магазин "Техноцентр"',
          inn: '5555666677',
        ),
        plannedArrivalTime: startTime.add(const Duration(hours: 7, minutes: 30)),
        plannedDepartureTime: startTime.add(const Duration(hours: 8, minutes: 15)),
        status: VisitStatus.planned,
      ),

      // Конечная точка
      RegularPointOfInterest(
        name: 'Дом',
        coordinates: const LatLng(55.7400, 37.6000),
        type: PointType.endPoint,
        plannedArrivalTime: startTime.add(const Duration(hours: 9)),
        plannedDepartureTime: startTime.add(const Duration(hours: 9, minutes: 10)),
        status: VisitStatus.planned,
      ),
    ];

    return Route(
      id: _generateRouteId(),
      name: 'Средний маршрут ${_formatDate(date)}',
      description: 'Тестовый средний маршрут с перерывами для пользователя ${userId ?? 'demo'}',
      pointsOfInterest: points,
      status: RouteStatus.active,
      startTime: startTime,
    );
  }

  /// Создает сложный маршрут (10+ точек, много разных типов и статусов)
  static Route createComplexRoute({
    String? userId,
    DateTime? startDate,
  }) {
    final date = startDate ?? DateTime.now();
    final startTime = DateTime(date.year, date.month, date.day, 7, 45);
    
    final points = <IPointOfInterest>[
      // Начальная точка - офис
      RegularPointOfInterest(
        name: 'Главный офис',
        coordinates: const LatLng(55.7558, 37.6176),
        type: PointType.startPoint,
        plannedArrivalTime: startTime,
        plannedDepartureTime: startTime.add(const Duration(minutes: 30)),
        status: VisitStatus.completed,
        actualArrivalTime: startTime.subtract(const Duration(minutes: 5)),
        actualDepartureTime: startTime.add(const Duration(minutes: 25)),
      ),

      // Склад
      RegularPointOfInterest(
        name: 'Склад №1',
        description: 'Получение товара',
        coordinates: const LatLng(55.7400, 37.6250),
        type: PointType.warehouse,
        plannedArrivalTime: startTime.add(const Duration(minutes: 45)),
        plannedDepartureTime: startTime.add(const Duration(hours: 1, minutes: 15)),
        status: VisitStatus.completed,
        actualArrivalTime: startTime.add(const Duration(minutes: 50)),
        actualDepartureTime: startTime.add(const Duration(hours: 1, minutes: 20)),
      ),
    ];

    // Добавляем много торговых точек
    final tradingPoints = [
      ('Сеть "Продукты24"', LatLng(55.7600, 37.6200), 'tp_201', '1010101010'),
      ('Аптека "Фармация"', LatLng(55.7650, 37.6150), 'tp_202', '2020202020'),
      ('Магазин "Электроника"', LatLng(55.7520, 37.6300), 'tp_203', '3030303030'),
      ('Кафе "Бистро"', LatLng(55.7580, 37.6120), 'tp_204', '4040404040'),
      ('Офис "Партнер"', LatLng(55.7450, 37.6350), 'tp_205', '5050505050'),
      ('Супермаркет "Мега"', LatLng(55.7700, 37.6080), 'tp_206', '6060606060'),
      ('Автосервис "Мастер"', LatLng(55.7380, 37.6400), 'tp_207', '7070707070'),
      ('Банк "Финанс"', LatLng(55.7620, 37.6050), 'tp_208', '8080808080'),
    ];

    final statuses = [
      VisitStatus.completed,
      VisitStatus.completed,
      VisitStatus.completed,
      VisitStatus.arrived,
      VisitStatus.enRoute,
      VisitStatus.planned,
      VisitStatus.skipped,
      VisitStatus.planned,
    ];

    for (int i = 0; i < tradingPoints.length; i++) {
      final (name, coords, extId, inn) = tradingPoints[i];
      final plannedTime = startTime.add(Duration(hours: 2 + i, minutes: 30));
      final status = statuses[i];
      
      points.add(TradingPointOfInterest(
        name: name,
        coordinates: coords,
        tradingPoint: TradingPoint(
          externalId: extId,
          name: name,
          inn: inn,
        ),
        plannedArrivalTime: plannedTime,
        plannedDepartureTime: plannedTime.add(const Duration(minutes: 45)),
        status: status,
        actualArrivalTime: status == VisitStatus.completed || status == VisitStatus.arrived 
            ? plannedTime.add(Duration(minutes: i * 2)) // Различные опоздания
            : null,
        actualDepartureTime: status == VisitStatus.completed 
            ? plannedTime.add(Duration(minutes: 45 + i)) 
            : null,
        notes: status == VisitStatus.skipped ? 'Не смогли дозвониться' : null,
      ));
    }

    // Обеденный перерыв
    points.add(RegularPointOfInterest(
      name: 'Ресторан "Деловой"',
      description: 'Деловой обед',
      coordinates: const LatLng(55.7500, 37.6200),
      type: PointType.break_,
      plannedArrivalTime: startTime.add(const Duration(hours: 6)),
      plannedDepartureTime: startTime.add(const Duration(hours: 7)),
      status: VisitStatus.completed,
      actualArrivalTime: startTime.add(const Duration(hours: 6, minutes: 10)),
      actualDepartureTime: startTime.add(const Duration(hours: 6, minutes: 55)),
    ));

    // Конечная точка
    points.add(RegularPointOfInterest(
      name: 'Возврат в офис',
      coordinates: const LatLng(55.7558, 37.6176),
      type: PointType.endPoint,
      plannedArrivalTime: startTime.add(const Duration(hours: 11)),
      plannedDepartureTime: startTime.add(const Duration(hours: 11, minutes: 15)),
      status: VisitStatus.planned,
    ));

    return Route(
      id: _generateRouteId(),
      name: 'Сложный маршрут ${_formatDate(date)}',
      description: 'Тестовый сложный маршрут с множеством точек для пользователя ${userId ?? 'demo'}',
      pointsOfInterest: points,
      status: RouteStatus.active,
      startTime: startTime,
    );
  }

  /// Форматирует дату для названия маршрута
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
