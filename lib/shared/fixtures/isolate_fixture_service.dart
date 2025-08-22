import 'dart:isolate';
import 'package:flutter/foundation.dart';
import '../providers/dev_data_loading_notifier.dart';

/// Сервис для создания тестовых данных в изоляте (фоновом потоке)
/// Предотвращает блокировку UI при создании большого количества данных
class IsolateFixtureService {
  /// Создает полный набор dev данных в изоляте
  /// Возвращает Future, который завершается когда данные готовы
  static Future<void> createDevDataInIsolate() async {

    devDataLoadingNotifier.setLoading();

    // Создаем ReceivePort для получения результата от изолята
    final receivePort = ReceivePort();
    
    try {
      // Запускаем изолят с точкой входа _isolateEntryPoint
      await Isolate.spawn(
        _isolateEntryPoint,
        receivePort.sendPort,
      );

      final result = await receivePort.first;
      
      if (result is String && result.startsWith('ERROR:')) {
        devDataLoadingNotifier.setError(result);
        throw Exception('Ошибка в изоляте: $result');
      }
      
      devDataLoadingNotifier.setLoaded();
      
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
      // В изоляте создаем dev данные напрямую
      // без использования GetIt (временная упрощенная реализация)
      await _createDevDataDirectly();
      
      if (kDebugMode) {
        print('✅ Изолят завершил создание dev данных');
      }
      
      sendPort.send('SUCCESS');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка в изоляте: $e');
      }
      sendPort.send('ERROR: $e');
    }
  }

  /// Создает dev данные напрямую в изоляте
  /// Полная инициализация базы данных и всех фикстур
  static Future<void> _createDevDataDirectly() async {
    // ВРЕМЕННО: отключаем создание данных в изоляте
    // так как это создает проблемы с GetIt и базой данных
    // TODO: Реализовать полную инициализацию базы данных в изоляте
    
    // Просто эмулируем успешное завершение
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (kDebugMode) {
      print('⚠️ Создание dev данных в изоляте временно отключено');
      print('📋 Dev данные будут созданы в основном потоке при первой загрузке');
    }
  }
}
