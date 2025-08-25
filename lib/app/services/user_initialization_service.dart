import 'package:get_it/get_it.dart';
import '../../../features/authentication/domain/entities/user.dart';
import 'user_preferences_service.dart';

/// Сервис для инициализации пользовательских настроек после аутентификации
/// 
/// Этот сервис:
/// - Инициализирует UserPreferencesService если он еще не готов
/// - Загружает пользовательские настройки для конкретного пользователя
/// - Обеспечивает что настройки доступны во всем приложении
class UserInitializationService {
  static bool _isInitialized = false;
  static User? _currentUser;

  static Future<void> initializeUserSettings(User user) async {
    try {
      UserPreferencesService? preferencesService;
      try {
        if (GetIt.instance.isRegistered<UserPreferencesService>()) {
          preferencesService = GetIt.instance<UserPreferencesService>();
        } else {
          preferencesService = UserPreferencesService();
          await preferencesService.initialize();
          GetIt.instance.registerSingleton<UserPreferencesService>(preferencesService);
        }
      } catch (e) {
        preferencesService = await GetIt.instance.getAsync<UserPreferencesService>();
      }
      
      // 2. Сохраняем информацию о текущем пользователе
      _currentUser = user;
      _isInitialized = true;
      
      await _loadUserSpecificSettings(user, preferencesService);

    } catch (e) {
      print('❌ Ошибка инициализации настроек пользователя: $e');
    }
  }
  
  static Future<void> _loadUserSpecificSettings(User user, UserPreferencesService preferencesService) async {
    // Здесь можно загрузить настройки специфичные для пользователя
    // Например:
    // - Последний выбранный маршрут
    // - Персональные настройки UI
    // - Предпочитаемые настройки карты
    
    // Для примера - установим настройки по умолчанию если их нет
    if (preferencesService.getSelectedRouteId() == null) {
      print('📍 Первый запуск - настройки маршрута будут установлены при выборе');
    }

    final isDarkTheme = preferencesService.getDarkTheme();
    final fontSize = preferencesService.getFontSize();
    
    print('🎨 Пользовательские настройки: тема=${isDarkTheme ? "темная" : "светлая"}, шрифт=${fontSize}px');
  }
  
  /// Очищает пользовательские настройки (при выходе)
  static Future<void> clearUserSettings() async {
    try {
      print('🧹 Очищаем пользовательские настройки...');
      
      if (GetIt.instance.isRegistered<UserPreferencesService>()) {
        // final preferencesService = GetIt.instance<UserPreferencesService>();
        // Можно очистить только UI настройки, оставив пользовательские данные
        // await preferencesService.clearUIPreferences();
        
        // Или очистить все (если пользователь выходит полностью)
        // await preferencesService.clearAllPreferences();
      }
      
      _currentUser = null;
      _isInitialized = false;
      
      print('✅ Настройки очищены');
    } catch (e) {
      print('❌ Ошибка очистки настроек: $e');
    }
  }
  
  /// Проверяет инициализированы ли настройки
  static bool get isInitialized => _isInitialized;
  
  /// Получает текущего пользователя
  static User? get currentUser => _currentUser;
  
  /// Получает сервис настроек (если доступен)
  static UserPreferencesService? getPreferencesService() {
    try {
      if (GetIt.instance.isRegistered<UserPreferencesService>()) {
        return GetIt.instance<UserPreferencesService>();
      }
    } catch (e) {
      print('⚠️ UserPreferencesService не доступен: $e');
    }
    return null;
  }
}
