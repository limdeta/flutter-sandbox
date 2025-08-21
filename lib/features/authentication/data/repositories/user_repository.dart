import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/repositories/iuser_repository.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/shared/infrastructure/database/app_database.dart';
import 'package:tauzero/shared/domain/either.dart';
import 'package:tauzero/shared/domain/failures.dart';

class UserRepository implements IUserRepository {
  final AppDatabase database;
  
  // In-memory кеш для производительности (опционально)
  final Map<String, User> _cache = {};

  UserRepository({
    required this.database,
  });

  @override
  Future<Either<Failure, User>> getUserByPhoneNumber(PhoneNumber phoneNumber) async {
    try {
      // Ищем в базе данных
      final user = await database.getUserByPhoneNumber(phoneNumber.value);
      
      if (user == null) {
        return Left(NotFoundFailure('Пользователь с номером ${phoneNumber.value} не найден'));
      }
      
      // Кешируем
      _cache[user.externalId] = user;
      
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Ошибка базы данных: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> createUser(User user) async {
    try {
      // Проверяем что пользователь с таким externalId не существует
      final existingByExternalId = await database.getUserByExternalId(user.externalId);
      if (existingByExternalId != null) {
        return Left(EntityCreationFailure('Пользователь с ID ${user.externalId} уже существует'));
      }
      
      // Проверяем что пользователь с таким номером телефона не существует
      final existingByPhone = await database.getUserByPhoneNumber(user.phoneNumber.value);
      if (existingByPhone != null) {
        return Left(EntityCreationFailure('Пользователь с номером ${user.phoneNumber.value} уже существует'));
      }
      
      // Сохраняем в БД
      await database.insertUser(user);
      
      // Получаем созданного пользователя с internalId
      final savedUser = await database.getUserByExternalId(user.externalId);
      if (savedUser == null) {
        return Left(EntityCreationFailure('Не удалось получить созданного пользователя'));
      }
      
      // Кешируем
      _cache[user.externalId] = savedUser;
      
      return Right(savedUser);
    } catch (e) {
      return Left(EntityCreationFailure('Не удалось создать пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> saveUser(User user) async {
    try {
      // Сохраняем или обновляем пользователя в БД
      await database.updateUser(user);
      
      // Кешируем
      _cache[user.externalId] = user;
      
      return Right(user);
    } catch (e) {
      return Left(EntityUpdateFailure('Не удалось сохранить пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getUserByExternalId(String externalId) async {
    try {
      // Сначала проверяем кеш
      if (_cache.containsKey(externalId)) {
        return Right(_cache[externalId]!);
      }
      
      // Ищем в БД
      final user = await database.getUserByExternalId(externalId);
      
      if (user == null) {
        return Left(NotFoundFailure('Пользователь с ID $externalId не найден'));
      }
      
      // Кешируем
      _cache[externalId] = user;
      
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Ошибка базы данных: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getUserByInternalId(int internalId) async {
    try {
      // Сначала проверяем кеш
      final cachedUser = _cache.values.firstWhere(
        (user) => user.internalId == internalId,
        orElse: () => throw StateError('Not found'),
      );
      return Right(cachedUser);
    } catch (_) {
      // Если в кеше нет, загружаем из БД
      try {
        final user = await database.getUserById(internalId);
        if (user == null) {
          return Left(NotFoundFailure('Пользователь с внутренним ID $internalId не найден'));
        }
        
        // Кешируем пользователя
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
      final users = await database.getAllUsers();
      
      // Обновляем кеш
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
      // Сначала проверяем существование пользователя
      final user = await database.getUserByExternalId(externalId);
      if (user == null) {
        return Left(NotFoundFailure('Пользователь с ID $externalId не найден'));
      }
      
      // Удаляем из БД
      await database.deleteUser(user.internalId!);
      
      // Удаляем из кеша
      _cache.remove(externalId);
      
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Ошибка удаления пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> userExists(String externalId) async {
    try {
      // Сначала проверяем кеш
      if (_cache.containsKey(externalId)) {
        return const Right(true);
      }
      
      // Проверяем в БД
      final user = await database.getUserByExternalId(externalId);
      return Right(user != null);
    } catch (e) {
      return Left(AuthFailure('Ошибка проверки существования пользователя: $e'));
    }
  }
}
