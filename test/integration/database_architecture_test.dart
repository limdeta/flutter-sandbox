import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tauzero/shared/infrastructure/database/app_database.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart' as domain;
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/features/tracking/data/repositories/user_track_repository.dart';
import 'package:tauzero/features/tracking/domain/entities/user_track.dart';
import 'package:tauzero/features/authentication/data/repositories/user_repository.dart';
import 'package:tauzero/features/route/data/repositories/route_repository.dart';
import 'package:tauzero/features/route/domain/entities/route.dart';

void main() {
  late AppDatabase database;
  late UserRepository userRepository;
  late RouteRepository routeRepository;
  late UserTrackRepository userTrackRepository;

  setUp(() async {
    database = AppDatabase.forTesting(drift.DatabaseConnection(NativeDatabase.memory()));
    userRepository = UserRepository(database: database);
    routeRepository = RouteRepository(database);
    userTrackRepository = UserTrackRepository(database, userRepository, routeRepository);
  });

  tearDown(() async {
    await database.close();
  });

  group('Database Architecture Unity Tests', () {
    test('CRITICAL: single database should allow route-track relationships to work', () async {
      // Arrange: Создаем пользователя
      final phoneResult = PhoneNumber.create('+79123456789');
      if (phoneResult.isLeft()) {
        final error = phoneResult.fold((l) => l, (r) => null);
        throw Exception('Phone creation failed: $error');
      }
      expect(phoneResult.isRight(), true);
      final phoneNumber = phoneResult.fold((l) => throw Exception('Phone creation failed'), (r) => r);
      
      final user = domain.User(
        externalId: '123',
        firstName: 'Test',
        lastName: 'User',
        role: domain.UserRole.user,
        phoneNumber: phoneNumber,
        hashedPassword: 'test_password',
      );
      final createdUser = await userRepository.createUser(user);
      final actualUser = createdUser.fold(
        (failure) => throw Exception('Failed to create user: $failure'),
        (user) => user,
      );

      // Создаем маршрут - сначала создаем объект Route
      final route = Route(
        name: 'Test Route',
        pointsOfInterest: [],
      );
      
      final routeCreatedResult = await routeRepository.createRoute(route, user);
      expect(routeCreatedResult.isRight(), true);
      
      final createdRoute = routeCreatedResult.fold(
        (failure) => throw Exception('Failed to create route: $failure'),
        (route) => route,
      );

      // Act: Создаем UserTrack с привязкой к маршруту используя factory
      final userTrack = await userTrackRepository.saveTrack(
        UserTrack.create(
          user: actualUser,
          route: createdRoute,
          startTime: DateTime.now(),
        ),
      );

      // Assert: Проверяем что связи работают
      expect(userTrack.user.externalId, equals(user.externalId));
      expect(userTrack.route?.id, equals(createdRoute.id));
      expect(userTrack.route?.name, equals('Test Route'));
      
      print('✅ SUCCESS: Single database architecture allows proper route-track relationships!');
      print('   User: ${userTrack.user.externalId}');
      print('   Route: ${userTrack.route?.id} - ${userTrack.route?.name}');
    });
  });
}
