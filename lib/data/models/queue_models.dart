import 'package:json_annotation/json_annotation.dart';
import 'elevator_models.dart';

part 'queue_models.g.dart';

/// Elevator with real-time queue prediction data
class ElevatorWithQueue {
  final Elevator elevator;
  final QueueState queueState;
  final double? distanceKm;
  final int? estimatedDriveMinutes;

  const ElevatorWithQueue({
    required this.elevator,
    required this.queueState,
    this.distanceKm,
    this.estimatedDriveMinutes,
  });

  /// Estimated arrival time based on current time + drive time
  DateTime? get estimatedArrivalTime {
    if (estimatedDriveMinutes == null) return null;
    return DateTime.now().add(Duration(minutes: estimatedDriveMinutes!));
  }

  /// Formatted estimated arrival time
  String get formattedArrivalTime {
    if (estimatedArrivalTime == null) return '--:--';
    final time = estimatedArrivalTime!;
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Formatted distance
  String get formattedDistance {
    if (distanceKm == null) return '--';
    return '${distanceKm!.toStringAsFixed(1)} km';
  }

  /// Total estimated time: drive + wait + unload
  int get totalEstimatedMinutes {
    final drive = estimatedDriveMinutes ?? 0;
    return drive + queueState.estimatedWaitMinutes + queueState.avgUnloadMinutes;
  }

  /// Formatted total time
  String get formattedTotalTime {
    return _formatMinutes(totalEstimatedMinutes);
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins}m';
  }

  /// Copy with updated fields
  ElevatorWithQueue copyWith({
    Elevator? elevator,
    QueueState? queueState,
    double? distanceKm,
    int? estimatedDriveMinutes,
  }) {
    return ElevatorWithQueue(
      elevator: elevator ?? this.elevator,
      queueState: queueState ?? this.queueState,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedDriveMinutes: estimatedDriveMinutes ?? this.estimatedDriveMinutes,
    );
  }
}

/// Real-time queue state with predictions
@JsonSerializable()
class QueueState {
  /// Current number of trucks in line (confirmed by app users)
  final int currentTrucksInLine;

  /// Number of app users en route (anonymous count)
  final int appUsersEnRoute;

  /// Estimated wait time in minutes
  final int estimatedWaitMinutes;

  /// Typical wait time for this day/time (baseline)
  final int typicalWaitMinutes;

  /// Average unload time for this elevator
  final int avgUnloadMinutes;

  /// Busyness percentage (-100 to +100, where 0 is normal)
  final int busynessPercent;

  /// Status of elevator (open, busy, closed, etc.)
  final String status;

  /// Confidence level (0.0 to 1.0)
  final double confidence;

  /// Last updated timestamp
  final DateTime lastUpdated;

  const QueueState({
    required this.currentTrucksInLine,
    required this.appUsersEnRoute,
    required this.estimatedWaitMinutes,
    required this.typicalWaitMinutes,
    required this.avgUnloadMinutes,
    required this.busynessPercent,
    required this.status,
    required this.confidence,
    required this.lastUpdated,
  });

  factory QueueState.fromJson(Map<String, dynamic> json) => _$QueueStateFromJson(json);
  Map<String, dynamic> toJson() => _$QueueStateToJson(this);

  /// Formatted wait time
  String get formattedWaitTime {
    if (estimatedWaitMinutes < 60) {
      return '${estimatedWaitMinutes} min';
    }
    final hours = estimatedWaitMinutes ~/ 60;
    final minutes = estimatedWaitMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  /// Status color based on wait time
  QueueColor get queueColor {
    if (estimatedWaitMinutes < 30) {
      return QueueColor.fast;
    } else if (estimatedWaitMinutes < 120) {
      return QueueColor.medium;
    } else {
      return QueueColor.slow;
    }
  }

  /// Whether elevator is operational
  bool get isOperational {
    return status == 'open' || status == 'busy';
  }

  /// Status display text
  String get statusDisplay {
    switch (status) {
      case 'open':
        return 'Open';
      case 'busy':
        return 'Busy';
      case 'closed':
        return 'Closed';
      case 'maintenance':
        return 'Maintenance';
      default:
        return status;
    }
  }

  /// Confidence text
  String get confidenceText {
    if (confidence >= 0.8) return 'High confidence';
    if (confidence >= 0.6) return 'Medium confidence';
    return 'Low confidence';
  }

  /// Busyness text (positive or negative)
  String get busynessText {
    if (busynessPercent == 0) return 'Normal';
    if (busynessPercent > 0) return '${busynessPercent}% busier than usual';
    return '${busynessPercent.abs()}% slower than usual';
  }

  /// Short busyness text for compact display
  String get shortBusynessText {
    if (busynessPercent == 0) return 'Normal';
    if (busynessPercent > 0) return '+${busynessPercent}%';
    return '${busynessPercent}%';
  }

  /// Copy with updated fields
  QueueState copyWith({
    int? currentTrucksInLine,
    int? appUsersEnRoute,
    int? estimatedWaitMinutes,
    int? typicalWaitMinutes,
    int? avgUnloadMinutes,
    int? busynessPercent,
    String? status,
    double? confidence,
    DateTime? lastUpdated,
  }) {
    return QueueState(
      currentTrucksInLine: currentTrucksInLine ?? this.currentTrucksInLine,
      appUsersEnRoute: appUsersEnRoute ?? this.appUsersEnRoute,
      estimatedWaitMinutes: estimatedWaitMinutes ?? this.estimatedWaitMinutes,
      typicalWaitMinutes: typicalWaitMinutes ?? this.typicalWaitMinutes,
      avgUnloadMinutes: avgUnloadMinutes ?? this.avgUnloadMinutes,
      busynessPercent: busynessPercent ?? this.busynessPercent,
      status: status ?? this.status,
      confidence: confidence ?? this.confidence,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Factory for creating empty/default state
  factory QueueState.empty() {
    return QueueState(
      currentTrucksInLine: 0,
      appUsersEnRoute: 0,
      estimatedWaitMinutes: 0,
      typicalWaitMinutes: 0,
      avgUnloadMinutes: 8,
      busynessPercent: 0,
      status: 'unknown',
      confidence: 0.0,
      lastUpdated: DateTime.now(),
    );
  }

  /// Factory for creating sample data (for testing/demo)
  factory QueueState.sample({
    int trucksInLine = 2,
    int waitMinutes = 18,
    int typical = 15,
  }) {
    final busyness = typical > 0 ? (((waitMinutes - typical) / typical) * 100).round() : 0;

    return QueueState(
      currentTrucksInLine: trucksInLine,
      appUsersEnRoute: 1,
      estimatedWaitMinutes: waitMinutes,
      typicalWaitMinutes: typical,
      avgUnloadMinutes: 8,
      busynessPercent: busyness,
      status: 'open',
      confidence: 0.85,
      lastUpdated: DateTime.now(),
    );
  }
}

/// Queue color enum for visual representation
enum QueueColor {
  fast,    // < 30 min - Green
  medium,  // 30-120 min - Orange
  slow,    // > 120 min - Red
}
