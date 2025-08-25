import 'package:flutter/material.dart';
import '../../../features/authentication/presentation/widgets/authentication_widget.dart';
import '../../../features/authentication/domain/entities/user.dart';
import '../../services/user_initialization_service.dart';
import '../../services/app_session_service.dart';

/// Страница входа в систему (App-уровень)
/// 
/// Ответственности:
/// - Использует AuthenticationWidget из модуля authentication
/// - Обрабатывает результат аутентификации
/// - Создает AppSession и AppUser
/// - Выполняет навигацию по ролям
/// - Инициализирует глобальное состояние приложения
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  /// Обработчик успешной аутентификации
  Future<void> _handleAuthSuccess(User securityUser) async {
    try {
      // 1. Создаем AppSession из security user
      final appSessionResult = await AppSessionService.createFromSecurityUser(securityUser);
      
      if (appSessionResult.isLeft()) {
        final error = appSessionResult.fold((l) => l.message, (r) => 'Unknown error');
        _handleAuthError('Ошибка создания сессии: $error');
        return;
      }
      
      final appSession = appSessionResult.fold((l) => null, (r) => r)!;
      
      // 2. Инициализируем настройки пользователя
      await UserInitializationService.initializeUserSettings(securityUser);
      
      // 3. Навигация в зависимости от роли
      if (mounted) {
        _navigateByUserRole(appSession.appUser.role);
      }
    } catch (e) {
      if (mounted) {
        _handleAuthError('Ошибка инициализации: $e');
      }
    }
  }

  /// Обработчик ошибки аутентификации
  void _handleAuthError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _navigateByUserRole(UserRole role) {
    String targetRoute;
    switch (role) {
      case UserRole.admin:
        targetRoute = '/admin';
        break;
      case UserRole.manager:
        targetRoute = '/home';
        break;
      case UserRole.user:
        targetRoute = '/sales-home';
        break;
    }
    
    Navigator.of(context).pushReplacementNamed(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход в TauZero'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: AuthenticationWidget(
          initialPhone: '+7-999-111-2233',
          initialPassword: 'password123',
          showTestData: true,
          onSuccess: _handleAuthSuccess,
          onError: _handleAuthError,
        ),
      ),
    );
  }
}
