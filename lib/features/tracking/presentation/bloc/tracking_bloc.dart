import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_track.dart';
import '../../data/services/gps_tracking_service.dart';
import '../../data/repositories/user_track_repository.dart';

// Events
abstract class TrackingEvent {}

class LoadHistoricalTracks extends TrackingEvent {
  final int userId;
  LoadHistoricalTracks(this.userId);
}

class StartTracking extends TrackingEvent {
  final String userId;
  StartTracking(this.userId);
}

class PauseTracking extends TrackingEvent {}

class ResumeTracking extends TrackingEvent {}

class StopTracking extends TrackingEvent {}

// States
abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingLoaded extends TrackingState {
  final List<UserTrack> historicalTracks;
  final UserTrack? currentTrack;
  final LatLng? currentPosition;
  final GpsTrackingState trackingState;
  final bool hasConnectionIssues;

  TrackingLoaded({
    required this.historicalTracks,
    this.currentTrack,
    this.currentPosition,
    required this.trackingState,
    this.hasConnectionIssues = false,
  });

  TrackingLoaded copyWith({
    List<UserTrack>? historicalTracks,
    UserTrack? currentTrack,
    LatLng? currentPosition,
    GpsTrackingState? trackingState,
    bool? hasConnectionIssues,
  }) {
    return TrackingLoaded(
      historicalTracks: historicalTracks ?? this.historicalTracks,
      currentTrack: currentTrack ?? this.currentTrack,
      currentPosition: currentPosition ?? this.currentPosition,
      trackingState: trackingState ?? this.trackingState,
      hasConnectionIssues: hasConnectionIssues ?? this.hasConnectionIssues,
    );
  }
}

class TrackingError extends TrackingState {
  final String message;
  TrackingError(this.message);
}

// Bloc
class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final UserTrackRepository _repository;
  final GpsTrackingService _trackingService;

  TrackingBloc(this._repository, this._trackingService) : super(TrackingInitial()) {
    on<LoadHistoricalTracks>(_onLoadHistoricalTracks);
    on<StartTracking>(_onStartTracking);
    on<PauseTracking>(_onPauseTracking);
    on<ResumeTracking>(_onResumeTracking);
    on<StopTracking>(_onStopTracking);

    // Подписываемся на изменения GPS сервиса
    _trackingService.stateStream.listen((gpsState) {
      if (state is TrackingLoaded) {
        final currentState = state as TrackingLoaded;
        emit(currentState.copyWith(
          trackingState: gpsState,
          hasConnectionIssues: gpsState == GpsTrackingState.disconnected,
        ));
      }
    });

    _trackingService.positionStream.listen((position) {
      if (state is TrackingLoaded) {
        final currentState = state as TrackingLoaded;
        emit(currentState.copyWith(currentPosition: position));
      }
    });

    _trackingService.currentTrackStream.listen((track) {
      if (state is TrackingLoaded) {
        final currentState = state as TrackingLoaded;
        emit(currentState.copyWith(currentTrack: track));
      }
    });
  }

  Future<void> _onLoadHistoricalTracks(LoadHistoricalTracks event, Emitter<TrackingState> emit) async {
    try {
      emit(TrackingLoading());
      
      final tracks = await _repository.getTracksByUserId(event.userId);
      
      emit(TrackingLoaded(
        historicalTracks: tracks,
        trackingState: _trackingService.currentState,
        hasConnectionIssues: _trackingService.hasConnectionIssues,
      ));
    } catch (e) {
      emit(TrackingError('Ошибка загрузки треков: $e'));
    }
  }

  Future<void> _onStartTracking(StartTracking event, Emitter<TrackingState> emit) async {
    try {
      await _trackingService.startTracking(event.userId);
      
      if (state is TrackingLoaded) {
        final currentState = state as TrackingLoaded;
        emit(currentState.copyWith(
          trackingState: _trackingService.currentState,
          currentTrack: _trackingService.currentTrack,
        ));
      }
    } catch (e) {
      emit(TrackingError('Ошибка запуска трекинга: $e'));
    }
  }

  Future<void> _onPauseTracking(PauseTracking event, Emitter<TrackingState> emit) async {
    try {
      await _trackingService.pauseTracking();
    } catch (e) {
      emit(TrackingError('Ошибка приостановки трекинга: $e'));
    }
  }

  Future<void> _onResumeTracking(ResumeTracking event, Emitter<TrackingState> emit) async {
    try {
      await _trackingService.resumeTracking();
    } catch (e) {
      emit(TrackingError('Ошибка возобновления трекинга: $e'));
    }
  }

  Future<void> _onStopTracking(StopTracking event, Emitter<TrackingState> emit) async {
    try {
      final completedTrack = await _trackingService.stopTracking();
      
      if (state is TrackingLoaded) {
        final currentState = state as TrackingLoaded;
        final updatedTracks = completedTrack != null 
          ? [...currentState.historicalTracks, completedTrack]
          : currentState.historicalTracks;
          
        emit(currentState.copyWith(
          historicalTracks: updatedTracks,
          currentTrack: null,
          trackingState: _trackingService.currentState,
        ));
      }
    } catch (e) {
      emit(TrackingError('Ошибка остановки трекинга: $e'));
    }
  }

  @override
  Future<void> close() {
    _trackingService.dispose();
    return super.close();
  }
}
