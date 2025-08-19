import 'dart:convert';
import '../../../../features/tracking/domain/entities/user_track.dart';
import '../../../../features/tracking/domain/entities/track_point.dart';
import '../app_database.dart';

/// Маппер для конвертации между доменными сущностями треков и Drift data классами
class TrackMapper {
  /// Конвертирует UserTrackData в доменную сущность UserTrack
  static UserTrack fromUserTrackData(
      UserTrackData data, List<TrackPointData> points) {
    return UserTrack(
      id: data.id,
      userId: data.userId,
      routeId: data.routeId,
      startTime: data.startTime,
      endTime: data.endTime,
      points: points.map((point) => fromTrackPointData(point)).toList(),
      totalDistanceMeters: data.totalDistanceMeters,
      movingTimeSeconds: data.movingTimeSeconds,
      totalTimeSeconds: data.totalTimeSeconds,
      averageSpeedKmh: data.averageSpeedKmh,
      maxSpeedKmh: data.maxSpeedKmh,
      status: TrackStatus.values.firstWhere(
        (status) => status.name == data.status,
        orElse: () => TrackStatus.active,
      ),
      metadata: data.metadata != null ? jsonDecode(data.metadata!) : null,
    );
  }

  /// Конвертирует TrackPointData в доменную сущность TrackPoint
  static TrackPoint fromTrackPointData(TrackPointData data) {
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
      metadata: data.metadata != null ? jsonDecode(data.metadata!) : null,
    );
  }

  /// Конвертирует список TrackPointData в список TrackPoint
  static List<TrackPoint> fromTrackPointDataList(List<TrackPointData> dataList) {
    return dataList.map((data) => fromTrackPointData(data)).toList();
  }
}
