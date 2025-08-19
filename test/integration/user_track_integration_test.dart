import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tauzero/shared/infrastructure/database/app_database.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart' as domain;
import 'package:tauzero/features/authentication/domain/value_objects/phone_number.dart';
import 'package:tauzero/features/tracking/data/repositories/user_track_repository.dart';
import 'package:tauzero/features/tracking/data/fixtures/user_track_fixtures.dart';

void main() {
  late AppDatabase database;
  late UserTrackRepository repository;

  setUp(() async {
    // Создаем in-memory database для тестов
    database = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    repository = UserTrackRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('User-Track Relations Integration Tests', () {
    test('should create user and link multiple tracks to them', () async {
      // Arrange: Создаем тестового пользователя
      final phoneNumberResult = PhoneNumber.create('89001234567'); // российский формат
      if (phoneNumberResult.isLeft()) {
        fail('Phone number creation failed');
      }
      final phoneNumber = phoneNumberResult.getOrElse(() => throw Exception('Invalid phone'));
      
      final testUserResult = domain.User.create(
        externalId: 'test-user-123',
        lastName: 'Иванов',
        firstName: 'Алексей',
        role: domain.UserRole.user,
        phoneNumber: phoneNumber,
        hashedPassword: 'hashed_password',
      );
      
      if (testUserResult.isLeft()) {
        fail('User creation failed');
      }
      final testUser = testUserResult.getOrElse(() => throw Exception('User creation failed'));

      // Act: Сохраняем пользователя в БД
      await database.insertUser(testUser);
      
      // Получаем внутренний ID пользователя
      final internalUserId = await database.getInternalUserIdByExternalId('test-user-123');
      expect(internalUserId, isA<int>());
      expect(internalUserId! > 0, true);
      print('Created user with internal ID: $internalUserId, external ID: test-user-123');

      // Создаем тестовые треки для этого пользователя
      final yesterdayTrack = UserTrackFixtures.createYesterdayCompletedTrack(internalUserId);
      final todayTrack = UserTrackFixtures.createTodayActiveTrack(internalUserId);

      // Act: Сохраняем треки
      final savedYesterdayTrack = await repository.saveTrack(yesterdayTrack);
      final savedTodayTrack = await repository.saveTrack(todayTrack);

      print('Saved yesterday track with ID: ${savedYesterdayTrack.id}');
      print('Saved today track with ID: ${savedTodayTrack.id}');

      // Assert: Проверяем что треки сохранились с правильным userId
      expect(savedYesterdayTrack.id > 0, true);
      expect(savedYesterdayTrack.userId, equals(internalUserId));
      expect(savedTodayTrack.id > 0, true);
      expect(savedTodayTrack.userId, equals(internalUserId));

      // Act: Получаем все треки пользователя
      final userTracks = await repository.getTracksByUserId(internalUserId);

      // Assert: Проверяем связь один-ко-многим
      expect(userTracks.length, equals(2));
      expect(userTracks.every((track) => track.userId == internalUserId), true);
      
      // Проверяем что треки содержат GPS точки
      final yesterdayFromDb = userTracks.firstWhere((t) => t.id == savedYesterdayTrack.id);
      final todayFromDb = userTracks.firstWhere((t) => t.id == savedTodayTrack.id);
      
      expect(yesterdayFromDb.points.isNotEmpty, true);
      expect(todayFromDb.points.isNotEmpty, true);
      
      print('Yesterday track has ${yesterdayFromDb.points.length} GPS points');
      print('Today track has ${todayFromDb.points.length} GPS points');

      // Assert: Проверяем статистику пользователя
      final stats = await repository.getUserTrackStatistics(internalUserId);
      expect(stats.totalTracks, equals(2));
      expect(stats.totalDistanceKm > 0, true);
      expect(stats.totalMovingTimeHours > 0, true);
      
      print('User statistics:');
      print('- Total tracks: ${stats.totalTracks}');
      print('- Total distance: ${stats.totalDistanceKm.toStringAsFixed(2)} km');
      print('- Total moving time: ${stats.totalMovingTimeHours.toStringAsFixed(2)} hours');
      print('- Average speed: ${stats.averageSpeedKmh.toStringAsFixed(2)} km/h');
    });

    test('should handle multiple users with their own tracks', () async {
      // Arrange: Создаем двух пользователей
      final phone1Result = PhoneNumber.create('89001111111');
      final phone2Result = PhoneNumber.create('89002222222');
      
      if (phone1Result.isLeft() || phone2Result.isLeft()) {
        fail('Phone number creation failed');
      }
      
      final phone1 = phone1Result.getOrElse(() => throw Exception('Invalid phone'));
      final phone2 = phone2Result.getOrElse(() => throw Exception('Invalid phone'));
      
      final user1Result = domain.User.create(
        externalId: 'user-1',
        lastName: 'Петров',
        firstName: 'Иван',
        role: domain.UserRole.user,
        phoneNumber: phone1,
        hashedPassword: 'hash1',
      );
      
      final user2Result = domain.User.create(
        externalId: 'user-2',
        lastName: 'Сидоров',
        firstName: 'Петр',
        role: domain.UserRole.user,
        phoneNumber: phone2,
        hashedPassword: 'hash2',
      );

      final user1 = user1Result.getOrElse(() => throw Exception('User1 creation failed'));
      final user2 = user2Result.getOrElse(() => throw Exception('User2 creation failed'));
      
      await database.insertUser(user1);
      await database.insertUser(user2);

      final user1Id = await database.getInternalUserIdByExternalId('user-1');
      final user2Id = await database.getInternalUserIdByExternalId('user-2');

      // Act: Создаем треки для каждого пользователя
      final user1Track = UserTrackFixtures.createYesterdayCompletedTrack(user1Id!);
      final user2Track1 = UserTrackFixtures.createTodayActiveTrack(user2Id!);
      final user2Track2 = UserTrackFixtures.createYesterdayCompletedTrack(user2Id);

      await repository.saveTrack(user1Track);
      await repository.saveTrack(user2Track1);
      await repository.saveTrack(user2Track2);

      // Assert: Каждый пользователь видит только свои треки
      final user1Tracks = await repository.getTracksByUserId(user1Id);
      final user2Tracks = await repository.getTracksByUserId(user2Id);

      expect(user1Tracks.length, equals(1));
      expect(user2Tracks.length, equals(2));
      expect(user1Tracks.first.userId, equals(user1Id));
      expect(user2Tracks.every((track) => track.userId == user2Id), true);

      print('User 1 has ${user1Tracks.length} tracks');
      print('User 2 has ${user2Tracks.length} tracks');
    });

    test('should verify foreign key constraint', () async {
      // Arrange: Пытаемся создать трек с несуществующим userId
      final invalidTrack = UserTrackFixtures.createTodayActiveTrack(9999); // несуществующий userId

      // Act & Assert: Должна быть ошибка foreign key constraint
      expect(
        repository.saveTrack(invalidTrack),
        throwsA(isA<SqliteException>()),
      );
    });
  });
}
