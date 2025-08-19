import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tauzero/features/authentication/domain/entities/user.dart';
import 'package:tauzero/features/authentication/domain/repositories/iuser_repository.dart';

import '../../../route/domain/entities/route.dart' as domain;
import '../../../route/domain/entities/ipoint_of_interest.dart';
import '../../../route/domain/repositories/iroute_repository.dart';
import '../../../route/data/di/route_di.dart';

/// Административная панель для мониторинга пользователей и маршрутов
/// 
/// Функции:
/// - 👥 Просмотр всех пользователей системы
/// - 📊 Мониторинг маршрутов в реальном времени  
/// - 📈 Аналитика по завершенности маршрутов
/// - ⚠️ Выявление проблемных маршрутов
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late IRouteRepository _routeRepository;
  late IUserRepository _userRepository;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Инициализируем DI если еще не инициализирован
    if (!GetIt.instance.isRegistered<IRouteRepository>()) {
      RouteDI.registerDependencies();
    }
    
    _routeRepository = GetIt.instance<IRouteRepository>();
    _userRepository = GetIt.instance<IUserRepository>();
    _loadUsers();
  }

  // Загружаем пользователей из настоящего репозитория
  Future<void> _loadUsers() async {
    final result = await _userRepository.getAllUsers();
    result.fold(
      (failure) {
        // Ошибка загрузки пользователей
        print('Ошибка загрузки пользователей: ${failure.message}');
      },
      (users) => setState(() {
        _users = users;
      }),
    );
  }
  
  // Получаем пользователей из настоящего репозитория
  List<User> get _Users {
    return _users; // Возвращаем пользователей как есть из репозитория
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Admin Dashboard'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Обзор'),
            Tab(icon: Icon(Icons.people), text: 'Пользователи'),
            Tab(icon: Icon(Icons.route), text: 'Маршруты'),
            Tab(icon: Icon(Icons.settings), text: 'Управление'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildUsersTab(),
          _buildRoutesTab(),
          _buildManagementTab(),
        ],
      ),
    );
  }

  /// Вкладка "Обзор" - общая статистика
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            children: [
              Icon(Icons.dashboard, color: Colors.blue[800], size: 28),
              const SizedBox(width: 12),
              const Text(
                'Общий обзор системы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Карточки с основными метриками
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                title: 'Активных пользователей',
                value: '${_Users.length}',
                icon: Icons.people,
                color: Colors.green,
              ),
              _buildMetricCard(
                title: 'Маршрутов сегодня',
                value: '0', // Будет обновляться динамически
                icon: Icons.route,
                color: Colors.blue,
              ),
              _buildMetricCard(
                title: 'Завершенность',
                value: '0%', // Будет обновляться динамически  
                icon: Icons.check_circle,
                color: Colors.orange,
              ),
              _buildMetricCard(
                title: 'Проблемных маршрутов',
                value: '0', // Будет обновляться динамически
                icon: Icons.warning,
                color: Colors.red,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Быстрые действия
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚡ Быстрые действия',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showSystemInfo(),
                        icon: const Icon(Icons.info),
                        label: const Text('Системная информация'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Вкладка "Пользователи" - управление пользователями
  Widget _buildUsersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            children: [
              Icon(Icons.people, color: Colors.blue[800], size: 28),
              const SizedBox(width: 12),
              const Text(
                'Управление пользователями',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Список пользователей
          ...(_Users.map((user) => _buildUserCard(user)).toList()),
        ],
      ),
    );
  }

  /// Вкладка "Маршруты" - мониторинг всех маршрутов
  Widget _buildRoutesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            children: [
              Icon(Icons.route, color: Colors.blue[800], size: 28),
              const SizedBox(width: 12),
              const Text(
                'Мониторинг маршрутов',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Маршруты по пользователям
          ...(_Users.map((user) => _buildUserRoutesSection(user)).toList()),
        ],
      ),
    );
  }

  /// Вкладка "Управление" - административные функции
  Widget _buildManagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            children: [
              Icon(Icons.settings, color: Colors.blue[800], size: 28),
              const SizedBox(width: 12),
              const Text(
                'Системное управление',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Управление фикстурами
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔧 Управление тестовыми данными',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Создавайте реалистичные тестовые данные для всех пользователей системы.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: _Users.map((user) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(user.fullName.substring(0, 1)),
                      ),
                      title: Text(user.fullName),
                      subtitle: Text('${user.role} •}'),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Экспорт данных
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📤 Экспорт и аналитика',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _exportAllData,
                        icon: const Icon(Icons.download),
                        label: const Text('Экспорт всех данных'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _generateReport,
                        icon: const Icon(Icons.analytics),
                        label: const Text('Сформировать отчет'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Создает карточку метрики
  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Создает карточку пользователя
  Widget _buildUserCard(User user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(user.fullName.substring(0, 1)),
        ),
        title: Text(user.fullName),
            children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${user.externalId}'),
                const SizedBox(height: 8),
                Text('Роль: ${user.role}'),
                const SizedBox(height: 8),
                
                // Статистика пользователя (будет динамической)
                FutureBuilder<List<domain.Route>>(
                  future: _routeRepository.watchUserRoutes(user).first,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final routes = snapshot.data!;
                      final completedRoutes = routes.where((r) => r.isCompleted).length;
                      final activeRoutes = routes.where((r) => r.isActive).length;
                      final averageCompletion = routes.isEmpty ? 0.0 :
                          routes.map((r) => r.completionPercentage).reduce((a, b) => a + b) / routes.length;
                      
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildUserStat('Всего маршрутов', '${routes.length}'),
                              _buildUserStat('Завершено', '$completedRoutes'),
                              _buildUserStat('Активных', '$activeRoutes'),
                              _buildUserStat('Ср. завершенность', '${(averageCompletion * 100).toStringAsFixed(0)}%'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _viewUserRoutes(user),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[100],
                                    foregroundColor: Colors.blue[800],
                                  ),
                                  child: const Text('Просмотр маршрутов'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Создает статистику пользователя
  Widget _buildUserStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Создает секцию маршрутов пользователя
  Widget _buildUserRoutesSection(User user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👤 ${user.fullName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            
            StreamBuilder<List<domain.Route>>(
              stream: _routeRepository.watchUserRoutes(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Text('Ошибка: ${snapshot.error}');
                }
                
                final routes = snapshot.data ?? [];
                
                if (routes.isEmpty) {
                  return const Text(
                    'Нет маршрутов. Создайте фикстуры для демонстрации.',
                    style: TextStyle(color: Colors.grey),
                  );
                }
                
                return Column(
                  children: routes.map((route) => _buildRouteCard(route, user)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Создает карточку маршрута
  Widget _buildRouteCard(domain.Route route, User user) {
    final statusColor = _getRouteStatusColor(route.status);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Text(route.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Статус: ${route.status.name}'),
            Text('Завершенность: ${(route.completionPercentage * 100).toStringAsFixed(1)}%'),
            Text('Точек: ${route.pointsOfInterest.length}'),
            if (route.isProblematic)
              const Text(
                '⚠️ Проблемный маршрут',
                style: TextStyle(color: Colors.orange),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'details',
              child: const Text('Подробности'),
              onTap: () => _showRouteDetails(route, user),
            ),
            PopupMenuItem(
              value: 'map',
              child: const Text('Показать на карте'),
              onTap: () => _showRouteOnMap(route),
            ),
          ],
        ),
      ),
    );
  }

  /// Возвращает цвет для статуса маршрута
  Color _getRouteStatusColor(domain.RouteStatus status) {
    switch (status) {
      case domain.RouteStatus.planned:
        return Colors.grey;
      case domain.RouteStatus.active:
        return Colors.blue;
      case domain.RouteStatus.completed:
        return Colors.green;
      case domain.RouteStatus.cancelled:
        return Colors.red;
      case domain.RouteStatus.paused:
        return Colors.orange;
    }
  }

  // =====================================================
  // ДЕЙСТВИЯ И ОБРАБОТЧИКИ
  // =====================================================

  /// Показывает системную информацию
  void _showSystemInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Системная информация'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🏗️ Architecture: Clean Architecture'),
            Text('🗄️ Database: Drift (SQLite)'),
            Text('🔄 State: Reactive Streams'),
            Text('🧪 Environment: Development'),
            Text('👥 Users: Test fixtures'),
            Text('📱 Platform: Flutter'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Просматривает маршруты пользователя
  void _viewUserRoutes(User user) {
    // TODO: Навигация к детальному просмотру маршрутов пользователя
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Просмотр маршрутов ${user.fullName} (TODO)')),
    );
  }

  /// Показывает детали маршрута
  void _showRouteDetails(domain.Route route, User user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 400,
          height: 600,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📋 ${route.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('👤 Пользователь: ${user.fullName}'),
              Text('📅 Создан: ${route.createdAt.toString().substring(0, 16)}'),
              Text('🔄 Статус: ${route.status.name}'),
              Text('📊 Завершенность: ${(route.completionPercentage * 100).toStringAsFixed(1)}%'),
              if (route.description != null)
                Text('📝 Описание: ${route.description}'),
              const SizedBox(height: 16),
              const Text(
                'Точки маршрута:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: route.pointsOfInterest.length,
                  itemBuilder: (context, index) {
                    final point = route.pointsOfInterest[index];
                    return ListTile(
                      leading: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getPointStatusColor(point.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      title: Text(point.name),
                      subtitle: Text('${point.status.name} • ${point.type.name}'),
                      dense: true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Закрыть'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Возвращает цвет для статуса точки
  Color _getPointStatusColor(VisitStatus status) {
    switch (status) {
      case VisitStatus.planned:
        return Colors.grey;
      case VisitStatus.enRoute:
        return Colors.blue;
      case VisitStatus.arrived:
        return Colors.orange;
      case VisitStatus.completed:
        return Colors.green;
      case VisitStatus.skipped:
        return Colors.red;
    }
  }

  /// Показывает маршрут на карте
  void _showRouteOnMap(domain.Route route) {
    // TODO: Навигация к карте с маршрутом
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Показать маршрут "${route.name}" на карте (TODO)')),
    );
  }

  /// Экспортирует все данные
  void _exportAllData() {
    // TODO: Реализовать экспорт данных
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Экспорт данных (TODO)')),
    );
  }

  /// Генерирует отчет
  void _generateReport() {
    // TODO: Реализовать генерацию отчетов
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Генерация отчета (TODO)')),
    );
  }
}