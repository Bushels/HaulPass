import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/elevator_queue_service.dart';
import '../../core/services/queue_alert_manager.dart';
import '../../data/models/elevator_insights.dart';

part 'dashboard_providers.g.dart';

/// Provider for favorite elevator ID
/// TODO: Replace with user preferences from database
@riverpod
String favoriteElevatorId(FavoriteElevatorIdRef ref) {
  // For now, return a hardcoded value
  // In production, fetch from user preferences
  return '1';
}

/// Provider for favorite elevator name
/// TODO: Fetch from elevators_import table
@riverpod
String favoriteElevatorName(FavoriteElevatorNameRef ref) {
  // For now, return a hardcoded value
  // In production, fetch from elevators_import table
  return 'Prairie Gold Co-op';
}

/// Provider for live elevator insights (combines status with historical data)
@riverpod
Stream<ElevatorInsights> liveElevatorInsights(
  LiveElevatorInsightsRef ref,
  String elevatorId,
) async* {
  final queueService = ref.watch(elevatorQueueServiceProvider);

  // First emit mock data immediately to prevent loading state
  yield ElevatorInsights(
    elevatorId: elevatorId,
    elevatorName: ref.read(favoriteElevatorNameProvider),
    currentWaitMinutes: 8,
    averageWaitMinutes: 18,
    yesterdayWaitMinutes: 18,
    lastWeekSameDayWaitMinutes: 25,
    currentLineup: 2,
    lastUpdated: DateTime.now(),
    status: 'open',
  );

  // Subscribe to real-time status updates
  await for (final status in queueService.subscribeToElevator(elevatorId)) {
    // Fetch historical data for comparisons
    final history = await queueService.getQueueHistory(
      elevatorId: elevatorId,
      limit: 20,
    );

    // Calculate yesterday's wait time (average from ~24 hours ago)
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayUpdates = history.where((update) {
      final diff = yesterday.difference(update.createdAt).abs();
      return diff < const Duration(hours: 2);
    }).toList();
    final yesterdayWait = yesterdayUpdates.isNotEmpty
        ? (yesterdayUpdates
                    .map((u) => u.waitTimeMinutes)
                    .reduce((a, b) => a + b) /
                yesterdayUpdates.length)
            .round()
        : status.estimatedWaitTime;

    // Calculate last week same day wait time
    final lastWeek = DateTime.now().subtract(const Duration(days: 7));
    final lastWeekUpdates = history.where((update) {
      final diff = lastWeek.difference(update.createdAt).abs();
      return diff < const Duration(hours: 2);
    }).toList();
    final lastWeekWait = lastWeekUpdates.isNotEmpty
        ? (lastWeekUpdates
                    .map((u) => u.waitTimeMinutes)
                    .reduce((a, b) => a + b) /
                lastWeekUpdates.length)
            .round()
        : status.estimatedWaitTime;

    // Calculate average wait time from all history
    final avgWait = history.isNotEmpty
        ? (history.map((u) => u.waitTimeMinutes).reduce((a, b) => a + b) /
                history.length)
            .round()
        : status.estimatedWaitTime;

    // Get elevator name from provider
    final elevatorName = ref.read(favoriteElevatorNameProvider);

    // Create insights object
    yield ElevatorInsights(
      elevatorId: elevatorId,
      elevatorName: elevatorName,
      currentWaitMinutes: status.estimatedWaitTime,
      averageWaitMinutes: avgWait,
      yesterdayWaitMinutes: yesterdayWait,
      lastWeekSameDayWaitMinutes: lastWeekWait,
      currentLineup: status.currentLineup,
      lastUpdated: status.lastUpdated,
      status: status.status,
    );
  }
}

/// Provider for mock user statistics
/// TODO: Replace with actual database queries
@riverpod
UserStatistics userStatistics(UserStatisticsRef ref) {
  // Get current user ID from Supabase
  final userId = Supabase.instance.client.auth.currentUser?.id ?? '';

  // Mock data for now - in production, fetch from database
  return UserStatistics(
    userId: userId,
    totalHauls: 124,
    totalWeightKg: 456000,
    averageWaitMinutes: 22,
    averageMoisture: 14.2,
    averageDockagePercent: 1.8,
    grainTypeBreakdown: const {
      'Wheat': 75,
      'Canola': 35,
      'Barley': 14,
    },
    elevatorBreakdown: const {
      'Prairie Gold Co-op': 45,
      'Viterra': 32,
      'Cargill': 28,
    },
    last24HoursHauls: 3,
    last24HoursWeightKg: 11200,
    lastUpdated: DateTime.now(),
  );
}
