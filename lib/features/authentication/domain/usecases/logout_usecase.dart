import '../../../../shared/domain/either.dart';
import '../../../../shared/domain/failures.dart';
import '../services/authentication_service.dart';

class LogoutUseCase {
  final AuthenticationService authenticationService;

  const LogoutUseCase({
    required this.authenticationService,
  });

  Future<Either<AuthFailure, void>> call() async {
    return await authenticationService.logoutUser();
  }
}
