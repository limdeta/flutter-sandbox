import 'package:tauzero/shared/either.dart';
import 'package:tauzero/shared/failures.dart';
import '../entities/trading_point.dart';
import '../entities/employee.dart';

/// Репозиторий для работы с торговыми точками
abstract class TradingPointRepository {
  /// Получает все торговые точки закрепленные за сотрудником
  Future<Either<Failure, List<TradingPoint>>> getEmployeeTradingPoints(Employee employee);
  
  /// Получает торговую точку по внешнему ID
  Future<Either<Failure, TradingPoint?>> getTradingPointByExternalId(String externalId);
  
  /// Сохраняет торговую точку
  Future<Either<Failure, TradingPoint>> saveTradingPoint(TradingPoint tradingPoint);
  
  /// Привязывает торговую точку к сотруднику
  Future<Either<Failure, void>> assignTradingPointToEmployee(
    TradingPoint tradingPoint, 
    Employee employee
  );
  
  /// Отвязывает торговую точку от сотрудника
  Future<Either<Failure, void>> unassignTradingPointFromEmployee(
    TradingPoint tradingPoint, 
    Employee employee
  );
  
  /// Получает все торговые точки в системе
  Future<Either<Failure, List<TradingPoint>>> getAllTradingPoints();
  
  /// Поиск торговых точек по названию
  Future<Either<Failure, List<TradingPoint>>> searchTradingPointsByName(String query);
}
