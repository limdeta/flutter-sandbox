import 'package:latlong2/latlong.dart';
import 'package:get_it/get_it.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';

import '../../domain/entities/route.dart';
import '../../domain/entities/regular_point_of_interest.dart';
import '../../domain/entities/trading_point_of_interest.dart';
import '../../domain/entities/trading_point.dart';
import '../../domain/entities/ipoint_of_interest.dart';
import '../../domain/repositories/iroute_repository.dart';


/// Сервис для создания dev фикстур маршрутов
/// 
/// Создает реалистичные тестовые маршруты для торговых представителей:
/// - Вчерашний маршрут (завершенный)
/// - Сегодняшний маршрут (в процессе выполнения)
/// - Завтрашний маршрут (запланированный)
/// 
/// Это поможет протестировать все use cases системы маршрутизации
class RouteFixtureService {
  final IRouteRepository _repository;
  
  RouteFixtureService(this._repository);
  
  /// Создает все dev фикстуры для торгового представителя
  Future<void> createDevFixtures(User user) async {
    print('🔧 Создаем dev фикстуры для торгового представителя ${user.fullName}');
    
    // Удаляем старые данные пользователя если есть
    await _clearUserData(user);
    
    // Создаем вчерашний маршрут (завершенный)
    final yesterdayRoute = _createYesterdayRoute(user);
    await _repository.createRoute(yesterdayRoute, user);
    print('✅ Вчерашний маршрут создан: ${yesterdayRoute.name}');
    
    // Создаем сегодняшний маршрут (в работе)
    final todayRoute = _createTodayRoute(user);
    await _repository.createRoute(todayRoute, user);
    print('✅ Сегодняшний маршрут создан: ${todayRoute.name}');
    
    // Создаем завтрашний маршрут (запланированный)
    final tomorrowRoute = _createTomorrowRoute(user);
    await _repository.createRoute(tomorrowRoute, user);
    print('✅ Завтрашний маршрут создан: ${tomorrowRoute.name}');
    
    print('🎉 Dev фикстуры для ${user.fullName} готовы!');
  }
  
  /// Создает вчерашний маршрут (почти полностью завершен)
  Route _createYesterdayRoute(User user) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final startOfDay = DateTime(yesterday.year, yesterday.month, yesterday.day, 9, 0);
    
    return Route(
      name: 'Маршрут от ${_formatDate(yesterday)}',
      description: 'Вчерашний рабочий день - почти полностью завершен',
      createdAt: startOfDay.subtract(const Duration(hours: 1)),
      startTime: startOfDay,
      endTime: startOfDay.add(const Duration(hours: 7, minutes: 45)), // Закончил раньше
      status: RouteStatus.completed,
      pointsOfInterest: [
        // 1. Склад - начальная точка (завершена)
        RegularPointOfInterest(
          name: 'Основной склад',
          description: 'Загрузка товара на день',
          coordinates: const LatLng(43.1158, 131.8858), // Владивосток, район склада
          type: PointType.warehouse,
          plannedArrivalTime: startOfDay,
          plannedDepartureTime: startOfDay.add(const Duration(minutes: 30)),
          actualArrivalTime: startOfDay.subtract(const Duration(minutes: 5)), // Приехал раньше
          actualDepartureTime: startOfDay.add(const Duration(minutes: 25)), // Уехал раньше
          status: VisitStatus.completed,
          notes: 'Загружено: 15 коробок, документы получены',
        ),
        
        // 2. Первый клиент - торговая точка (завершена)
        TradingPointOfInterest(
          name: 'Визит к клиенту "Океан"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_001',
            name: 'ООО "Океан"',
            inn: '2536789012',
          ),
          coordinates: const LatLng(43.1356, 131.9113), // Центр Владивостока
          plannedArrivalTime: startOfDay.add(const Duration(hours: 1)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 1, minutes: 45)),
          actualArrivalTime: startOfDay.add(const Duration(hours: 1, minutes: 10)), // Опоздал на 10 мин
          actualDepartureTime: startOfDay.add(const Duration(hours: 2)), // Задержался
          status: VisitStatus.completed,
          notes: 'Доставлено 5 коробок. Клиент доволен. Новый заказ на следующую неделю.',
        ),
        
        // 3. Второй клиент - торговая точка (завершена)
        TradingPointOfInterest(
          name: 'Визит к клиенту "Приморский"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_002',
            name: 'ИП Иванов А.С. "Приморский"',
            inn: '253678901234',
          ),
          coordinates: const LatLng(43.1050, 131.8735), // Другой район
          plannedArrivalTime: startOfDay.add(const Duration(hours: 2, minutes: 30)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 3, minutes: 15)),
          actualArrivalTime: startOfDay.add(const Duration(hours: 2, minutes: 45)),
          actualDepartureTime: startOfDay.add(const Duration(hours: 3, minutes: 30)),
          status: VisitStatus.completed,
          notes: 'Доставлено 3 коробки. Оплата наличными.',
        ),
        
        // 4. Третий клиент - торговая точка (завершена)
        TradingPointOfInterest(
          name: 'Визит к клиенту "Дальний"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_003',
            name: 'ООО "Дальний Восток Трейд"',
            inn: '2536789034',
          ),
          coordinates: const LatLng(43.0721, 131.9042), // Отдаленный район
          plannedArrivalTime: startOfDay.add(const Duration(hours: 4)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 4, minutes: 45)),
          actualArrivalTime: startOfDay.add(const Duration(hours: 4, minutes: 15)),
          actualDepartureTime: startOfDay.add(const Duration(hours: 5)),
          status: VisitStatus.completed,
          notes: 'Доставлено 4 коробки. Обсудили расширение ассортимента.',
        ),
        
        // 5. Обеденный перерыв (пропущен - работал без перерыва)
        RegularPointOfInterest(
          name: 'Обеденный перерыв',
          description: 'Кафе "У моря"',
          coordinates: const LatLng(43.1183, 131.8850),
          type: PointType.break_,
          plannedArrivalTime: startOfDay.add(const Duration(hours: 5, minutes: 30)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 6, minutes: 30)),
          status: VisitStatus.skipped, // Пропустил обед
          notes: 'Пропущен - работал без перерыва, чтобы успеть больше клиентов',
        ),
        
        // 6. Четвертый клиент - торговая точка (завершена)
        TradingPointOfInterest(
          name: 'Визит к клиенту "Золотой Рог"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_004',
            name: 'ООО "Золотой Рог"',
            inn: '2536789045',
          ),
          coordinates: const LatLng(43.1067, 131.8730),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 7)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 7, minutes: 45)),
          actualArrivalTime: startOfDay.add(const Duration(hours: 6, minutes: 45)), // Приехал раньше
          actualDepartureTime: startOfDay.add(const Duration(hours: 7, minutes: 30)),
          status: VisitStatus.completed,
          notes: 'Доставлено 3 коробки. Все отлично!',
        ),
        
        // 7. Последний клиент (НЕ завершена - не успел)
        TradingPointOfInterest(
          name: 'Визит к клиенту "Конечная"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_005',
            name: 'ИП Петров "Конечная точка"',
            inn: '2536789056',
          ),
          coordinates: const LatLng(43.0856, 131.9156),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 8, minutes: 15)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 9)),
          status: VisitStatus.planned, // НЕ УСПЕЛ!
          notes: 'Не успел доехать - закончился рабочий день',
        ),
      ],
    );
  }
  
  /// Создает сегодняшний маршрут (в процессе выполнения)
  Route _createTodayRoute(User user) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day, 9, 0);
    final currentTime = DateTime.now();
    
    return Route(
      name: 'Текущий маршрут ${_formatDate(today)}',
      description: 'Сегодняшний рабочий день - в процессе выполнения',
      createdAt: startOfDay.subtract(const Duration(hours: 12)),
      startTime: startOfDay,
      status: RouteStatus.active,
      pointsOfInterest: [
        RegularPointOfInterest(
          name: 'Старт',
          description: 'Начальная точка маршрута',
          coordinates: const LatLng(43.1438, 131.9268),
          type: PointType.warehouse,
          plannedArrivalTime: startOfDay,
          plannedDepartureTime: startOfDay.add(const Duration(minutes: 30)),
          actualArrivalTime: startOfDay.add(const Duration(minutes: 5)),
          actualDepartureTime: startOfDay.add(const Duration(minutes: 35)),
          status: VisitStatus.completed,
          notes: 'Загружено: 18 коробок, все документы в порядке',
          order: 0,
        ),
        TradingPointOfInterest(
          name: 'Первая точка',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_101',
            name: 'ООО "Первая точка"',
            inn: '2536789101',
          ),
          coordinates: const LatLng(43.1332, 131.9118),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 1)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 1, minutes: 45)),
          actualArrivalTime: startOfDay.add(const Duration(hours: 1, minutes: 10)),
          actualDepartureTime: startOfDay.add(const Duration(hours: 1, minutes: 50)),
          status: VisitStatus.completed,
          notes: 'Доставлено 6 коробок. Клиент заказал еще на следующую неделю.',
          order: 1,
        ),
        TradingPointOfInterest(
          name: 'Вторая точка',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_102',
            name: 'ИП Сидоров "Вторая точка"',
            inn: '253678910234',
          ),
          coordinates: const LatLng(43.1372, 131.9501),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 2, minutes: 30)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 3, minutes: 15)),
          actualArrivalTime: startOfDay.add(const Duration(hours: 2, minutes: 35)),
          actualDepartureTime: startOfDay.add(const Duration(hours: 3, minutes: 20)),
          status: VisitStatus.completed,
          notes: 'Доставлено 4 коробки. Оплата по безналу.',
          order: 2,
        ),
        TradingPointOfInterest(
          name: 'Третья точка',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_103',
            name: 'ООО "Третья точка"',
            inn: '2536789103',
          ),
          coordinates: const LatLng(43.1081, 131.9399),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 4)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 4, minutes: 45)),
          actualArrivalTime: currentTime.isAfter(startOfDay.add(const Duration(hours: 4, minutes: 5)))
              ? startOfDay.add(const Duration(hours: 4, minutes: 5))
              : null,
          status: _getCurrentPointStatus(startOfDay.add(const Duration(hours: 4)), currentTime),
          notes: _getCurrentPointStatus(startOfDay.add(const Duration(hours: 4)), currentTime) == VisitStatus.completed
              ? 'Доставлено 5 коробок. Обсудили новые позиции.'
              : null,
          order: 3,
        ),
        TradingPointOfInterest(
          name: 'Четвертая точка',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_104',
            name: 'ООО "Четвертая точка"',
            inn: '2536789104',
          ),
          coordinates: const LatLng(43.0882, 131.9366),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 5, minutes: 30)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 6, minutes: 30)),
          status: VisitStatus.planned,
          order: 4,
        ),
        TradingPointOfInterest(
          name: 'Пятая точка',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_105',
            name: 'ООО "Пятая точка"',
            inn: '2536789105',
          ),
          coordinates: const LatLng(43.0882, 131.9366),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 7)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 7, minutes: 45)),
          status: VisitStatus.planned,
          order: 5,
        ),
        TradingPointOfInterest(
          name: 'Шестая точка',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_106',
            name: 'ООО "Шестая точка"',
            inn: '2536789106',
          ),
          coordinates: const LatLng(43.0757, 131.9591),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 8, minutes: 15)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 9)),
          status: VisitStatus.planned,
          order: 6,
        ),
      ],
    );
  }
  
  /// Определяет статус текущей точки на основе времени
  VisitStatus _getCurrentPointStatus(DateTime plannedTime, DateTime currentTime) {
    if (currentTime.isBefore(plannedTime.subtract(const Duration(minutes: 15)))) {
      return VisitStatus.planned;
    } else if (currentTime.isBefore(plannedTime.add(const Duration(minutes: 30)))) {
      return VisitStatus.enRoute;
    } else if (currentTime.isBefore(plannedTime.add(const Duration(hours: 1)))) {
      return VisitStatus.arrived;
    } else {
      return VisitStatus.completed;
    }
  }
  
  /// Создает завтрашний маршрут (запланированный)
  Route _createTomorrowRoute(User user) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final startOfDay = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);
    
    return Route(
      name: 'Плановый маршрут ${_formatDate(tomorrow)}',
      description: 'Завтрашний рабочий день - полностью запланирован',
      createdAt: DateTime.now(), // Создан сегодня для завтра
      startTime: startOfDay,
      status: RouteStatus.planned,
      pointsOfInterest: [
        // 1. Склад - начальная точка
        RegularPointOfInterest(
          name: 'Основной склад',
          description: 'Загрузка товара на завтра',
          coordinates: const LatLng(43.1158, 131.8858),
          type: PointType.warehouse,
          plannedArrivalTime: startOfDay,
          plannedDepartureTime: startOfDay.add(const Duration(minutes: 30)),
          status: VisitStatus.planned,
        ),
        
        // 2. Крупный клиент - приоритетный визит
        TradingPointOfInterest(
          name: 'Визит к клиенту "Приоритетный"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_PRIORITY_001',
            name: 'ООО "Приоритетный партнер"',
            inn: '2536789201',
          ),
          coordinates: const LatLng(43.1400, 131.9200), // VIP район
          plannedArrivalTime: startOfDay.add(const Duration(hours: 1)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 2)),
          status: VisitStatus.planned,
          notes: 'Важная встреча - презентация новых товаров',
        ),
        
        // 3. Новый клиент - первый визит
        TradingPointOfInterest(
          name: 'Визит к клиенту "Новичок"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_NEW_001',
            name: 'ИП Новиков "Новая точка"',
            inn: '253678920234',
          ),
          coordinates: const LatLng(43.1200, 131.8900),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 2, minutes: 30)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 3, minutes: 30)),
          status: VisitStatus.planned,
          notes: 'Первый визит - знакомство, изучение потребностей',
        ),
        
        // 4. Обеденный перерыв
        RegularPointOfInterest(
          name: 'Обеденный перерыв',
          description: 'Ресторан "Планы на завтра"',
          coordinates: const LatLng(43.1180, 131.8950),
          type: PointType.break_,
          plannedArrivalTime: startOfDay.add(const Duration(hours: 4)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 5)),
          status: VisitStatus.planned,
        ),
        
        // 5. Проблемный клиент - требует внимания
        TradingPointOfInterest(
          name: 'Визит к клиенту "Проблемный"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_PROBLEM_001',
            name: 'ООО "Сложные вопросы"',
            inn: '2536789202',
          ),
          coordinates: const LatLng(43.0900, 131.8600),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 5, minutes: 30)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 6, minutes: 30)),
          status: VisitStatus.planned,
          notes: 'Разбор претензий по качеству. Нужно решить конфликт.',
        ),
        
        // 6. Постоянный клиент - плановый визит
        TradingPointOfInterest(
          name: 'Визит к клиенту "Постоянный"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_REGULAR_001',
            name: 'ИП Константинов "Постоянство"',
            inn: '253678920345',
          ),
          coordinates: const LatLng(43.1300, 131.9100),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 7)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 7, minutes: 45)),
          status: VisitStatus.planned,
          notes: 'Регулярный заказ + обсуждение скидок на большие объемы',
        ),
        
        // 7. Потенциальный клиент - разведка
        TradingPointOfInterest(
          name: 'Визит к клиенту "Потенциал"',
          tradingPoint: TradingPoint(
            externalId: 'CLIENT_POTENTIAL_001',
            name: 'ООО "Большие возможности"',
            inn: '2536789203',
          ),
          coordinates: const LatLng(43.1100, 131.8800),
          plannedArrivalTime: startOfDay.add(const Duration(hours: 8, minutes: 15)),
          plannedDepartureTime: startOfDay.add(const Duration(hours: 9)),
          status: VisitStatus.planned,
          notes: 'Потенциально крупный клиент. Изучить потребности и бюджет.',
        ),
      ],
    );
  }

  /// Очищает данные пользователя (для dev среды)
  Future<void> _clearUserData(User user) async {
    try {
      final routes = await _repository.watchUserRoutes(user).first;
      for (final route in routes) {
        await _repository.deleteRoute(route);
      }
      print('🧹 Старые данные пользователя очищены');
    } catch (e) {
      print('ℹ️ Нет старых данных для очистки: $e');
    }
  }
  
  /// Форматирует дату для отображения
  String _formatDate(DateTime date) {
    final months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

/// Factory для создания FixtureService
class RouteFixtureServiceFactory {
  static RouteFixtureService create() {
    final repository = GetIt.instance<IRouteRepository>();
    return RouteFixtureService(repository);
  }
}
