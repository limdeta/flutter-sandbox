# TauZero - Мобильное приложение для торговых представителей

Приложение для торговых представителей с функциями геолокации, маршрутов и отчетности.

## 📋 Системные требования

### Windows
- Windows 10/11
- PowerShell или Command Prompt
- Git
- 8+ GB RAM
- 20+ GB свободного места на диске

### Общие требования
- Стабильное интернет-соединение для первоначальной установки
- Android устройство или эмулятор для тестирования

## 🚀 Быстрый старт

### 1. Клонирование проекта
```bash
git clone https://github.com/yourusername/tauzero.git
cd tauzero
```

### 2. Автоматическая установка (рекомендуется)
```bash
# Если у вас есть Make
make install

# Или запустите скрипт установки
# В Windows PowerShell:
.\scripts\install.ps1

# В Linux/Mac:
./scripts/install.sh
```

### 3. Запуск приложения
```bash
# Запуск на Android эмуляторе
make run-android

# Запуск на Windows Desktop
make run-windows

# Запуск тестов
make test
```

## 📖 Подробная инструкция по установке

### Шаг 1: Установка Flutter SDK

#### Windows
1. Скачайте Flutter SDK с [официального сайта](https://docs.flutter.dev/get-started/install/windows)
2. Распакуйте в `C:\FlutterSDK\flutter`
3. Добавьте `C:\FlutterSDK\flutter\bin` в переменную PATH
4. Перезапустите терминал

#### Linux/Mac
```bash
# Скачиваем и устанавливаем Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
echo 'export PATH="$PATH:`pwd`/flutter/bin"' >> ~/.bashrc
```

#### Проверка установки
```bash
flutter --version
flutter doctor
```

### Шаг 2: Установка Android SDK

#### Через Android Studio (рекомендуется)
1. Скачайте [Android Studio](https://developer.android.com/studio)
2. Установите Android Studio
3. Запустите SDK Manager и установите:
   - Android SDK Platform-Tools
   - Android SDK Build-Tools (последняя версия)
   - Android API 34 (или выше)

#### Через командную строку
```bash
# Windows (через Chocolatey)
choco install android-sdk

# Linux
sudo apt install android-sdk

# Mac (через Homebrew)
brew install android-sdk
```

### Шаг 3: Настройка Android эмулятора

#### Создание эмулятора
```bash
# Проверяем доступные образы системы
flutter emulators

# Если эмуляторов нет, создаем новый через Android Studio:
# Tools > AVD Manager > Create Virtual Device
```

#### Или через командную строку
```bash
# Скачиваем образ системы
sdkmanager "system-images;android-34;google_apis;x86_64"

# Создаем эмулятор
avdmanager create avd -n flutter_emulator -k "system-images;android-34;google_apis;x86_64"

# Запускаем эмулятор
emulator -avd flutter_emulator
```

### Шаг 4: Проверка окружения

```bash
# Запускаем диагностику Flutter
flutter doctor

# Все пункты должны быть с галочками ✓
# Если есть проблемы, следуйте инструкциям flutter doctor
```

### Шаг 5: Установка зависимостей проекта

```bash
# Находясь в корне проекта
flutter pub get
```

### Шаг 6: Запуск приложения

```bash
# Проверяем доступные устройства
flutter devices

# Запускаем на Android эмуляторе
flutter run -d emulator-5554

# Запускаем на Windows Desktop
flutter run -d windows

# Запускаем в браузере (для веб-версии)
flutter run -d chrome
```

## 🛠️ Разработка

### Структура проекта
```
tauzero/
├── lib/                    # Исходный код Dart
│   ├── main.dart          # Точка входа
│   ├── models/            # Модели данных
│   ├── screens/           # Экраны приложения
│   └── services/          # Сервисы и API
├── android/               # Android-специфичный код
├── windows/               # Windows-специфичный код
├── test/                  # Тесты
├── Makefile              # Команды для разработки
└── pubspec.yaml          # Зависимости Flutter
```

### Полезные команды

```bash
# Обновление зависимостей
flutter pub upgrade

# Генерация кода (если используете code generation)
flutter packages pub run build_runner build

# Анализ кода
flutter analyze

# Форматирование кода
flutter format .

# Сборка для релиза
flutter build apk --release      # Android APK
flutter build windows --release  # Windows
```

## 🧪 Тестирование

```bash
# Запуск всех тестов
flutter test

# Запуск тестов с покрытием
flutter test --coverage

# Интеграционные тесты
flutter drive --target=test_driver/app.dart
```

## 🚨 Решение проблем

### Flutter Doctor показывает проблемы

**Android License не принят:**
```bash
flutter doctor --android-licenses
```

**Не найден Android SDK:**
```bash
# Добавьте в переменные окружения
export ANDROID_HOME=/path/to/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

**Не найден Java:**
```bash
# Windows
choco install openjdk11

# Linux
sudo apt install openjdk-11-jdk

# Mac
brew install openjdk@11
```

### Проблемы с эмулятором

**Эмулятор не запускается:**
```bash
# Проверьте включена ли виртуализация в BIOS
# Для Windows также включите Hyper-V

# Создайте новый эмулятор через Android Studio
```

**Медленная работа эмулятора:**
- Убедитесь что включено аппаратное ускорение
- Выделите больше RAM эмулятору
- Используйте образ системы x86_64 вместо ARM

### Проблемы сборки

**Gradle build fails:**
```bash
# Очистите кэш
flutter clean
flutter pub get

# Обновите Gradle Wrapper
cd android
./gradlew wrapper --gradle-version=8.12
```

**Ошибки компиляции Dart:**
```bash
# Проверьте синтаксис
flutter analyze

# Исправьте автоматические ошибки форматирования
flutter format .
```

## 📚 Дополнительные ресурсы

- [Официальная документация Flutter](https://docs.flutter.dev/)
- [Flutter samples](https://github.com/flutter/samples)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте ветку для новой функции (`git checkout -b feature/amazing-feature`)
3. Закоммитьте изменения (`git commit -m 'Add amazing feature'`)
4. Запушьте в ветку (`git push origin feature/amazing-feature`)
5. Создайте Pull Request

## 📄 Лицензия

Этот проект лицензирован под MIT License - смотрите файл [LICENSE](LICENSE) для деталей.
