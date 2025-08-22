import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/map_point.dart';
import '../../domain/repositories/imap_service.dart';
import '../../domain/adapters/route_map_adapter.dart';
import '../../data/repositories/osm_map_service.dart';
import '../../../route/domain/entities/route.dart' as domain;
import '../../../../shared/services/user_initialization_service.dart';
import '../../../tracking/domain/services/location_tracking_service.dart';
import '../../../tracking/domain/entities/user_track.dart';
import 'route_polyline.dart';

/// Основной виджет карты с поддержкой различных провайдеров
class MapWidget extends StatefulWidget {
  final domain.Route? route;
  final MapPoint? center;
  final double? initialZoom;
  final Function(MapPoint)? onTap;
  final Function(MapPoint)? onLongPress;
  
  /// Сервис трекинга для отображения пути пользователя (опционально)
  final LocationTrackingService? trackingService;
  
  /// Показывать ли трек пользователя на карте
  final bool showUserTrack;
  
  /// Исторические GPS треки для отображения
  final List<UserTrack> historicalTracks;
  
  final List<LatLng> routePolylinePoints;

  const MapWidget({
    super.key,
    this.route,
    this.center,
    this.initialZoom,
    this.onTap,
    this.onLongPress,
    this.trackingService,
    this.showUserTrack = false,
    this.historicalTracks = const [],
    this.routePolylinePoints = const [],
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final MapController _mapController;
  late final IMapService _mapService;
  
  // Центр карты и масштаб по умолчанию (Владивосток)
  static const LatLng _defaultCenter = LatLng(43.1056, 131.8735);
  static const double _defaultZoom = 12.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _mapService = OSMMapService(); // В будущем можно inject через DI
  }

  @override
  void dispose() {
    _saveMapState(); // Сохраняем состояние при выходе
    _mapController.dispose();
    super.dispose();
  }

  /// Сохраняет текущее состояние карты
  void _saveMapState() {
    final preferencesService = UserInitializationService.getPreferencesService();
    if (preferencesService != null) {
      final camera = _mapController.camera;
      preferencesService.setMapState(
        centerLat: camera.center.latitude,
        centerLng: camera.center.longitude,
        zoom: camera.zoom,
      );
    }
  }

  /// Получает центр карты на основе маршрута или переданного центра
  LatLng _getMapCenter() {
    if (widget.center != null) {
      return LatLng(widget.center!.latitude, widget.center!.longitude);
    }

    final preferencesService = UserInitializationService.getPreferencesService();
    if (preferencesService != null) {
      final savedState = preferencesService.getMapState();
      if (savedState != null) {
        return LatLng(savedState.centerLat, savedState.centerLng);
      }
    }

    // Если есть маршрут - центрируем по нему
    if (widget.route != null && widget.route!.pointsOfInterest.isNotEmpty) {
      final centerPoint = RouteMapAdapter.getRouteCenterPoint(widget.route!);
      if (centerPoint != null) {
        return LatLng(centerPoint.latitude, centerPoint.longitude);
      }
    }

    return _defaultCenter;
  }

  /// Получает оптимальный масштаб на основе маршрута
  double _getMapZoom() {
    // 1. Приоритет: явно переданный зум
    if (widget.initialZoom != null) {
      return widget.initialZoom!;
    }

    // 2. Проверяем сохраненное состояние карты
    final preferencesService = UserInitializationService.getPreferencesService();
    if (preferencesService != null) {
      final savedState = preferencesService.getMapState();
      if (savedState != null) {
        return savedState.zoom;
      }
    }

    // 3. Если есть маршрут - рассчитываем оптимальный зум
    if (widget.route != null && widget.route!.pointsOfInterest.isNotEmpty) {
      final bounds = RouteMapAdapter.getRouteBounds(widget.route!);
      if (bounds != null) {
        final context = this.context;
        final size = MediaQuery.of(context).size;
        
        // Получаем оптимальный масштаб, но ограничиваем его
        final optimalZoom = _mapService.getOptimalZoom(bounds, size.width, size.height);
        final clampedZoom = optimalZoom.toDouble().clamp(8.0, 16.0);
        return clampedZoom;
      }
    }

    return _defaultZoom;
  }

  /// Создает маркеры для точек маршрута
  List<Marker> _buildRouteMarkers() {
    if (widget.route == null) return [];

    return widget.route!.pointsOfInterest
        .map((poi) => _buildMarkerForPOI(poi))
        .toList();
  }

  /// Создает маркер для точки интереса
  Marker _buildMarkerForPOI(dynamic poi) {
    // Используем адаптер для получения цвета и иконки
    final colorName = RouteMapAdapter.getMarkerColorByStatus(poi.status);
    final iconName = RouteMapAdapter.getMarkerIconByType(poi.type);
    
    // Преобразуем названия в Flutter объекты
    Color markerColor = _getColorFromName(colorName);
    IconData markerIcon = _getIconFromName(iconName);

    return Marker(
      point: LatLng(poi.coordinates.latitude, poi.coordinates.longitude),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _onMarkerTap(poi),
        child: Container(
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            markerIcon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'yellow':
        return Colors.yellow;
      case 'blue':
        return Colors.blue;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'warehouse':
        return Icons.warehouse;
      case 'business':
        return Icons.business;
      case 'home':
        return Icons.home;
      case 'flag':
        return Icons.flag;
      case 'store':
        return Icons.store;
      case 'meeting_room':
        return Icons.meeting_room;
      case 'restaurant':
        return Icons.restaurant;
      case 'location_on':
      default:
        return Icons.location_on;
    }
  }

  void _onMarkerTap(dynamic poi) {
    _showPOIDetails(poi);
  }

  void _showPOIDetails(dynamic poi) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poi.name ?? 'Точка маршрута',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (poi.description != null) ...[
              Text('Описание: ${poi.description}'),
              const SizedBox(height: 4),
            ],
            Text('Тип: ${RouteMapAdapter.getTypeDisplayText(poi.type)}'),
            Text('Статус: ${RouteMapAdapter.getStatusDisplayText(poi.status)}'),
            if (poi.plannedArrivalTime != null) ...[
              const SizedBox(height: 4),
              Text('Планируемое время: ${poi.plannedArrivalTime}'),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Закрыть'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Основная карта
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _getMapCenter(),
            initialZoom: _getMapZoom(),
            minZoom: _mapService.minZoom.toDouble(),
            maxZoom: _mapService.maxZoom.toDouble(),
            onPositionChanged: (MapCamera position, bool hasGesture) {
              // Сохраняем состояние карты при каждом изменении позиции/зума
              if (hasGesture) {
                // Сохраняем с небольшой задержкой чтобы не спамить
                Future.delayed(const Duration(milliseconds: 500), () {
                  _saveMapState();
                });
              }
            },
            onTap: (tapPosition, point) {
              if (widget.onTap != null) {
                widget.onTap!(MapPoint(latitude: point.latitude, longitude: point.longitude));
              }
            },
            onLongPress: (tapPosition, point) {
              if (widget.onLongPress != null) {
                widget.onLongPress!(MapPoint(latitude: point.latitude, longitude: point.longitude));
              }
            },
          ),
          children: [
            // Слой тайлов карты
            TileLayer(
              urlTemplate: _mapService.getTileUrl(0, 0, 0).replaceAll('/0/0/0.png', '/{z}/{x}/{y}.png'),
              userAgentPackageName: 'com.tauzero.app.tauzero',
              maxZoom: _mapService.maxZoom.toDouble(),
            ),
            
            // Слой GPS треков (polylines) - отображаем треки для выбранного маршрута
            if (widget.historicalTracks.isNotEmpty)
              PolylineLayer(polylines: _buildTrackPolylines()),
            
            // Слой маршрута (построенного через OSRM)
            if (widget.routePolylinePoints.isNotEmpty)
              RoutePolyline(points: widget.routePolylinePoints),
            
            // Слой трека пользователя - ВРЕМЕННО ОТКЛЮЧЕН
            // TODO: Восстановить после реализации LiveTrackMapLayer
            // if (widget.showUserTrack && widget.trackingService != null)
            //   LiveTrackMapLayer(
            //     trackingService: widget.trackingService!,
            //     mapController: _mapController,
            //     showTrackInfo: false, // Информацию показываем отдельно
            //   ),
            
            // Слой маркеров GPS треков (начало/конец) - ВРЕМЕННО ОТКЛЮЧЕНО
            // if (widget.historicalTracks.isNotEmpty)
            //   MarkerLayer(markers: _buildTrackMarkers()),
            
            // Слой маркеров маршрута
            if (widget.route != null)
              MarkerLayer(
                markers: _buildRouteMarkers(),
              ),
          ],
        ),
        
        // Кнопки управления картой
        _buildMapControls(context),
      ],
    );
  }

  /// Строит кнопки управления картой
  Widget _buildMapControls(BuildContext context) {
    return Positioned(
      right: 16,
      // Адаптивный отступ снизу: базовый отступ + место для кнопки "Построить маршрут" (если есть)
      bottom: 88, // 16 базовый + 48 кнопка + 16 padding + 8 доп. отступ = 88
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Кнопка трекинга (если включена)
          if (widget.trackingService != null)
            _buildTrackingButton(),
          
          // Интервал между группами кнопок
          if (widget.trackingService != null)
            const SizedBox(height: 16),
          
          // Кнопка текущего положения
          FloatingActionButton(
            mini: true,
            heroTag: "location",
            onPressed: _onLocationPressed,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            child: const Icon(Icons.my_location),
          ),
          
          const SizedBox(height: 8),
          
          // Кнопка увеличения
          FloatingActionButton(
            mini: true,
            heroTag: "zoom_in",
            onPressed: _onZoomInPressed,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            child: const Icon(Icons.add),
          ),
          
          const SizedBox(height: 8),
          
          // Кнопка уменьшения
          FloatingActionButton(
            mini: true,
            heroTag: "zoom_out",
            onPressed: _onZoomOutPressed,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  /// Строит кнопку быстрого доступа к трекингу
  Widget _buildTrackingButton() {
    return StreamBuilder<bool>(
      stream: widget.trackingService!.trackUpdateStream.map((track) => track.isActive),
      initialData: widget.trackingService!.isTracking,
      builder: (context, snapshot) {
        final isTracking = snapshot.data ?? false;
        
        return FloatingActionButton(
          heroTag: "tracking",
          onPressed: _onTrackingPressed,
          backgroundColor: isTracking ? Colors.red : Colors.green,
          foregroundColor: Colors.white,
          child: Icon(isTracking ? Icons.stop : Icons.play_arrow),
        );
      },
    );
  }

  /// Обработчик кнопки текущего положения
  void _onLocationPressed() {
    // TODO: Получить текущее положение пользователя и переместить карту
    // Пока центрируем на Владивостоке
    const vladivostokCenter = LatLng(43.1056, 131.8735);
    _mapController.move(vladivostokCenter, 12.0);
    _saveMapState(); // Сохраняем новое состояние
  }

  /// Обработчик кнопки увеличения
  void _onZoomInPressed() {
    final currentZoom = _mapController.camera.zoom;
    final newZoom = (currentZoom + 1).clamp(_mapService.minZoom.toDouble(), _mapService.maxZoom.toDouble());
    _mapController.move(_mapController.camera.center, newZoom);
    _saveMapState(); // Сохраняем новое состояние
  }

  /// Обработчик кнопки уменьшения  
  void _onZoomOutPressed() {
    final currentZoom = _mapController.camera.zoom;
    final newZoom = (currentZoom - 1).clamp(_mapService.minZoom.toDouble(), _mapService.maxZoom.toDouble());
    _mapController.move(_mapController.camera.center, newZoom);
    _saveMapState(); // Сохраняем новое состояние
  }

  /// Обработчик кнопки трекинга
  void _onTrackingPressed() {
    // Здесь можно показать диалог управления трекингом
    // или выполнить быстрое действие (старт/стоп)
    if (widget.trackingService!.isTracking) {
      // Показываем диалог остановки трекинга
      _showTrackingStopDialog();
    } else {
      // Показываем диалог начала трекинга
      _showTrackingStartDialog();
    }
  }

  void _showTrackingStartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Начать запись маршрута?'),
        content: const Text(
          'Будет начата запись вашего пути с помощью GPS. '
          'Убедитесь, что у приложения есть разрешение на геолокацию.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Запуск трекинга (здесь нужно получить userId)
              // await widget.trackingService!.startTracking(userId: currentUserId);
            },
            child: const Text('Начать'),
          ),
        ],
      ),
    );
  }

  void _showTrackingStopDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Остановить запись?'),
        content: const Text('Запись маршрута будет остановлена и сохранена.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await widget.trackingService!.stopTracking();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Остановить'),
          ),
        ],
      ),
    );
  }

  /// Создает маркеры начала/конца GPS треков - ВРЕМЕННО ОТКЛЮЧЕНО ДЛЯ ОПТИМИЗАЦИИ
  /*
  List<Marker> _buildTrackMarkers() {
    final markers = <Marker>[];

    for (final track in widget.historicalTracks) {
      if (track.points.isEmpty) continue;

      final firstPoint = track.points.first;
      final lastPoint = track.points.last;

      markers.addAll([
        // Начало трека
        Marker(
          point: LatLng(firstPoint.latitude, firstPoint.longitude),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.green,
            size: 20,
          ),
        ),
        // Конец трека (только для завершенных)
        if (track.status == TrackStatus.completed)
          Marker(
            point: LatLng(lastPoint.latitude, lastPoint.longitude),
            child: const Icon(
              Icons.stop,
              color: Colors.red,
              size: 20,
            ),
          ),
      ]);
    }

    return markers;
  }
  */

  /// Создает полилинии для отображения GPS треков пользователя
  List<Polyline> _buildTrackPolylines() {
    final polylines = <Polyline>[];

    for (final track in widget.historicalTracks) {
      // Получаем все точки из всех сегментов трека
      final allPoints = <LatLng>[];
      
      for (final segment in track.segments) {
        for (int i = 0; i < segment.pointCount; i++) {
          final (lat, lng) = segment.getCoordinates(i);
          allPoints.add(LatLng(lat, lng));
        }
      }

      if (allPoints.isEmpty) continue;

      // Определяем цвет линии в зависимости от статуса трека
      Color trackColor;
      double strokeWidth;
      
      switch (track.status.name) {
        case 'active':
          trackColor = Colors.blue;
          strokeWidth = 4.0;
          break;
        case 'completed':
          trackColor = Colors.green;
          strokeWidth = 3.0;
          break;
        case 'paused':
          trackColor = Colors.orange;
          strokeWidth = 3.0;
          break;
        default:
          trackColor = Colors.grey;
          strokeWidth = 2.0;
      }

      polylines.add(
        Polyline(
          points: allPoints,
          strokeWidth: strokeWidth,
          color: trackColor.withOpacity(0.8),
        ),
      );
    }

    return polylines;
  }

}
