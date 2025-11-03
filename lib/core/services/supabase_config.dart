/// Supabase Configuration for HaulPass 2.0
/// 
/// Modern configuration with latest Supabase Flutter SDK patterns
import 'package:supabase_flutter/supabase_flutter.dart';

/// App configuration constants
class AppConfig {
  static const String appName = 'HaulPass';
  static const String appVersion = '2.0.0';
  static const String buildNumber = '1';
  
  // Feature flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableLocationTracking = true;
  static const bool enableTimerFeatures = true;
  static const bool enablePremiumFeatures = true;
}

/// Supabase configuration and setup
class SupabaseConfig {
  // These will be provided by the user
  static String? supabaseUrl;
  static String? supabaseAnonKey;
  
  // Real-time channel names
  static const String lineupChannelPrefix = 'lineup:';
  static const String elevatorChannelPrefix = 'elevator:';
  static const String locationChannelPrefix = 'location:';
  static const String timerChannelPrefix = 'timer:';
  
  // Database schema versions
  static const int currentSchemaVersion = 2;
  static const String migrationPath = 'migrations';
  
  // Performance settings
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  
  // PostGIS and geospatial settings
  static const double defaultRadiusMeters = 500.0;
  static const double maxSearchRadiusMeters = 50000.0; // 50km
  static const int locationUpdateIntervalSeconds = 30;
  static const int locationHistoryRetentionDays = 30;
  
  // Authentication settings
  static const List<String> supportedAuthProviders = [
    'email',
    'google',
    'apple',
  ];
  
  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration tokenRefreshBuffer = Duration(minutes: 5);
  
  // Real-time subscription settings
  static const Duration subscriptionReconnectDelay = Duration(seconds: 5);
  static const int maxConcurrentSubscriptions = 10;
  static const Duration subscriptionHeartbeatInterval = Duration(seconds: 25);
  
  // Edge function endpoints (will be configured after deployment)
  static String get edgeFunctionsUrl {
    if (supabaseUrl == null) return '';
    return '$supabaseUrl/functions/v1';
  }
  
  // Storage bucket names
  static const String profilePicturesBucket = 'profile-pictures';
  static const String appAssetsBucket = 'app-assets';
  static const String userFilesBucket = 'user-files';
  
  // Feature flags for premium features
  static const List<String> premiumFeatures = [
    'advanced_analytics',
    'predictive_wait_times',
    'market_price_alerts',
    'unlimited_history',
    'priority_support',
    'custom_elevators',
    'advanced_routing',
    'bulk_operations',
  ];
}

/// Environment configuration
class EnvironmentConfig {
  static const bool isDevelopment = bool.fromEnvironment('dart.vm.product') == false;
  static const bool isProduction = bool.fromEnvironment('dart.vm.product') == true;
  
  // Logging configuration
  static const bool enableVerboseLogging = isDevelopment;
  static const bool enableNetworkLogging = isDevelopment;
  
  // Mock data for development
  static const bool useMockData = isDevelopment;
  static const bool simulateNetworkDelay = isDevelopment;
  static const Duration simulatedDelay = Duration(milliseconds: 500);
}

/// Configuration validation
class ConfigValidator {
  static List<String> validateConfiguration() {
    final errors = <String>[];
    
    if (SupabaseConfig.supabaseUrl == null || SupabaseConfig.supabaseUrl!.isEmpty) {
      errors.add('Supabase URL is required');
    }
    
    if (SupabaseConfig.supabaseAnonKey == null || SupabaseConfig.supabaseAnonKey!.isEmpty) {
      errors.add('Supabase Anonymous Key is required');
    }
    
    if (SupabaseConfig.supabaseUrl != null) {
      final urlPattern = RegExp(r'^https://[a-zA-Z0-9-]+\.supabase\.co$');
      if (!urlPattern.hasMatch(SupabaseConfig.supabaseUrl!)) {
        errors.add('Invalid Supabase URL format');
      }
    }
    
    if (SupabaseConfig.supabaseAnonKey != null) {
      final keyPattern = RegExp(r'^[a-zA-Z0-9]{40,}$');
      if (!keyPattern.hasMatch(SupabaseConfig.supabaseAnonKey!)) {
        errors.add('Invalid Supabase Anonymous Key format');
      }
    }
    
    return errors;
  }
}

/// Initialize Supabase with configuration
Future<SupabaseClient> initializeSupabase({
  required String url,
  required String anonKey,
}) async {
  // Store configuration
  SupabaseConfig.supabaseUrl = url;
  SupabaseConfig.supabaseAnonKey = anonKey;
  
  // Validate configuration
  final validationErrors = ConfigValidator.validateConfiguration();
  if (validationErrors.isNotEmpty) {
    throw ArgumentError('Invalid Supabase configuration:\n${validationErrors.join('\n')}');
  }
  
  // Initialize Supabase
  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
    debug: EnvironmentConfig.enableVerboseLogging,
  );
  
  // Configure global settings
  Supabase.instance.client.auth.onAuthStateChange((data) {
    // Handle auth state changes globally if needed
    print('Auth state changed: ${data.event}');
  });
  
  return Supabase.instance.client;
}

/// Create real-time channel for elevator data
String createElevatorChannel(String elevatorId) {
  return '${SupabaseConfig.elevatorChannelPrefix}$elevatorId';
}

/// Create real-time channel for location tracking
String createLocationChannel(String userId) {
  return '${SupabaseConfig.locationChannelPrefix}$userId';
}

/// Create real-time channel for timer session
String createTimerChannel(String sessionId) {
  return '${SupabaseConfig.timerChannelPrefix}$sessionId';
}

/// Create real-time channel for lineup updates
String createLineupChannel(String elevatorId) {
  return '${SupabaseConfig.lineupChannelPrefix}$elevatorId';
}
