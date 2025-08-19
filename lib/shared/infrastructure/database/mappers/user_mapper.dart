import 'package:drift/drift.dart';

import '../../../../features/authentication/domain/entities/user.dart' as domain;
import '../../../../features/authentication/domain/value_objects/phone_number.dart';
import '../app_database.dart';
import '../../../domain/either.dart';
import '../../../domain/failures.dart';

/// Маппер для преобразования между UserEntry и domain.User
class UserMapper {
  /// Преобразует UserEntry в domain.User с валидацией
  static domain.User fromUserEntry(UserEntry userData) {
    final phoneResult = PhoneNumber.create(userData.phoneNumber);
    if (phoneResult.isLeft()) {
      throw Exception('Invalid phone number in database: ${userData.phoneNumber}');
    }

    final phone = (phoneResult as Right<Failure, PhoneNumber>).value;

    // Преобразование строки роли в перечисление
    final role = domain.UserRole.values.firstWhere(
      (r) => r.name == userData.role,
      orElse: () => domain.UserRole.user,
    );

    final userResult = domain.User.create(
      externalId: userData.externalId, // externalId - строка в БД, Uint32 в домене
      lastName: userData.lastName,
      firstName: userData.firstName,
      middleName: userData.middleName,
      phoneNumber: phone,
      hashedPassword: userData.hashedPassword,
      role: role,
    );

    if (userResult.isLeft()) {
      final error = (userResult as Left<Failure, domain.User>).value;
      throw Exception('Invalid user data in database: ${error.message}');
    }

    return (userResult as Right<Failure, domain.User>).value;
  }

  /// Преобразует domain.User в UserEntriesCompanion для вставки
  static UserEntriesCompanion toInsertCompanion(domain.User user) {
    return UserEntriesCompanion(
      externalId: Value(user.externalId.toString()), // преобразование externalId домена в строку БД
      lastName: Value(user.lastName),
      firstName: Value(user.firstName),
      middleName: Value(user.middleName),
      phoneNumber: Value(user.phoneNumber.value),
      hashedPassword: Value(user.hashedPassword),
      role: Value(user.role.name),
      // createdAt, updatedAt: обрабатываются по умолчанию
    );
  }

  /// Преобразует domain.User в UserEntriesCompanion для обновления
  static UserEntriesCompanion toUpdateCompanion(domain.User user) {
    return UserEntriesCompanion(
      lastName: Value(user.lastName),
      firstName: Value(user.firstName),
      middleName: Value(user.middleName),
      phoneNumber: Value(user.phoneNumber.value),
      hashedPassword: Value(user.hashedPassword),
      role: Value(user.role.name),
      updatedAt: Value(DateTime.now()),
    );
  }

  /// Преобразует список UserEntry в список domain.User
  static List<domain.User> fromUserEntryList(List<UserEntry> userDataList) {
    return userDataList.map(fromUserEntry).toList();
  }
}
