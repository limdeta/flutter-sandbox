import 'package:flutter_test/flutter_test.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/repositories/iuser_repository.dart';
import 'package:tauzero/features/authentication/domain/usecases/login_usecase.dart';
import 'package:tauzero/shared/di/service_locator.dart';
import '../../../helpers/test_factories.dart';

void main() {
  group('LoginUseCase Integration Tests with Test Factories', () {
    late LoginUseCase loginUseCase;
    late IUserRepository userRepository;

    setUpAll(() async {
      setupServiceLocator();
      userRepository = getIt<IUserRepository>();
      loginUseCase = getIt<LoginUseCase>();
    });

    tearDownAll(() async {
      await getIt.reset();
    });

    test('should login successfully with admin user created via factory', () async {
      // Arrange - Create test admin user with factory (visible test data)
      final testAdmin = await TestFactories.createAdminUser(
        phoneNumber: TestPhones.admin,
        externalId: 'test_admin_login_success',
        firstName: 'Test',
        lastName: 'Admin',
      );
      
      // Save to repository using correct method
      final saveResult = await userRepository.saveUser(testAdmin);
      expect(saveResult.isRight(), true, reason: 'Failed to save test admin user');

      // Act - Login using correct method signature
      final result = await loginUseCase(
        phoneString: testAdmin.phoneNumber.value,
        password: 'password123',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected success but got failure: ${failure.message}'),
        (session) {
          // UserSession contains User object
          expect(session.user.externalId, testAdmin.externalId);
          expect(session.user.phoneNumber.value, testAdmin.phoneNumber.value);
          expect(session.user.role, UserRole.admin);
          expect(session.user.firstName, 'Test');
          expect(session.user.lastName, 'Admin');
          expect(session.loginTime, isNotNull);
        },
      );
    });

    test('should login successfully with manager created via factory', () async {
      // Arrange - Create test manager user with factory (visible test data)
      final testManager = await TestFactories.createManagerUser(
        phoneNumber: TestPhones.manager,
        externalId: 'test_manager_login_success',
        firstName: 'Test',
        lastName: 'Manager',
      );
      
      // Save to repository
      final saveResult = await userRepository.saveUser(testManager);
      expect(saveResult.isRight(), true, reason: 'Failed to save test manager user');

      // Act
      final result = await loginUseCase(
        phoneString: testManager.phoneNumber.value,
        password: 'password123',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected success but got failure: ${failure.message}'),
        (session) {
          expect(session.user.externalId, testManager.externalId);
          expect(session.user.phoneNumber.value, testManager.phoneNumber.value);
          expect(session.user.role, UserRole.manager);
          expect(session.user.firstName, 'Test');
          expect(session.user.lastName, 'Manager');
        },
      );
    });

    test('should fail login with invalid password', () async {
      // Arrange - Create test user with factory (visible test data)
      final testUser = await TestFactories.createAdminUser(
        phoneNumber: TestPhones.admin,
        externalId: 'test_admin_invalid_password',
      );
      
      // Save to repository
      final saveResult = await userRepository.saveUser(testUser);
      expect(saveResult.isRight(), true, reason: 'Failed to save test user');

      // Act - Use wrong password
      final result = await loginUseCase(
        phoneString: testUser.phoneNumber.value,
        password: 'wrongpassword',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('Invalid credentials')),
        (session) => fail('Expected failure but got success'),
      );
    });

    test('should fail login with non-existent user', () async {
      // Arrange - Use non-existent phone number from factory (visible test data)
      final nonExistentPhone = TestPhones.nonExistent;

      // Act
      final result = await loginUseCase(
        phoneString: nonExistentPhone,
        password: 'password123',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('User not found')),
        (session) => fail('Expected failure but got success'),
      );
    });

    test('should handle multiple user scenarios created via batch factory', () async {
      // Arrange - Create a batch of users for comprehensive testing (visible test data)
      final testUsers = await TestFactories.createUserBatch(
        adminCount: 2,
        managerCount: 1,
        salesRepCount: 2,
      );
      
      // Save all users to repository
      for (final user in testUsers) {
        final saveResult = await userRepository.saveUser(user);
        expect(saveResult.isRight(), true, reason: 'Failed to save user ${user.externalId}');
      }
      
      // Test login for first admin
      final firstAdmin = testUsers.where((u) => u.role == UserRole.admin).first;

      // Act
      final result = await loginUseCase(
        phoneString: firstAdmin.phoneNumber.value,
        password: 'password123',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected success but got failure: ${failure.message}'),
        (session) {
          expect(session.user.externalId, firstAdmin.externalId);
          expect(session.user.role, UserRole.admin);
          expect(session.user.firstName, 'Admin');
          expect(session.user.lastName, 'User');
        },
      );
    });

    test('should demonstrate factory flexibility with custom data', () async {
      // Arrange - Use factory to create user with custom data for specific scenario
      final customUser = await TestFactories.createManagerUser(
        phoneNumber: '+79991234567', // Custom phone for this test
        externalId: 'custom_manager_test',
        firstName: 'Custom',
        lastName: 'Manager',
        password: 'custom_password_456', // Custom password
      );
      
      // Save to repository
      final saveResult = await userRepository.saveUser(customUser);
      expect(saveResult.isRight(), true, reason: 'Failed to save custom user');

      // Act - Login with custom password
      final result = await loginUseCase(
        phoneString: customUser.phoneNumber.value,
        password: 'custom_password_456',
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Expected success but got failure: ${failure.message}'),
        (session) {
          expect(session.user.firstName, 'Custom');
          expect(session.user.lastName, 'Manager');
          expect(session.user.role, UserRole.manager);
        },
      );
    });
  });
}
