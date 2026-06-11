/// App-wide constants and configuration
class AppConstants {
  // App Info
  static const String appName = 'OOTD AI';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Configuration
  static const String apiBaseUrl = 'https://api.ootd-ai.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Local Storage Keys
  static const String userPreferencesKey = 'user_preferences';
  static const String clothingItemsKey = 'clothing_items';
  static const String outfitsKey = 'outfits';
  static const String laundryItemsKey = 'laundry_items';
  static const String lastSyncKey = 'last_sync';

  // Image Configuration
  static const int imageQuality = 85;
  static const int maxImageSize = 5242880; // 5 MB
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // Pagination
  static const int pageSize = 20;
  static const int initialPageSize = 10;

  // Clothing Categories
  static const List<String> clothingCategories = [
    'Shirts',
    'Pants',
    'Dresses',
    'Skirts',
    'Shoes',
    'Jackets',
    'Sweaters',
    'Accessories',
    'Bags',
    'Other',
  ];

  // Wash Types
  static const List<String> washTypes = [
    'Delicate',
    'Normal',
    'Heavy',
    'Hand Wash',
    'Dry Clean Only',
  ];

  // Occasions
  static const List<String> occasions = [
    'Casual',
    'Formal',
    'Work',
    'Athletic',
    'Party',
    'Date',
    'Travel',
    'Other',
  ];

  // Weather Types
  static const List<String> weatherTypes = [
    'Sunny',
    'Rainy',
    'Cold',
    'Hot',
    'Snowy',
    'Cloudy',
    'Windy',
  ];

  // Rating Scale
  static const int minRating = 1;
  static const int maxRating = 5;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Database
  static const String databaseName = 'ootd_ai.db';
  static const int databaseVersion = 1;

  // Cache
  static const Duration cacheExpiration = Duration(days: 7);
  static const int maxCacheSize = 104857600; // 100 MB

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;

  // Error Messages
  static const String errorNoInternet = 'No internet connection';
  static const String errorServerError = 'Server error occurred';
  static const String errorUnauthorized = 'Unauthorized access';
  static const String errorNotFound = 'Resource not found';
  static const String errorInvalidInput = 'Invalid input provided';
  static const String errorTimeout = 'Request timeout';
  static const String errorUnknown = 'Unknown error occurred';

  // Success Messages
  static const String successItemAdded = 'Item added successfully';
  static const String successItemUpdated = 'Item updated successfully';
  static const String successItemDeleted = 'Item deleted successfully';
  static const String successOutfitCreated = 'Outfit created successfully';
  static const String successOutfitUpdated = 'Outfit updated successfully';

  // Debug
  static const bool enableDebugLogging = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
}

/// Environment-specific configuration
enum AppEnvironment { development, staging, production }

class EnvironmentConfig {
  static const AppEnvironment currentEnvironment =
      AppEnvironment.development;

  static String get apiBaseUrl {
    switch (currentEnvironment) {
      case AppEnvironment.development:
        return 'http://localhost:3000';
      case AppEnvironment.staging:
        return 'https://staging-api.ootd-ai.com';
      case AppEnvironment.production:
        return 'https://api.ootd-ai.com';
    }
  }

  static bool get isProduction =>
      currentEnvironment == AppEnvironment.production;

  static bool get isDevelopment =>
      currentEnvironment == AppEnvironment.development;

  static bool get enableLogging =>
      currentEnvironment != AppEnvironment.production;
}
