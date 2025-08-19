import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../route/domain/entities/route.dart' as domain;
import '../../../route/domain/repositories/iroute_repository.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../authentication/domain/repositories/iuser_repository.dart';
import '../../../authentication/domain/usecases/get_current_session_usecase.dart';
import '../../../route/presentation/pages/route_detail_page.dart';
import '../../../map/presentation/widgets/map_widget.dart';
import '../../../tracking/domain/repositories/iuser_track_repository.dart';
import '../../../tracking/domain/entities/user_track.dart';
import '../../../../shared/providers/selected_route_provider.dart';

/// Главный экран с картой и кнопкой меню для торгового представителя
class SalesRepHomePage extends StatefulWidget {
  final domain.Route? selectedRoute; // Маршрут переданный из списка

  const SalesRepHomePage({
    super.key,
    this.selectedRoute,
  });

  @override
  State<SalesRepHomePage> createState() => _SalesRepHomePageState();
}

class _SalesRepHomePageState extends State<SalesRepHomePage> {
  final IRouteRepository _routeRepository = GetIt.instance<IRouteRepository>();
  final GetCurrentSessionUseCase _getCurrentSessionUseCase = GetIt.instance<GetCurrentSessionUseCase>();
  final IUserTrackRepository _trackRepository = GetIt.instance<IUserTrackRepository>();
  
  User? _currentUser;
  domain.Route? _currentRoute;
  List<UserTrack> _historicalTracks = [];
  bool _isLoading = true;
  String? _error;
  bool _showRoutePanel = true;
  bool _hasLoadedInitialRoute = false; // Флаг для предотвращения повторной загрузки

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

      // Получаем текущего пользователя
      final sessionResult = await _getCurrentSessionUseCase.call();
      if (sessionResult.isLeft()) {
        setState(() {
          _error = 'Не удалось получить сессию пользователя';
          _isLoading = false;
        });
        return;
      }

      final session = sessionResult.fold((l) => throw Exception(l), (r) => r);
      _currentUser = session?.user;

      if (_currentUser == null) {
        setState(() {
          _error = 'Пользователь не найден в сессии';
          _isLoading = false;
        });
        return;
      }

      // Загружаем исторические треки пользователя
      await _loadHistoricalTracks();

      // Получаем маршруты пользователя
      _routeRepository.watchUserRoutes(_currentUser!).listen(
        (routes) async {
          if (mounted) {
            final selectedRouteProvider = Provider.of<SelectedRouteProvider>(context, listen: false);
            
            domain.Route? routeToDisplay;
            
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

  /// Загружает исторические треки пользователя
  Future<void> _loadHistoricalTracks() async {
    if (_currentUser == null) return;
    
    try {
      // Получаем репозиторий пользователей для получения внутреннего ID
      final userRepository = GetIt.instance<IUserRepository>();
      final usersResult = await userRepository.getAllUsers();
      
      if (usersResult.isLeft()) {
        print('❌ Не удалось получить пользователей из БД: ${usersResult.fold((l) => l, (r) => '')}');
        return;
      }
      
      final allUsers = usersResult.fold((l) => <User>[], (r) => r);
      final dbUser = allUsers.where((u) => u.externalId == _currentUser!.externalId).firstOrNull;
      
      if (dbUser == null) {
        print('❌ Пользователь ${_currentUser!.firstName} не найден в БД');
        return;
      }
      
      // Получаем внутренний userId (предполагаем что это порядковый номер в списке + 1)
      final userId = allUsers.indexOf(dbUser) + 1;
      
      final tracks = await _trackRepository.getTracksByUserId(userId);
      if (mounted) {
        setState(() {
          _historicalTracks = tracks;
        });
        print('📊 Загружено ${tracks.length} исторических треков для пользователя ${_currentUser!.firstName} (userId: $userId)');
      }
    } catch (e) {
      print('❌ Ошибка загрузки треков: $e');
    }
  }

  domain.Route? _findCurrentRoute(List<domain.Route> routes) {
    // Ищем активный маршрут
    var activeRoute = routes.where((r) => r.status == domain.RouteStatus.active).firstOrNull;
    if (activeRoute != null) return activeRoute;
    
    // Ищем сегодняшний маршрут
    final today = DateTime.now();
    var todayRoute = routes.where((r) {
      return r.startTime != null && 
             r.startTime!.year == today.year &&
             r.startTime!.month == today.month &&
             r.startTime!.day == today.day;
    }).firstOrNull;
    if (todayRoute != null) return todayRoute;
    
    // Возвращаем первый доступный
    return routes.isNotEmpty ? routes.first : null;
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
      ),
    );
  }

  Widget _buildMapArea() {
    return Consumer<SelectedRouteProvider>(
      builder: (context, selectedRouteProvider, child) {
        // Используем выбранный пользователем маршрут, если есть
        final routeToShow = selectedRouteProvider.selectedRoute ?? _currentRoute;
        
        // Фильтруем треки для текущего маршрута, если он выбран
        final filteredTracks = routeToShow != null && routeToShow.id != null
            ? _historicalTracks.where((track) => track.routeId == routeToShow.id).toList()
            : _historicalTracks;
        
        return MapWidget(
          route: routeToShow,
          historicalTracks: filteredTracks, // Передаем треки напрямую в MapWidget
          onTap: (point) {
            // TODO: Обработка нажатия на карту
            print('Нажатие на карту: ${point.latitude}, ${point.longitude}');
          },
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
    final currentPoint = _currentRoute!.currentPoint;
    final currentIndex = currentPoint != null 
        ? _currentRoute!.pointsOfInterest.indexOf(currentPoint)
        : 0;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Прогресс бар
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _currentRoute!.completionPercentage,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getRouteStatusColor(_currentRoute!.status),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(_currentRoute!.completionPercentage * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Навигация по точкам
              if (currentPoint != null) ...[
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: currentIndex > 0 ? () {
                        // TODO: Переход к предыдущей точке
                      } : null,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${currentIndex + 1} из ${_currentRoute!.pointsOfInterest.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            currentPoint.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: currentIndex < _currentRoute!.pointsOfInterest.length - 1 ? () {
                        // TODO: Переход к следующей точке
                      } : null,
                    ),
                  ],
                ),
              ] else ...[
                const Text(
                  'Все точки маршрута выполнены',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ],
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

  Color _getRouteStatusColor(domain.RouteStatus status) {
    switch (status) {
      case domain.RouteStatus.planned:
        return Colors.blue;
      case domain.RouteStatus.active:
        return Colors.orange;
      case domain.RouteStatus.completed:
        return Colors.green;
      case domain.RouteStatus.cancelled:
        return Colors.red;
      case domain.RouteStatus.paused:
        return Colors.grey;
    }
  }

  String _getRouteStatusText(domain.RouteStatus status) {
    switch (status) {
      case domain.RouteStatus.planned:
        return 'Запланирован';
      case domain.RouteStatus.active:
        return 'Активный';
      case domain.RouteStatus.completed:
        return 'Завершен';
      case domain.RouteStatus.cancelled:
        return 'Отменен';
      case domain.RouteStatus.paused:
        return 'Приостановлен';
    }
  }

  int _getCompletedCount() {
    return _currentRoute!.pointsOfInterest
        .where((point) => point.isVisited)
        .length;
  }
}
