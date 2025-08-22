import 'package:flutter/foundation.dart';
import 'dart:async';
import '../../domain/entities/user_track.dart';
import '../../../authentication/domain/entities/user.dart';
import '../usecases/get_user_tracks_usecase.dart';

/// Provider для управления состоянием треков пользователя (ОПТИМИЗИРОВАННО для производительности)
class UserTracksProvider extends ChangeNotifier {
  final GetUserTracksUseCase _getUserTracksUseCase;
  
  List<UserTrack> _userTracks = [];
  UserTrack? _activeTrack;
  List<UserTrack> _completedTracks = [];
  bool _isLoading = false;
  String? _error;
  
  // Кэширование для предотвращения повторных запросов
  User? _lastLoadedUser;
  DateTime? _lastLoadTime;
  static const Duration _cacheTimeout = Duration(minutes: 5);
  
  // Дебаунсинг для предотвращения частых обновлений UI
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 300);
  
  UserTracksProvider(this._getUserTracksUseCase);
  
  // Getters
  List<UserTrack> get userTracks => _userTracks;
  UserTrack? get activeTrack => _activeTrack;
  List<UserTrack> get completedTracks => _completedTracks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Загружает все треки пользователя (с кэшированием и дебаунсингом)
  Future<void> loadUserTracks(User user) async {
    // Проверяем кэш: если данные свежие и для того же пользователя - не перезагружаем
    if (_lastLoadedUser?.externalId == user.externalId && 
        _lastLoadTime != null && 
        DateTime.now().difference(_lastLoadTime!) < _cacheTimeout) {
      print('⚡ UserTracksProvider: Используем кэшированные треки для ${user.fullName}');
      return;
    }
    
    // Отменяем предыдущий дебаунс таймер если есть
    _debounceTimer?.cancel();
    
    _debounceTimer = Timer(_debounceDelay, () async {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      print('🔄 UserTracksProvider: Загружаем треки для ${user.fullName}...');
      
      final result = await _getUserTracksUseCase.call(user);
      
      result.fold(
        (failure) {
          _error = 'Ошибка загрузки треков: $failure';
          _isLoading = false;
          print('❌ UserTracksProvider: Ошибка загрузки треков: $failure');
          notifyListeners();
        },
        (tracks) {
          _userTracks = tracks;
          _activeTrack = tracks.where((track) => track.status.isActive).firstOrNull;
          _completedTracks = tracks.where((track) => track.status.name == 'completed').toList();
          _isLoading = false;
          
          // Обновляем кэш
          _lastLoadedUser = user;
          _lastLoadTime = DateTime.now();
          
          print('✅ UserTracksProvider: Загружено ${tracks.length} треков (активных: ${_activeTrack != null ? 1 : 0}, завершенных: ${_completedTracks.length})');
          notifyListeners();
        },
      );
    });
  }
  
  /// Получает треки для конкретного маршрута
  List<UserTrack> getTracksForRoute(int routeId) {
    return _userTracks.where((track) => track.route?.id == routeId).toList();
  }
  
  /// Очищает треки (при выходе пользователя)
  void clearTracks() {
    _debounceTimer?.cancel(); // Отменяем таймер для экономии ресурсов
    _userTracks.clear();
    _activeTrack = null;
    _completedTracks.clear();
    _error = null;
    _lastLoadedUser = null;
    _lastLoadTime = null;
    print('🧹 UserTracksProvider: Треки и кэш очищены');
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Очищаем таймер при удалении провайдера
    super.dispose();
  }
}
