# Настройка Сервера Автообновлений

## 📋 Что нужно сделать

### 1. Создать JSON файл на вашем сервере

Создайте файл `version.json` по адресу `https://your-server.com/tauzero/version.json`:

```json
{
  "version": "1.1.0",
  "changelog": "🔧 Исправлены ошибки с базой данных\n✨ Добавлена новая функция экспорта\n🚀 Улучшена производительность",
  "download_url": "https://your-server.com/tauzero/TauZero-v1.1.0.exe",
  "required": false,
  "min_supported_version": "1.0.0"
}
```

### 2. Загрузить новую версию .exe файла

Положите файл `TauZero-v1.1.0.exe` по адресу указанному в `download_url`.

### 3. Обновить версию в приложении

В файле `lib/app/services/simple_update_service.dart` измените:

```dart
static const String CURRENT_VERSION = '1.1.0'; // Новая версия
static const String UPDATE_URL = 'https://your-server.com/tauzero/version.json'; // Ваш URL
```

## 🔄 Как работает

1. **Автоматическая проверка**: При запуске приложения (если включено в настройках)
2. **Ручная проверка**: Через меню "Проверить обновления"  
3. **Сравнение версий**: Сравнивает `CURRENT_VERSION` с `version` из JSON
4. **Скачивание**: Открывает ссылку `download_url` в браузере

## 📱 Поддержка платформ

### Windows (Ваш случай)
- ✅ **Полная свобода**: Можно скачивать и устанавливать любые .exe файлы
- ✅ **Простота**: Пользователь просто скачивает и запускает новый .exe
- ✅ **Обновления по ссылке**: Работает через браузер

### Android
- ⚠️ **APK sideload**: Нужно разрешить установку из неизвестных источников  
- 📱 **Лучше через Google Play**: Автоматические обновления через маркет

### iOS  
- ❌ **Только App Store**: Apple не разрешает установку вне App Store
- 🍎 **Используйте upgrader**: Автоматически проверяет обновления в App Store

### Web
- ✅ **Автоматически**: Браузер сам обновляет при новом деплое

## 🚀 Тупой скрипт для деплоя

Создайте `deploy_update.bat`:

```batch
@echo off
echo 🔨 Собираем Windows версию...
flutter build windows --release

echo 📦 Копируем файлы...
copy "build\windows\x64\runner\Release\*" "C:\deploy\tauzero\v1.1.0\"

echo 📝 Обновляем version.json...
echo {
echo   "version": "1.1.0",
echo   "changelog": "Новые исправления и улучшения",
echo   "download_url": "https://your-server.com/tauzero/TauZero-v1.1.0.exe"
echo } > C:\deploy\tauzero\version.json

echo ☁️ Загружаем на сервер...
scp C:\deploy\tauzero\* user@your-server.com:/var/www/html/tauzero/

echo ✅ Готово! Обновление опубликовано
pause
```

## ⚙️ Настройки

В `lib/app/config/app_config.dart`:

```dart
class AppConfig {
  // Включить/выключить проверку обновлений
  static const bool checkForUpdates = true;
  
  // Проверять при запуске приложения
  static const bool checkOnStartup = true;
}
```

## 🔧 Troubleshooting

### Проблема: "Не удается проверить обновления"
- ✅ Проверьте доступность URL `UPDATE_URL`
- ✅ Убедитесь что JSON валидный 
- ✅ Проверьте CORS заголовки на сервере

### Проблема: "Ссылка не открывается"
- ✅ Проверьте URL в `download_url`
- ✅ Убедитесь что файл существует на сервере

### Проблема: "Обновления не показываются"
- ✅ Проверьте что `checkForUpdates = true`
- ✅ Убедитесь что версии разные (`CURRENT_VERSION` != `version`)
