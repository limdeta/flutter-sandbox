import 'package:get_it/get_it.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/features/authentication/domain/repositories/iuser_repository.dart';
import 'package:tauzero/features/authentication/domain/services/password_service.dart';

class UserFixtureService {
  final IUserRepository _repository;
  
  UserFixtureService(this._repository);

  /// Создает администратора
  /// Логин: +7-999-000-0001, Пароль: password123
  Future<User> createAdmin() async {
    final phoneResult = PhoneNumber.create('+7-999-000-0001');
    if (phoneResult.isLeft()) {
      throw Exception('Не удалось создать номер телефона для администратора');
    }
    
    final userResult = User.create(
      externalId: 'admin_001',
      lastName: 'Админов',
      firstName: 'Александр',
      middleName: 'Администраторович',
      role: UserRole.admin,
      phoneNumber: phoneResult.fold((l) => throw Exception(l), (r) => r),
      hashedPassword: PasswordService.hashPassword('password123'),
    );
    
    if (userResult.isLeft()) {
      throw Exception('Не удалось создать администратора: ${userResult.fold((l) => l, (r) => '')}');
    }
    
    final admin = userResult.fold((l) => throw Exception(l), (r) => r);
    final createResult = await _repository.createUser(admin);
    
    if (createResult.isLeft()) {
      throw Exception('Не удалось сохранить администратора: ${createResult.fold((l) => l, (r) => '')}');
    }
    
    return admin;
  }

  /// Создает менеджера
  /// Логин: +7-999-000-0002, Пароль: password123
  Future<User> createManager() async {
    final phoneResult = PhoneNumber.create('+7-999-000-0002');
    if (phoneResult.isLeft()) {
      throw Exception('Не удалось создать номер телефона для менеджера');
    }
    
    final userResult = User.create(
      externalId: 'manager_001',
      lastName: 'Менеджеров',
      firstName: 'Михаил',
      middleName: 'Михайлович',
      role: UserRole.manager,
      phoneNumber: phoneResult.fold((l) => throw Exception(l), (r) => r),
      hashedPassword: PasswordService.hashPassword('password123'),
    );
    
    if (userResult.isLeft()) {
      throw Exception('Не удалось создать менеджера: ${userResult.fold((l) => l, (r) => '')}');
    }
    
    final manager = userResult.fold((l) => throw Exception(l), (r) => r);
    final createResult = await _repository.createUser(manager);
    
    if (createResult.isLeft()) {
      throw Exception('Не удалось сохранить менеджера: ${createResult.fold((l) => l, (r) => '')}');
    }
    
    return manager;
  }

  /// Создает торгового представителя с заданными параметрами
  /// Пароль для всех торговых представителей: password123
  Future<User> createSalesRep({
    required String name,
    required String email, // для externalId
    required String phone,
  }) async {
    final nameParts = name.split(' ');
    final lastName = nameParts.isNotEmpty ? nameParts[0] : 'Торговый';
    final firstName = nameParts.length > 1 ? nameParts[1] : 'Представитель';
    final middleName = nameParts.length > 2 ? nameParts[2] : null;
    
    final phoneResult = PhoneNumber.create(phone);
    if (phoneResult.isLeft()) {
      throw Exception('Не удалось создать номер телефона $phone: ${phoneResult.fold((l) => l, (r) => '')}');
    }
    
    final userResult = User.create(
      externalId: email, // Используем email как externalId
      lastName: lastName,
      firstName: firstName,
      middleName: middleName,
      role: UserRole.user,
      phoneNumber: phoneResult.fold((l) => throw Exception(l), (r) => r),
      hashedPassword: PasswordService.hashPassword('password123'),
    );
    
    if (userResult.isLeft()) {
      throw Exception('Не удалось создать торгового представителя $name: ${userResult.fold((l) => l, (r) => '')}');
    }
    
    final salesRep = userResult.fold((l) => throw Exception(l), (r) => r);
    final createResult = await _repository.createUser(salesRep);
    
    if (createResult.isLeft()) {
      throw Exception('Не удалось сохранить торгового представителя $name: ${createResult.fold((l) => l, (r) => '')}');
    }
    
    return salesRep;
  }

  Future<void> clearAllUsers() async {
    try {
      // Получаем всех пользователей и удаляем dev-пользователей
      final allUsersResult = await _repository.getAllUsers();
      
      await allUsersResult.fold(
        (failure) async {
          print('ℹ️ Не удалось получить список пользователей: ${failure.message}');
        },
        (allUsers) async {
          for (final user in allUsers) {
            // Удаляем пользователей с dev префиксами или email
            if (_isDevUser(user)) {
              final deleteResult = await _repository.deleteUser(user.externalId);
              deleteResult.fold(
                (failure) => print('⚠️ Не удалось удалить ${user.fullName}: ${failure.message}'),
                (_) => {}, // Успешно удален
              );
            }
          }
          
          print('🧹 Dev пользователи очищены');
        },
      );
    } catch (e) {
      print('ℹ️ Ошибка при очистке пользователей: $e');
    }
  }

  bool _isDevUser(User user) {
    return user.externalId.startsWith('admin_') ||
           user.externalId.startsWith('manager_') ||
           user.externalId.contains('@tauzero.dev') ||
           user.lastName == 'Админов' ||
           user.lastName == 'Менеджеров' ||
           user.lastName == 'Торговый' ||
           user.lastName == 'Продажкина' ||
           user.lastName == 'Курьеров' ||
           user.lastName == 'Доставкина' ||
           user.lastName == 'Быстров';
  }
}

class UserFixtureServiceFactory {
  static UserFixtureService create() {
    final repository = GetIt.instance<IUserRepository>();
    return UserFixtureService(repository);
  }
}
