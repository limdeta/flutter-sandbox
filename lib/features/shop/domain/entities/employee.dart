
import 'package:tauzero/features/navigation/tracking/domain/entities/navigation_user.dart';
import 'package:tauzero/features/shop/domain/entities/trading_point.dart';

enum EmployeeRole{
  sales,
  supervisor,
  manager,
}

class Employee implements NavigationUser {
  final int? _id;
  @override
  String? lastName;
  @override
  String? firstName;
  String? middleName;
  EmployeeRole role;
  List<TradingPoint> assignedTradingPoints; // Торговые точки закрепленные за сотрудником

  Employee({
    int? id,
    required this.lastName,
    required this.firstName,
    this.middleName,
    required this.role,
    List<TradingPoint>? assignedTradingPoints,
  }) : _id = id,
       assignedTradingPoints = assignedTradingPoints ?? [];

  @override
  int get id => _id ?? 0; // Возвращаем 0 если id еще не присвоен

  @override
  String get fullName => middleName != null
      ? '$lastName $firstName $middleName'
      : '$lastName $firstName';

  String get shortName {
    final firstInitial = firstName?.isNotEmpty == true ? firstName![0] : '';
    final middleInitial = middleName?.isNotEmpty == true ? middleName![0] : '';
    return middleInitial.isNotEmpty
        ? '$lastName $firstInitial.$middleInitial.'
        : '$lastName $firstInitial.';
  }

  /// Добавляет торговую точку к списку закрепленных
  void assignTradingPoint(TradingPoint tradingPoint) {
    if (!assignedTradingPoints.any((tp) => tp.externalId == tradingPoint.externalId)) {
      assignedTradingPoints.add(tradingPoint);
    }
  }

  /// Удаляет торговую точку из списка закрепленных
  void unassignTradingPoint(TradingPoint tradingPoint) {
    assignedTradingPoints.removeWhere((tp) => tp.externalId == tradingPoint.externalId);
  }

  /// Проверяет закреплена ли торговая точка за сотрудником
  bool hasTradingPoint(TradingPoint tradingPoint) {
    return assignedTradingPoints.any((tp) => tp.externalId == tradingPoint.externalId);
  }

  /// Создает копию с новыми торговыми точками
  Employee copyWithTradingPoints(List<TradingPoint> tradingPoints) {
    return Employee(
      id: _id,
      lastName: lastName,
      firstName: firstName,
      middleName: middleName,
      role: role,
      assignedTradingPoints: List.from(tradingPoints),
    );
  }
}
    
