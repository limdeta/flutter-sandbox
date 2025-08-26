import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/features/authentication/domain/services/password_service.dart';

/// Test data factories for creating test entities on-demand
class TestFactories {
  static const _defaultPassword = 'password123';
  
  /// Creates admin user with specified phone or default
  static Future<User> createAdminUser({
    String? externalId,
    String phoneNumber = '+79990000001',
    String password = _defaultPassword,
    String firstName = 'Admin',
    String lastName = 'User',
  }) async {
    final hashedPassword = PasswordService.hashPassword(password);
    final phone = PhoneNumber.create(phoneNumber).fold(
      (failure) => throw Exception('Invalid phone: ${failure.message}'),
      (phone) => phone,
    );
    
    return User(
      externalId: externalId ?? 'test_admin_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phone,
      hashedPassword: hashedPassword,
      role: UserRole.admin,
    );
  }

  /// Creates manager user with specified phone or default
  static Future<User> createManagerUser({
    String? externalId,
    String phoneNumber = '+79990000002',
    String password = _defaultPassword,
    String firstName = 'Manager',
    String lastName = 'User',
  }) async {
    final hashedPassword = PasswordService.hashPassword(password);
    final phone = PhoneNumber.create(phoneNumber).fold(
      (failure) => throw Exception('Invalid phone: ${failure.message}'),
      (phone) => phone,
    );
    
    return User(
      externalId: externalId ?? 'test_manager_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phone,
      hashedPassword: hashedPassword,
      role: UserRole.manager,
    );
  }

  /// Creates sales rep user with specified phone or default
  static Future<User> createSalesRepUser({
    String? externalId,
    String phoneNumber = '+79990000003',
    String password = _defaultPassword,
    String firstName = 'Sales',
    String lastName = 'Rep',
  }) async {
    final hashedPassword = PasswordService.hashPassword(password);
    final phone = PhoneNumber.create(phoneNumber).fold(
      (failure) => throw Exception('Invalid phone: ${failure.message}'),
      (phone) => phone,
    );
    
    return User(
      externalId: externalId ?? 'test_sales_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phone,
      hashedPassword: hashedPassword,
      role: UserRole.user, // Assuming 'user' is the sales rep role
    );
  }

  /// Creates a batch of users for testing scenarios
  static Future<List<User>> createUserBatch({
    int adminCount = 1,
    int managerCount = 1,
    int salesRepCount = 3,
  }) async {
    final users = <User>[];
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    // Create admins
    for (int i = 0; i < adminCount; i++) {
      users.add(await createAdminUser(
        externalId: 'test_admin_${timestamp}_$i',
        phoneNumber: '+7999000100${i + 1}',
      ));
    }
    
    // Create managers
    for (int i = 0; i < managerCount; i++) {
      users.add(await createManagerUser(
        externalId: 'test_manager_${timestamp}_$i',
        phoneNumber: '+7999000200${i + 1}',
      ));
    }
    
    // Create sales reps
    for (int i = 0; i < salesRepCount; i++) {
      users.add(await createSalesRepUser(
        externalId: 'test_sales_${timestamp}_$i',
        phoneNumber: '+7999000300${i + 1}',
      ));
    }
    
    return users;
  }
}

/// Common test phone numbers that are guaranteed to be unique per test run
class TestPhones {
  static String get admin => '+7999${DateTime.now().millisecondsSinceEpoch.toString().substring(7, 10)}0001';
  static String get manager => '+7999${DateTime.now().millisecondsSinceEpoch.toString().substring(7, 10)}0002';
  static String get salesRep => '+7999${DateTime.now().millisecondsSinceEpoch.toString().substring(7, 10)}0003';
  static String get nonExistent => '+7999${DateTime.now().millisecondsSinceEpoch.toString().substring(7, 10)}9999';
}