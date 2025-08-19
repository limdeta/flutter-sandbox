import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';

/// Фабрика для создания тестовых пользователей
/// 
/// Использует стандартный паттерн Builder для максимальной гибкости
class UserFactory {
  static int _counter = 1;
  
  String? _externalId;
  String? _firstName;
  String? _lastName;
  String? _middleName;
  UserRole? _role;
  String? _phoneNumber;
  String? _hashedPassword;

  UserFactory();

  UserFactory externalId(String externalId) {
    _externalId = externalId;
    return this;
  }

  UserFactory firstName(String firstName) {
    _firstName = firstName;
    return this;
  }

  UserFactory lastName(String lastName) {
    _lastName = lastName;
    return this;
  }

  UserFactory middleName(String middleName) {
    _middleName = middleName;
    return this;
  }

  UserFactory role(UserRole role) {
    _role = role;
    return this;
  }

  UserFactory phoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    return this;
  }

  UserFactory hashedPassword(String hashedPassword) {
    _hashedPassword = hashedPassword;
    return this;
  }

  /// Создает пользователя с указанными параметрами
  User build() {
    final currentCounter = _counter++;
    
    final phoneResult = PhoneNumber.create(
      _phoneNumber ?? '+7999123456${currentCounter.toString().padLeft(1, '0')}'
    );
    
    final validPhoneNumber = phoneResult.fold(
      (failure) => throw Exception('Invalid phone number in factory: $failure'),
      (phone) => phone,
    );

    return User(
      externalId: _externalId ?? currentCounter.toString(),
      firstName: _firstName ?? 'User$currentCounter',
      lastName: _lastName ?? 'Test',
      middleName: _middleName,
      role: _role ?? UserRole.user,
      phoneNumber: validPhoneNumber,
      hashedPassword: _hashedPassword ?? 'hash_$currentCounter',
    );
  }

  /// Быстрое создание базового пользователя
  static User createDefault() => UserFactory().build();
  
  /// Создание администратора
  static User createAdmin() => UserFactory()
    .role(UserRole.admin)
    .firstName('Admin')
    .lastName('System')
    .build();

  /// Создание водителя
  static User createDriver() => UserFactory()
    .role(UserRole.user)
    .firstName('Водитель')
    .lastName('Тестов')
    .build();

  /// Создание пользователя с конкретным ID (для связанных тестов)
  static User createWithId(String id) => UserFactory()
    .externalId(id)
    .build();

  /// Сброс счетчика (для предсказуемости в тестах)
  static void resetCounter() {
    _counter = 1;
  }
}
