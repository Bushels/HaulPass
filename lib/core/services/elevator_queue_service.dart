import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/elevator_insights.dart';

part 'elevator_queue_service.g.dart';

/// Service for managing real-time elevator queue data
class ElevatorQueueService {
  final SupabaseClient _supabase;
  final Map<String, RealtimeChannel> _subscriptions = {};

  ElevatorQueueService(this._supabase);

  /// Subscribe to real-time updates for a specific elevator
  Stream<ElevatorStatus> subscribeToElevator(String elevatorId) {
    final controller = StreamController<ElevatorStatus>();

    // Create unique channel name
    final channelName = 'elevator_status_$elevatorId';

    // Remove existing subscription if any
    if (_subscriptions.containsKey(channelName)) {
      _subscriptions[channelName]?.unsubscribe();
      _subscriptions.remove(channelName);
    }

    // Create new subscription
    final channel = _supabase
        .channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'elevator_status',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'elevator_id',
            value: elevatorId,
          ),
          callback: (payload) {
            try {
              final record = payload.newRecord;
              if (record.isNotEmpty) {
                final status = ElevatorStatus.fromJson(record);
                controller.add(status);
              }
            } catch (e) {
              controller.addError(e);
            }
          },
        )
        .subscribe();

    _subscriptions[channelName] = channel;

    // Load initial data
    _loadInitialElevatorStatus(elevatorId).then((status) {
      if (status != null && !controller.isClosed) {
        controller.add(status);
      }
    }).catchError((error) {
      if (!controller.isClosed) {
        controller.addError(error);
      }
    });

    // Clean up on stream cancellation
    controller.onCancel = () {
      channel.unsubscribe();
      _subscriptions.remove(channelName);
    };

    return controller.stream;
  }

  /// Load initial elevator status
  Future<ElevatorStatus?> _loadInitialElevatorStatus(String elevatorId) async {
    try {
      final response = await _supabase
          .from('elevator_status')
          .select()
          .eq('elevator_id', elevatorId)
          .maybeSingle();

      if (response != null) {
        return ElevatorStatus.fromJson(response);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get current elevator status (one-time fetch)
  Future<ElevatorStatus?> getElevatorStatus(String elevatorId) async {
    try {
      final response = await _supabase
          .from('elevator_status')
          .select()
          .eq('elevator_id', elevatorId)
          .maybeSingle();

      if (response != null) {
        return ElevatorStatus.fromJson(response);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Update elevator status (farmer reports current queue)
  Future<void> updateElevatorStatus({
    required String elevatorId,
    required int currentLineup,
    required int estimatedWaitMinutes,
    required String status,
  }) async {
    await _supabase.from('elevator_status').upsert({
      'elevator_id': elevatorId,
      'current_lineup': currentLineup,
      'estimated_wait_time': estimatedWaitMinutes,
      'status': status,
      'last_updated': DateTime.now().toIso8601String(),
    }, onConflict: 'elevator_id');

    // Also log to queue_updates for historical tracking
    await _supabase.from('queue_updates').insert({
      'elevator_id': elevatorId,
      'lineup_count': currentLineup,
      'wait_time_minutes': estimatedWaitMinutes,
      'reported_by': _supabase.auth.currentUser?.id,
    });
  }

  /// Get queue update history for an elevator
  Future<List<QueueUpdate>> getQueueHistory({
    required String elevatorId,
    int limit = 20,
  }) async {
    final response = await _supabase
        .from('queue_updates')
        .select()
        .eq('elevator_id', elevatorId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => QueueUpdate.fromJson(json))
        .toList();
  }

  /// Set user's current queue status
  Future<void> setUserQueueStatus({
    required String elevatorId,
    required String status,
    bool silenceAlerts = false,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('user_queue_status').upsert({
      'user_id': userId,
      'elevator_id': elevatorId,
      'status': status,
      'alerts_silenced': silenceAlerts,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id');
  }

  /// Get user's current queue status
  Future<UserQueueStatus?> getUserQueueStatus() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _supabase
        .from('user_queue_status')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response != null) {
      return UserQueueStatus.fromJson(response);
    }
    return null;
  }

  /// Clear user's queue status (when haul is finished)
  Future<void> clearUserQueueStatus() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase
        .from('user_queue_status')
        .delete()
        .eq('user_id', userId);
  }

  /// Dispose of all subscriptions
  void dispose() {
    for (final channel in _subscriptions.values) {
      channel.unsubscribe();
    }
    _subscriptions.clear();
  }
}

/// Model for elevator status
class ElevatorStatus {
  final String id;
  final String elevatorId;
  final int currentLineup;
  final int estimatedWaitTime;
  final String status;
  final DateTime lastUpdated;

  ElevatorStatus({
    required this.id,
    required this.elevatorId,
    required this.currentLineup,
    required this.estimatedWaitTime,
    required this.status,
    required this.lastUpdated,
  });

  factory ElevatorStatus.fromJson(Map<String, dynamic> json) {
    return ElevatorStatus(
      id: json['id'] as String,
      elevatorId: json['elevator_id'].toString(),
      currentLineup: json['current_lineup'] as int? ?? 0,
      estimatedWaitTime: json['estimated_wait_time'] as int? ?? 0,
      status: json['status'] as String? ?? 'open',
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'elevator_id': elevatorId,
      'current_lineup': currentLineup,
      'estimated_wait_time': estimatedWaitTime,
      'status': status,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

/// Model for queue update history
class QueueUpdate {
  final String id;
  final String elevatorId;
  final int lineupCount;
  final int waitTimeMinutes;
  final String? reportedBy;
  final DateTime createdAt;

  QueueUpdate({
    required this.id,
    required this.elevatorId,
    required this.lineupCount,
    required this.waitTimeMinutes,
    this.reportedBy,
    required this.createdAt,
  });

  factory QueueUpdate.fromJson(Map<String, dynamic> json) {
    return QueueUpdate(
      id: json['id'] as String,
      elevatorId: json['elevator_id'].toString(),
      lineupCount: json['lineup_count'] as int,
      waitTimeMinutes: json['wait_time_minutes'] as int,
      reportedBy: json['reported_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Model for user queue status
class UserQueueStatus {
  final String userId;
  final String? elevatorId;
  final String status;
  final bool alertsSilenced;
  final DateTime startedAt;
  final DateTime updatedAt;

  UserQueueStatus({
    required this.userId,
    this.elevatorId,
    required this.status,
    required this.alertsSilenced,
    required this.startedAt,
    required this.updatedAt,
  });

  factory UserQueueStatus.fromJson(Map<String, dynamic> json) {
    return UserQueueStatus(
      userId: json['user_id'] as String,
      elevatorId: json['elevator_id']?.toString(),
      status: json['status'] as String,
      alertsSilenced: json['alerts_silenced'] as bool? ?? false,
      startedAt: DateTime.parse(json['started_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

@riverpod
ElevatorQueueService elevatorQueueService(ElevatorQueueServiceRef ref) {
  final supabase = Supabase.instance.client;
  final service = ElevatorQueueService(supabase);

  // Dispose when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
}

@riverpod
Stream<ElevatorStatus> liveElevatorStatus(
  LiveElevatorStatusRef ref,
  String elevatorId,
) {
  final service = ref.watch(elevatorQueueServiceProvider);
  return service.subscribeToElevator(elevatorId);
}

@riverpod
Future<UserQueueStatus?> userQueueStatus(UserQueueStatusRef ref) async {
  final service = ref.watch(elevatorQueueServiceProvider);
  return service.getUserQueueStatus();
}
