# TauZero - Makefile for development

#flutter emulators --launch android
#flutter run -d emulator-5554

# Variables
FLUTTER := flutter
PROJECT_NAME := tauzero
ANDROID_DEVICE := emulator-5554
WINDOWS_DEVICE := windows
CHROME_DEVICE := chrome
ANDROID_EMULATOR := android

.PHONY: help install check clean deps upgrade analyze format test coverage build run-android run-android-force-emulator emulator-list emulator-start run-windows run-web dev docs lint setup-git hooks pre-commit devices android-debug

# Default target
.DEFAULT_GOAL := help

## General commands

help: ## Show this help message
	@echo "TauZero - Development Commands"
	@echo ""
	@echo "Usage: make [command]"
	@echo ""
	@echo "Available commands:"
	@echo "  install      - Full project installation"
	@echo "  dev          - Start development mode"
	@echo "  dev-mock     - Start development with mock data"
	@echo "  dev-real     - Start development with real database"
	@echo "  codegen      - Generate Drift database code"
	@echo "  watch-codegen - Watch for changes and auto-generate code"
	@echo "  test         - Run all tests"
	@echo "  test-auth    - Run authentication feature tests"
	@echo "  lint         - Code analysis and formatting"
	@echo "  emulator-list - List available Android emulators"
	@echo "  emulator-start - Start default Android emulator"
	@echo "  run-android  - Smart Android run (auto-start emulator + run app)"
	@echo "  run-windows  - Run on Windows desktop"
	@echo "  run-web      - Run in browser"
	@echo "  devices      - Show all devices and emulators"
	@echo "  android-debug - Quick Android debug info"
	@echo "  build        - Build for all platforms"
	@echo "  clean        - Clean cache and temp files"
	@echo "  doctor       - Flutter environment diagnostics"
	@echo ""
	@echo "Examples:"
	@echo "  make install        # Full environment setup"
	@echo "  make dev           # Start development"
	@echo "  make emulator-list # List Android emulators"
	@echo "  make run-android   # Smart Android run (auto-start + run)"
	@echo "  make test          # Run all tests"

install: ## Full project installation and dependencies
	@$(FLUTTER) --version
	@$(FLUTTER) doctor
	@echo "Installing dependencies..."
	@$(FLUTTER) pub get
	@echo "Installation completed!"
	@echo "Run 'make dev' to start development"

check: ## Check environment and dependencies
	@echo "Checking environment..."
	@$(FLUTTER) doctor
	@echo ""
	@echo "Available devices:"
	@$(FLUTTER) devices
	@echo ""
	@echo "Available emulators:"
	@$(FLUTTER) emulators

clean: ## Clean cache and temporary files
	@echo "Cleaning project..."
	@$(FLUTTER) clean
	@echo "Removing temporary files..."
	@if exist "build" rmdir /s /q "build"
	@if exist ".dart_tool" rmdir /s /q ".dart_tool"
	@echo "Cleanup completed!"

deps: ## Install dependencies
	@echo "Installing dependencies..."
	@$(FLUTTER) pub get

upgrade: ## Update dependencies
	@echo "Updating dependencies..."
	@$(FLUTTER) pub upgrade
	@echo "Dependencies updated!"

## Development

dev: ## Start development mode (smart Android run)
	@echo "🚀 Starting development mode..."
	@echo "🔧 Checking dependencies..."
	@$(FLUTTER) pub get
	@echo ""
	@echo "🔥 Starting with hot reload..."
	@$(FLUTTER) run --hot

dev-mock: ## Run in development mode with mock data
	@echo "🧪 Running in development mode with mock data..."
	@$(FLUTTER) run --dart-define=ENV=development --dart-define=USE_MOCK=true -d android

dev-real: ## Run in development mode with real database
	@echo "💾 Running in development mode with real database..."
	@$(FLUTTER) run --dart-define=ENV=development --dart-define=USE_MOCK=false -d android

## Database commands

codegen: ## Generate Drift database code
	@echo "Generating Drift database code..."
	@dart run build_runner build --delete-conflicting-outputs
	@echo "Code generation completed!"

watch-codegen: ## Watch for changes and auto-generate code
	@echo "Watching for changes and auto-generating code..."
	@dart run build_runner watch --delete-conflicting-outputs
	@echo "Starting development mode..."
	@echo "Checking available devices..."
	@$(FLUTTER) devices
	@echo "Starting on Android emulator..."
	@$(FLUTTER) run

analyze: ## Code analysis
	@echo "Analyzing code..."
	@$(FLUTTER) analyze

format: ## Format code
	@echo "Formatting code..."
	@dart format .
	@echo "Code formatted!"

lint: ## Full code check (analysis + formatting)
	@echo "Full code check..."
	@make analyze
	@make format

## Testing

test: ## Run all tests
	@echo "Running tests..."
	@$(FLUTTER) test

test-auth: ## Run authentication feature tests
	@echo "Running authentication tests..."
	@$(FLUTTER) test test/features/authentication/

coverage: ## Run tests with coverage
	@echo "Running tests with coverage..."
	@$(FLUTTER) test --coverage
	@echo "Coverage report: coverage/lcov.info"

## Running

emulator-list: ## List available Android emulators
	@echo "Available Android emulators:"
	@$(FLUTTER) emulators

emulator-start: ## Start the first available Android emulator
	@echo "Starting Android emulator..."
	@$(FLUTTER) emulators --launch $(ANDROID_EMULATOR)
	@echo "Waiting for emulator to boot..."
	@timeout /t 10
	@echo "Emulator should be starting..."

run-android: ## Smart Android run - auto-start emulator if needed and run app
	@echo "🚀 Smart Android Run - TauZero"
	@echo "================================="
	@echo ""
	@echo "🔍 Checking available devices..."
	@$(FLUTTER) devices
	@echo ""
	@echo "📱 Starting emulator if needed..."
	@$(FLUTTER) emulators --launch $(ANDROID_EMULATOR) || echo "Emulator already running or failed to start"
	@echo "⏳ Waiting for device to be ready..."
	@timeout /t 10 > nul
	@echo ""
	@echo "🎯 Launching TauZero on Android..."
	@$(FLUTTER) run -d android
	@echo "✅ App launched successfully!"

run-android-force-emulator: ## Force start new emulator and run
	@echo "🔄 Force starting new Android emulator..."
	@make emulator-start
	@timeout /t 20
	@echo "🎯 Running TauZero on emulator..."
	@$(FLUTTER) run -d android

run-windows: ## Run on Windows Desktop
	@echo "🖥️  Running TauZero on Windows..."
	@$(FLUTTER) run -d $(WINDOWS_DEVICE)

run-web: ## Run in browser
	@echo "🌐 Running TauZero in browser..."
	@$(FLUTTER) run -d $(CHROME_DEVICE)

## Building

build-android-debug: ## Build Android APK (debug)
	@echo "Building Android APK (debug)..."
	@$(FLUTTER) build apk --debug
	@echo "APK built: build/app/outputs/flutter-apk/app-debug.apk"

build-android-release: ## Build Android APK (release)
	@echo "Building Android APK (release)..."
	@$(FLUTTER) build apk --release
	@echo "APK built: build/app/outputs/flutter-apk/app-release.apk"

build-windows: ## Build Windows application
	@echo "Building Windows application..."
	@$(FLUTTER) build windows --release
	@echo "Windows app built: build/windows/"

build-web: ## Build web version
	@echo "Building web version..."
	@$(FLUTTER) build web --release
	@echo "Web version built: build/web/"

build: ## Build for all platforms
	@echo "Building for all platforms..."
	@make build-android-release
	@make build-windows
	@make build-web
	@echo "All builds completed!"

## Tools

doctor: ## Flutter environment diagnostics
	@echo "Flutter diagnostics..."
	@$(FLUTTER) doctor -v

devices: ## Show all connected devices and emulators
	@echo "🔍 Checking connected devices..."
	@$(FLUTTER) devices
	@echo ""
	@echo "📱 Available emulators:"
	@$(FLUTTER) emulators

android-debug: ## Quick Android debug info
	@echo "🔧 Android Debug Information"
	@echo "============================"
	@echo ""
	@echo "📱 Connected Android devices:"
	@$(FLUTTER) devices | findstr /C:"android"
	@echo ""
	@echo "📋 Available emulators:"
	@$(FLUTTER) emulators
	@echo ""
	@echo "🏥 Flutter doctor:"
	@$(FLUTTER) doctor

update-flutter: ## Update Flutter SDK
	@echo "Updating Flutter SDK..."
	@$(FLUTTER) upgrade
	@echo "Flutter updated!"

troubleshoot: ## Common problems solutions
	@echo "🔧 Common problems solutions:"
	@echo ""
	@echo "❌ If Flutter not found:"
	@echo "  - Make sure Flutter is in PATH"
	@echo "  - Restart terminal"
	@echo "  - See INSTALL.md"
	@echo ""
	@echo "📱 If Android emulator doesn't start:"
	@echo "  - Check: make emulator-list"
	@echo "  - Ensure virtualization enabled in BIOS"
	@echo "  - Make sure Android SDK installed"
	@echo "  - Create new emulator via Android Studio"
	@echo "  - Try: make run-android-force-emulator"
	@echo ""
	@echo "🚀 Quick Android setup:"
	@echo "  1. make emulator-list     # See available emulators"
	@echo "  2. make emulator-start    # Start emulator manually"
	@echo "  3. make run-android       # Smart run (recommended)"
	@echo ""
	@echo "💡 Tips:"
	@echo "  - Use 'make run-android' for automatic emulator management"
	@echo "  - Use 'make dev' for quick development start"
	@echo "  - Check 'flutter doctor' if having issues"
