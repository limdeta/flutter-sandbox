import 'dart:convert';
import 'package:drift/drift.dart';

import '../../../../shared/infrastructure/database/app_database.dart';
import '../../../../shared/domain/either.dart';
import '../../../../shared/domain/failures.dart';
import '../../../../features/authentication/domain/entities/user.dart';
import '../../../../features/authentication/domain/repositories/iuser_repository.dart';
import '../../../../features/route/domain/entities/route.dart' as domain_route;
import '../../../../features/route/domain/repositories/iroute_repository.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/entities/compact_track.dart';
import '../../domain/repositories/iuser_track_repository.dart';
import '../../domain/enums/track_status.dart';

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
  Future<Either<Failure, UserTrack>> getUserTrackById(int id) async {
    try {
      final userTrackData = await (_database.select(_database.userTracks)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

      if (userTrackData == null) {
        return const Left(NotFoundFailure('UserTrack not found'));
      }

      // Получаем User из базы
      final user = await _getUserById(userTrackData.userId);
      if (user == null) {
        return const Left(NotFoundFailure('User not found for UserTrack'));
      }

      // Получаем Route если есть
      domain_route.Route? route;
      if (userTrackData.routeId != null) {
        route = await _getRouteById(userTrackData.routeId!);
      }

      // Загружаем CompactTrack сегменты
      final segments = await _loadCompactTrackSegments(id);

      final userTrack = UserTrack(
        id: userTrackData.id,
        user: user,
        route: route,
        status: _parseStatus(userTrackData.status),
        startTime: userTrackData.startTime,
        endTime: userTrackData.endTime,
        segments: segments,
        totalPoints: userTrackData.totalPoints,
        totalDistanceKm: userTrackData.totalDistanceKm,
        totalDuration: Duration(seconds: userTrackData.totalDurationSeconds),
        metadata: _parseMetadata(userTrackData.metadata),
      );

      return Right(userTrack);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get UserTrack: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserTrack>>> getUserTracks(User user) async {
    try {
      // Находим внутренний ID пользователя
      final userId = await _getUserInternalId(user);
      if (userId == null) {
        return const Left(NotFoundFailure('User not found in database'));
      }

      final userTracksData = await (_database.select(_database.userTracks)
            ..where((tbl) => tbl.userId.equals(userId)))
          .get();

      final userTracks = <UserTrack>[];
      for (final data in userTracksData) {
        // Загружаем сегменты для каждого трека
        final segments = await _loadCompactTrackSegments(data.id);
        
        // Получаем Route если есть
        domain_route.Route? route;
        if (data.routeId != null) {
          route = await _getRouteById(data.routeId!);
        }

        final userTrack = UserTrack(
          id: data.id,
          user: user,
          route: route,
          status: _parseStatus(data.status),
          startTime: data.startTime,
          endTime: data.endTime,
          segments: segments,
          totalPoints: data.totalPoints,
          totalDistanceKm: data.totalDistanceKm,
          totalDuration: Duration(seconds: data.totalDurationSeconds),
          metadata: _parseMetadata(data.metadata),
        );
        
        userTracks.add(userTrack);
      }

      return Right(userTracks);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get UserTracks: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserTrack>>> getUserTracksByDateRange(
    User user,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final userId = await _getUserInternalId(user);
      if (userId == null) {
        return const Left(NotFoundFailure('User not found in database'));
      }

      final userTracksData = await (_database.select(_database.userTracks)
            ..where((tbl) => 
                tbl.userId.equals(userId) &
                tbl.startTime.isBiggerOrEqualValue(startDate) &
                tbl.startTime.isSmallerOrEqualValue(endDate)))
          .get();

      final userTracks = <UserTrack>[];
      for (final data in userTracksData) {
        final segments = await _loadCompactTrackSegments(data.id);
        
        domain_route.Route? route;
        if (data.routeId != null) {
          route = await _getRouteById(data.routeId!);
        }

        final userTrack = UserTrack(
          id: data.id,
          user: user,
          route: route,
          status: _parseStatus(data.status),
          startTime: data.startTime,
          endTime: data.endTime,
          segments: segments,
          totalPoints: data.totalPoints,
          totalDistanceKm: data.totalDistanceKm,
          totalDuration: Duration(seconds: data.totalDurationSeconds),
          metadata: _parseMetadata(data.metadata),
        );
        
        userTracks.add(userTrack);
      }

      return Right(userTracks);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get UserTracks by date range: $e'));
    }
  }

  @override
  Future<Either<Failure, UserTrack?>> getActiveUserTrack(User user) async {
    try {
      final userId = await _getUserInternalId(user);
      if (userId == null) {
        return const Left(NotFoundFailure('User not found in database'));
      }

      final activeTrackData = await (_database.select(_database.userTracks)
            ..where((tbl) => 
                tbl.userId.equals(userId) &
                tbl.endTime.isNull()))
          .getSingleOrNull();

      if (activeTrackData == null) {
        return const Right(null);
      }

      final segments = await _loadCompactTrackSegments(activeTrackData.id);
      
      domain_route.Route? route;
      if (activeTrackData.routeId != null) {
        route = await _getRouteById(activeTrackData.routeId!);
      }

      final userTrack = UserTrack(
        id: activeTrackData.id,
        user: user,
        route: route,
        status: _parseStatus(activeTrackData.status),
        startTime: activeTrackData.startTime,
        endTime: activeTrackData.endTime,
        segments: segments,
        totalPoints: activeTrackData.totalPoints,
        totalDistanceKm: activeTrackData.totalDistanceKm,
        totalDuration: Duration(seconds: activeTrackData.totalDurationSeconds),
        metadata: _parseMetadata(activeTrackData.metadata),
      );

      return Right(userTrack);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get active UserTrack: $e'));
    }
  }

  @override
  Future<Either<Failure, UserTrack>> saveUserTrack(UserTrack track) async {
    try {
      final userId = await _getUserInternalId(track.user);
      if (userId == null) {
        return const Left(NotFoundFailure('User not found in database'));
      }

      final routeId = track.route?.id;

      // Сохраняем основную запись UserTrack
      final userTrackCompanion = UserTracksCompanion(
        userId: Value(userId),
        routeId: routeId != null ? Value(routeId) : const Value.absent(),
        startTime: Value(track.startTime),
        endTime: track.endTime != null ? Value(track.endTime!) : const Value.absent(),
        status: Value(track.status.name),
        totalPoints: Value(track.totalPoints),
        totalDistanceKm: Value(track.totalDistanceKm),
        totalDurationSeconds: Value(track.totalDuration.inSeconds),
        metadata: track.metadata != null ? Value(_encodeMetadata(track.metadata!)) : const Value.absent(),
      );

      final userTrackId = await _database.into(_database.userTracks).insert(userTrackCompanion);

      // Сохраняем сегменты CompactTrack
      for (int i = 0; i < track.segments.length; i++) {
        final segment = track.segments[i];
        
        final compactTrackCompanion = CompactTracksCompanion(
          userTrackId: Value(userTrackId),
          coordinatesBlob: Value(segment.serializeCoordinates()),
          timestampsBlob: Value(segment.serializeTimestamps()),
          speedsBlob: Value(segment.serializeSpeeds()),
          accuraciesBlob: Value(segment.serializeAccuracies()),
          bearingsBlob: Value(segment.serializeBearings()),
          segmentOrder: Value(i),
        );

        await _database.into(_database.compactTracks).insert(compactTrackCompanion);
      }

      // Возвращаем трек с новым ID
      final savedTrack = UserTrack(
        id: userTrackId,
        user: track.user,
        route: track.route,
        status: track.status,
        startTime: track.startTime,
        endTime: track.endTime,
        segments: track.segments,
        totalPoints: track.totalPoints,
        totalDistanceKm: track.totalDistanceKm,
        totalDuration: track.totalDuration,
        metadata: track.metadata,
      );

      return Right(savedTrack);
    } catch (e) {
      return Left(DatabaseFailure('Failed to save UserTrack: $e'));
    }
  }

  @override
  Future<Either<Failure, UserTrack>> updateUserTrack(UserTrack track) async {
    try {
      final userId = await _getUserInternalId(track.user);
      if (userId == null) {
        return const Left(NotFoundFailure('User not found in database'));
      }

      // Обновляем основную запись
      final userTrackCompanion = UserTracksCompanion(
        id: Value(track.id),
        userId: Value(userId),
        routeId: track.route?.id != null ? Value(track.route!.id!) : const Value.absent(),
        startTime: Value(track.startTime),
        endTime: track.endTime != null ? Value(track.endTime!) : const Value.absent(),
        totalPoints: Value(track.totalPoints),
        totalDistanceKm: Value(track.totalDistanceKm),
        totalDurationSeconds: Value(track.totalDuration.inSeconds),
        metadata: track.metadata != null ? Value(_encodeMetadata(track.metadata!)) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      );

      await (_database.update(_database.userTracks)
            ..where((tbl) => tbl.id.equals(track.id)))
          .write(userTrackCompanion);

      // Удаляем старые сегменты и создаем новые
      await (_database.delete(_database.compactTracks)
            ..where((tbl) => tbl.userTrackId.equals(track.id)))
          .go();

      // Сохраняем новые сегменты
      for (int i = 0; i < track.segments.length; i++) {
        final segment = track.segments[i];
        
        final compactTrackCompanion = CompactTracksCompanion(
          userTrackId: Value(track.id),
          coordinatesBlob: Value(segment.serializeCoordinates()),
          timestampsBlob: Value(segment.serializeTimestamps()),
          speedsBlob: Value(segment.serializeSpeeds()),
          accuraciesBlob: Value(segment.serializeAccuracies()),
          bearingsBlob: Value(segment.serializeBearings()),
          segmentOrder: Value(i),
        );

        await _database.into(_database.compactTracks).insert(compactTrackCompanion);
      }

      return Right(track);
    } catch (e) {
      return Left(DatabaseFailure('Failed to update UserTrack: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserTrack(UserTrack track) async {
    try {
      // Удаляем сегменты
      await (_database.delete(_database.compactTracks)
            ..where((tbl) => tbl.userTrackId.equals(track.id)))
          .go();

      // Удаляем основную запись
      await (_database.delete(_database.userTracks)
            ..where((tbl) => tbl.id.equals(track.id)))
          .go();

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete UserTrack: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserTrack>>> getTracksByRoute(domain_route.Route route) async {
    try {
      if (route.id == null) {
        return const Left(ValidationFailure('Route ID is required'));
      }

      final userTracksData = await (_database.select(_database.userTracks)
            ..where((tbl) => tbl.routeId.equals(route.id!)))
          .get();

      final userTracks = <UserTrack>[];
      for (final data in userTracksData) {
        final user = await _getUserById(data.userId);
        if (user == null) continue; // Пропускаем треки с несуществующими пользователями

        final segments = await _loadCompactTrackSegments(data.id);

        final userTrack = UserTrack(
          id: data.id,
          user: user,
          route: route,
          status: _parseStatus(data.status),
          startTime: data.startTime,
          endTime: data.endTime,
          segments: segments,
          totalPoints: data.totalPoints,
          totalDistanceKm: data.totalDistanceKm,
          totalDuration: Duration(seconds: data.totalDurationSeconds),
          metadata: _parseMetadata(data.metadata),
        );
        
        userTracks.add(userTrack);
      }

      return Right(userTracks);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get UserTracks by route: $e'));
    }
  }

  // =====================================================
  // HELPER METHODS
  // =====================================================

  /// Загружает сегменты CompactTrack для UserTrack
  Future<List<CompactTrack>> _loadCompactTrackSegments(int userTrackId) async {
    final segmentsData = await (_database.select(_database.compactTracks)
          ..where((tbl) => tbl.userTrackId.equals(userTrackId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.segmentOrder)]))
        .get();

    return segmentsData.map((data) => CompactTrack.fromDatabase(
      coordinatesBlob: data.coordinatesBlob,
      timestampsBlob: data.timestampsBlob,
      speedsBlob: data.speedsBlob,
      accuraciesBlob: data.accuraciesBlob,
      bearingsBlob: data.bearingsBlob,
    )).toList();
  }

  /// Получает внутренний ID пользователя по его externalId
  Future<int?> _getUserInternalId(User user) async {
    final userData = await (_database.select(_database.userEntries)
          ..where((tbl) => tbl.externalId.equals(user.externalId)))
        .getSingleOrNull();
    
    return userData?.id;
  }

  /// Получает User объект по внутреннему ID через UserRepository
  Future<User?> _getUserById(int userId) async {
    final result = await _userRepository.getUserByInternalId(userId);
    return result.fold(
      (failure) => null,
      (user) => user,
    );
  }

  /// Получает Route объект по ID через RouteRepository
  Future<domain_route.Route?> _getRouteById(int routeId) async {
    final result = await _routeRepository.getRouteByInternalId(routeId);
    return result.fold(
      (failure) => null,
      (route) => route,
    );
  }

  /// Парсит метаданные из JSON строки
  Map<String, dynamic>? _parseMetadata(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;
    
    try {
      final decoded = jsonDecode(jsonString);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (e) {
      return null;
    }
  }

  /// Кодирует метаданные в JSON строку
  String _encodeMetadata(Map<String, dynamic> metadata) {
    return jsonEncode(metadata);
  }

  /// Парсит статус трека из строки
  TrackStatus _parseStatus(String? statusString) {
    if (statusString == null) return TrackStatus.active;
    
    switch (statusString) {
      case 'active':
        return TrackStatus.active;
      case 'paused':
        return TrackStatus.paused;
      case 'completed':
        return TrackStatus.completed;
      case 'cancelled':
        return TrackStatus.cancelled;
      default:
        return TrackStatus.active;
    }
  }
}
