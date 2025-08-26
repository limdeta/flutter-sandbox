
import 'package:tauzero/features/navigation/tracking/domain/entities/navigation_user.dart';

enum EmployeeRole{
  sales,
  manager,
  cashier,
}

class Employee implements NavigationUser {
  final int? _id;
  @override
  String? lastName;
  @override
  String? firstName;
  String? middleName;
  EmployeeRole role;

  Employee({
    int? id,
    required this.lastName,
    required this.firstName,
    this.middleName,
    required this.role,
  }) : _id = id;

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
}
    
