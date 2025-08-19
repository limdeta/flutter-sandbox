# Dev Fixture System

Система для создания реалистичных тестовых данных для разработки и тестирования.

## 🎯 Цель

Обеспечить разработчиков максимально приближенными к реальности данными для:
- Тестирования UI/UX
- Демонстрации функционала
- Отладки бизнес-логики
- Интеграционного тестирования

## 🏗️ Архитектура

### Feature-First подход
```
lib/
├── features/
│   ├── authentication/
│   │   └── data/fixtures/user_fixture_service.dart
│   └── route/
│       └── data/fixtures/route_fixture_service.dart
└── shared/
    └── fixtures/
        ├── dev_fixture_orchestrator.dart     # Центральный координатор
        ├── dev_fixture_bootstrap.dart        # Точка входа
        └── main_integration_example.dart     # Примеры интеграции
```

### Принцип "LEGO кубиков"
- Каждый feature имеет свой FixtureService
- Центральный Orchestrator координирует создание связанных данных
- Bootstrap обеспечивает простой API для запуска

## 📊 Создаваемые данные

### Пользователи
- **1 Администратор**: Админов Александр Администраторович
- **1 Менеджер**: Менеджеров Михаил Михайлович  
- **3 Курьера**: 
  - Алексей Курьеров
  - Мария Доставкина
  - Иван Быстров

### Маршруты (для каждого курьера)
- **Вчерашний маршрут**: почти полностью завершен (реальная картина)
- **Сегодняшний маршрут**: в процессе выполнения (текущая работа)

Каждый маршрут содержит:
- Склад (начальная точка)
- 4-6 торговых точек
- Обеденный перерыв
- Реалистичные временные метки
- Заметки и статусы

## 🚀 Использование

### Вариант 1: Отдельный скрипт (рекомендуется)
```bash
# В корне проекта
dart run dev.dart
```

### Вариант 2: В main.dart
```dart
import 'package:flutter/foundation.dart';
import 'package:tauzero/shared/fixtures/dev_fixture_bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация DI, БД и т.д.
  
  // 🔧 DEV ONLY: Создаем тестовые данные
  if (kDebugMode) {
    await DevFixtureBootstrap.initializeDevData();
  }
  
  runApp(MyApp());
}
```

### Вариант 3: Только пользователи
```dart
await DevFixtureBootstrap.initializeUsersOnly();
```

## 🔧 API

### DevFixtureBootstrap
- `initializeDevData()` - полная инициализация (пользователи + маршруты)
- `initializeUsersOnly()` - только пользователи
- `showDevInfo()` - справочная информация

### DevFixtureOrchestrator
- `createFullDevDataset()` - создает все данные
- `createUsersOnly()` - только пользователи
- `createRoutesForExistingUsers()` - маршруты для существующих курьеров

## 📝 Добавление новых фикстур

### 1. Создать FixtureService для feature
```dart
// lib/features/orders/data/fixtures/order_fixture_service.dart
class OrderFixtureService {
  Future<void> createDevFixtures(User user) async {
    // Создание заказов для пользователя
  }
}
```

### 2. Интегрировать в Orchestrator
```dart
class DevFixtureOrchestrator {
  final OrderFixtureService _orderFixtureService;
  
  Future<void> createFullDevDataset() async {
    // ... создание пользователей и маршрутов
    
    // Создаем заказы
    await _createOrdersForUsers(users);
  }
}
```

## 🧹 Очистка данных

Система автоматически очищает старые dev данные по паттернам:
- externalId содержит `@tauzero.dev`
- Фамилии: Админов, Менеджеров, Курьеров, Доставкина, Быстров
- Префиксы: `admin_`, `manager_`

## 🔒 Безопасность

- Работает только в Debug режиме
- Использует отдельные dev пароли
- Легко отключается для production

## 🎨 Преимущества

1. **Реалистичность**: данные максимально приближены к реальным
2. **Связанность**: все данные логически связаны между собой
3. **Воспроизводимость**: каждый запуск создает одинаковые данные
4. **Модульность**: легко добавлять новые типы фикстур
5. **Безопасность**: отделено от production данных

## 🚨 Важные замечания

- Не используйте в production!
- Система очищает старые dev данные при каждом запуске
- Все пароли в dev режиме - фиктивные
- Координаты привязаны к Владивостоку (можно изменить)

## 🛠️ Настройка

Для изменения базовых данных отредактируйте:
- `UserFixtureService` - пользователи и роли
- `RouteFixtureService` - маршруты и точки
- Координаты и временные зоны в фабриках

---

**Результат**: полноценное приложение с реалистичными данными за один запуск! 🎉
