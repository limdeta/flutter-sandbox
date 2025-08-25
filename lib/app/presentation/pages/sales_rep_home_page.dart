import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:tauzero/app/services/app_session_service.dart';
import 'package:tauzero/app/providers/selected_route_provider.dart';
import 'package:tauzero/app/presentation/widgets/combined_map_widget.dart';
import 'package:tauzero/features/navigation/map/domain/entities/map_point.dart';
import 'package:tauzero/features/navigation/path_predictor/osrm_path_prediction_service.dart';
import 'package:tauzero/features/navigation/tracking/presentation/providers/user_tracks_provider.dart';
import 'package:tauzero/features/shop/route/domain/entities/point_of_interest.dart';
import 'package:tauzero/features/shop/route/domain/repositories/route_repository.dart';
import 'package:tauzero/features/shop/route/domain/entities/route.dart' as shop;
import 'package:tauzero/features/shop/route/presentation/pages/route_detail_page.dart';


/// Главный экран с картой и кнопкой меню для торгового представителя
class SalesRepHomePage extends StatefulWidget {
  final shop.Route? selectedRoute; // Маршрут переданный из списка

  const SalesRepHomePage({
    super.key,
    this.selectedRoute,
  });

  @override
  State<SalesRepHomePage> createState() => _SalesRepHomePageState();
}

class _SalesRepHomePageState extends State<SalesRepHomePage> {
  final RouteRepository _routeRepository = GetIt.instance<RouteRepository>();
  
  shop.Route? _currentRoute;
  bool _isLoading = true;
  String? _error;
  bool _showRoutePanel = true;
  bool _hasLoadedInitialRoute = false; // Флаг для предотвращения повторной загрузки
  List<LatLng> _routePolylinePoints = [];
  bool _isBuildingRoute = false;

  @override
  void initState() {
    super.initState();
    _loadUserAndRoutes();
  }

  Future<void> _loadUserAndRoutes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Получаем текущую сессию приложения
      final sessionResult = await AppSessionService.getCurrentAppSession();
      if (sessionResult.isLeft()) {
        setState(() {
          _error = 'Не удалось получить сессию пользователя';
          _isLoading = false;
        });
        return;
      }

      final session = sessionResult.fold((l) => throw Exception(l), (r) => r);
      if (session == null) {
        setState(() {
          _error = 'Пользователь не найден в сессии';
          _isLoading = false;
        });
        return;
      }

      // Загружаем треки через Provider  
      final tracksProvider = Provider.of<UserTracksProvider>(context, listen: false);
      await tracksProvider.loadUserTracks(session.appUser);

      // Получаем маршруты пользователя через Employee
      _routeRepository.watchEmployeeRoutes(session.appUser.employee).listen(
        (routes) async {
          if (mounted) {
            final selectedRouteProvider = Provider.of<SelectedRouteProvider>(context, listen: false);
            
            shop.Route? routeToDisplay;
            
            // Загружаем сохраненный маршрут только при первой загрузке
            if (!_hasLoadedInitialRoute) {
              // Приоритет: переданный маршрут → сохраненный выбор → автоматический выбор
              if (widget.selectedRoute != null) {
                // 1. Если передан конкретный маршрут через параметр (высший приоритет)
                routeToDisplay = widget.selectedRoute!;
                await selectedRouteProvider.setSelectedRoute(routeToDisplay);
                print('📍 Установлен переданный маршрут: ${routeToDisplay.name}');
              } else {
                // 2. Попытаемся загрузить сохраненный выбор пользователя
                final savedRouteFound = await selectedRouteProvider.loadSavedSelection(routes);
                
                if (savedRouteFound && selectedRouteProvider.selectedRoute != null) {
                  // Используем сохраненный выбор пользователя
                  routeToDisplay = selectedRouteProvider.selectedRoute!;
                  print('📍 Восстановлен сохраненный маршрут: ${routeToDisplay.name}');
                } else {
                  // 3. Fallback: автоматический выбор активного или сегодняшнего маршрута
                  routeToDisplay = _findCurrentRoute(routes);
                  if (routeToDisplay != null) {
                    await selectedRouteProvider.setSelectedRoute(routeToDisplay);
                    print('📍 Автоматически выбран маршрут: ${routeToDisplay.name}');
                  }
                }
              }
              
              _hasLoadedInitialRoute = true; // Отмечаем что начальная загрузка завершена
            } else {
              // При последующих обновлениях используем уже выбранный маршрут
              routeToDisplay = selectedRouteProvider.selectedRoute ?? _currentRoute;
            }
            
            setState(() {
              _currentRoute = routeToDisplay;
              _isLoading = false;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _error = 'Ошибка загрузки маршрутов: $error';
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _error = 'Ошибка: $e';
        _isLoading = false;
      });
    }
  }

  shop.Route? _findCurrentRoute(List<shop.Route> routes) {
    // Ищем активный маршрут
    var activeRoute = routes.where((r) => r.status == shop.RouteStatus.active).firstOrNull;
    if (activeRoute != null) {
      return activeRoute;
    }
    
    // Ищем сегодняшний маршрут
    final today = DateTime.now();
    
    var todayRoute = routes.where((r) {
      if (r.startTime == null) return false;
      return r.startTime!.year == today.year &&
             r.startTime!.month == today.month &&
             r.startTime!.day == today.day;
    }).firstOrNull;
    
    if (todayRoute != null) {
      print('📌 Найден сегодняшний маршрут: ${todayRoute.name}');
      return todayRoute;
    }
    
    // Возвращаем первый доступный
    if (routes.isNotEmpty) {
      print('📌 Используем первый доступный маршрут: ${routes.first.name}');
      return routes.first;
    }
    
    print('❌ Маршруты не найдены');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Карта занимает весь экран
          _buildMapArea(),
          
          // Объединенная панель: кнопка меню + информация о маршруте
          if (!_isLoading && _currentRoute != null)
            _buildTopPanelWithMenu(),
          
          // Нижняя панель с навигацией по точкам (скрываемая)
          if (!_isLoading && _currentRoute != null && _showRoutePanel)
            _buildBottomPanel(),
          
          // Индикатор загрузки
          if (_isLoading)
            _buildLoadingOverlay(),
            
          // Сообщение об ошибке
          if (_error != null)
            _buildErrorOverlay(),
        ],
      )
    );
  }

  Widget _buildMapArea() {
    return Consumer2<SelectedRouteProvider, UserTracksProvider>(
      builder: (context, selectedRouteProvider, tracksProvider, child) {
        // Используем выбранный пользователем маршрут, если есть
        final routeToShow = selectedRouteProvider.selectedRoute ?? _currentRoute;
        
        // Получаем треки пользователя
        final routeTracks = tracksProvider.userTracks;
        
        return CombinedMapWidget(
          route: routeToShow,
          historicalTracks: routeTracks,
          onTap: (point) {
            // TODO: Обработка нажатия на карту
            print('Нажатие на карту: ${point.latitude}, ${point.longitude}');
          },
          routePolylinePoints: _routePolylinePoints,
        );
      },
    );
  }

  Widget _buildTopPanelWithMenu() {
    return Consumer<SelectedRouteProvider>(
      builder: (context, selectedRouteProvider, child) {
        // Используем выбранный пользователем маршрут, если есть
        final routeToShow = selectedRouteProvider.selectedRoute ?? _currentRoute;
        
        if (routeToShow == null) return const SizedBox.shrink();
        
        return Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                // Левая колонка - кнопка меню
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/menu');
                    },
                    icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                  ),
                ),
                
                // Правая колонка - информация о маршруте (кликабельная)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteDetailPage(route: routeToShow),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Название маршрута
                          Text(
                            routeToShow.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          // Статус и количество точек
                          Row(
                            children: [
                              Text(
                                _getRouteStatusText(routeToShow.status),
                                style: TextStyle(
                                  color: _getRouteStatusColor(routeToShow.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                ' • ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${routeToShow.pointsOfInterest.length} точек',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const Text(
                                ' • ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${_getCompletedCount()} выполнено',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Кнопка скрыть/показать нижнюю панель
                Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _showRoutePanel ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey.shade700,
                    ),
                    onPressed: () {
                      setState(() {
                        _showRoutePanel = !_showRoutePanel;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isBuildingRoute ? null : _buildRoute,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          child: _isBuildingRoute
              ? const CircularProgressIndicator()
              : const Text('Построить маршрут'),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Загрузка маршрута...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadUserAndRoutes,
                  child: const Text('Повторить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getRouteStatusColor(shop.RouteStatus status) {
    switch (status) {
      case shop.RouteStatus.planned:
        return Colors.blue;
      case shop.RouteStatus.active:
        return Colors.orange;
      case shop.RouteStatus.completed:
        return Colors.green;
      case shop.RouteStatus.cancelled:
        return Colors.red;
      case shop.RouteStatus.paused:
        return Colors.grey;
    }
  }

  String _getRouteStatusText(shop.RouteStatus status) {
    switch (status) {
      case shop.RouteStatus.planned:
        return 'Запланирован';
      case shop.RouteStatus.active:
        return 'Активный';
      case shop.RouteStatus.completed:
        return 'Завершен';
      case shop.RouteStatus.cancelled:
        return 'Отменен';
      case shop.RouteStatus.paused:
        return 'Приостановлен';
    }
  }

  int _getCompletedCount() {
    return _currentRoute!.pointsOfInterest
        .where((point) => point.isVisited)
        .length;
  }

  /// Построение маршрута через OSRM
  Future<void> _buildRoute() async {
    if (_currentRoute == null) return;
    
    print('🚀 Построение маршрута начато для ${_currentRoute!.pointsOfInterest.length} точек');
    
    setState(() {
      _isBuildingRoute = true;
    });

    try {
      final pathPredictionService = GetIt.instance<OsrmPathPredictionService>();
      
      // Находим последнюю завершенную точку (индекс начала маршрута)
      int lastCompletedIndex = -1;
      for (int i = 0; i < _currentRoute!.pointsOfInterest.length; i++) {
        if (_currentRoute!.pointsOfInterest[i].status == VisitStatus.completed) {
          lastCompletedIndex = i;
        }
      }
      
      // Если есть завершенные точки, начинаем с последней завершенной
      // Иначе начинаем с первой точки
      final startIndex = lastCompletedIndex >= 0 ? lastCompletedIndex : 0;
      final routePoints = _currentRoute!.pointsOfInterest.sublist(startIndex);
      
      if (routePoints.length < 2) {
        print('⚠️ Недостаточно точек для построения маршрута (нужно минимум 2, есть ${routePoints.length})');
        return;
      }

      print('🎯 Строим маршрут от точки ${startIndex + 1} до конца: ${routePoints.length} точек');

      // Преобразуем в MapPoint для OSRM сервиса
      final mapPoints = routePoints.map((poi) => MapPoint(
        latitude: poi.coordinates.latitude,
        longitude: poi.coordinates.longitude,
      )).toList();

      // Вызываем OSRM сервис
      final result = await pathPredictionService.predictRouteGeometry(mapPoints);
      
      if (result.routePoints.isNotEmpty) {
        final polylinePoints = result.routePoints.map((point) => 
          LatLng(point.latitude, point.longitude)
        ).toList();
        
        setState(() {
          _routePolylinePoints = polylinePoints;
        });
        
        print('✅ Маршрут построен успешно: ${polylinePoints.length} точек');
      } else {
        print('❌ OSRM вернул пустой результат');
      }
    } catch (e) {
      print('❌ Ошибка построения маршрута: $e');
    } finally {
      setState(() {
        _isBuildingRoute = false;
      });
    }
  }
}