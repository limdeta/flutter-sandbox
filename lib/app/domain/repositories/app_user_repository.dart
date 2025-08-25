import 'package:tauzero/app/domain/app_user.dart';
import 'package:tauzero/shared/either.dart';
import 'package:tauzero/shared/failures.dart';

abstract interface class AppUserRepository {
  Future<Either<Failure, AppUser>> getAppUserByEmployeeId(int employeeId);
  Future<Either<Failure, AppUser>> getAppUserByUserId(int userId);
  Future<Either<Failure, AppUser?>> getAppUserByExternalId(String externalId);
  Future<Either<Failure, AppUser>> createAppUser({
    required int employeeId,
    required int userId,
  });
  Future<Either<Failure, void>> deleteAppUser(int employeeId);
  Future<Either<Failure, bool>> appUserExists(int employeeId);
}
