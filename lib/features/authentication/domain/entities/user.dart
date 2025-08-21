import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/shared/domain/either.dart';
import 'package:tauzero/shared/domain/failures.dart';

enum UserRole {
  admin,
  manager,
  user,
}

class User {
  final int? internalId; // Внутренний ID из БД (null для новых пользователей)
  final String externalId;
  final String lastName;
  final String firstName;
  final String? middleName;
  final UserRole role;
  final PhoneNumber phoneNumber;
  final String hashedPassword;
  
  const User({
    this.internalId,
    required this.externalId,
    required this.lastName,
    required this.firstName,
    required this.role,
    this.middleName,
    required this.phoneNumber,
    required this.hashedPassword,
  });
  
  static Either<Failure, User> create({
    required String externalId,
    required String lastName,
    required String firstName,
    required UserRole role,
    String? middleName,
    required PhoneNumber phoneNumber,
    required String hashedPassword,
  }) {
    if (lastName.trim().isEmpty) {
      return const Left(ValidationFailure('Last name cannot be empty'));
    }
    
    if (firstName.trim().isEmpty) {
      return const Left(ValidationFailure('First name cannot be empty'));
    }
    
    if (hashedPassword.trim().isEmpty) {
      return const Left(ValidationFailure('Hashed password cannot be empty'));
    }
    
    final normalizedMiddleName = middleName?.trim().isEmpty == true ? null : middleName?.trim();
    
    return Right(User(
      externalId: externalId,
      lastName: lastName.trim(),
      firstName: firstName.trim(),
      middleName: normalizedMiddleName,
      phoneNumber: phoneNumber,
      hashedPassword: hashedPassword.trim(),
      role: role
    ));
  }
  
  String get getId {
    return externalId;
  }

  String get fullName {
    if (middleName != null) {
      return '$lastName $firstName $middleName';
    }
    return '$lastName $firstName';
  }
  
  String get shortName {
    final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final middleInitial = middleName?.isNotEmpty == true ? middleName![0] : '';
    
    if (middleInitial.isNotEmpty) {
      return '$lastName $firstInitial.$middleInitial.';
    }
    return '$lastName $firstInitial.';
  }
  
  bool verifyPassword(String hashedPassword) {
    if (hashedPassword.isEmpty) return false;
    return this.hashedPassword == hashedPassword;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.externalId == externalId &&
        other.lastName == lastName &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.phoneNumber == phoneNumber &&
        other.hashedPassword == hashedPassword;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      externalId,
      lastName,
      firstName,
      middleName,
      phoneNumber,
      hashedPassword,
    );
  }
  
  @override
  String toString() {
    return 'User(externalId: $externalId, fullName: $fullName, phone: ${phoneNumber.displayFormat})';
  }
}
