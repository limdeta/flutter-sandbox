import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import '../../features/tracking/domain/services/location_tracking_service.dart';
import '../../features/tracking/domain/repositories/iuser_track_repository.dart';
import '../../features/tracking/domain/entities/user_track.dart';
import '../../features/authentication/domain/usecases/get_current_session_usecase.dart';

/// Менеджер жизненного цикла приложения для GPS трекинга
/// 
/// Обеспечивает:
/// - Сохранение активного трека при сворачивании приложения
/// - Восстановление трека при разворачивании
/// - Автоматический старт трекинга в начале рабочего дня
/// - Корректное завершение трека при закрытии приложения
class AppLifecycleManager with WidgetsBindingObserver {
  static const String _tag = 'AppLifecycle';
  
  final LocationTrackingService _trackingService;
  final IUserTrackRepository _trackRepository;
  final GetCurrentSessionUseCase _sessionUsecase;
  
  bool _isInitialized = false;
  bool _wasTrackingBeforePause = false;

  AppLifecycleManager({
    LocationTrackingService? trackingService,
    IUserTrackRepository? trackRepository,
    GetCurrentSessionUseCase? sessionUsecase,
  }) : _trackingService = trackingService ?? GetIt.instance<LocationTrackingService>(),
       _trackRepository = trackRepository ?? GetIt.instance<IUserTrackRepository>(),
       _sessionUsecase = sessionUsecase ?? GetIt.instance<GetCurrentSessionUseCase>();

  /// Инициализирует менеджер жизненного цикла
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    WidgetsBinding.instance.addObserver(this);
    await _restoreActiveTrackingIfNeeded();
    _isInitialized = true;
    
    _log('Менеджер жизненного цикла инициализирован');
  }

  /// Освобождает ресурсы
  void dispose() {
    if (_isInitialized) {
      WidgetsBinding.instance.removeObserver(this);
      _isInitialized = false;
      _log('Менеджер жизненного цикла освобожден');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.inactive:
        // Не делаем ничего - это кратковременное состояние
        break;
      case AppLifecycleState.hidden:
        // Приложение скрыто но работает в фоне
        _log('Приложение скрыто, трекинг продолжается в фоне');
        break;
    }
  }

  /// Обработка возобновления приложения
  Future<void> _onAppResumed() async {
    _log('Приложение восстановлено');
    
    // Восстанавливаем трекинг если он был активен
    if (_wasTrackingBeforePause && !_trackingService.isTracking) {
      await _restoreActiveTrackingIfNeeded();
    }
    
    _wasTrackingBeforePause = false;
  }

  /// Обработка сворачивания приложения
  Future<void> _onAppPaused() async {
    _log('Приложение свернуто');
    
    _wasTrackingBeforePause = _trackingService.isTracking;
    
    if (_trackingService.isTracking) {
      _log('Трекинг продолжается в фоновом режиме');
      // LocationTrackingService уже настроен для фонового режима
      // через foregroundNotificationConfig для Android
    }
  }

  /// Обработка закрытия приложения
  Future<void> _onAppDetached() async {
    _log('Приложение закрывается');
    
    if (_trackingService.isTracking) {
      _log('Завершаем активный трек при закрытии приложения');
      await _trackingService.stopTracking();
    }
  }

  /// Восстанавливает активный трекинг при перезапуске приложения
  Future<void> _restoreActiveTrackingIfNeeded() async {
    try {
      // Получаем текущего пользователя
      final sessionResult = await _sessionUsecase.call();
      if (sessionResult.isLeft()) {
        _log('Не удалось получить текущую сессию');
        return;
      }

      final session = sessionResult.fold((l) => null, (r) => r);
      if (session?.user == null) {
        _log('Пользователь не авторизован');
        return;
      }

      // Ищем активный трек пользователя по externalId
      // TODO: Нужно получить внутренний userId из базы данных
      _log('Пользователь найден: ${session!.user.externalId}');
      // Пока пропускаем восстановление трека - нужна доработка архитектуры
      
      /*
      final activeTrack = await _trackRepository.getActiveTrackByUserId(userId);
      if (activeTrack == null) {
        _log('Активных треков не найдено');
        return;
      }

      _log('Найден активный трек, восстанавливаем трекинг');
      
      final success = await _trackingService.startTracking(
        userId: userId,
        routeId: activeTrack.routeId,
      );
      
      if (success) {
        _log('Трекинг успешно восстановлен');
      } else {
        _log('Не удалось восстановить трекинг');
      }
      */
      
    } catch (e) {
      _log('Ошибка при восстановлении трекинга: $e');
    }
  }

  /// Начинает трекинг для рабочего дня
  Future<bool> startWorkDayTracking({
    required int userId,
    int? routeId,
  }) async {
    if (_trackingService.isTracking) {
      _log('Трекинг уже активен');
      return true;
    }

    try {
      final success = await _trackingService.startTracking(
        userId: userId,
        routeId: routeId,
        metadata: {
          'autoStarted': true,
          'startedAt': DateTime.now().toIso8601String(),
        },
      );

      if (success) {
        _log('Автоматический трекинг рабочего дня начат');
      } else {
        _log('Не удалось начать автоматический трекинг');
      }

      return success;
    } catch (e) {
      _log('Ошибка при запуске трекинга: $e');
      return false;
    }
  }

  /// Останавливает трекинг рабочего дня
  Future<bool> stopWorkDayTracking() async {
    if (!_trackingService.isTracking) {
      _log('Трекинг не активен');
      return true;
    }

    try {
      await _trackingService.stopTracking();
      _log('Трекинг рабочего дня завершен');
      return true;
    } catch (e) {
      _log('Ошибка при остановке трекинга: $e');
      return false;
    }
  }

  /// Проверяет нужно ли автоматически начать трекинг
  Future<bool> shouldAutoStartTracking() async {
    try {
      final sessionResult = await _sessionUsecase.call();
      if (sessionResult.isLeft()) return false;

      final session = sessionResult.fold((l) => null, (r) => r);
      if (session?.user == null) return false;

      // Проверяем есть ли маршрут на сегодня
      // TODO: добавить проверку рабочего времени
      final now = DateTime.now();
      final isWorkingHours = now.hour >= 8 && now.hour <= 18;
      
      return isWorkingHours && !_trackingService.isTracking;
    } catch (e) {
      _log('Ошибка при проверке автостарта: $e');
      return false;
    }
  }

  /// Текущий статус трекинга
  bool get isTracking => _trackingService.isTracking;

  /// Текущий трек
  UserTrack? get currentTrack => _trackingService.currentTrack;

  void _log(String message) {
    if (kDebugMode) {
      print('🔄 [$_tag] $message');
    }
  }
}
