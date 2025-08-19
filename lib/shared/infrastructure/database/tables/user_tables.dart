import 'package:drift/drift.dart';

class UserEntries extends Table {
  @override
  String get tableName => 'users';
  
  IntColumn get id => integer().autoIncrement()();
  TextColumn get externalId => text().withLength(min: 1, max: 100)();
  TextColumn get lastName => text().withLength(min: 1, max: 100)();
  TextColumn get firstName => text().withLength(min: 1, max: 100)();
  TextColumn get middleName => text().nullable()();
  TextColumn get phoneNumber => text().withLength(min: 10, max: 20)();
  TextColumn get hashedPassword => text().withLength(min: 1, max: 255)();
  TextColumn get role => text()(); 
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {externalId},
    {phoneNumber},
  ];
}
