import 'package:latlong2/latlong.dart';
import 'route_point.dart';

/// Утилиты для создания тестовых маршрутов для отладки геолокации
class TestRoutes {
  // Центр Владивостока (площадь Борцов революции)
  static const LatLng vladivostokCenter = LatLng(43.1198, 131.8869);
  
  // ДВФУ (остров Русский)
  static const LatLng dvfu = LatLng(43.0231, 131.8921);
  
  // Торговые центры и офисы
  static const LatLng oceanPlaza = LatLng(43.1150, 131.8820);
  static const LatLng cloverHouse = LatLng(43.1180, 131.8780);
  static const LatLng fanPlaza = LatLng(43.1320, 131.9100);
  static const LatLng kalina = LatLng(43.1280, 131.8950);

  /// Создает рабочий день коммерческого представителя
  /// Начинается в 9:00, заканчивается в 18:00
  static WorkDayRoute createSalesRepWorkDay() {
    final DateTime startOfDay = DateTime.now().copyWith(hour: 9, minute: 0, second: 0, millisecond: 0);
    
    final List<RoutePoint> points = [
      // 9:00 - Начало дня (дом/офис)
      RoutePoint(
        location: vladivostokCenter,
        timestamp: startOfDay,
        description: '🏢 Начало рабочего дня',
        type: RoutePointType.start,
      ),
      
      // 9:30 - Едем к первому клиенту
      RoutePoint(
        location: const LatLng(43.1170, 131.8830),
        timestamp: startOfDay.add(const Duration(minutes: 30)),
        description: '🚗 В пути к Ocean Plaza',
      ),
      
      // 10:00 - Первый клиент (Ocean Plaza)
      RoutePoint(
        location: oceanPlaza,
        timestamp: startOfDay.add(const Duration(hours: 1)),
        description: '🛍️ Клиент: Ocean Plaza\n💼 Презентация новинок',
        type: RoutePointType.checkpoint,
      ),
      
      // 11:00 - Выезжаем от первого клиента
      RoutePoint(
        location: const LatLng(43.1160, 131.8810),
        timestamp: startOfDay.add(const Duration(hours: 2)),
        description: '✅ Встреча завершена, едем дальше',
      ),
      
      // 11:45 - Второй клиент (Clover House)
      RoutePoint(
        location: cloverHouse,
        timestamp: startOfDay.add(const Duration(hours: 2, minutes: 45)),
        description: '🏢 Клиент: Clover House\n📋 Обсуждение ценовой политики',
        type: RoutePointType.checkpoint,
      ),
      
      // 12:30 - Обед
      RoutePoint(
        location: const LatLng(43.1190, 131.8790),
        timestamp: startOfDay.add(const Duration(hours: 3, minutes: 30)),
        description: '🍽️ Обеденный перерыв',
        type: RoutePointType.stop,
      ),
      
      // 13:30 - После обеда, едем к третьему клиенту
      RoutePoint(
        location: const LatLng(43.1250, 131.8900),
        timestamp: startOfDay.add(const Duration(hours: 4, minutes: 30)),
        description: '🚗 Поездка к Fan Plaza',
      ),
      
      // 14:00 - Третий клиент (Fan Plaza)
      RoutePoint(
        location: fanPlaza,
        timestamp: startOfDay.add(const Duration(hours: 5)),
        description: '🛒 Клиент: Fan Plaza\n💰 Переговоры о скидках',
        type: RoutePointType.checkpoint,
      ),
      
      // 15:30 - Четвертый клиент (Kalina Mall)
      RoutePoint(
        location: kalina,
        timestamp: startOfDay.add(const Duration(hours: 6, minutes: 30)),
        description: '🏬 Клиент: Kalina Mall\n📦 Демонстрация товаров',
        type: RoutePointType.checkpoint,
      ),
      
      // 16:30 - Возвращаемся в офис
      RoutePoint(
        location: const LatLng(43.1220, 131.8880),
        timestamp: startOfDay.add(const Duration(hours: 7, minutes: 30)),
        description: '🚗 Возвращение в офис',
      ),
      
      // 17:00 - Конец рабочего дня
      RoutePoint(
        location: vladivostokCenter,
        timestamp: startOfDay.add(const Duration(hours: 8)),
        description: '🏁 Конец рабочего дня\n📊 Отчет готов',
        type: RoutePointType.end,
      ),
    ];
    
    return WorkDayRoute(
      points: points,
      startTime: startOfDay,
      endTime: startOfDay.add(const Duration(hours: 8)),
      description: 'Рабочий день коммерческого представителя',
    );
  }

  /// Создает короткий тестовый маршрут (30 минут)
  static WorkDayRoute createShortTestRoute() {
    final DateTime start = DateTime.now();
    
    final List<RoutePoint> points = [
      RoutePoint(
        location: vladivostokCenter,
        timestamp: start,
        description: '🎯 Тест: Начало',
        type: RoutePointType.start,
      ),
      
      RoutePoint(
        location: const LatLng(43.1180, 131.8850),
        timestamp: start.add(const Duration(minutes: 5)),
        description: '🚶 Движение к цели',
      ),
      
      RoutePoint(
        location: oceanPlaza,
        timestamp: start.add(const Duration(minutes: 15)),
        description: '🎯 Тест: Чек-поинт достигнут',
        type: RoutePointType.checkpoint,
      ),
      
      RoutePoint(
        location: vladivostokCenter,
        timestamp: start.add(const Duration(minutes: 30)),
        description: '🏁 Тест: Завершен',
        type: RoutePointType.end,
      ),
    ];
    
    return WorkDayRoute(
      points: points,
      startTime: start,
      endTime: start.add(const Duration(minutes: 30)),
      description: 'Короткий тестовый маршрут',
    );
  }

  /// Устаревшие методы для совместимости (возвращают только координаты)
  @Deprecated('Используйте createSalesRepWorkDay() или createShortTestRoute()')
  static List<LatLng> centerCircle() {
    return createShortTestRoute().coordinates;
  }

  @Deprecated('Используйте createSalesRepWorkDay() или createShortTestRoute()')
  static List<LatLng> toDVFU() {
    final start = DateTime.now();
    final points = [
      RoutePoint(location: vladivostokCenter, timestamp: start),
      RoutePoint(location: const LatLng(43.1100, 131.8900), timestamp: start.add(const Duration(minutes: 10))),
      RoutePoint(location: const LatLng(43.0800, 131.8920), timestamp: start.add(const Duration(minutes: 20))),
      RoutePoint(location: dvfu, timestamp: start.add(const Duration(minutes: 45))),
    ];
    return points.map((p) => p.location).toList();
  }

  @Deprecated('Используйте createSalesRepWorkDay() или createShortTestRoute()')
  static List<LatLng> vladivostokCenterRoute() {
    return createSalesRepWorkDay().coordinates;
  }

  @Deprecated('Используйте createSalesRepWorkDay() или createShortTestRoute()')
  static List<LatLng> getCircularRoute() {
    return createShortTestRoute().coordinates;
  }
}
