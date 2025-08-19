import 'package:drift/drift.dart';

class RoutesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startTime => dateTime().nullable()();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get pathJson => text().nullable()();
  IntColumn get userId => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  String get tableName => 'routes';
}

class TradingPointsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get externalId => text().unique()();
  TextColumn get name => text()();
  TextColumn get inn => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  String get tableName => 'trading_points';
}

class PointsOfInterestTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routeId => integer()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  
  DateTimeColumn get plannedArrivalTime => dateTime().nullable()();
  DateTimeColumn get plannedDepartureTime => dateTime().nullable()();
  DateTimeColumn get actualArrivalTime => dateTime().nullable()();
  DateTimeColumn get actualDepartureTime => dateTime().nullable()();
  
  TextColumn get type => text()();
  TextColumn get status => text()();
  
  TextColumn get notes => text().nullable()();
  
  IntColumn get tradingPointId => integer().nullable()();
  IntColumn get orderIndex => integer()();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  String get tableName => 'points_of_interest';
}

class PointStatusHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Связь с точкой интереса (Foreign Key)
  IntColumn get pointId => integer()();
  
  TextColumn get fromStatus => text()();
  TextColumn get toStatus => text()();
  
  TextColumn get changedBy => text()();
  TextColumn get reason => text().nullable()();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  String get tableName => 'point_status_history';
}
