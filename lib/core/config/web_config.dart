import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Web-specific configuration for the HaulPass application
/// Handles GitHub Pages deployment, PWA features, and web browser optimizations
class WebConfig {
  // Note: _baseConfigFileName removed as it was unused

  // PWA Configuration
  static const String appName = 'HaulPass';
  static const String appShortName = 'HaulPass';
  static const String appDescription = 'Professional Hauling and Logistics Management Application';

  // GitHub Pages Configuration
  static String get baseUrl {
    if (kIsWeb) {
      final uri = Uri.base;
      final host = uri.host;
      
      // Detect GitHub Pages deployment
      if (host.endsWith('github.io')) {
        // Handle GitHub Pages subdirectory deployment
        final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
        if (segments.isNotEmpty) {
          final repoName = segments.first;
          return 'https://$host/$repoName/';
        }
        return 'https://$host/';
      }
      
      // Handle other hosting platforms
      return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}${uri.path}/';
    }
    return 'http://localhost:3000/';
  }

  static String get apiUrl {
    return '${baseUrl}api/';
  }

  static String get assetsUrl {
    return '${baseUrl}assets/';
  }

  // Environment Configuration
  static Environment get currentEnvironment {
    if (!kIsWeb) return Environment.development;

    final hostname = html.window.location.hostname ?? '';

    if (hostname.contains('github.io') ||
        hostname.contains('netlify.app') ||
        hostname.contains('vercel.app')) {
      return Environment.production;
    }

    if (hostname.contains('staging') || hostname.contains('test')) {
      return Environment.staging;
    }

    return Environment.development;
  }

  // Web Browser Detection
  static BrowserInfo get browserInfo {
    if (!kIsWeb) return BrowserInfo.unknown;
    
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    
    if (userAgent.contains('chrome') && !userAgent.contains('edg')) {
      return BrowserInfo.chrome;
    } else if (userAgent.contains('firefox')) {
      return BrowserInfo.firefox;
    } else if (userAgent.contains('safari') && !userAgent.contains('chrome')) {
      return BrowserInfo.safari;
    } else if (userAgent.contains('edg')) {
      return BrowserInfo.edge;
    }
    
    return BrowserInfo.unknown;
  }

  // Feature Flags for Web
  static WebFeatureFlags get featureFlags {
    switch (currentEnvironment) {
      case Environment.production:
        return const WebFeatureFlags(
          enableServiceWorker: true,
          enablePushNotifications: true,
          enableOfflineMode: true,
          enablePerformanceMonitoring: true,
          enableAnalytics: true,
          enableCacheOptimization: true,
          enableWebAssembly: true,
          enableWebGL: true,
          enableIndexedDB: true,
          enableWebShare: true,
          enableClipboardAPI: true,
          enableFileAPI: true,
        );
      case Environment.staging:
        return const WebFeatureFlags(
          enableServiceWorker: true,
          enablePushNotifications: true,
          enableOfflineMode: true,
          enablePerformanceMonitoring: true,
          enableAnalytics: false,
          enableCacheOptimization: true,
          enableWebAssembly: true,
          enableWebGL: true,
          enableIndexedDB: true,
          enableWebShare: true,
          enableClipboardAPI: true,
          enableFileAPI: true,
        );
      case Environment.development:
      default:
        return const WebFeatureFlags(
          enableServiceWorker: false,
          enablePushNotifications: false,
          enableOfflineMode: true,
          enablePerformanceMonitoring: false,
          enableAnalytics: false,
          enableCacheOptimization: false,
          enableWebAssembly: false,
          enableWebGL: true,
          enableIndexedDB: true,
          enableWebShare: true,
          enableClipboardAPI: true,
          enableFileAPI: true,
        );
    }
  }

  // Service Worker Registration
  static Future<void> registerServiceWorker() async {
    if (!kIsWeb || !featureFlags.enableServiceWorker) return;

    try {
      if (html.window.navigator.serviceWorker != null) {
        final registration = await html.window.navigator.serviceWorker?.register(
          'sw.js',
        );

        if (registration != null) {
          debugPrint('Service Worker registered successfully');
        }
      }
    } catch (e) {
      debugPrint('Service Worker registration failed: $e');
    }
  }

  // Web API Handlers
  static Future<bool> requestNotificationPermission() async {
    if (!kIsWeb || !featureFlags.enablePushNotifications) return false;
    
    try {
      final permission = await html.Notification.requestPermission();
      return permission == 'granted';
    } catch (e) {
      debugPrint('Notification permission request failed: $e');
      return false;
    }
  }

  static Future<void> showNotification(String title, String body) async {
    if (!kIsWeb || !featureFlags.enablePushNotifications) return;
    
    try {
      if (html.Notification.permission == 'granted') {
        html.Notification(title, body: body);
      }
    } catch (e) {
      debugPrint('Notification display failed: $e');
    }
  }

  // Local Storage Management
  static Future<void> setLocalStorage(String key, String value) async {
    if (!kIsWeb) return;
    
    try {
      html.window.localStorage[key] = value;
    } catch (e) {
      debugPrint('LocalStorage set failed: $e');
    }
  }

  static Future<String?> getLocalStorage(String key) async {
    if (!kIsWeb) return null;
    
    try {
      return html.window.localStorage[key];
    } catch (e) {
      debugPrint('LocalStorage get failed: $e');
      return null;
    }
  }

  static Future<void> removeLocalStorage(String key) async {
    if (!kIsWeb) return;
    
    try {
      html.window.localStorage.remove(key);
    } catch (e) {
      debugPrint('LocalStorage remove failed: $e');
    }
  }

  // URL Management for GitHub Pages
  static String normalizeUrl(String path) {
    if (!kIsWeb) return path;
    
    // Remove leading slash and normalize path
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    
    // For GitHub Pages, ensure proper path structure
    if (baseUrl.contains('github.io')) {
      return '$baseUrl$normalizedPath';
    }
    
    return '$baseUrl$normalizedPath';
  }

  // Handle deep linking for GitHub Pages
  static Future<void> handleDeepLink() async {
    if (!kIsWeb) return;
    
    try {
      final uri = Uri.parse(html.window.location.href);
      if (uri.pathSegments.isNotEmpty) {
        // Notify app about deep link
        // This can be integrated with your routing system
        debugPrint('Deep link detected: ${uri.path}');
      }
    } catch (e) {
      debugPrint('Deep link handling failed: $e');
    }
  }

  // Performance Monitoring
  static void trackWebVitals() {
    if (!kIsWeb || !featureFlags.enablePerformanceMonitoring) return;
    
    try {
      // Track Core Web Vitals
      final navigation = html.window.performance.getEntriesByType('navigation')[0] as html.PerformanceNavigationTiming?;

      if (navigation != null) {
        final loadEventEnd = navigation.loadEventEnd ?? 0;
        final fetchStart = navigation.fetchStart ?? 0;
        final domContentLoadedEventEnd = navigation.domContentLoadedEventEnd ?? 0;
        debugPrint('Page Load Time: ${loadEventEnd - fetchStart}ms');
        debugPrint('DOM Content Loaded: ${domContentLoadedEventEnd - fetchStart}ms');
      }
        } catch (e) {
      debugPrint('Performance tracking failed: $e');
    }
  }

  // Web-specific theme configurations
  static ThemeData get webOptimizedTheme {
    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Web-optimized defaults
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2196F3),
        brightness: Brightness.light,
      ),
    );
  }

  // Cache Configuration
  static Map<String, dynamic> get cacheConfig {
    return {
      'version': '1.0.0',
      'cacheName': 'haulpass-cache-v1',
      'assetsToCache': [
        '/',
        '/index.html',
        '/manifest.json',
        '/assets/',
      ],
      'cacheTimeout': const Duration(days: 7),
    };
  }

  // Environment Variables for Web
  static Future<Map<String, String>> loadEnvironmentVariables() async {
    final variables = <String, String>{};
    
    if (!kIsWeb) return variables;
    
    try {
      // Try to load from meta tags first
      final metaTags = html.document.getElementsByTagName('meta');
      for (final meta in metaTags) {
        if (meta is html.MetaElement) {
          final name = meta.name;
          if (name.isNotEmpty && name.startsWith('env-')) {
            final key = name.substring(4); // Remove 'env-' prefix
            final value = meta.content;
            variables[key] = value;
          }
        }
      }
      
      // Fallback to global window variables
      if (js.context.hasProperty('ENV')) {
        final env = js.context['ENV'];
        // Note: Direct JsObject property iteration is complex in dart:js
        // Using meta tags above is the preferred approach for web environment variables
        if (env != null) {
          // Try common environment variable names
          for (final key in ['SUPABASE_URL', 'SUPABASE_ANON_KEY', 'GOOGLE_MAPS_API_KEY']) {
            try {
              final value = js.context.callMethod('eval', ['ENV.$key']);
              if (value != null) {
                variables[key] = value.toString();
              }
            } catch (_) {
              // Skip if property doesn't exist
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Environment variables loading failed: $e');
    }
    
    return variables;
  }

  // Web-specific app initialization
  static Future<void> initializeWebApp() async {
    if (!kIsWeb) return;
    
    try {
      // Set up web-specific configurations
      await registerServiceWorker();
      await handleDeepLink();
      trackWebVitals();
      
      // Set up PWA meta tags dynamically if needed
      _setupPWAMetaTags();
      
      debugPrint('Web app initialized successfully');
    } catch (e) {
      debugPrint('Web app initialization failed: $e');
    }
  }

  static void _setupPWAMetaTags() {
    try {
      // Add or update viewport meta tag for PWA
      var viewport = html.document.querySelector('meta[name="viewport"]') as html.MetaElement?;
      if (viewport == null) {
        viewport = html.document.createElement('meta') as html.MetaElement;
        viewport.name = 'viewport';
        html.document.head?.append(viewport);
      }
      viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
      
      // Add theme color meta tag
      var themeColor = html.document.querySelector('meta[name="theme-color"]') as html.MetaElement?;
      if (themeColor == null) {
        themeColor = html.document.createElement('meta') as html.MetaElement;
        themeColor.name = 'theme-color';
        html.document.head?.append(themeColor);
      }
      themeColor.content = '#2196F3';
      
      // Add Apple PWA meta tags
      var appleMobileWebAppCapable = html.document.querySelector('meta[name="apple-mobile-web-app-capable"]') as html.MetaElement?;
      if (appleMobileWebAppCapable == null) {
        appleMobileWebAppCapable = html.document.createElement('meta') as html.MetaElement;
        appleMobileWebAppCapable.name = 'apple-mobile-web-app-capable';
        html.document.head?.append(appleMobileWebAppCapable);
      }
      appleMobileWebAppCapable.content = 'yes';
      
    } catch (e) {
      debugPrint('PWA meta tags setup failed: $e');
    }
  }
}

/// Environment configuration enum
enum Environment {
  development,
  staging,
  production,
}

/// Browser information enum
enum BrowserInfo {
  chrome,
  firefox,
  safari,
  edge,
  unknown,
}

/// Web feature flags configuration
class WebFeatureFlags {
  final bool enableServiceWorker;
  final bool enablePushNotifications;
  final bool enableOfflineMode;
  final bool enablePerformanceMonitoring;
  final bool enableAnalytics;
  final bool enableCacheOptimization;
  final bool enableWebAssembly;
  final bool enableWebGL;
  final bool enableIndexedDB;
  final bool enableWebShare;
  final bool enableClipboardAPI;
  final bool enableFileAPI;

  const WebFeatureFlags({
    required this.enableServiceWorker,
    required this.enablePushNotifications,
    required this.enableOfflineMode,
    required this.enablePerformanceMonitoring,
    required this.enableAnalytics,
    required this.enableCacheOptimization,
    required this.enableWebAssembly,
    required this.enableWebGL,
    required this.enableIndexedDB,
    required this.enableWebShare,
    required this.enableClipboardAPI,
    required this.enableFileAPI,
  });

  WebFeatureFlags copyWith({
    bool? enableServiceWorker,
    bool? enablePushNotifications,
    bool? enableOfflineMode,
    bool? enablePerformanceMonitoring,
    bool? enableAnalytics,
    bool? enableCacheOptimization,
    bool? enableWebAssembly,
    bool? enableWebGL,
    bool? enableIndexedDB,
    bool? enableWebShare,
    bool? enableClipboardAPI,
    bool? enableFileAPI,
  }) {
    return WebFeatureFlags(
      enableServiceWorker: enableServiceWorker ?? this.enableServiceWorker,
      enablePushNotifications: enablePushNotifications ?? this.enablePushNotifications,
      enableOfflineMode: enableOfflineMode ?? this.enableOfflineMode,
      enablePerformanceMonitoring: enablePerformanceMonitoring ?? this.enablePerformanceMonitoring,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      enableCacheOptimization: enableCacheOptimization ?? this.enableCacheOptimization,
      enableWebAssembly: enableWebAssembly ?? this.enableWebAssembly,
      enableWebGL: enableWebGL ?? this.enableWebGL,
      enableIndexedDB: enableIndexedDB ?? this.enableIndexedDB,
      enableWebShare: enableWebShare ?? this.enableWebShare,
      enableClipboardAPI: enableClipboardAPI ?? this.enableClipboardAPI,
      enableFileAPI: enableFileAPI ?? this.enableFileAPI,
    );
  }
}