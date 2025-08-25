import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

/// Независимый виджет аутентификации
/// 
/// Особенности:
/// - Не знает про AppSession, навигацию, инициализацию
/// - Работает только с User из authentication модуля
/// - Полностью переиспользуемый компонент
/// - Вся app-логика делегируется через колбэки
class AuthenticationWidget extends StatefulWidget {
  final Function(User user) onSuccess;
  final Function(String message) onError;
  final String? initialPhone;
  final String? initialPassword;
  final bool showTestData;
  
  const AuthenticationWidget({
    super.key,
    required this.onSuccess,
    required this.onError,
    this.initialPhone,
    this.initialPassword,
    this.showTestData = false,
  });

  @override
  State<AuthenticationWidget> createState() => _AuthenticationWidgetState();
}

class _AuthenticationWidgetState extends State<AuthenticationWidget> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPhone != null) {
      _phoneController.text = widget.initialPhone!;
    }
    if (widget.initialPassword != null) {
      _passwordController.text = widget.initialPassword!;
    }
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
          (failure) => widget.onError(failure.message),
          (session) => widget.onSuccess(session.user),
        );
      }
    } catch (e) {
      if (mounted) {
        widget.onError('Произошла ошибка: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          
          // Тестовые данные (если нужно)
          if (widget.showTestData) ...[
            const SizedBox(height: 16),
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
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
