import '../../../../features/authentication/domain/entities/user.dart';
import '../../../../features/route/domain/entities/route.dart';

import '../entities/user_track.dart';
import '../../../../shared/domain/either.dart';
import '../../../../shared/domain/failures.dart';

abstract interface class IUserTrackRepository {
  Future<Either<Failure, UserTrack>> getUserTrackById(int id);
  
  Future<Either<Failure, List<UserTrack>>> getUserTracks(User user);
  
  Future<Either<Failure, List<UserTrack>>> getUserTracksByDateRange(
    User user,
    DateTime startDate,
    DateTime endDate,
  );
  
  Future<Either<Failure, UserTrack?>> getActiveUserTrack(User user);
  
  Future<Either<Failure, UserTrack>> saveUserTrack(UserTrack track);
  
  Future<Either<Failure, UserTrack>> updateUserTrack(UserTrack track);
  
  Future<Either<Failure, void>> deleteUserTrack(UserTrack track);
  
  Future<Either<Failure, List<UserTrack>>> getTracksByRoute(Route route);
}
