import 'package:tauzero/features/shop/domain/entities/employee.dart';
import 'package:tauzero/shared/either.dart';
import 'package:tauzero/shared/failures.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, Employee>> createEmployee(Employee employee);
  Future<Either<Failure, List<Employee>>> getAllEmployees();
  Future<Either<Failure, Employee?>> getEmployeeById(int id);
  Future<Either<Failure, void>> deleteEmployee(int id);
  Future<Either<Failure, int?>> getInternalIdForNavigationUser(Employee navigationUser);
  Future<Either<Failure, Employee?>> getNavigationUserById(int id);
}
