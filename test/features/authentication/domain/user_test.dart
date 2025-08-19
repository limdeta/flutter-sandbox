import 'package:flutter_test/flutter_test.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';

void main() {
  group('User', () {
    test('should create valid user with all fields', () {
      // Arrange
      final phoneNumber = PhoneNumber.create('+79123456789').getOrElse(() => throw Exception());
      
      // Act
      final result = User.create(
        externalId: 'ext_123',
        lastName: 'Иванов',
        firstName: 'Иван',
        middleName: 'Иванович',
        role: UserRole.user,
        phoneNumber: phoneNumber,
        hashedPassword: 'hashed_password_123',
      );
      
      // Assert
      expect(result.isRight(), true);
      final user = result.getOrElse(() => throw Exception());
      expect(user.fullName, 'Иванов Иван Иванович');
      expect(user.shortName, 'Иванов И.И.');
    });

    test('should create valid user without middle name', () {
      // Arrange
      final phoneNumber = PhoneNumber.create('+79123456789').getOrElse(() => throw Exception());
      
      // Act
      final result = User.create(
        externalId: 'ext_123',
        lastName: 'Петров',
        firstName: 'Петр',
        role: UserRole.user,
        phoneNumber: phoneNumber,
        hashedPassword: 'hashed_password_123',
      );
      
      // Assert
      expect(result.isRight(), true);
      final user = result.getOrElse(() => throw Exception());
      expect(user.fullName, 'Петров Петр');
      expect(user.shortName, 'Петров П.');
    });

    test('should verify password correctly', () {
      // Arrange
      final phoneNumber = PhoneNumber.create('+79123456789').getOrElse(() => throw Exception());
      final user = User.create(
        externalId: 'ext_123',
        lastName: 'Иванов',
        firstName: 'Иван',
        role: UserRole.user,
        phoneNumber: phoneNumber,
        hashedPassword: 'correct_hash',
      ).getOrElse(() => throw Exception());
      
      // Act & Assert - это реальное поведение!
      expect(user.verifyPassword('correct_hash'), true);
      expect(user.verifyPassword('wrong_hash'), false);
      expect(user.verifyPassword(''), false);
    });
  });
}
