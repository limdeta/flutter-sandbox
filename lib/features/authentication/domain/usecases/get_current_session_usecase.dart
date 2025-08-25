import 'package:tauzero/shared/failures.dart';

import '../../../../shared/either.dart';
import '../entities/user_session.dart';
import '../repositories/session_repository.dart';

class GetCurrentSessionUseCase {
  final SessionRepository sessionRepository;

  const GetCurrentSessionUseCase({
    required this.sessionRepository,
  });

  Future<Either<AuthFailure, UserSession?>> call() async {
    return await sessionRepository.getCurrentSession();
  }
}
