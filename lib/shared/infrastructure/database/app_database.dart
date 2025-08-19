import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../../features/authentication/domain/entities/user.dart' as domain;
import 'tables/user_tables.dart';
import 'tables/tracking_tables.dart';
import 'mappers/user_mapper.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [UserEntries, UserTracks, TrackPoints])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  // Конструктор для тестов
  AppDatabase.forTesting(DatabaseConnection super.connection);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Включаем foreign key constraints
      await customStatement('PRAGMA foreign_keys = ON');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Включаем foreign key constraints при обновлении
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // User queries returning domain entities
  Future<List<domain.User>> getAllUsers() async {
    final usersData = await select(userEntries).get();
    return UserMapper.fromUserEntryList(usersData);
  }

  Future<domain.User?> getUserById(int id) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return userData != null ? UserMapper.fromUserEntry(userData) : null;
  }

  Future<domain.User?> getUserByExternalId(String externalId) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.externalId.equals(externalId))).getSingleOrNull();
    return userData != null ? UserMapper.fromUserEntry(userData) : null;
  }

  Future<domain.User?> getUserByPhoneNumber(String phoneNumber) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.phoneNumber.equals(phoneNumber))).getSingleOrNull();
    return userData != null ? UserMapper.fromUserEntry(userData) : null;
  }

  Future<void> insertUser(domain.User user) async {
    await into(userEntries).insert(UserMapper.toInsertCompanion(user));
  }

  Future<void> updateUser(domain.User user) async {
    await (update(userEntries)..where((tbl) => tbl.externalId.equals(user.externalId.toString()))).write(UserMapper.toUpdateCompanion(user));
  }

  Future<void> deleteUser(int id) async {
    await (delete(userEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Удобные методы для работы с ID
  Future<int?> getInternalUserIdByExternalId(String externalId) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.externalId.equals(externalId))).getSingleOrNull();
    return userData?.id;
  }

  Future<String?> getExternalUserIdByInternalId(int internalId) async {
    final userData = await (select(userEntries)..where((tbl) => tbl.id.equals(internalId))).getSingleOrNull();
    return userData?.externalId;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Make sure sqlite3 is properly initialized on Android
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
