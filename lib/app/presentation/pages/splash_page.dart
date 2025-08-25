import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../features/authentication/domain/usecases/get_current_session_usecase.dart';
import '../../services/user_initialization_service.dart';

/// Экран загрузки с проверкой сессии
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    // Небольшая задержка для splash эффекта
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    try {
      final getCurrentSession = GetIt.instance<GetCurrentSessionUseCase>();
      final result = await getCurrentSession.call();
      
      if (mounted) {
        result.fold(
          (failure) {
            // Ошибка получения сессии - идем на логин
            Navigator.of(context).pushReplacementNamed('/login');
          },
          (session) async {
            if (session != null && session.isValid) {
              // Есть валидная сессия - инициализируем настройки пользователя
              await UserInitializationService.initializeUserSettings(session.user);
              
              // Переходим на главную
              Navigator.of(context).pushReplacementNamed('/home');
            } else {
              // Нет сессии или она истекла - идем на логин
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
        );
      }
    } catch (e) {
      if (mounted) {
        // При любой ошибке идем на логин
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Логотип приложения
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.business_center,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            
            // Название приложения
            Text(
              'TauZero',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            
            // Подзаголовок
            Text(
              'Система для торговых представителей',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            // Индикатор загрузки
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            
            const Text(
              'Проверка сессии...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
