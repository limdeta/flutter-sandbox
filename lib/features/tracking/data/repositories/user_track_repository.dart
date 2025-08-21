import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/entities/track_point.dart';
import '../../domain/repositories/iuser_track_repository.dart';
import '../../../../shared/infrastructure/database/app_database.dart';
import '../../../authentication/domain/repositories/iuser_repository.dart';
import '../../../route/domain/repositories/iroute_repository.dart';
import '../../../route/domain/entities/route.dart';

/// Реализация репозитория треков пользователей для Drift БД
class UserTrackRepository implements IUserTrackRepository {
  final AppDatabase _database;
  final IUserRepository _userRepository;
  final IRouteRepository _routeRepository;

  UserTrackRepository(
    this._database,
    this._userRepository,
    this._routeRepository,
  );

  @override
  Future<UserTrack> saveTrack(UserTrack track) async {
    // Получаем правильный internal ID пользователя из базы данных
    int? userInternalId = track.user.internalId;
    
    // Если у объекта User нет internalId, получаем его из БД по externalId
    if (userInternalId == null) {
      userInternalId = await _database.getInternalUserIdByExternalId(track.user.externalId);
      if (userInternalId == null) {
        throw StateError('User with externalId ${track.user.externalId} not found in database');
      }
    }
    
    final companion = UserTracksCompanion.insert(
      userId: userInternalId,
      routeId: Value.absentIfNull(track.routeId),
      startTime: track.startTime,
      endTime: Value.absentIfNull(track.endTime),
      totalDistanceMeters: Value(track.totalDistanceMeters),
      movingTimeSeconds: Value(track.movingTimeSeconds),
      totalTimeSeconds: Value(track.totalTimeSeconds),
      averageSpeedKmh: Value(track.averageSpeedKmh),
      maxSpeedKmh: Value(track.maxSpeedKmh),
      status: track.status.name,
      metadata: Value.absentIfNull(track.metadata != null ? jsonEncode(track.metadata) : null),
    );

    final id = await _database.into(_database.userTracks).insert(companion);
    
    // Сохраняем точки трека
    if (track.points.isNotEmpty) {
      await _saveTrackPointsInternal(id, track.points);
    }

    return track.copyWith(id: id);
  }

  @override
  Future<UserTrack> updateTrack(UserTrack track) async {
    // Получаем правильный internal ID пользователя
    int? userInternalId = track.user.internalId;
    
    if (userInternalId == null) {
      userInternalId = await _database.getInternalUserIdByExternalId(track.user.externalId);
      if (userInternalId == null) {
        throw StateError('User with externalId ${track.user.externalId} not found in database');
      }
    }
    
    final companion = UserTracksCompanion(
      id: Value(track.id),
      userId: Value(userInternalId),
      routeId: Value.absentIfNull(track.routeId),
      startTime: Value(track.startTime),
      endTime: Value.absentIfNull(track.endTime),
      totalDistanceMeters: Value(track.totalDistanceMeters),
      movingTimeSeconds: Value(track.movingTimeSeconds),
      totalTimeSeconds: Value(track.totalTimeSeconds),
      averageSpeedKmh: Value(track.averageSpeedKmh),
      maxSpeedKmh: Value(track.maxSpeedKmh),
      status: Value(track.status.name),
      metadata: Value.absentIfNull(track.metadata != null ? jsonEncode(track.metadata) : null),
      updatedAt: Value(DateTime.now()),
    );

    await _database.update(_database.userTracks).replace(companion);
    return track;
  }

  @override
  Future<UserTrack?> getTrackById(int id) async {
    final query = _database.select(_database.userTracks)
      ..where((t) => t.id.equals(id));

    final trackData = await query.getSingleOrNull();
    if (trackData == null) return null;

    final points = await getTrackPoints(id);
    return await _mapDataToTrack(trackData, points);
  }

  @override
  Future<List<UserTrack>> getTracksByUserId(int userId) async {
    final query = _database.select(_database.userTracks)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.startTime)]);

    final tracksData = await query.get();
    final tracks = <UserTrack>[];

    for (final trackData in tracksData) {
      final points = await getTrackPoints(trackData.id);
      tracks.add(await _mapDataToTrack(trackData, points));
    }

    return tracks;
  }

  @override
  Future<List<UserTrack>> getTracksByUserIdAndDateRange({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final query = _database.select(_database.userTracks)
      ..where((t) => 
          t.userId.equals(userId) &
          t.startTime.isBiggerOrEqualValue(startDate) &
          t.startTime.isSmallerThanValue(endDate))
      ..orderBy([(t) => OrderingTerm.desc(t.startTime)]);

    final tracksData = await query.get();
    final tracks = <UserTrack>[];

    for (final trackData in tracksData) {
      final points = await getTrackPoints(trackData.id);
      tracks.add(await _mapDataToTrack(trackData, points));
    }

    return tracks;
  }

  @override
  Future<List<UserTrack>> getTracksByRouteId(int routeId) async {
    final query = _database.select(_database.userTracks)
      ..where((t) => t.routeId.equals(routeId))
      ..orderBy([(t) => OrderingTerm.desc(t.startTime)]);

    final tracksData = await query.get();
    final tracks = <UserTrack>[];

    for (final trackData in tracksData) {
      final points = await getTrackPoints(trackData.id);
      tracks.add(await _mapDataToTrack(trackData, points));
    }

    return tracks;
  }

  @override
  Future<UserTrack?> getActiveTrackByUserId(int userId) async {
    final query = _database.select(_database.userTracks)
      ..where((t) => 
          t.userId.equals(userId) &
          (t.status.equals('active') | t.status.equals('paused')))
      ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
      ..limit(1);

    final trackData = await query.getSingleOrNull();
    if (trackData == null) return null;

    final points = await getTrackPoints(trackData.id);
    return await _mapDataToTrack(trackData, points);
  }

  @override
  Future<bool> deleteTrack(int id) async {
    final deletedRows = await (_database.delete(_database.userTracks)
      ..where((t) => t.id.equals(id))).go();
    return deletedRows > 0;
  }

  @override
  Future<void> saveTrackPoints(int trackId, List<TrackPoint> points) async {
    await _saveTrackPointsInternal(trackId, points);
  }

  @override
  Future<List<TrackPoint>> getTrackPoints(int trackId) async {
    final query = _database.select(_database.trackPoints)
      ..where((p) => p.trackId.equals(trackId))
      ..orderBy([(p) => OrderingTerm.asc(p.timestamp)]);

    final pointsData = await query.get();
    return pointsData.map(_mapDataToTrackPoint).toList();
  }

  @override
  Future<List<TrackPoint>> getTrackPointsByDateRange({
    required int trackId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final query = _database.select(_database.trackPoints)
      ..where((p) => 
          p.trackId.equals(trackId) &
          p.timestamp.isBiggerOrEqualValue(startTime) &
          p.timestamp.isSmallerThanValue(endTime))
      ..orderBy([(p) => OrderingTerm.asc(p.timestamp)]);

    final pointsData = await query.get();
    return pointsData.map(_mapDataToTrackPoint).toList();
  }

  @override
  Future<UserTrackStatistics> getUserTrackStatistics(int userId) async {
    final tracksQuery = _database.select(_database.userTracks)
      ..where((t) => t.userId.equals(userId));

    final tracks = await tracksQuery.get();

    return _calculateStatistics(tracks);
  }

  @override
  Future<UserTrackStatistics> getUserTrackStatisticsByDateRange({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final tracksQuery = _database.select(_database.userTracks)
      ..where((t) => 
          t.userId.equals(userId) &
          t.startTime.isBiggerOrEqualValue(startDate) &
          t.startTime.isSmallerThanValue(endDate));

    final tracks = await tracksQuery.get();

    return _calculateStatistics(tracks);
  }

  @override
  Future<int> cleanupOldTracks({
    required Duration olderThan,
    bool keepCompletedTracks = true,
  }) async {
    final cutoffDate = DateTime.now().subtract(olderThan);
    
    var query = _database.delete(_database.userTracks)
      ..where((t) => t.startTime.isSmallerThanValue(cutoffDate));

    if (keepCompletedTracks) {
      query = query..where((t) => t.status.isNotValue('completed'));
    }

    return await query.go();
  }

  /// Внутренний метод для сохранения точек трека
  Future<void> _saveTrackPointsInternal(int trackId, List<TrackPoint> points) async {
    final companions = points.map((point) => TrackPointsCompanion.insert(
      trackId: trackId,
      latitude: point.latitude,
      longitude: point.longitude,
      timestamp: point.timestamp,
      accuracy: Value.absentIfNull(point.accuracy),
      altitude: Value.absentIfNull(point.altitude),
      altitudeAccuracy: Value.absentIfNull(point.altitudeAccuracy),
      speedKmh: Value.absentIfNull(point.speedKmh),
      bearing: Value.absentIfNull(point.bearing),
      distanceFromPrevious: Value.absentIfNull(point.distanceFromPrevious),
      timeFromPrevious: Value.absentIfNull(point.timeFromPrevious),
      metadata: Value.absentIfNull(point.metadata != null ? jsonEncode(point.metadata) : null),
    )).toList();

    await _database.batch((batch) {
      batch.insertAll(_database.trackPoints, companions);
    });
  }

  /// Преобразует данные БД в доменную модель трека
  Future<UserTrack> _mapDataToTrack(UserTrackData data, List<TrackPoint> points) async {
    TrackStatus status;
    switch (data.status) {
      case 'active':
        status = TrackStatus.active;
        break;
      case 'paused':
        status = TrackStatus.paused;
        break;
      case 'completed':
        status = TrackStatus.completed;
        break;
      case 'cancelled':
        status = TrackStatus.cancelled;
        break;
      default:
        status = TrackStatus.completed;
    }

    Map<String, dynamic>? metadata;
    if (data.metadata != null) {
      try {
        metadata = jsonDecode(data.metadata!) as Map<String, dynamic>;
      } catch (e) {
        metadata = null;
      }
    }

    // Загружаем связанный объект User
    final userResult = await _userRepository.getUserByInternalId(data.userId);
    final user = userResult.fold(
      (failure) => throw Exception('User not found for ID ${data.userId}: $failure'),
      (user) => user,
    );

    // Загружаем связанный объект Route, если есть
    Route? route;
    if (data.routeId != null) {
      final routeResult = await _routeRepository.getRouteByInternalId(data.routeId!);
      route = routeResult.fold(
        (failure) => null, // Если маршрут не найден, продолжаем без него
        (route) => route,
      );
    }

    return UserTrack(
      id: data.id,
      user: user,
      route: route,
      startTime: data.startTime,
      endTime: data.endTime,
      points: points,
      totalDistanceMeters: data.totalDistanceMeters,
      movingTimeSeconds: data.movingTimeSeconds,
      totalTimeSeconds: data.totalTimeSeconds,
      averageSpeedKmh: data.averageSpeedKmh,
      maxSpeedKmh: data.maxSpeedKmh,
      status: status,
      metadata: metadata,
    );
  }

  /// Преобразует данные БД в доменную модель точки трека
  TrackPoint _mapDataToTrackPoint(TrackPointData data) {
    Map<String, dynamic>? metadata;
    if (data.metadata != null) {
      try {
        metadata = jsonDecode(data.metadata!) as Map<String, dynamic>;
      } catch (e) {
        metadata = null;
      }
    }

    return TrackPoint(
      latitude: data.latitude,
      longitude: data.longitude,
      timestamp: data.timestamp,
      accuracy: data.accuracy,
      altitude: data.altitude,
      altitudeAccuracy: data.altitudeAccuracy,
      speedKmh: data.speedKmh,
      bearing: data.bearing,
      distanceFromPrevious: data.distanceFromPrevious,
      timeFromPrevious: data.timeFromPrevious,
      metadata: metadata,
    );
  }

  /// Вычисляет статистику по трекам
  UserTrackStatistics _calculateStatistics(List<UserTrackData> tracks) {
    if (tracks.isEmpty) {
      return const UserTrackStatistics(
        totalTracks: 0,
        totalDistanceMeters: 0.0,
        totalMovingTimeSeconds: 0,
        totalTimeSeconds: 0,
        averageSpeedKmh: 0.0,
        maxSpeedKmh: 0.0,
        activeTracks: 0,
        completedTracks: 0,
      );
    }

    double totalDistance = 0.0;
    int totalMovingTime = 0;
    int totalTime = 0;
    double maxSpeed = 0.0;
    int activeTracks = 0;
    int completedTracks = 0;

    DateTime? firstDate;
    DateTime? lastDate;

    for (final track in tracks) {
      totalDistance += track.totalDistanceMeters;
      totalMovingTime += track.movingTimeSeconds;
      totalTime += track.totalTimeSeconds;
      
      if (track.maxSpeedKmh > maxSpeed) {
        maxSpeed = track.maxSpeedKmh;
      }

      switch (track.status) {
        case 'active':
        case 'paused':
          activeTracks++;
          break;
        case 'completed':
          completedTracks++;
          break;
      }

      if (firstDate == null || track.startTime.isBefore(firstDate)) {
        firstDate = track.startTime;
      }
      if (lastDate == null || track.startTime.isAfter(lastDate)) {
        lastDate = track.startTime;
      }
    }

    final averageSpeed = totalMovingTime > 0 
        ? (totalDistance / 1000.0) / (totalMovingTime / 3600.0)
        : 0.0;

    return UserTrackStatistics(
      totalTracks: tracks.length,
      totalDistanceMeters: totalDistance,
      totalMovingTimeSeconds: totalMovingTime,
      totalTimeSeconds: totalTime,
      averageSpeedKmh: averageSpeed,
      maxSpeedKmh: maxSpeed,
      activeTracks: activeTracks,
      completedTracks: completedTracks,
      firstTrackDate: firstDate,
      lastTrackDate: lastDate,
    );
  }
}
