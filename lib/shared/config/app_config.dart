enum Environment {
  development,
  staging,
  production,
}

class AppConfig {
  static Environment _environment = Environment.development;
  
  static Environment get environment => _environment;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;
  
  // API Configuration
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'https://dev-api.tauzero.com';
      case Environment.staging:
        return 'https://staging-api.tauzero.com';
      case Environment.production:
        return 'https://api.tauzero.com';
    }
  }
  
  // Database Configuration
  static String get databaseName {
    switch (_environment) {
      case Environment.development:
        return 'tauzero_dev.db';
      case Environment.staging:
        return 'tauzero_staging.db';
      case Environment.production:
        return 'tauzero.db';
    }
  }
  
  // Feature Flags
  static bool get useMockData => isDevelopment;
  static bool get enableDebugTools => isDevelopment || isStaging;
  static bool get enableDetailedLogging => !isProduction;
  
  // Dev configuration from command line
  static void configureFromArgs() {
    // Get environment from dart defines
    const envString = String.fromEnvironment('ENV', defaultValue: 'development');
    const useMockString = String.fromEnvironment('USE_MOCK', defaultValue: 'true');
    
    switch (envString.toLowerCase()) {
      case 'production':
        _environment = Environment.production;
        break;
      case 'staging':
        _environment = Environment.staging;
        break;
      case 'development':
      default:
        _environment = Environment.development;
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
