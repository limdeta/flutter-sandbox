import 'package:drift/drift.dart';
import 'user_tables.dart'; // Импорт локальных таблиц пользователей

/// Таблица для хранения GPS треков пользователей
@DataClassName('UserTrackData')
class UserTracks extends Table {
  @override
  String get tableName => 'user_tracks';
  
  /// Уникальный ID трека
  IntColumn get id => integer().autoIncrement()();
  
  /// ID пользователя, которому принадлежит трек
  IntColumn get userId => integer().references(UserEntries, #id)();
  
  /// ID маршрута, в рамках которого записан трек (может быть null)
  IntColumn get routeId => integer().nullable()(); // Убираем FK пока что
  
  /// Дата и время начала трека
  DateTimeColumn get startTime => dateTime()();
  
  /// Дата и время окончания трека (null если трек активен)
  DateTimeColumn get endTime => dateTime().nullable()();
  
  /// Общая дистанция в метрах
  RealColumn get totalDistanceMeters => real().withDefault(const Constant(0.0))();
  
  /// Время в движении в секундах
  IntColumn get movingTimeSeconds => integer().withDefault(const Constant(0))();
  
  /// Общее время трека в секундах
  IntColumn get totalTimeSeconds => integer().withDefault(const Constant(0))();
  
  /// Средняя скорость в км/ч
  RealColumn get averageSpeedKmh => real().withDefault(const Constant(0.0))();
  
  /// Максимальная скорость в км/ч
  RealColumn get maxSpeedKmh => real().withDefault(const Constant(0.0))();
  
  /// Статус трека: active, paused, completed, cancelled
  TextColumn get status => text().withLength(min: 1, max: 20)();
  
  /// Дополнительные метаданные в формате JSON
  TextColumn get metadata => text().nullable()();
  
  /// Дата создания записи
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// Дата последнего обновления
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Таблица для хранения отдельных GPS точек трека
@DataClassName('TrackPointData')
class TrackPoints extends Table {
  @override
  String get tableName => 'track_points';
  
  /// Уникальный ID точки
  IntColumn get id => integer().autoIncrement()();
  
  /// ID трека, к которому относится точка
  IntColumn get trackId => integer().references(UserTracks, #id)();
  
  /// Широта
  RealColumn get latitude => real()();
  
  /// Долгота
  RealColumn get longitude => real()();
  
  /// Временная метка GPS точки
  DateTimeColumn get timestamp => dateTime()();
  
  /// Точность GPS в метрах
  RealColumn get accuracy => real().nullable()();
  
  /// Высота над уровнем моря в метрах
  RealColumn get altitude => real().nullable()();
  
  /// Точность высоты в метрах
  RealColumn get altitudeAccuracy => real().nullable()();
  
  /// Скорость в км/ч
  RealColumn get speedKmh => real().nullable()();
  
  /// Направление движения в градусах (0-360)
  RealColumn get bearing => real().nullable()();
  
  /// Расстояние от предыдущей точки в метрах
  RealColumn get distanceFromPrevious => real().nullable()();
  
  /// Время от предыдущей точки в секундах
  IntColumn get timeFromPrevious => integer().nullable()();
  
  /// Дополнительные метаданные в формате JSON
  TextColumn get metadata => text().nullable()();
  
  /// Дата создания записи
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}