import 'package:flutter/material.dart';

/// Элемент меню
class MenuItem {
  final String title;
  final IconData icon;
  final String? route;
  final List<MenuItem>? subItems;
  
  const MenuItem({
    required this.title,
    required this.icon,
    this.route,
    this.subItems,
  });
}

/// Главное меню приложения для торгового представителя
class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final Set<String> _expandedItems = {};

  /// Структура меню
  final List<MenuItem> _menuItems = const [
    MenuItem(
      title: 'Маршруты',
      icon: Icons.route,
      route: '/routes',
    ),
    MenuItem(
      title: 'Товары',
      icon: Icons.inventory,
      subItems: [
        MenuItem(
          title: 'Каталог',
          icon: Icons.list,
          route: '/products/catalog',
        ),
        MenuItem(
          title: 'Категории прайса',
          icon: Icons.category,
          route: '/products/categories',
        ),
        MenuItem(
          title: 'Акции',
          icon: Icons.local_offer,
          route: '/products/promotions',
        ),
      ],
    ),
    MenuItem(
      title: 'Торговые Точки',
      icon: Icons.store,
      route: '/outlets',
    ),
    MenuItem(
      title: 'Заказы Агента',
      icon: Icons.assignment,
      route: '/agent-orders',
    ),
    MenuItem(
      title: 'Заказы пользователя',
      icon: Icons.shopping_cart,
      route: '/user-orders',
    ),
    MenuItem(
      title: 'Отправка Данных',
      icon: Icons.cloud_upload,
      route: '/data-sync',
    ),
    MenuItem(
      title: 'Профиль агента',
      icon: Icons.person,
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главное меню'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/sales-home');
          },
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return _buildMenuItem(item);
        },
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    final hasSubItems = item.subItems != null && item.subItems!.isNotEmpty;
    final isExpanded = _expandedItems.contains(item.title);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              item.icon,
              color: Colors.blue,
              size: 28,
            ),
            title: Text(
              item.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: hasSubItems
                ? Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
            onTap: () {
              if (hasSubItems) {
                _toggleExpansion(item.title);
              } else {
                _navigateToItem(item);
              }
            },
          ),
          if (hasSubItems && isExpanded) _buildSubMenu(item.subItems!),
        ],
      ),
    );
  }

  Widget _buildSubMenu(List<MenuItem> subItems) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: subItems.map((subItem) {
          return ListTile(
            contentPadding: const EdgeInsets.only(left: 56, right: 16),
            leading: Icon(
              subItem.icon,
              color: Colors.blue[300],
              size: 24,
            ),
            title: Text(
              subItem.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 14,
            ),
            onTap: () => _navigateToItem(subItem),
          );
        }).toList(),
      ),
    );
  }

  void _toggleExpansion(String itemTitle) {
    setState(() {
      if (_expandedItems.contains(itemTitle)) {
        _expandedItems.remove(itemTitle);
      } else {
        _expandedItems.add(itemTitle);
      }
    });
  }

  void _navigateToItem(MenuItem item) {
    if (item.route != null) {
      // Обрабатываем навигацию в зависимости от типа пункта меню
      if (item.route == '/routes') {
        // Для маршрутов открываем список маршрутов
        Navigator.pushNamed(context, '/routes');
      } else {
        // Для остальных функций показываем что они работают через главную карту
        Navigator.pushReplacementNamed(context, '/sales-home');
        
        // Показываем snackbar для обратной связи
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} - работает через главную карту'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
