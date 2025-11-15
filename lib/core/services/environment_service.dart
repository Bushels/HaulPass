import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for managing environment variables across web and mobile platforms
/// Uses flutter_dotenv to load from .env file
class EnvironmentService {
  static EnvironmentService? _instance;
  static EnvironmentService get instance => _instance ??= EnvironmentService._internal();

  EnvironmentService._internal();

  // Cache for loaded values
  final Map<String, String?> _cache = {};
  bool _isInitialized = false;

  // Required environment variables
  static const List<String> _requiredKeys = [
    'SUPABASE_URL',
    'SUPABASE_ANON_KEY',
  ];

  // Optional environment variables
  static const List<String> _optionalKeys = [
    'GOOGLE_MAPS_API_KEY',
  ];

  /// Initialize the environment service by loading .env file
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await dotenv.load(fileName: '.env');
      _isInitialized = true;
      debugPrint('✅ Environment variables loaded successfully');

      // Validate required variables
      validateAll();
    } catch (e) {
      debugPrint('⚠️ Error loading .env file: $e');
      debugPrint('⚠️ Using default values. Some features may not work.');
      _isInitialized = true;
    }
  }

  /// Get environment variable with optional fallback
  String getEnvironmentVariable(String key, {String? fallback, bool required = false}) {
    if (!_isInitialized) {
      throw const EnvironmentException(
        'EnvironmentService not initialized. Call EnvironmentService.instance.initialize() first.'
      );
    }

    // Check cache first
    if (_cache.containsKey(key)) {
      return _cache[key] ?? fallback ?? '';
    }

    // Load from dotenv
    String? value = dotenv.env[key];

    // Use fallback if not found
    if (value == null || value.isEmpty) {
      value = fallback;
    }

    // Store in cache
    _cache[key] = value;

    // Validate if required
    if (required && (value == null || value.isEmpty)) {
      throw EnvironmentException(
        'Required environment variable $key is not set. '
        'Please add it to your .env file.'
      );
    }

    return value ?? '';
  }

  /// Get Supabase URL
  String get supabaseUrl {
    return getEnvironmentVariable(
      'SUPABASE_URL',
      required: true,
      fallback: 'https://nwismkrgztbttlndylmu.supabase.co',
    );
  }

  /// Get Supabase Anonymous Key
  String get supabaseAnonKey {
    return getEnvironmentVariable(
      'SUPABASE_ANON_KEY',
      required: true,
    );
  }

  /// Get Google Maps API Key
  String get googleMapsApiKey {
    return getEnvironmentVariable(
      'GOOGLE_MAPS_API_KEY',
      required: false,
      fallback: '',
    );
  }

  /// Validate that a required environment variable is set
  void validateRequired(String key) {
    final value = getEnvironmentVariable(key, required: false);

    if (value.isEmpty) {
      throw EnvironmentException(
        'Required environment variable $key is not set. '
        'Please configure it in your .env file.'
      );
    }

    debugPrint('✅ $key is configured');
  }

  /// Validate all required environment variables
  void validateAll() {
    debugPrint('🔍 Validating environment variables...');

    for (final key in _requiredKeys) {
      try {
        validateRequired(key);
      } catch (e) {
        debugPrint('❌ Validation failed for $key: $e');
        rethrow;
      }
    }

    debugPrint('✅ All required environment variables validated');
  }

  /// Check if all required environment variables are properly configured
  bool get isConfigured {
    if (!_isInitialized) return false;

    try {
      validateAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get environment information for debugging
  Map<String, String> getEnvironmentInfo() {
    final info = <String, String>{};

    // Required keys
    for (final key in _requiredKeys) {
      final value = getEnvironmentVariable(key, required: false);
      info[key] = _isValidValue(value) ? '✓ Configured' : '✗ Not configured';
    }

    // Optional keys
    for (final key in _optionalKeys) {
      final value = getEnvironmentVariable(key, required: false);
      info[key] = _isValidValue(value) ? '✓ Configured' : '- Optional (not set)';
    }

    info['platform'] = kIsWeb ? 'Web' : 'Mobile';
    info['initialized'] = _isInitialized.toString();
    info['isConfigured'] = isConfigured.toString();

    return info;
  }

  /// Check if value is valid (not empty)
  bool _isValidValue(String? value) {
    return value != null && value.isNotEmpty;
  }

  /// Clear cache (useful for testing)
  void clearCache() {
    _cache.clear();
  }

  /// Reset initialization status (useful for testing)
  void reset() {
    _cache.clear();
    _isInitialized = false;
  }

  /// Load multiple environment variables at once
  Map<String, String> loadMultiple(List<String> keys) {
    final result = <String, String>{};
    for (final key in keys) {
      result[key] = getEnvironmentVariable(key, required: false);
    }
    return result;
  }

  /// Print environment configuration (safe for debugging)
  void printConfiguration() {
    debugPrint('📋 Environment Configuration:');
    final info = getEnvironmentInfo();
    info.forEach((key, value) {
      // Don't print actual keys, just status
      debugPrint('  $key: $value');
    });
  }
}

/// Exception class for environment-related errors
class EnvironmentException implements Exception {
  final String message;

  const EnvironmentException(this.message);

  @override
  String toString() => 'EnvironmentException: $message';
}

/// Extension for easy environment access
extension EnvironmentServiceExtension on String {
  /// Get environment variable by string key
  String get env => EnvironmentService.instance.getEnvironmentVariable(this, required: false);

  /// Get required environment variable
  String get envRequired => EnvironmentService.instance.getEnvironmentVariable(this, required: true);
}
