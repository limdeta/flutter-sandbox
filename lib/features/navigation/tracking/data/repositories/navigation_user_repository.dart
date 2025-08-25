import 'package:tauzero/features/navigation/tracking/domain/entities/navigation_user.dart';
import 'package:tauzero/shared/either.dart';
import 'package:tauzero/shared/failures.dart';

abstract interface class NavigationUserRepository {
  Future<Either<Failure, NavigationUser>> getUserById(int id);
}
