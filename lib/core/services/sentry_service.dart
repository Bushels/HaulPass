import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Sentry service for crash reporting and performance monitoring
class SentryService {
  static final SentryService _instance = SentryService._internal();
  factory SentryService() => _instance;
  SentryService._internal();

  static SentryService get instance => _instance;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Initialize Sentry
  /// Set SENTRY_DSN environment variable or pass it directly
  Future<void> initialize({
    String? dsn,
    required Future<void> Function() appRunner,
  }) async {
    // Get DSN from environment or parameter
    final sentryDsn = dsn ?? const String.fromEnvironment('SENTRY_DSN');

    if (sentryDsn.isEmpty) {
      if (kDebugMode) {
        debugPrint('⚠️ Sentry DSN not configured');
        debugPrint('💡 Set SENTRY_DSN environment variable or pass to initialize()');
        debugPrint('💡 Get your DSN from: https://sentry.io/settings/projects/');
      }

      // Run app without Sentry
      await appRunner();
      return;
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();

      await SentryFlutter.init(
        (options) {
          options.dsn = sentryDsn;

          // Set release version
          options.release = '${packageInfo.packageName}@${packageInfo.version}+${packageInfo.buildNumber}';

          // Configure sample rates
          options.tracesSampleRate = kDebugMode ? 1.0 : 0.2; // 100% in debug, 20% in production
          options.profilesSampleRate = kDebugMode ? 1.0 : 0.2;

          // Enable/disable features
          options.enableAutoSessionTracking = true;
          options.attachScreenshot = true;
          options.attachViewHierarchy = true;

          // Debug settings
          options.debug = kDebugMode;
          options.diagnosticLevel = kDebugMode ? SentryLevel.debug : SentryLevel.warning;

          // Environment
          options.environment = kDebugMode ? 'debug' : 'production';

          // Before send callback - filter out sensitive data
          options.beforeSend = (event, {hint}) {
            // Filter out events in debug mode if needed
            if (kDebugMode && !const bool.fromEnvironment('SENTRY_IN_DEBUG', defaultValue: false)) {
              return null; // Don't send events in debug mode
            }

            // Remove sensitive data
            event = _sanitizeEvent(event);

            return event;
          };

          // Performance monitoring
          options.enableAutoPerformanceTracing = true;
          options.enableUserInteractionTracing = true;

          if (kDebugMode) {
            debugPrint('✅ Sentry initialized');
            debugPrint('📊 Environment: ${options.environment}');
            debugPrint('🔢 Release: ${options.release}');
          }
        },
        appRunner: appRunner,
      );

      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Sentry initialization error: $e');
      }

      // Run app anyway
      await appRunner();
    }
  }

  /// Sanitize event to remove sensitive data
  SentryEvent _sanitizeEvent(SentryEvent event) {
    // Remove sensitive data from request
    if (event.request != null) {
      final sanitizedHeaders = <String, String>{};
      event.request?.headers.forEach((key, value) {
        // Remove auth headers
        if (!key.toLowerCase().contains('auth') &&
            !key.toLowerCase().contains('token') &&
            !key.toLowerCase().contains('key')) {
          sanitizedHeaders[key] = value;
        }
      });

      event = event.copyWith(
        request: event.request?.copyWith(
          headers: sanitizedHeaders,
        ),
      );
    }

    return event;
  }

  /// Capture exception manually
  Future<void> captureException(
    dynamic exception, {
    dynamic stackTrace,
    String? hint,
  }) async {
    if (!_initialized) return;

    try {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        hint: hint != null ? Hint.withMap({'hint': hint}) : null,
      );

      if (kDebugMode) {
        debugPrint('📤 Exception sent to Sentry: $exception');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Sentry capture error: $e');
      }
    }
  }

  /// Capture message
  Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
  }) async {
    if (!_initialized) return;

    try {
      await Sentry.captureMessage(
        message,
        level: level,
      );

      if (kDebugMode) {
        debugPrint('📤 Message sent to Sentry: $message');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Sentry message error: $e');
      }
    }
  }

  /// Add breadcrumb
  void addBreadcrumb(
    String message, {
    String? category,
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? data,
  }) {
    if (!_initialized) return;

    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        level: level,
        data: data,
      ),
    );

    if (kDebugMode) {
      debugPrint('🍞 Breadcrumb: $message');
    }
  }

  /// Set user context
  Future<void> setUser({
    required String id,
    String? email,
    String? username,
    Map<String, dynamic>? extras,
  }) async {
    if (!_initialized) return;

    await Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(
          id: id,
          email: email,
          username: username,
          data: extras,
        ),
      );
    });

    if (kDebugMode) {
      debugPrint('👤 Sentry user set: $id');
    }
  }

  /// Clear user context
  Future<void> clearUser() async {
    if (!_initialized) return;

    await Sentry.configureScope((scope) {
      scope.setUser(null);
    });

    if (kDebugMode) {
      debugPrint('👤 Sentry user cleared');
    }
  }

  /// Set custom context
  Future<void> setContext({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    if (!_initialized) return;

    await Sentry.configureScope((scope) {
      scope.setContexts(key, value);
    });

    if (kDebugMode) {
      debugPrint('🔧 Sentry context set: $key');
    }
  }

  /// Start a transaction for performance monitoring
  ISentrySpan startTransaction({
    required String name,
    required String operation,
  }) {
    return Sentry.startTransaction(
      name,
      operation,
      bindToScope: true,
    );
  }
}
