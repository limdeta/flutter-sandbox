import 'package:drift/drift.dart';
import 'user_tables.dart'; // Импорт локальных таблиц пользователей

/// Таблица для хранения пользовательских треков (высокоуровневая сущность)
@DataClassName('UserTrackData')
class UserTracks extends Table {
  @override
  String get tableName => 'user_tracks';
  
  /// Уникальный ID трека
  IntColumn get id => integer().autoIncrement()();
  
  /// ID пользователя, которому принадлежит трек
  IntColumn get userId => integer().references(UserEntries, #id)();
  
  /// ID маршрута, в рамках которого записан трек (может быть null)
  IntColumn get routeId => integer().nullable()();
  
  /// Дата и время начала трека
  DateTimeColumn get startTime => dateTime()();
  
  /// Дата и время окончания трека (null если трек активен)
  DateTimeColumn get endTime => dateTime().nullable()();
  
  /// Статус трека (active, paused, completed, cancelled)
  TextColumn get status => text().withDefault(const Constant('active'))();
  
  /// Кешированное количество точек в треке
  IntColumn get totalPoints => integer().withDefault(const Constant(0))();
  
  /// Кешированная общая дистанция в километрах
  RealColumn get totalDistanceKm => real().withDefault(const Constant(0.0))();
  
  /// Кешированная общая длительность в секундах
  IntColumn get totalDurationSeconds => integer().withDefault(const Constant(0))();
  
  /// Дополнительные метаданные в формате JSON
  TextColumn get metadata => text().nullable()();
  
  /// Дата создания записи
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// Дата последнего обновления
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Таблица для хранения компактных GPS треков (сегментов) в бинарном формате
@DataClassName('CompactTrackData')
class CompactTracks extends Table {
  @override
  String get tableName => 'compact_tracks';
  
  /// Уникальный ID компактного трека
  IntColumn get id => integer().autoIncrement()();
  
  /// ID пользовательского трека, к которому относится этот сегмент
  IntColumn get userTrackId => integer().references(UserTracks, #id)();
  
  /// Координаты в бинарном формате Float64List -> Uint8List
  BlobColumn get coordinatesBlob => blob()();
  
  /// Временные метки в бинарном формате Int64List -> Uint8List
  BlobColumn get timestampsBlob => blob()();
  
  /// Скорости в бинарном формате Float32List -> Uint8List
  BlobColumn get speedsBlob => blob()();
  
  /// Точность GPS в бинарном формате Float32List -> Uint8List
  BlobColumn get accuraciesBlob => blob()();
  
  /// Направление движения в бинарном формате Float32List -> Uint8List
  BlobColumn get bearingsBlob => blob()();
  
  /// Порядковый номер сегмента в треке (для правильной сортировки)
  IntColumn get segmentOrder => integer()();
  
  /// Дата создания записи
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}