import 'package:flutter/foundation.dart';
import '../../domain/entities/user_track.dart';
import '../../../authentication/domain/entities/user.dart';
import '../usecases/get_user_tracks_usecase.dart';

/// Provider для управления состоянием треков пользователя
class UserTracksProvider extends ChangeNotifier {
  final GetUserTracksUseCase _getUserTracksUseCase;
  
  List<UserTrack> _userTracks = [];
  UserTrack? _activeTrack;
  List<UserTrack> _completedTracks = [];
  bool _isLoading = false;
  String? _error;
  
  UserTracksProvider(this._getUserTracksUseCase);
  
  // Getters
  List<UserTrack> get userTracks => _userTracks;
  UserTrack? get activeTrack => _activeTrack;
  List<UserTrack> get completedTracks => _completedTracks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Загружает все треки пользователя
  Future<void> loadUserTracks(User user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await _getUserTracksUseCase.call(user);
    
    result.fold(
      (failure) {
        _error = 'Ошибка загрузки треков: $failure';
        _isLoading = false;
        notifyListeners();
      },
      (tracks) {
        _userTracks = tracks;
        _activeTrack = tracks.where((track) => track.status.isActive).firstOrNull;
        _completedTracks = tracks.where((track) => track.status.name == 'completed').toList();
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  /// Получает треки для конкретного маршрута
  List<UserTrack> getTracksForRoute(int routeId) {
    return _userTracks.where((track) => track.route?.id == routeId).toList();
  }
  
  /// Очищает треки (при выходе пользователя)
  void clearTracks() {
    _userTracks.clear();
    _activeTrack = null;
    _completedTracks.clear();
    _error = null;
    notifyListeners();
  }
}
