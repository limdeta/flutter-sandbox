import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tauzero/features/map/presentation/widgets/map_widget.dart';
import 'package:tauzero/features/tracking/data/repositories/user_track_repository.dart';
import 'package:tauzero/features/tracking/data/services/gps_tracking_service.dart';
import 'package:tauzero/features/tracking/presentation/providers/tracking_provider.dart';
import 'package:tauzero/features/tracking/presentation/widgets/tracking_controls.dart';
import 'package:tauzero/features/tracking/presentation/widgets/tracking_map_layers.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/shared/di/service_locator.dart';

/// Страница карты с интегрированным GPS трекингом
class TrackingMapPage extends StatefulWidget {
  final User user;

  const TrackingMapPage({
    super.key,
    required this.user,
  });

  @override
  State<TrackingMapPage> createState() => _TrackingMapPageState();
}

class _TrackingMapPageState extends State<TrackingMapPage> {
  late TrackingProvider _trackingProvider;

  @override
  void initState() {
    super.initState();
    
    // Получаем зависимости из сервис локатора
    final repository = getIt<UserTrackRepository>();
    final trackingService = GpsTrackingService(repository);
    
    _trackingProvider = TrackingProvider(repository, trackingService);
    
    // Загружаем исторические треки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackingProvider.loadHistoricalTracks(widget.user.internalId ?? 0);
    });
  }

  @override
  void dispose() {
    _trackingProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _trackingProvider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GPS Трекинг'),
          actions: [
            Consumer<TrackingProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  icon: Icon(
                    provider.isActive ? Icons.stop : Icons.play_arrow,
                    color: provider.isActive ? Colors.red : Colors.green,
                  ),
                  onPressed: () => _toggleTracking(provider),
                );
              },
            ),
          ],
        ),
        body: Consumer<TrackingProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ошибка: ${provider.error}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: provider.clearError,
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                // Основная карта
                MapWidget(
                  showUserTrack: true,
                ),
                
                // Слой с треками
                TrackingMapLayers(
                  historicalTracks: provider.historicalTracks,
                  currentTrack: provider.currentTrack,
                  currentPosition: provider.currentPosition,
                  isLiveTrackingActive: provider.isActive,
                  hasConnectionIssues: provider.hasConnectionIssues,
                ),
                
                // Элементы управления трекингом
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: TrackingControls(
                    onStartTracking: () => _startTracking(provider),
                    onPauseTracking: () => provider.pauseTracking(),
                    onResumeTracking: () => provider.resumeTracking(),
                    onStopTracking: () => provider.stopTracking(),
                    trackingState: provider.trackingState,
                    currentTrack: provider.currentTrack,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggleTracking(TrackingProvider provider) {
    if (provider.isActive) {
      provider.stopTracking();
    } else {
      _startTracking(provider);
    }
  }

  void _startTracking(TrackingProvider provider) {
    provider.startTracking(widget.user);
  }
}
