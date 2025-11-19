import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Local notification service for in-app notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Notification channels
  static const String _timerChannelId = 'haul_timer_notifications';
  static const String _timerChannelName = 'Haul Timer';
  static const String _timerChannelDescription = 'Notifications for active haul timers';

  static const String _queueChannelId = 'queue_notifications';
  static const String _queueChannelName = 'Queue Updates';
  static const String _queueChannelDescription = 'Updates about grain elevator queues';

  static const String _generalChannelId = 'general_notifications';
  static const String _generalChannelName = 'General';
  static const String _generalChannelDescription = 'General app notifications';

  /// Initialize notification service
  Future<void> initialize() async {
    try {
      // Initialize timezone database
      tz.initializeTimeZones();

      // Android initialization settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize plugin
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions (iOS)
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _notifications
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }

      // Request permissions (Android 13+)
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      _initialized = true;

      if (kDebugMode) {
        debugPrint('✅ Notification service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Notification initialization error: $e');
      }
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      debugPrint('📬 Notification tapped: ${response.payload}');
    }

    // TODO: Handle navigation based on payload
    // Example: Navigate to timer screen if timer notification
    // You can use go_router here via a global key or callback
  }

  /// Show simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationChannel channel = NotificationChannel.general,
  }) async {
    if (!_initialized) return;

    try {
      final channelDetails = _getChannelDetails(channel);

      await _notifications.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelDetails.id,
            channelDetails.name,
            channelDescription: channelDetails.description,
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );

      if (kDebugMode) {
        debugPrint('📨 Notification shown: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Show notification error: $e');
      }
    }
  }

  /// Show timer milestone notification
  Future<void> showTimerMilestone({
    required String elevatorName,
    required int minutes,
  }) async {
    await showNotification(
      id: 1000 + minutes, // Unique ID based on milestone
      title: '⏱️ Haul Timer: $minutes minutes',
      body: 'You\'ve been at $elevatorName for $minutes minutes',
      payload: 'timer_milestone_$minutes',
      channel: NotificationChannel.timer,
    );
  }

  /// Show queue position update
  Future<void> showQueueUpdate({
    required String elevatorName,
    required int position,
    required int estimatedWait,
  }) async {
    await showNotification(
      id: 2000, // Fixed ID for queue updates (replaces previous)
      title: '🚜 Queue Update - $elevatorName',
      body: 'Position: #$position • Est. wait: $estimatedWait min',
      payload: 'queue_update',
      channel: NotificationChannel.queue,
    );
  }

  /// Show haul complete notification
  Future<void> showHaulComplete({
    required String elevatorName,
    required String duration,
  }) async {
    await showNotification(
      id: 3000,
      title: '✅ Haul Complete!',
      body: 'Finished at $elevatorName in $duration',
      payload: 'haul_complete',
      channel: NotificationChannel.general,
    );
  }

  /// Schedule notification for later
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    NotificationChannel channel = NotificationChannel.general,
  }) async {
    if (!_initialized) return;

    try {
      final channelDetails = _getChannelDetails(channel);

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelDetails.id,
            channelDetails.name,
            channelDescription: channelDetails.description,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      if (kDebugMode) {
        debugPrint('📅 Notification scheduled for: $scheduledDate');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Schedule notification error: $e');
      }
    }
  }

  /// Cancel notification by ID
  Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);

      if (kDebugMode) {
        debugPrint('🗑️ Notification cancelled: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Cancel notification error: $e');
      }
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();

      if (kDebugMode) {
        debugPrint('🗑️ All notifications cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Cancel all notifications error: $e');
      }
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Get pending notifications error: $e');
      }
      return [];
    }
  }

  /// Get channel details
  _ChannelDetails _getChannelDetails(NotificationChannel channel) {
    switch (channel) {
      case NotificationChannel.timer:
        return _ChannelDetails(
          id: _timerChannelId,
          name: _timerChannelName,
          description: _timerChannelDescription,
        );
      case NotificationChannel.queue:
        return _ChannelDetails(
          id: _queueChannelId,
          name: _queueChannelName,
          description: _queueChannelDescription,
        );
      case NotificationChannel.general:
        return _ChannelDetails(
          id: _generalChannelId,
          name: _generalChannelName,
          description: _generalChannelDescription,
        );
    }
  }
}

/// Notification channel enum
enum NotificationChannel {
  timer,
  queue,
  general,
}

/// Channel details
class _ChannelDetails {
  final String id;
  final String name;
  final String description;

  _ChannelDetails({
    required this.id,
    required this.name,
    required this.description,
  });
}
