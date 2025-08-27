import 'package:tauzero/shared/either.dart';
import 'package:tauzero/shared/failures.dart';
import '../../domain/entities/trading_point.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/trading_point_repository.dart';

/// In-memory реализация репозитория торговых точек для тестирования
class InMemoryTradingPointRepository implements TradingPointRepository {
  final Map<String, TradingPoint> _tradingPoints = {};
  final Map<int, List<String>> _employeeTradingPoints = {}; // employeeId -> List<tradingPointExternalId>

  @override
  Future<Either<Failure, List<TradingPoint>>> getEmployeeTradingPoints(Employee employee) async {
    try {
      final tradingPointIds = _employeeTradingPoints[employee.id] ?? [];
      final tradingPoints = tradingPointIds
          .map((id) => _tradingPoints[id])
          .where((tp) => tp != null)
          .cast<TradingPoint>()
          .toList();
      
      return Right(tradingPoints);
    } catch (e) {
      return Left(DatabaseFailure('Ошибка получения торговых точек сотрудника: $e'));
    }
  }

  @override
  Future<Either<Failure, TradingPoint?>> getTradingPointByExternalId(String externalId) async {
    try {
      final tradingPoint = _tradingPoints[externalId];
      return Right(tradingPoint);
    } catch (e) {
      return Left(DatabaseFailure('Ошибка получения торговой точки: $e'));
    }
  }

  @override
  Future<Either<Failure, TradingPoint>> saveTradingPoint(TradingPoint tradingPoint) async {
    try {
      _tradingPoints[tradingPoint.externalId] = tradingPoint;
      return Right(tradingPoint);
    } catch (e) {
      return Left(DatabaseFailure('Ошибка сохранения торговой точки: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> assignTradingPointToEmployee(
    TradingPoint tradingPoint, 
    Employee employee
  ) async {
    try {
      // Сохраняем торговую точку если её нет
      _tradingPoints[tradingPoint.externalId] = tradingPoint;
      
      // Добавляем связь
      final employeeTradingPoints = _employeeTradingPoints[employee.id] ?? [];
      if (!employeeTradingPoints.contains(tradingPoint.externalId)) {
        employeeTradingPoints.add(tradingPoint.externalId);
        _employeeTradingPoints[employee.id] = employeeTradingPoints;
      }
      
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Ошибка привязки торговой точки к сотруднику: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> unassignTradingPointFromEmployee(
    TradingPoint tradingPoint, 
    Employee employee
  ) async {
    try {
      final employeeTradingPoints = _employeeTradingPoints[employee.id] ?? [];
      employeeTradingPoints.remove(tradingPoint.externalId);
      _employeeTradingPoints[employee.id] = employeeTradingPoints;
      
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Ошибка отвязки торговой точки от сотрудника: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TradingPoint>>> getAllTradingPoints() async {
    try {
      return Right(_tradingPoints.values.toList());
    } catch (e) {
      return Left(DatabaseFailure('Ошибка получения всех торговых точек: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TradingPoint>>> searchTradingPointsByName(String query) async {
    try {
      final filtered = _tradingPoints.values.where((tp) =>
        tp.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      return Right(filtered);
    } catch (e) {
      return Left(DatabaseFailure('Ошибка поиска торговых точек: $e'));
    }
  }

  /// Утилитный метод для инициализации тестовых данных
  void seedTestData({
    required List<TradingPoint> tradingPoints,
    required Map<int, List<String>> employeeAssignments,
  }) {
    _tradingPoints.clear();
    _employeeTradingPoints.clear();
    
    for (final tp in tradingPoints) {
      _tradingPoints[tp.externalId] = tp;
    }
    
    _employeeTradingPoints.addAll(employeeAssignments);
  }
}
