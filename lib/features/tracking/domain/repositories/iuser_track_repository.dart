import '../entities/user_track.dart';
import '../entities/track_point.dart';

/// Интерфейс репозитория для работы с треками пользователей
abstract class IUserTrackRepository {
  Future<UserTrack> saveTrack(UserTrack track);
  Future<UserTrack> updateTrack(UserTrack track);
  Future<UserTrack?> getTrackById(int id);
  Future<List<UserTrack>> getTracksByUserId(int userId);
  
  Future<List<UserTrack>> getTracksByUserIdAndDateRange({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  });
  
  Future<List<UserTrack>> getTracksByRouteId(int routeId);
  Future<UserTrack?> getActiveTrackByUserId(int userId);
  Future<bool> deleteTrack(int id);
  Future<void> saveTrackPoints(int trackId, List<TrackPoint> points);
  
  Future<List<TrackPoint>> getTrackPoints(int trackId);
  Future<List<TrackPoint>> getTrackPointsByDateRange({
    required int trackId,
    required DateTime startTime,
    required DateTime endTime,
  });
  
  Future<UserTrackStatistics> getUserTrackStatistics(int userId);
  
  Future<UserTrackStatistics> getUserTrackStatisticsByDateRange({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  });
  
  Future<int> cleanupOldTracks({
    required Duration olderThan,
    bool keepCompletedTracks = true,
  });
}

/// Статистика треков пользователя
class UserTrackStatistics {
  final int totalTracks;
  final double totalDistanceMeters;
  final int totalMovingTimeSeconds;
  final int totalTimeSeconds;
  final double averageSpeedKmh;
  final double maxSpeedKmh;
  final int activeTracks;
  final int completedTracks;
  final DateTime? firstTrackDate;
  final DateTime? lastTrackDate;

  const UserTrackStatistics({
    required this.totalTracks,
    required this.totalDistanceMeters,
    required this.totalMovingTimeSeconds,
    required this.totalTimeSeconds,
    required this.averageSpeedKmh,
    required this.maxSpeedKmh,
    required this.activeTracks,
    required this.completedTracks,
    this.firstTrackDate,
    this.lastTrackDate,
  });

  double get totalDistanceKm => totalDistanceMeters / 1000.0;
  double get totalMovingTimeHours => totalMovingTimeSeconds / 3600.0;
  double get totalTimeHours => totalTimeSeconds / 3600.0;

  @override
  String toString() {
    return 'UserTrackStatistics('
        'tracks: $totalTracks, '
        'distance: ${totalDistanceKm.toStringAsFixed(2)}km, '
        'movingTime: ${totalMovingTimeHours.toStringAsFixed(1)}h, '
        'avgSpeed: ${averageSpeedKmh.toStringAsFixed(1)}km/h'
        ')';
  }
}
