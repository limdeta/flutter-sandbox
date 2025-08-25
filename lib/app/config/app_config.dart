enum Environment {
  dev,
  prod,
  test,
}

class AppConfig {
  static Environment _environment = Environment.dev;
  
  static Environment get environment => _environment;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  static bool get isDev => _environment == Environment.dev;
  static bool get isProd => _environment == Environment.prod;
  static bool get isTest => _environment == Environment.test;
  
  // Backward compatibility
  static bool get isDevelopment => isDev;
  static bool get isProduction => isProd;
  
  // API Configuration
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://dev-api.tauzero.com';
      case Environment.prod:
        return 'https://api.tauzero.com';
      case Environment.test:
        return 'https://test-api.tauzero.com';
    }
  }
  
  // Database Configuration
  static String get databaseName {
    switch (_environment) {
      case Environment.dev:
        return 'tauzero_dev.db';
      case Environment.prod:
        return 'tauzero.db';
      case Environment.test:
        return 'tauzero_test.db';
    }
  }
  
  // Feature Flags
  static bool get useMockData => isDev;
  static bool get enableDebugTools => isDev || isTest;
  static bool get enableDetailedLogging => !isProd;
  
  // Dev configuration from command line
  static void configureFromArgs() {
    // Get environment from dart defines
    const envString = String.fromEnvironment('ENV', defaultValue: 'dev');
    const useMockString = String.fromEnvironment('USE_MOCK', defaultValue: 'true');
    
    switch (envString.toLowerCase()) {
      case 'prod':
      case 'production':
        _environment = Environment.prod;
        break;
      case 'test':
      case 'testing':
        _environment = Environment.test;
        break;
      case 'dev':
      case 'development':
      default:
        _environment = Environment.dev;
        break;
    }
    
    // Override mock usage if specified
    if (useMockString.toLowerCase() == 'false') {
      // Force real data even in development
      // This is handled in service locator
    }
  }

  // Helper methods for debugging
  static void printConfig() {
    print('=== App Configuration ===');
    print('Environment: $_environment');
    print('API Base URL: $apiBaseUrl');
    print('Database Name: $databaseName');
    print('Use Mock Data: $useMockData');
    print('Debug Tools: $enableDebugTools');
    print('Detailed Logging: $enableDetailedLogging');
    print('========================');
  }
}
