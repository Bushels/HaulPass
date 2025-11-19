import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'elevator_queue_service.dart';

part 'queue_alert_manager.g.dart';

/// Alert types for queue changes
enum QueueAlertType {
  queueGrowing,
  queueShrinking,
  waitTimeIncreased,
  waitTimeDecreased,
  elevatorStatusChanged,
}

/// Alert data model
class QueueAlert {
  final QueueAlertType type;
  final String elevatorId;
  final String elevatorName;
  final String message;
  final int currentLineup;
  final int previousLineup;
  final int currentWaitTime;
  final int previousWaitTime;
  final DateTime timestamp;

  QueueAlert({
    required this.type,
    required this.elevatorId,
    required this.elevatorName,
    required this.message,
    required this.currentLineup,
    required this.previousLineup,
    required this.currentWaitTime,
    required this.previousWaitTime,
    required this.timestamp,
  });

  /// Get priority level (higher = more urgent)
  int get priority {
    switch (type) {
      case QueueAlertType.queueGrowing:
        final increase = currentLineup - previousLineup;
        if (increase >= 5) return 3; // High priority
        if (increase >= 3) return 2; // Medium priority
        return 1; // Low priority
      case QueueAlertType.waitTimeIncreased:
        final increase = currentWaitTime - previousWaitTime;
        if (increase >= 20) return 3; // High priority
        if (increase >= 15) return 2; // Medium priority
        return 1; // Low priority
      case QueueAlertType.elevatorStatusChanged:
        return 3; // Always high priority
      default:
        return 1; // Low priority
    }
  }
}

/// Service to manage queue alerts and notifications
class QueueAlertManager {
  final ElevatorQueueService _queueService;
  final Map<String, ElevatorStatus> _lastStatus = {};
  final Map<String, DateTime> _lastAlertTime = {};
  final StreamController<QueueAlert> _alertController =
      StreamController<QueueAlert>.broadcast();

  // Configurable thresholds
  static const int lineupThreshold = 3; // Alert if queue grows by 3+ trucks
  static const int waitTimeThreshold = 15; // Alert if wait increases by 15+ min
  static const Duration alertDebounce = Duration(seconds: 3); // Prevent spam

  QueueAlertManager(this._queueService);

  /// Stream of alerts
  Stream<QueueAlert> get alerts => _alertController.stream;

  /// Start monitoring an elevator for changes
  StreamSubscription<ElevatorStatus> monitorElevator({
    required String elevatorId,
    required String elevatorName,
  }) {
    return _queueService.subscribeToElevator(elevatorId).listen(
      (status) {
        _handleStatusUpdate(elevatorId, elevatorName, status);
      },
      onError: (error) {
        debugPrint('Error monitoring elevator $elevatorId: $error');
      },
    );
  }

  /// Handle status update and generate alerts
  void _handleStatusUpdate(
    String elevatorId,
    String elevatorName,
    ElevatorStatus newStatus,
  ) {
    final previousStatus = _lastStatus[elevatorId];

    // Store current status
    _lastStatus[elevatorId] = newStatus;

    // Skip if this is the first update
    if (previousStatus == null) return;

    // Check if we should debounce alerts
    final lastAlert = _lastAlertTime[elevatorId];
    if (lastAlert != null &&
        DateTime.now().difference(lastAlert) < alertDebounce) {
      return; // Skip to prevent alert spam
    }

    // Check for significant queue growth
    if (newStatus.currentLineup - previousStatus.currentLineup >=
        lineupThreshold) {
      final increase = newStatus.currentLineup - previousStatus.currentLineup;
      final alert = QueueAlert(
        type: QueueAlertType.queueGrowing,
        elevatorId: elevatorId,
        elevatorName: elevatorName,
        message: 'Queue growing fast! +$increase trucks in line',
        currentLineup: newStatus.currentLineup,
        previousLineup: previousStatus.currentLineup,
        currentWaitTime: newStatus.estimatedWaitTime,
        previousWaitTime: previousStatus.estimatedWaitTime,
        timestamp: DateTime.now(),
      );
      _emitAlert(elevatorId, alert);
    }

    // Check for significant wait time increase
    if (newStatus.estimatedWaitTime - previousStatus.estimatedWaitTime >=
        waitTimeThreshold) {
      final increase =
          newStatus.estimatedWaitTime - previousStatus.estimatedWaitTime;
      final alert = QueueAlert(
        type: QueueAlertType.waitTimeIncreased,
        elevatorId: elevatorId,
        elevatorName: elevatorName,
        message: 'Wait time increased by +$increase minutes',
        currentLineup: newStatus.currentLineup,
        previousLineup: previousStatus.currentLineup,
        currentWaitTime: newStatus.estimatedWaitTime,
        previousWaitTime: previousStatus.estimatedWaitTime,
        timestamp: DateTime.now(),
      );
      _emitAlert(elevatorId, alert);
    }

    // Check for elevator status change
    if (newStatus.status != previousStatus.status) {
      final alert = QueueAlert(
        type: QueueAlertType.elevatorStatusChanged,
        elevatorId: elevatorId,
        elevatorName: elevatorName,
        message:
            'Elevator status changed: ${previousStatus.status} → ${newStatus.status}',
        currentLineup: newStatus.currentLineup,
        previousLineup: previousStatus.currentLineup,
        currentWaitTime: newStatus.estimatedWaitTime,
        previousWaitTime: previousStatus.estimatedWaitTime,
        timestamp: DateTime.now(),
      );
      _emitAlert(elevatorId, alert);
    }

    // Check for significant queue decrease (good news!)
    if (previousStatus.currentLineup - newStatus.currentLineup >= 3) {
      final decrease = previousStatus.currentLineup - newStatus.currentLineup;
      final alert = QueueAlert(
        type: QueueAlertType.queueShrinking,
        elevatorId: elevatorId,
        elevatorName: elevatorName,
        message: 'Queue moving! -$decrease trucks in line',
        currentLineup: newStatus.currentLineup,
        previousLineup: previousStatus.currentLineup,
        currentWaitTime: newStatus.estimatedWaitTime,
        previousWaitTime: previousStatus.estimatedWaitTime,
        timestamp: DateTime.now(),
      );
      _emitAlert(elevatorId, alert);
    }

    // Check for significant wait time decrease (good news!)
    if (previousStatus.estimatedWaitTime - newStatus.estimatedWaitTime >= 10) {
      final decrease =
          previousStatus.estimatedWaitTime - newStatus.estimatedWaitTime;
      final alert = QueueAlert(
        type: QueueAlertType.waitTimeDecreased,
        elevatorId: elevatorId,
        elevatorName: elevatorName,
        message: 'Wait time decreased by -$decrease minutes',
        currentLineup: newStatus.currentLineup,
        previousLineup: previousStatus.currentLineup,
        currentWaitTime: newStatus.estimatedWaitTime,
        previousWaitTime: previousStatus.estimatedWaitTime,
        timestamp: DateTime.now(),
      );
      _emitAlert(elevatorId, alert);
    }
  }

  /// Emit alert and update debounce timer
  void _emitAlert(String elevatorId, QueueAlert alert) {
    _lastAlertTime[elevatorId] = DateTime.now();
    _alertController.add(alert);
    debugPrint('Alert: ${alert.message}');
  }

  /// Check if alerts should be silenced for current user
  Future<bool> shouldSilenceAlerts() async {
    final userStatus = await _queueService.getUserQueueStatus();

    // Silence alerts if user is waiting in queue or unloading
    if (userStatus != null) {
      return userStatus.alertsSilenced ||
          userStatus.status == 'waiting_in_queue' ||
          userStatus.status == 'unloading';
    }

    return false;
  }

  /// Get the last known status for an elevator
  ElevatorStatus? getLastStatus(String elevatorId) {
    return _lastStatus[elevatorId];
  }

  /// Clear monitoring data
  void clear() {
    _lastStatus.clear();
    _lastAlertTime.clear();
  }

  /// Dispose resources
  void dispose() {
    _alertController.close();
    _lastStatus.clear();
    _lastAlertTime.clear();
  }
}

@riverpod
QueueAlertManager queueAlertManager(QueueAlertManagerRef ref) {
  final queueService = ref.watch(elevatorQueueServiceProvider);
  final manager = QueueAlertManager(queueService);

  // Dispose when provider is disposed
  ref.onDispose(() {
    manager.dispose();
  });

  return manager;
}

@riverpod
Stream<QueueAlert> elevatorAlerts(
  ElevatorAlertsRef ref,
  String elevatorId,
  String elevatorName,
) async* {
  final manager = ref.watch(queueAlertManagerProvider);

  // Start monitoring
  final subscription = manager.monitorElevator(
    elevatorId: elevatorId,
    elevatorName: elevatorName,
  );

  // Clean up subscription when provider is disposed
  ref.onDispose(() {
    subscription.cancel();
  });

  // Forward alerts from the manager
  await for (final alert in manager.alerts) {
    // Only emit alerts for this specific elevator
    if (alert.elevatorId == elevatorId) {
      // Check if we should silence alerts
      final shouldSilence = await manager.shouldSilenceAlerts();
      if (!shouldSilence) {
        yield alert;
      }
    }
  }
}
