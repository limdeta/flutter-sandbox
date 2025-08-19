import '../entities/user_track.dart';
import '../entities/track_point.dart';

/// Интерфейс репозитория для работы с треками пользователей
abstract class IUserTrackRepository {
  /// Сохраняет новый трек
  Future<UserTrack> saveTrack(UserTrack track);
  
  /// Обновляет существующий трек
  Future<UserTrack> updateTrack(UserTrack track);
  
  /// Получает трек по ID
  Future<UserTrack?> getTrackById(int id);
  
  /// Получает все треки пользователя
  Future<List<UserTrack>> getTracksByUserId(int userId);
  
  /// Получает треки пользователя за определенный период
  Future<List<UserTrack>> getTracksByUserIdAndDateRange({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  });
  
  /// Получает треки для определенного маршрута
  Future<List<UserTrack>> getTracksByRouteId(int routeId);
  
  /// Получает активный трек пользователя (если есть)
  Future<UserTrack?> getActiveTrackByUserId(int userId);
  
  /// Удаляет трек
  Future<bool> deleteTrack(int id);
  
  /// Сохраняет точки трека (batch операция)
  Future<void> saveTrackPoints(int trackId, List<TrackPoint> points);
  
  /// Получает точки трека
  Future<List<TrackPoint>> getTrackPoints(int trackId);
  
  /// Получает точки трека за определенный период
  Future<List<TrackPoint>> getTrackPointsByDateRange({
    required int trackId,
    required DateTime startTime,
    required DateTime endTime,
  });
  
  /// Получает статистику треков пользователя
  Future<UserTrackStatistics> getUserTrackStatistics(int userId);
  
  /// Получает статистику треков за период
  Future<UserTrackStatistics> getUserTrackStatisticsByDateRange({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  });
  
  /// Очищает старые треки (для управления размером БД)
  Future<int> cleanupOldTracks({
    required Duration olderThan,
    bool keepCompletedTracks = true,
  });
}

/// Статистика треков пользователя
class UserTrackStatistics {
  /// Общее количество треков
  final int totalTracks;
  
  /// Общее пройденное расстояние в метрах
  final double totalDistanceMeters;
  
  /// Общее время в движении в секундах
  final int totalMovingTimeSeconds;
  
  /// Общее время всех треков в секундах
  final int totalTimeSeconds;
  
  /// Средняя скорость в км/ч
  final double averageSpeedKmh;
  
  /// Максимальная скорость в км/ч
  final double maxSpeedKmh;
  
  /// Количество активных треков
  final int activeTracks;
  
  /// Количество завершенных треков
  final int completedTracks;
  
  /// Дата первого трека
  final DateTime? firstTrackDate;
  
  /// Дата последнего трека
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

  /// Получает общее расстояние в километрах
  double get totalDistanceKm => totalDistanceMeters / 1000.0;
  
  /// Получает общее время в движении в часах
  double get totalMovingTimeHours => totalMovingTimeSeconds / 3600.0;
  
  /// Получает общее время в часах
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
