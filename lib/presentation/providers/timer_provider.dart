import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/elevator_models.dart';
import '../../data/models/location_models.dart';
import 'auth_provider.dart';
import 'dart:async';

part 'timer_provider.g.dart';

/// Timer session provider using modern Riverpod patterns
@riverpod
class TimerNotifier extends _$TimerNotifier {
  Timer? _periodicTimer;

  @override
  TimerState build() {
    _initializeTimer();
    return TimerState();
  }

  void _initializeTimer() {
    // Load existing active session if any
    _loadActiveSession();
  }

  /// Load any existing active session
  Future<void> _loadActiveSession() async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('timer_sessions')
          .select()
          .eq('user_id', user.id)
          .eq('status', 'active')
          .single();

      final session = TimerSession.fromJson(response);
      state = state.copyWith(activeSession: session);
    } catch (e) {
      // No active session found, which is normal
      print('No active timer session found');
    }
  }

  /// Start a new timer session
  Future<void> startTimer({
    required String elevatorId,
    required String elevatorName,
    required AppLocation location,
    String? grainType,
    String? notes,
  }) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('User must be logged in to start timer');
      }

      // Check if there's already an active session
      if (state.activeSession != null) {
        throw Exception('A timer is already running. Stop it before starting a new one.');
      }

      state = state.copyWith(isLoading: true, error: null);

      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      final startTime = DateTime.now();

      // Create timer session
      final session = TimerSession(
        id: sessionId,
        elevatorId: elevatorId,
        elevatorName: elevatorName,
        location: location,
        grainType: grainType,
        startTime: startTime,
        status: TimerStatus.active,
        notes: notes,
      );

      // Save to database
      await Supabase.instance.client.from('timer_sessions').insert({
        'id': sessionId,
        'user_id': user.id,
        'elevator_id': elevatorId,
        'elevator_name': elevatorName,
        'location': {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'altitude': location.altitude,
          'accuracy': location.accuracy,
        },
        'grain_type': grainType,
        'start_time': startTime.toIso8601String(),
        'status': 'active',
        'notes': notes,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Add start event
      await _addTimerEvent(
        sessionId: sessionId,
        type: TimerEventType.start,
        description: 'Timer started at $elevatorName',
      );

      state = state.copyWith(
        activeSession: session,
        isLoading: false,
      );

      // Start periodic updates
      _startPeriodicUpdates(sessionId);
    } catch (e, stackTrace) {
      state = state.copyWith(
        error: 'Failed to start timer: $e',
        isLoading: false,
      );
      print('Start timer error: $e\n$stackTrace');
    }
  }

  /// Stop the active timer session
  Future<void> stopTimer() async {
    try {
      final session = state.activeSession;
      if (session == null) {
        throw Exception('No active timer session');
      }

      state = state.copyWith(isLoading: true, error: null);

      final endTime = DateTime.now();
      final totalDuration = endTime.difference(session.startTime);

      // Update session in database
      await Supabase.instance.client
          .from('timer_sessions')
          .update({
            'end_time': endTime.toIso8601String(),
            'total_duration_seconds': totalDuration.inSeconds,
            'status': 'completed',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', session.id);

      // Add completion event
      await _addTimerEvent(
        sessionId: session.id,
        type: TimerEventType.complete,
        description: 'Timer completed. Duration: ${_formatDuration(totalDuration)}',
      );

      final completedSession = session.copyWith(
        endTime: endTime,
        totalDuration: totalDuration,
        status: TimerStatus.completed,
      );

      state = state.copyWith(
        activeSession: null,
        completedSessions: [completedSession, ...state.completedSessions],
        isLoading: false,
      );

      _stopPeriodicUpdates();
    } catch (e, stackTrace) {
      state = state.copyWith(
        error: 'Failed to stop timer: $e',
        isLoading: false,
      );
      print('Stop timer error: $e\n$stackTrace');
    }
  }

  /// Pause the active timer session
  Future<void> pauseTimer() async {
    try {
      final session = state.activeSession;
      if (session == null) {
        throw Exception('No active timer session');
      }

      if (session.status == TimerStatus.paused) {
        // Resume if already paused
        return await resumeTimer();
      }

      final pauseTime = DateTime.now();
      final pausedDuration = pauseTime.difference(session.startTime);

      // Update session in database
      await Supabase.instance.client
          .from('timer_sessions')
          .update({
            'status': 'paused',
            'paused_at': pauseTime.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', session.id);

      // Add pause event
      await _addTimerEvent(
        sessionId: session.id,
        type: TimerEventType.pause,
        description: 'Timer paused',
      );

      final pausedSession = session.copyWith(
        status: TimerStatus.paused,
        metadata: {
          ...session.metadata ?? {},
          'paused_at': pauseTime.toIso8601String(),
          'paused_duration_seconds': pausedDuration.inSeconds,
        },
      );

      state = state.copyWith(activeSession: pausedSession);
    } catch (e, stackTrace) {
      state = state.copyWith(error: 'Failed to pause timer: $e');
      print('Pause timer error: $e\n$stackTrace');
    }
  }

  /// Resume the paused timer session
  Future<void> resumeTimer() async {
    try {
      final session = state.activeSession;
      if (session == null || session.status != TimerStatus.paused) {
        throw Exception('No paused timer session');
      }

      final resumeTime = DateTime.now();

      // Update session in database
      await Supabase.instance.client
          .from('timer_sessions')
          .update({
            'status': 'active',
            'resumed_at': resumeTime.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', session.id);

      // Add resume event
      await _addTimerEvent(
        sessionId: session.id,
        type: TimerEventType.resume,
        description: 'Timer resumed',
      );

      final resumedSession = session.copyWith(status: TimerStatus.active);

      state = state.copyWith(activeSession: resumedSession);
    } catch (e, stackTrace) {
      state = state.copyWith(error: 'Failed to resume timer: $e');
      print('Resume timer error: $e\n$stackTrace');
    }
  }

  /// Add a custom event to the timer session
  Future<void> addTimerEvent({
    required TimerEventType type,
    required String description,
    String? notes,
  }) async {
    try {
      final session = state.activeSession;
      if (session == null) {
        throw Exception('No active timer session');
      }

      await _addTimerEvent(
        sessionId: session.id,
        type: type,
        description: description,
        notes: notes,
      );

      // Update local state
      final event = TimerEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sessionId: session.id,
        type: type,
        description: description,
        timestamp: DateTime.now(),
        metadata: notes != null ? {'notes': notes} : null,
      );

      state = state.copyWith(
        activeSession: session.copyWith(
          events: [...session.events, event],
        ),
      );
    } catch (e, stackTrace) {
      state = state.copyWith(error: 'Failed to add timer event: $e');
      print('Add timer event error: $e\n$stackTrace');
    }
  }

  /// Internal method to add timer event to database
  Future<void> _addTimerEvent({
    required String sessionId,
    required TimerEventType type,
    required String description,
    String? notes,
  }) async {
    await Supabase.instance.client.from('timer_events').insert({
      'session_id': sessionId,
      'type': type.name,
      'description': description,
      'timestamp': DateTime.now().toIso8601String(),
      'metadata': notes != null ? {'notes': notes} : null,
    });
  }

  /// Load timer history
  Future<void> loadTimerHistory({int limit = 50}) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('timer_sessions')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(limit);

      final sessions = response.map((json) {
        return TimerSession.fromJson(json);
      }).toList();

      state = state.copyWith(completedSessions: sessions);
    } catch (e, stackTrace) {
      state = state.copyWith(error: 'Failed to load timer history: $e');
      print('Load timer history error: $e\n$stackTrace');
    }
  }

  /// Get timer statistics
  Future<TimerStats?> getTimerStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return null;

      final response = await Supabase.instance.client.rpc('get_timer_stats', params: {
        'user_id': user.id,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
      });

      return TimerStats.fromJson(response);
    } catch (e, stackTrace) {
      print('Get timer stats error: $e\n$stackTrace');
      return null;
    }
  }

  /// Start periodic updates for active timer
  void _startPeriodicUpdates(String sessionId) {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        // Update state to trigger UI refresh
        state = state.copyWith();
      },
    );
  }

  /// Stop periodic updates
  void _stopPeriodicUpdates() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

}

/// Timer state model
@riverpod
class TimerState extends _$TimerState {
  @override
  TimerState build() {
    return TimerState();
  }

  TimerState copyWith({
    TimerSession? activeSession,
    List<TimerSession> completedSessions = const [],
    List<TimerEvent> recentEvents = const [],
    bool isLoading = false,
    String? error,
    TimerStats? statistics,
    String? selectedElevatorId,
    String? selectedGrainType,
  }) {
    return TimerState(
      activeSession: activeSession,
      completedSessions: completedSessions,
      recentEvents: recentEvents,
      isLoading: isLoading,
      error: error,
      statistics: statistics,
      selectedElevatorId: selectedElevatorId,
      selectedGrainType: selectedGrainType,
    );
  }

  TimerState({
    this.activeSession,
    this.completedSessions = const [],
    this.recentEvents = const [],
    this.isLoading = false,
    this.error,
    this.statistics,
    this.selectedElevatorId,
    this.selectedGrainType,
  });

  final TimerSession? activeSession;
  final List<TimerSession> completedSessions;
  final List<TimerEvent> recentEvents;
  final bool isLoading;
  final String? error;
  final TimerStats? statistics;
  final String? selectedElevatorId;
  final String? selectedGrainType;
}

/// Provider for active timer session
@riverpod
TimerSession? activeTimer(ActiveTimerRef ref) {
  final timerState = ref.watch(timerNotifierProvider);
  return timerState.activeSession;
}

/// Provider for completed timer sessions
@riverpod
List<TimerSession> completedTimers(CompletedTimersRef ref) {
  final timerState = ref.watch(timerNotifierProvider);
  return timerState.completedSessions;
}

/// Provider for timer loading state
@riverpod
bool isTimerLoading(IsTimerLoadingRef ref) {
  final timerState = ref.watch(timerNotifierProvider);
  return timerState.isLoading;
}

/// Provider for timer error state
@riverpod
String? timerError(TimerErrorRef ref) {
  final timerState = ref.watch(timerNotifierProvider);
  return timerState.error;
}
