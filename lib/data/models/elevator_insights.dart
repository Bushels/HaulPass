import 'package:freezed_annotation/freezed_annotation.dart';

part 'elevator_insights.freezed.dart';
part 'elevator_insights.g.dart';

/// Elevator wait time insights with comparisons
@freezed
class ElevatorInsights with _$ElevatorInsights {
  const ElevatorInsights._();

  const factory ElevatorInsights({
    required String elevatorId,
    required String elevatorName,
    required int currentWaitMinutes,
    @Default(0) int averageWaitMinutes,
    @Default(0) int yesterdayWaitMinutes,
    @Default(0) int lastWeekSameDayWaitMinutes,
    @Default(0) int currentLineup,
    required DateTime lastUpdated,
    String? status,
    @Default({}) Map<String, dynamic> metadata,
  }) = _ElevatorInsights;

  factory ElevatorInsights.fromJson(Map<String, dynamic> json) =>
      _$ElevatorInsightsFromJson(json);

  /// Calculate percentage difference from yesterday
  double get percentageFromYesterday {
    if (yesterdayWaitMinutes == 0) return 0.0;
    final diff = currentWaitMinutes - yesterdayWaitMinutes;
    return (diff / yesterdayWaitMinutes) * 100;
  }

  /// Calculate percentage difference from same day last week
  double get percentageFromLastWeek {
    if (lastWeekSameDayWaitMinutes == 0) return 0.0;
    final diff = currentWaitMinutes - lastWeekSameDayWaitMinutes;
    return (diff / lastWeekSameDayWaitMinutes) * 100;
  }

  /// Calculate percentage difference from average
  double get percentageFromAverage {
    if (averageWaitMinutes == 0) return 0.0;
    final diff = currentWaitMinutes - averageWaitMinutes;
    return (diff / averageWaitMinutes) * 100;
  }

  /// Get formatted comparison text for yesterday
  String get yesterdayComparisonText {
    final pct = percentageFromYesterday;
    if (pct.abs() < 1) return 'Same as yesterday';

    final faster = pct < 0;
    final absPct = pct.abs().toStringAsFixed(0);

    return faster
        ? '$absPct% quicker than yesterday'
        : '$absPct% slower than yesterday';
  }

  /// Get formatted comparison text for same day last week
  String get lastWeekComparisonText {
    final pct = percentageFromLastWeek;
    if (pct.abs() < 1) return 'Same as last week';

    final faster = pct < 0;
    final absPct = pct.abs().toStringAsFixed(0);
    final dayName = _getDayName();

    return faster
        ? '$absPct% faster than usual for $dayName'
        : '$absPct% slower than usual for $dayName';
  }

  /// Get formatted comparison text for average
  String get averageComparisonText {
    final pct = percentageFromAverage;
    if (pct.abs() < 1) return 'Average wait time';

    final faster = pct < 0;
    final absPct = pct.abs().toStringAsFixed(0);

    return faster
        ? '$absPct% faster than average'
        : '$absPct% slower than average';
  }

  /// Get current day name
  String _getDayName() {
    final now = DateTime.now();
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[now.weekday % 7];
  }

  /// Get wait time display
  String get waitTimeDisplay {
    if (currentWaitMinutes < 60) {
      return '$currentWaitMinutes min';
    }
    final hours = currentWaitMinutes ~/ 60;
    final mins = currentWaitMinutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }

  /// Is the elevator busy?
  bool get isBusy => currentLineup > 5 || currentWaitMinutes > 30;

  /// Is the wait time good?
  bool get isGoodWaitTime => currentWaitMinutes < averageWaitMinutes;
}

/// User statistics for the dashboard
@freezed
class UserStatistics with _$UserStatistics {
  const UserStatistics._();

  const factory UserStatistics({
    required String userId,
    @Default(0) int totalHauls,
    @Default(0.0) double totalWeightKg,
    @Default(0) int averageWaitMinutes,
    @Default(0.0) double averageMoisture,
    @Default(0.0) double averageDockagePercent,
    @Default({}) Map<String, int> grainTypeBreakdown,
    @Default({}) Map<String, int> elevatorBreakdown,
    @Default({}) Map<String, double> avgWaitByElevator,
    DateTime? lastHaulDate,
    @Default(0) int last24HoursHauls,
    @Default(0.0) double last24HoursWeightKg,
    required DateTime lastUpdated,
  }) = _UserStatistics;

  factory UserStatistics.fromJson(Map<String, dynamic> json) =>
      _$UserStatisticsFromJson(json);

  /// Get formatted total weight
  String get totalWeightDisplay {
    if (totalWeightKg < 1000) {
      return '${totalWeightKg.toStringAsFixed(0)} kg';
    } else if (totalWeightKg < 1000000) {
      return '${(totalWeightKg / 1000).toStringAsFixed(1)} tonnes';
    } else {
      return '${(totalWeightKg / 1000000).toStringAsFixed(2)}M tonnes';
    }
  }

  /// Get formatted average wait time
  String get avgWaitDisplay {
    if (averageWaitMinutes < 60) {
      return '$averageWaitMinutes min';
    }
    final hours = averageWaitMinutes ~/ 60;
    final mins = averageWaitMinutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }

  /// Get total weight in pounds
  double get totalWeightLbs => totalWeightKg * 2.20462;

  /// Get formatted total weight in pounds
  String get totalWeightLbsDisplay {
    if (totalWeightLbs < 1000) {
      return '${totalWeightLbs.toStringAsFixed(0)} lbs';
    } else if (totalWeightLbs < 1000000) {
      return '${(totalWeightLbs / 1000).toStringAsFixed(1)}k lbs';
    } else {
      return '${(totalWeightLbs / 1000000).toStringAsFixed(2)}M lbs';
    }
  }

  /// Get most hauled grain type
  String get topGrainType {
    if (grainTypeBreakdown.isEmpty) return 'None';
    return grainTypeBreakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get most visited elevator
  String get topElevator {
    if (elevatorBreakdown.isEmpty) return 'None';
    return elevatorBreakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

/// Haul session model
@freezed
class HaulSession with _$HaulSession {
  const HaulSession._();

  const factory HaulSession({
    required String id,
    required String userId,
    required String elevatorId,
    required String elevatorName,
    String? truckId,
    String? truckName,
    String? grainType,
    double? weightKg,
    double? moisturePercent,
    double? dockagePercent,
    String? moistureSource, // 'bin' or 'elevator'
    required DateTime startTime,
    DateTime? loadStartTime,
    DateTime? loadEndTime,
    DateTime? driveStartTime,
    DateTime? arrivalTime,
    DateTime? queueStartTime,
    DateTime? unloadStartTime,
    DateTime? unloadEndTime,
    DateTime? endTime,
    @Default('in_progress') String status,
    String? notes,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _HaulSession;

  factory HaulSession.fromJson(Map<String, dynamic> json) =>
      _$HaulSessionFromJson(json);

  /// Calculate total duration in minutes
  int get totalDurationMinutes {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inMinutes;
  }

  /// Calculate load duration in minutes
  int get loadDurationMinutes {
    if (loadStartTime == null || loadEndTime == null) return 0;
    return loadEndTime!.difference(loadStartTime!).inMinutes;
  }

  /// Calculate drive duration in minutes
  int get driveDurationMinutes {
    if (driveStartTime == null || arrivalTime == null) return 0;
    return arrivalTime!.difference(driveStartTime!).inMinutes;
  }

  /// Calculate wait duration in minutes
  int get waitDurationMinutes {
    if (queueStartTime == null || unloadStartTime == null) return 0;
    return unloadStartTime!.difference(queueStartTime!).inMinutes;
  }

  /// Calculate unload duration in minutes
  int get unloadDurationMinutes {
    if (unloadStartTime == null || unloadEndTime == null) return 0;
    return unloadEndTime!.difference(unloadStartTime!).inMinutes;
  }

  /// Get formatted total duration
  String get totalDurationDisplay {
    final mins = totalDurationMinutes;
    if (mins < 60) return '$mins min';
    final hours = mins ~/ 60;
    final remainingMins = mins % 60;
    return remainingMins > 0 ? '${hours}h ${remainingMins}m' : '${hours}h';
  }

  /// Is session complete?
  bool get isComplete => status == 'completed';

  /// Is session in progress?
  bool get isInProgress => status == 'in_progress';
}
