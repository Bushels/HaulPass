import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

/// Service for managing environment variables across web and mobile platforms
/// Supports runtime configuration via window object and build-time constants
class EnvironmentService {
  static EnvironmentService? _instance;
  static EnvironmentService get instance => _instance ??= EnvironmentService._internal();

  EnvironmentService._internal();

  // Cache for loaded values
  final Map<String, String?> _cache = {};
  final Map<String, bool> _validationCache = {};

  // Required environment variables
  static const List<String> _requiredKeys = [
    'SUPABASE_URL',
    'SUPABASE_ANON_KEY',
    'GOOGLE_MAPS_API_KEY',
  ];

  // Development placeholders
  static const Map<String, String> _developmentPlaceholders = {
    'SUPABASE_URL': 'https://your-project.supabase.co',
    'SUPABASE_ANON_KEY': 'your-anon-key-here',
    'GOOGLE_MAPS_API_KEY': 'your-api-key-here',
  };

  /// Load environment variable from web window object or mobile platform
  String? _loadFromPlatform(String key) {
    if (kIsWeb) {
      // Web environment - check window object
      return _loadFromWindow(key);
    } else {
      // Mobile environment - could be implemented for iOS/Android native
      return _loadFromMobile(key);
    }
  }

  /// Load environment variable from web window object
  String? _loadFromWindow(String key) {
    try {
      if (html.window != null) {
        final element = html.document.querySelector('meta[name="env-$key"]');
        if (element != null) {
          final content = element.getAttribute('content');
          if (content != null && content.isNotEmpty) {
            return content;
          }
        }
        
        // Alternative: check window object directly
        final windowValue = html.window[key];
        if (windowValue is String && windowValue.isNotEmpty) {
          return windowValue;
        }
      }
    } catch (e) {
      debugPrint('Error loading env var $key from window: $e');
    }
    return null;
  }

  /// Load environment variable from mobile platform
  String? _loadFromMobile(String key) {
    // Implementation for iOS/Android native environment variables
    // This could be expanded to use platform channels for native code
    return null;
  }

  /// Get environment variable with fallback to development placeholders
  String getEnvironmentVariable(String key, {bool required = false}) {
    if (_cache.containsKey(key)) {
      return _cache[key] ?? '';
    }

    // Try to load from platform
    String? value = _loadFromPlatform(key);
    
    // Fallback to development placeholder
    if (value == null || value.isEmpty) {
      value = _developmentPlaceholders[key];
    }

    // Store in cache
    _cache[key] = value;
    
    // Validate if required
    if (required) {
      validateRequired(key);
    }

    return value ?? '';
  }

  /// Get Supabase URL
  String get supabaseUrl => getEnvironmentVariable('SUPABASE_URL', required: true);

  /// Get Supabase Anonymous Key
  String get supabaseAnonKey => getEnvironmentVariable('SUPABASE_ANON_KEY', required: true);

  /// Get Google Maps API Key
  String get googleMapsApiKey => getEnvironmentVariable('GOOGLE_MAPS_API_KEY', required: true);

  /// Validate that a required environment variable is set
  void validateRequired(String key) {
    if (_validationCache.containsKey(key)) return;

    final value = getEnvironmentVariable(key, required: false);
    
    if (value.isEmpty || value == _developmentPlaceholders[key]) {
      throw EnvironmentException(
        'Required environment variable $key is not set. '
        'Please configure it properly for your environment.'
      );
    }
    
    _validationCache[key] = true;
  }

  /// Validate all required environment variables
  void validateAll() {
    for (final key in _requiredKeys) {
      validateRequired(key);
    }
  }

  /// Check if all required environment variables are properly configured
  bool get isConfigured {
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
    
    for (final key in _requiredKeys) {
      final value = getEnvironmentVariable(key, required: false);
      info[key] = _isValidValue(value, key) ? '✓ Set' : '✗ Not set';
    }
    
    info['platform'] = kIsWeb ? 'Web' : 'Mobile';
    info['isConfigured'] = isConfigured.toString();
    
    return info;
  }

  /// Check if value is valid (not empty and not development placeholder)
  bool _isValidValue(String? value, String key) {
    if (value == null || value.isEmpty) return false;
    
    final placeholder = _developmentPlaceholders[key];
    return value != placeholder;
  }

  /// Clear cache (useful for testing)
  void clearCache() {
    _cache.clear();
    _validationCache.clear();
  }

  /// Load multiple environment variables at once
  Map<String, String> loadMultiple(List<String> keys) {
    final result = <String, String>{};
    for (final key in keys) {
      result[key] = getEnvironmentVariable(key, required: false);
    }
    return result;
  }

  /// Load environment variables from JSON string (for build-time configuration)
  static Map<String, String> loadFromJson(String jsonString) {
    try {
      final decoded = json.decode(jsonString) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      throw EnvironmentException('Invalid JSON format for environment configuration: $e');
    }
  }

  /// Get build-time configuration
  String get buildTimeConfig {
    if (kIsWeb) {
      // For web, build-time config is injected via meta tags or window object
      return 'web';
    } else {
      // For mobile, this could be populated during build
      return 'mobile';
    }
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