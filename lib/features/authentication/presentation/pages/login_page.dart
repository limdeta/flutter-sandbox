import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../shared/services/user_initialization_service.dart';

/// Страница входа в систему
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Предзаполняем для тестирования - "Алексей Торговый" (торговый представитель)
    _phoneController.text = '+7-999-111-2233';
    _passwordController.text = 'password123';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final loginUseCase = GetIt.instance<LoginUseCase>();
      
      final result = await loginUseCase.call(
        phoneString: _phoneController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (mounted) {
        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: Colors.red,
              ),
            );
          },
          (session) async {
            // Инициализируем настройки пользователя после успешного логина
            await UserInitializationService.initializeUserSettings(session.user);
            
            // Определяем куда переходить в зависимости от роли пользователя
            final user = session.user;
            
            String targetRoute;
            if (user.role == UserRole.admin) {
              targetRoute = '/admin';
            } else if (user.role == UserRole.manager) {
              targetRoute = '/home'; // Менеджеры пока на старый главный экран
            } else {
              // Торговые представители (user role) переходят на новый экран с картой
              targetRoute = '/sales-home';
            }
            
            Navigator.of(context).pushReplacementNamed(targetRoute);
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.person_outline,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              
              // Поле для номера телефона
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Номер телефона',
                  hintText: '+7 999 123 45 67',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите номер телефона';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Поле для пароля
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите пароль';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Чекбокс "Запомнить меня"
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() => _rememberMe = value ?? false);
                    },
                  ),
                  const Text('Запомнить меня'),
                ],
              ),
              const SizedBox(height: 32),
              
              // Кнопка входа
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Войти'),
                ),
              ),
              const SizedBox(height: 16),
              
              // Информация для тестирования
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Тестовые данные:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text('Телефон: +7-999-111-2233 (Алексей Торговый)'),
                      const Text('Пароль: password123'),
                      const SizedBox(height: 8),
                      const Text('Другие тестовые пользователи:'),
                      const Text('• +7-999-444-5566 - Мария Продажкина (торговый представитель)'),
                      const Text('• +7-999-000-0001 - Александр Админов (администратор)'),
                      const Text('• +7-999-000-0002 - Михаил Менеджеров (менеджер)'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
