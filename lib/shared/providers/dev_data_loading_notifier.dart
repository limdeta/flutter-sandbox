import 'package:flutter/foundation.dart';

/// Состояние загрузки dev данных
enum DevDataLoadingState {
  idle,       // Не начинали загрузку
  loading,    // Идет загрузка в изоляте
  loaded,     // Данные загружены успешно
  error,      // Ошибка при загрузке
}

/// Уведомляемое состояние для отслеживания загрузки dev данных
class DevDataLoadingNotifier extends ValueNotifier<DevDataLoadingState> {
  DevDataLoadingNotifier() : super(DevDataLoadingState.idle);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Устанавливает состояние загрузки
  void setLoading() {
    value = DevDataLoadingState.loading;
    _errorMessage = null;
  }

  /// Устанавливает состояние успешной загрузки
  void setLoaded() {
    value = DevDataLoadingState.loaded;
    _errorMessage = null;
  }

  /// Устанавливает состояние ошибки
  void setError(String error) {
    value = DevDataLoadingState.error;
    _errorMessage = error;
  }

  /// Сбрасывает состояние в idle
  void reset() {
    value = DevDataLoadingState.idle;
    _errorMessage = null;
  }
}

/// Глобальный экземпляр для отслеживания состояния загрузки dev данных
final devDataLoadingNotifier = DevDataLoadingNotifier();
