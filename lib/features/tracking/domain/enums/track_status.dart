/// Статус GPS трека пользователя
enum TrackStatus {
  /// Трек активен - идет запись GPS точек
  active,
  
  /// Трек приостановлен - запись временно остановлена
  paused,
  
  /// Трек завершен - запись остановлена, данные сохранены
  completed,
  
  /// Трек отменен - запись остановлена без сохранения
  cancelled;

  /// Человекочитаемое название статуса
  String get displayName {
    switch (this) {
      case TrackStatus.active:
        return 'Активен';
      case TrackStatus.paused:
        return 'Приостановлен';
      case TrackStatus.completed:
        return 'Завершен';
      case TrackStatus.cancelled:
        return 'Отменен';
    }
  }

  /// Проверяет, является ли трек активным (идет запись)
  bool get isActive => this == TrackStatus.active;

  /// Проверяет, завершен ли трек
  bool get isCompleted => this == TrackStatus.completed || this == TrackStatus.cancelled;
}
