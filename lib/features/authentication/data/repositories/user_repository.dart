import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/repositories/iuser_repository.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/shared/infrastructure/database/app_database.dart';
import 'package:tauzero/shared/domain/either.dart';
import 'package:tauzero/shared/domain/failures.dart';

class UserRepository implements IUserRepository {
  final AppDatabase database;
  
  // In-memory storage for dev/testing
  final Map<String, User> _users = {};

  UserRepository({
    required this.database,
  });

  @override
  Future<Either<Failure, User>> getUserByPhoneNumber(PhoneNumber phoneNumber) async {
    try {
      // Ищем пользователя по номеру телефона
      final user = _users.values.where((u) => u.phoneNumber.value == phoneNumber.value).firstOrNull;
      
      if (user == null) {
        return Left(NotFoundFailure('Пользователь с номером ${phoneNumber.value} не найден'));
      }
      
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Ошибка базы данных: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> createUser(User user) async {
    try {
      // Проверяем что пользователь с таким externalId не существует
      if (_users.containsKey(user.externalId)) {
        return Left(EntityCreationFailure('Пользователь с ID ${user.externalId} уже существует'));
      }
      
      // Проверяем что пользователь с таким номером телефона не существует
      final existingUser = _users.values.where((u) => u.phoneNumber.value == user.phoneNumber.value).firstOrNull;
      if (existingUser != null) {
        return Left(EntityCreationFailure('Пользователь с номером ${user.phoneNumber.value} уже существует'));
      }
      
      // Сохраняем пользователя
      _users[user.externalId] = user;
      
      return Right(user);
    } catch (e) {
      return Left(EntityCreationFailure('Не удалось создать пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> saveUser(User user) async {
    try {
      // Сохраняем или обновляем пользователя
      _users[user.externalId] = user;
      
      return Right(user);
    } catch (e) {
      return Left(EntityUpdateFailure('Не удалось сохранить пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getUserByExternalId(String externalId) async {
    try {
      final user = _users[externalId];
      
      if (user == null) {
        return Left(NotFoundFailure('Пользователь с ID $externalId не найден'));
      }
      
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Ошибка базы данных: $e'));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      return Right(_users.values.toList());
    } catch (e) {
      return Left(AuthFailure('Ошибка получения списка пользователей: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String externalId) async {
    try {
      if (!_users.containsKey(externalId)) {
        return Left(NotFoundFailure('Пользователь с ID $externalId не найден'));
      }
      
      _users.remove(externalId);
      
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Ошибка удаления пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> userExists(String externalId) async {
    try {
      return Right(_users.containsKey(externalId));
    } catch (e) {
      return Left(AuthFailure('Ошибка проверки существования пользователя: $e'));
    }
  }
}
