import 'dev_fixture_orchestrator.dart';

/// Централизованный сервис для создания реалистичной симуляции рабочих данных
/// Автоматически наполняет приложение данными при запуске в dev режиме
/// Использует только настоящие репозитории и сервисы через фикстуры
class DevDataSimulator {
  static bool _isInitialized = false;

  static Future<void> initializeDevData() async {
    if (_isInitialized) return;

    try {
      // Используем оркестратор для создания всех dev данных
      final orchestrator = DevFixtureOrchestratorFactory.create();
      final result = await orchestrator.createFullDevDataset();
      
      if (result.success) {
        print('✅ Dev данные успешно инициализированы через настоящие репозитории');
        print('👥 Создано пользователей: ${result.users.length}');
        print('� Маршруты созданы для ${result.users.salesReps.length} торговых представителей');
      } else {
        print('❌ Ошибка создания dev данных: ${result.message}');
      }

      _isInitialized = true;
      
    } catch (e) {
      print('❌ Ошибка инициализации dev данных: $e');
    }
  }

  static bool get isInitialized => _isInitialized;
  
  static void reset() {
    _isInitialized = false;
  }
}
