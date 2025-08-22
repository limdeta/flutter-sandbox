import '../../domain/entities/user_track.dart';
import '../../domain/repositories/iuser_track_repository.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../../shared/domain/either.dart';
import '../../../../shared/domain/failures.dart';

/// Use case для получения и фильтрации треков пользователя
class GetUserTracksUseCase {
  final IUserTrackRepository _repository;
  
  const GetUserTracksUseCase(this._repository);
  
  /// Получает все треки пользователя
  Future<Either<Failure, List<UserTrack>>> call(User user) async {
    return await _repository.getUserTracks(user);
  }
  
  /// Получает треки для конкретного маршрута
  Future<Either<Failure, List<UserTrack>>> getTracksForRoute(User user, int routeId) async {
    final result = await _repository.getUserTracks(user);
    
    return result.fold(
      (failure) => Left(failure),
      (tracks) => Right(tracks.where((track) => track.route?.id == routeId).toList())
    );
  }
  
  /// Получает только активный трек пользователя
  Future<Either<Failure, UserTrack?>> getActiveTrack(User user) async {
    final result = await _repository.getUserTracks(user);
    
    return result.fold(
      (failure) => Left(failure),
      (tracks) => Right(tracks.where((track) => track.status.isActive).firstOrNull)
    );
  }
}
