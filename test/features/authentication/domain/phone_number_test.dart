import 'package:flutter_test/flutter_test.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';

void main() {
  group('PhoneNumber', () {
    test('should create valid phone number with Russian format', () {
      // Arrange
      const phoneString = '+79123456789';
      
      // Act
      final result = PhoneNumber.create(phoneString);
      
      // Assert
      expect(result.isRight(), true);
      expect(result.fold((l) => null, (r) => r.value), phoneString);
    });

    test('should create valid phone number with 8 prefix', () {
      // Arrange
      const phoneString = '89123456789';
      
      // Act
      final result = PhoneNumber.create(phoneString);
      
      // Assert
      expect(result.isRight(), true);
      expect(result.fold((l) => null, (r) => r.value), '+79123456789');
    });

    test('should reject invalid phone number', () {
      // Arrange
      const invalidPhone = '123';
      
      // Act
      final result = PhoneNumber.create(invalidPhone);
      
      // Assert
      expect(result.isLeft(), true);
      expect(
        result.fold((l) => l.message, (r) => null),
        contains('Invalid phone number format'),
      );
    });

    test('should reject empty phone number', () {
      // Arrange
      const emptyPhone = '';
      
      // Act
      final result = PhoneNumber.create(emptyPhone);
      
      // Assert
      expect(result.isLeft(), true);
    });

    test('should format phone number for display', () {
      // Arrange
      const phoneString = '+79123456789';
      final phoneNumber = PhoneNumber.create(phoneString).getOrElse(() => throw Exception());
      
      // Act
      final formatted = phoneNumber.displayFormat;
      
      // Assert
      expect(formatted, '+7 (912) 345-67-89');
    });
  });
}
