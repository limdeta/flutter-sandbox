import 'package:get_it/get_it.dart';
import 'package:tauzero/app/database/database.dart';
import 'package:tauzero/features/shop/domain/entities/trading_point.dart';

class TradingPointsFixtureService {
  Future<List<TradingPoint>> createBaseTradingPoints() async {
    final points = [
      // Основные торговые точки для маршрутов
      TradingPoint(
        externalId: 'CLIENT_001',
        name: 'ООО "Океан"',
        inn: '2536789012',
      ),
      TradingPoint(
        externalId: 'CLIENT_002', 
        name: 'ООО "Вторая Компания"',
        inn: '2536789023',
      ),
      TradingPoint(
        externalId: 'CLIENT_003',
        name: 'ООО "Третья Компания"',
        inn: '2536789034',
      ),
      TradingPoint(
        externalId: 'CLIENT_004',
        name: 'ООО "Золотой Рог"',
        inn: '2536789045',
      ),
      TradingPoint(
        externalId: 'CLIENT_005',
        name: 'ИП Петров "Конечная точка"',
        inn: '2536789056',
      ),
      TradingPoint(
        externalId: 'CLIENT_101', 
        name: 'ООО "Первая точка"',
        inn: '2536789101',
      ),
      TradingPoint(
        externalId: 'CLIENT_102',
        name: 'ИП Семенов "Вторая точка"', 
        inn: '2536789102',
      ),
      TradingPoint(
        externalId: 'CLIENT_103',
        name: 'ООО "Третья точка"',
        inn: '2536789103',
      ),
      TradingPoint(
        externalId: 'CLIENT_104',
        name: 'ООО "Четвертая точка"',
        inn: '2536789104',
      ),
      TradingPoint(
        externalId: 'CLIENT_105',
        name: 'ООО "Пятая точка"',
        inn: '2536789105',
      ),
      TradingPoint(
        externalId: 'CLIENT_106',
        name: 'ООО "Шестая точка"',
        inn: '2536789106',
      ),
      TradingPoint(
        externalId: 'CLIENT_PRIORITY_001',
        name: 'ООО "Приоритетный партнер"',
        inn: '2536789201',
      ),
      // Специальные точки для разных типов визитов
      TradingPoint(
        externalId: 'CLIENT_NEW_001',
        name: 'ООО "Новый клиент"',
        inn: '2536789301',
      ),
      TradingPoint(
        externalId: 'CLIENT_PROBLEM_001',
        name: 'ИП "Проблемный клиент"',
        inn: '2536789401',
      ),
      TradingPoint(
        externalId: 'CLIENT_REGULAR_001',
        name: 'ООО "Постоянный партнер"',
        inn: '2536789501',
      ),
      TradingPoint(
        externalId: 'CLIENT_POTENTIAL_001',
        name: 'ИП "Потенциальный клиент"',
        inn: '2536789601',
      ),
      // Дополнительные точки для разнообразия
      TradingPoint(
        externalId: 'CLIENT_MALL_001',
        name: 'ТЦ "Владивосток"',
        inn: '2536789701',
      ),
      TradingPoint(
        externalId: 'CLIENT_SMALL_001',
        name: 'Магазин "У дома"',
        inn: '2536789801',
      ),
      TradingPoint(
        externalId: 'CLIENT_CHAIN_001',
        name: 'Сеть "Продукты 24"',
        inn: '2536789901',
      ),
    ];
    
    // Сохраняем все точки в базу данных
    for (final point in points) {
      await _saveTradingPoint(point);
    }

    return points;
  }
  
  /// Получает торговую точку по external_id
  TradingPoint getTradingPointById(String externalId, List<TradingPoint> points) {
    final point = points.where((p) => p.externalId == externalId).firstOrNull;
    if (point == null) {
      throw Exception('Торговая точка с ID $externalId не найдена');
    }
    return point;
  }
  
  /// Приватный метод для сохранения торговой точки
  Future<void> _saveTradingPoint(TradingPoint point) async {
    final database = GetIt.instance<AppDatabase>();
    final companion = RouteMapper.tradingPointToCompanion(point);
    await database.upsertTradingPoint(companion);
  }
}

/// Factory для создания TradingPointsFixtureService  
class TradingPointsFixtureServiceFactory {
  static TradingPointsFixtureService create() {
    return TradingPointsFixtureService();
  }
}
