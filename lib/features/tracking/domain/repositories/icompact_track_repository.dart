import '../../../../features/authentication/domain/entities/user.dart';

import '../entities/compact_track.dart';
import '../../../../shared/domain/either.dart';
import '../../../../shared/domain/failures.dart';

abstract interface class ICompactTrackRepository {
  Future<Either<Failure, CompactTrack>> getCompactTrackById(int id);
  
  Future<Either<Failure, CompactTrack>> saveCompactTrack(CompactTrack track);
  
  Future<Either<Failure, CompactTrack>> updateCompactTrack(CompactTrack track);
  
  Future<Either<Failure, void>> deleteCompactTrack(CompactTrack track);
  
  Future<Either<Failure, List<CompactTrack>>> getCompactTracksByUser(User user);

  Future<Either<Failure, List<CompactTrack>>> getCompactTracksByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
