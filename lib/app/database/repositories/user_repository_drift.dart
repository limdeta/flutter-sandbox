import 'package:tauzero/app/database/app_database.dart';
import 'package:tauzero/app/database/mappers/user_mapper.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/repositories/user_repository.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/shared/either.dart';
import 'package:tauzero/shared/failures.dart';

class UserRepositoryImpl implements UserRepository {
  final AppDatabase database;
  // In-memory кеш для производительности (опционально)
  final Map<String, User> _cache = {};

  UserRepositoryImpl({
    required this.database,
  });

  Future<UserData?> _getUserByPhoneNumber(String phoneNumber) async {
    final query = database.select(database.users)..where((u) => u.phoneNumber.equals(phoneNumber));
    return await query.getSingleOrNull();
  }

  Future<UserData?> _getUserByExternalId(String externalId) async {
    final query = database.select(database.users)..where((u) => u.externalId.equals(externalId));
    return await query.getSingleOrNull();
  }

  Future<UserData?> _getUserById(int id) async {
    final query = database.select(database.users)..where((u) => u.id.equals(id));
    return await query.getSingleOrNull();
  }

  Future<List<UserData>> _getAllUsers() async {
    return await database.select(database.users).get();
  }

  Future<int> _insertUser(UsersCompanion user) async {
    return await database.into(database.users).insert(user);
  }

  Future<bool> _updateUser(UserData user) async {
    return await database.update(database.users).replace(user);
  }

  Future<int> _deleteUser(int id) async {
    return await (database.delete(database.users)..where((u) => u.id.equals(id))).go();
  }

  @override
  Future<Either<Failure, User>> getUserByPhoneNumber(PhoneNumber phoneNumber) async {
    try {
      final userData = await _getUserByPhoneNumber(phoneNumber.value);
      if (userData == null) {
        return Left(NotFoundFailure('Пользователь с номером ${phoneNumber.value} не найден'));
      }
      final user = UserMapper.fromDb(userData);
      _cache[user.externalId] = user;
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Ошибка базы данных: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> createUser(User user) async {
    try {
      final existingByExternalId = await _getUserByExternalId(user.externalId);
      if (existingByExternalId != null) {
        return Left(EntityCreationFailure('Пользователь с ID ${user.externalId} уже существует'));
      }
      final existingByPhone = await _getUserByPhoneNumber(user.phoneNumber.value);
      if (existingByPhone != null) {
        return Left(EntityCreationFailure('Пользователь с номером ${user.phoneNumber.value} уже существует'));
      }
      await _insertUser(UserMapper.toDb(user));
      final savedUserData = await _getUserByExternalId(user.externalId);
      if (savedUserData == null) {
        return Left(EntityCreationFailure('Не удалось получить созданного пользователя'));
      }
      final savedUser = UserMapper.fromDb(savedUserData);
      _cache[savedUser.externalId] = savedUser;
      return Right(savedUser);
    } catch (e) {
      return Left(EntityCreationFailure('Не удалось создать пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> saveUser(User user) async {
    try {
      final userData = await _getUserByExternalId(user.externalId);
      if (userData == null) {
        return Left(NotFoundFailure('Пользователь с ID ${user.externalId} не найден'));
      }
      final updated = await _updateUser(
        userData.copyWith(
          role: UserMapper.userRoleToString(user.role),
          phoneNumber: user.phoneNumber.value,
          hashedPassword: user.hashedPassword,
        ),
      );
      if (!updated) {
        return Left(EntityUpdateFailure('Не удалось обновить пользователя'));
      }
      final updatedUserData = await _getUserByExternalId(user.externalId);
      if (updatedUserData == null) {
        return Left(EntityUpdateFailure('Не удалось получить обновленного пользователя'));
      }
      final updatedUser = UserMapper.fromDb(updatedUserData);
      _cache[updatedUser.externalId] = updatedUser;
      return Right(updatedUser);
    } catch (e) {
      return Left(EntityUpdateFailure('Не удалось сохранить пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getUserByExternalId(String externalId) async {
    try {
      if (_cache.containsKey(externalId)) {
        return Right(_cache[externalId]!);
      }
      final userData = await _getUserByExternalId(externalId);
      if (userData == null) {
        return Left(NotFoundFailure('Пользователь с ID $externalId не найден'));
      }
      final user = UserMapper.fromDb(userData);
      _cache[externalId] = user;
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Ошибка базы данных: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getUserByInternalId(int internalId) async {
    try {
      final cachedUser = _cache.values.firstWhere(
        (user) => user.id == internalId,
        orElse: () => throw StateError('Not found'),
      );
      return Right(cachedUser);
    } catch (_) {
      try {
        final userData = await _getUserById(internalId);
        if (userData == null) {
          return Left(NotFoundFailure('Пользователь с внутренним ID $internalId не найден'));
        }
        final user = UserMapper.fromDb(userData);
        _cache[user.externalId] = user;
        return Right(user);
      } catch (e) {
        return Left(AuthFailure('Ошибка базы данных: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final usersData = await _getAllUsers();
      final users = usersData.map(UserMapper.fromDb).toList();
      for (final user in users) {
        _cache[user.externalId] = user;
      }
      return Right(users);
    } catch (e) {
      return Left(AuthFailure('Ошибка получения списка пользователей: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String externalId) async {
    try {
      final userData = await _getUserByExternalId(externalId);
      if (userData == null) {
        return Left(NotFoundFailure('Пользователь с ID $externalId не найден'));
      }
      await _deleteUser(userData.id);
      _cache.remove(externalId);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Ошибка удаления пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> userExists(String externalId) async {
    try {
      if (_cache.containsKey(externalId)) {
        return const Right(true);
      }
      final userData = await _getUserByExternalId(externalId);
      return Right(userData != null);
    } catch (e) {
      return Left(AuthFailure('Ошибка проверки существования пользователя: $e'));
    }
  }
}
