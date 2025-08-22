import 'dart:isolate';
import 'package:flutter/foundation.dart';
import '../providers/dev_data_loading_notifier.dart';

/// Сервис для создания тестовых данных в изоляте (фоновом потоке)
/// Предотвращает блокировку UI при создании большого количества данных
class IsolateFixtureService {
  /// Создает полный набор dev данных в изоляте
  /// Возвращает Future, который завершается когда данные готовы
  static Future<void> createDevDataInIsolate() async {
    // Устанавливаем состояние загрузки
    devDataLoadingNotifier.setLoading();
    
    if (kDebugMode) {
      print('🔄 Запуск создания dev данных в изоляте...');
    }

    // Создаем ReceivePort для получения результата от изолята
    final receivePort = ReceivePort();
    
    try {
      // Запускаем изолят с точкой входа _isolateEntryPoint
      await Isolate.spawn(
        _isolateEntryPoint,
        receivePort.sendPort,
      );

      // Ждем завершения работы изолята
      final result = await receivePort.first;
      
      if (result is String && result.startsWith('ERROR:')) {
        devDataLoadingNotifier.setError(result);
        throw Exception('Ошибка в изоляте: $result');
      }
      
      // Устанавливаем состояние успешной загрузки
      devDataLoadingNotifier.setLoaded();
      
      if (kDebugMode) {
        print('✅ Dev данные созданы в изоляте успешно');
      }
    } catch (e) {
      devDataLoadingNotifier.setError(e.toString());
      
      if (kDebugMode) {
        print('❌ Ошибка при создании dev данных в изоляте: $e');
      }
      rethrow;
    }
  }

  /// Точка входа для изолята
  /// Выполняется в отдельном потоке, изолированно от UI
  static void _isolateEntryPoint(SendPort sendPort) async {
    try {
      if (kDebugMode) {
        print('🧵 Изолят запущен для создания dev данных');
      }

      // В изоляте создаем dev данные напрямую
      // без использования GetIt (временная упрощенная реализация)
      await _createDevDataDirectly();
      
      if (kDebugMode) {
        print('✅ Изолят завершил создание dev данных');
      }
      
      // Отправляем сигнал об успешном завершении
      sendPort.send('SUCCESS');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка в изоляте: $e');
      }
      
      // Отправляем информацию об ошибке
      sendPort.send('ERROR: $e');
    }
  }

  /// Создает dev данные напрямую (временная упрощенная реализация)
  /// TODO: Реализовать полную инициализацию базы данных в изоляте
  static Future<void> _createDevDataDirectly() async {
    // Эмулируем создание dev данных
    await Future.delayed(const Duration(seconds: 3));
    
    if (kDebugMode) {
      print('📊 Dev данные созданы в изоляте (временная заглушка)');
    }
  }
}
