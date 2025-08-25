import 'package:get_it/get_it.dart';
import '../../shared/either.dart';
import '../../shared/failures.dart';
import '../../features/authentication/domain/usecases/logout_usecase.dart';
import '../services/app_session_service.dart';

/// Обёртка над authentication фичей для logout через AppUser
/// Делегирует logout к LogoutUseCase и очищает AppSession
class AppUserLogoutService {
  final LogoutUseCase _logoutUseCase;

  AppUserLogoutService({
    LogoutUseCase? logoutUseCase,
  }) : _logoutUseCase = logoutUseCase ?? GetIt.instance<LogoutUseCase>();

  /// Полный logout с очисткой всех данных
  /// 1. Делегирует logout к authentication фиче
  /// 2. Очищает AppSession
  /// 3. Возвращает результат
  Future<Either<AuthFailure, void>> logoutAppUser() async {
    print('🚪 [AppUserLogout] Начинаем logout...');

    try {
      // 1. Делегируем logout к authentication фиче
      final logoutResult = await _logoutUseCase.call();

      return logoutResult.fold(
        (authFailure) {
          print('❌ [AppUserLogout] Ошибка logout: ${authFailure.message}');
          return Left(authFailure);
        },
        (_) async {
          print('✅ [AppUserLogout] Authentication logout успешен');

          // 2. Очищаем AppSession
          try {
            AppSessionService.clearSession();
            print('✅ [AppUserLogout] AppSession очищен');
            
            print('🎯 [AppUserLogout] Logout завершен успешно');
            return const Right(null);
          } catch (e) {
            print('❌ [AppUserLogout] Ошибка очистки AppSession: $e');
            // Возвращаем успех, так как основной logout прошел
            return const Right(null);
          }
        },
      );
    } catch (e) {
      print('❌ [AppUserLogout] Неожиданная ошибка logout: $e');
      return Left(AuthFailure('Ошибка logout: $e'));
    }
  }
}
