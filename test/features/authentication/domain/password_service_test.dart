import 'package:flutter_test/flutter_test.dart';
import 'package:tauzero/features/authentication/domain/services/password_service.dart';

void main() {
  group('PasswordService', () {
    test('should hash password and verify it correctly', () {
      // Arrange
      const plainPassword = 'SecurePassword123!';
      
      // Act
      final hashedPassword = PasswordService.hashPassword(plainPassword);
      final isValid = PasswordService.verifyPassword(plainPassword, hashedPassword);
      
      // Assert
      expect(hashedPassword, isNotEmpty);
      expect(hashedPassword.contains('\$'), true); // Should have separators
      expect(isValid, true);
    });

    test('should reject wrong password', () {
      // Arrange
      const plainPassword = 'SecurePassword123!';
      const wrongPassword = 'WrongPassword456!';
      
      // Act
      final hashedPassword = PasswordService.hashPassword(plainPassword);
      final isValid = PasswordService.verifyPassword(wrongPassword, hashedPassword);
      
      // Assert
      expect(isValid, false);
    });

    test('should generate different hashes for same password', () {
      // Arrange
      const plainPassword = 'SamePassword';
      
      // Act
      final hash1 = PasswordService.hashPassword(plainPassword);
      final hash2 = PasswordService.hashPassword(plainPassword);
      
      // Assert - Different salts should produce different hashes
      expect(hash1, isNot(equals(hash2)));
      expect(PasswordService.verifyPassword(plainPassword, hash1), true);
      expect(PasswordService.verifyPassword(plainPassword, hash2), true);
    });

    test('should handle invalid hash format gracefully', () {
      // Arrange
      const plainPassword = 'password';
      const invalidHash = 'not_a_valid_hash';
      
      // Act
      final isValid = PasswordService.verifyPassword(plainPassword, invalidHash);
      
      // Assert
      expect(isValid, false);
    });

    test('should handle empty password correctly', () {
      // Arrange
      const emptyPassword = '';
      
      // Act
      final hashedPassword = PasswordService.hashPassword(emptyPassword);
      final isValid = PasswordService.verifyPassword(emptyPassword, hashedPassword);
      
      // Assert
      expect(isValid, true);
    });
  });
}
