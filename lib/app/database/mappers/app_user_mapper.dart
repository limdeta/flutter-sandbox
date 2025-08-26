import 'package:tauzero/app/domain/app_user.dart';
import 'package:tauzero/app/database/app_database.dart' as db;
import 'package:tauzero/features/shop/domain/entities/employee.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:drift/drift.dart';

class AppUserMapper {
  static AppUser fromComponents({
    required Employee employee,
    required User authUser,
  }) {
    return AppUser(
      employee: employee,
      authUser: authUser,
    );
  }

  static db.AppUsersCompanion toDb({
    required int employeeId,
    required int userId,
  }) {
    return db.AppUsersCompanion(
      employeeId: Value(employeeId),
      userId: Value(userId),
    );
  }

  static AppUser fromDbWithComponents({
    required db.AppUserData appUserData,
    required Employee employee,
    required User authUser,
  }) {
    return AppUser(
      employee: employee,
      authUser: authUser,
    );
  }
}
