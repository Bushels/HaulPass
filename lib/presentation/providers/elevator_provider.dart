import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/elevator_models.dart';
import '../../data/models/location_models.dart';
import '../../core/services/supabase_config.dart';
import 'auth_provider.dart';
import 'location_provider.dart';
import 'dart:math';

part 'elevator_provider.g.dart';

/// Elevator data provider using modern Riverpod patterns
@riverpod
class ElevatorNotifier extends _$ElevatorNotifier {
  @override
  ElevatorState build() {
    _initializeRealtimeSubscription();
    return const ElevatorState();
  }

  void _initializeRealtimeSubscription() {
    // Listen to elevator status changes
    Supabase.instance.client
        .channel('elevator_updates')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'elevators',
          callback: _handleElevatorUpdate,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'elevator_status',
          callback: _handleStatusUpdate,
        )
        .subscribe();
  }

  void _handleElevatorUpdate(PostgresChangePayload payload) {
    // Handle elevator information updates
    try {
      final elevatorData = payload.newRecord;
      final updatedElevator = Elevator.fromJson(elevatorData);
      
      state = state.copyWith(
        elevators: state.elevators.map((elevator) {
          if (elevator.id == updatedElevator.id) {
            return updatedElevator;
          }
          return elevator;
        }).toList(),
      );
    } catch (e) {
      print('Error handling elevator update: $e');
    }
  }

  void _handleStatusUpdate(PostgresChangePayload payload) {
    // Handle elevator status updates
    try {
      final statusData = payload.newRecord;
      final updatedStatus = ElevatorStatus.fromJson(statusData);
      
      state = state.copyWith(
        elevatorStatuses: Map.from(state.elevatorStatuses)
          ..[updatedStatus.elevatorId] = updatedStatus,
      );
    } catch (e) {
      print('Error handling status update: $e');
    }
  }

  /// Load all elevators
  Future<void> loadElevators() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await Supabase.instance.client
          .from('elevators')
          .select('''
            *,
            elevator_status(*)
          ''')
          .eq('is_active', true)
          .order('name');

      final elevators = response.map((json) => Elevator.fromJson(json)).toList();
      final statuses = <String, ElevatorStatus>{};

      for (final elevator in elevators) {
        try {
          final statusResponse = await Supabase.instance.client
              .from('elevator_status')
              .select()
              .eq('elevator_id', elevator.id)
              .single();
          
          statuses[elevator.id] = ElevatorStatus.fromJson(statusResponse);
        } catch (e) {
          // No status found for this elevator, create default
          statuses[elevator.id] = ElevatorStatus(
            elevatorId: elevator.id,
            currentLineup: 0,
            estimatedWaitTime: 0,
            averageUnloadTime: 15,
            dailyCapacity: 0,
            dailyProcessed: 0,
            status: 'open',
            lastUpdated: DateTime.now(),
          );
        }
      }

      state = state.copyWith(
        elevators: elevators,
        elevatorStatuses: statuses,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        error: 'Failed to load elevators: $e',
        isLoading: false,
      );
      print('Load elevators error: $e\n$stackTrace');
    }
  }

  /// Get nearby elevators based on current location
  Future<List<NearbyElevator>> getNearbyElevators({
    Location? centerLocation,
    double radiusKm = 50.0,
    List<String>? grainTypes,
  }) async {
    try {
      // Use current location if none provided
      final location = centerLocation ?? ref.read(currentLocationProvider);
      if (location == null) {
        throw Exception('Current location is required');
      }

      // Query elevators using PostGIS for spatial proximity
      var query = Supabase.instance.client
          .from('elevators')
          .select('''
            *,
            elevator_status(*)
          ''')
          .eq('is_active', true);

      // Add grain type filter if specified
      if (grainTypes != null && grainTypes.isNotEmpty) {
        query = query.overlaps('accepted_grains', grainTypes);
      }

      final response = await query;

      final nearbyElevators = <NearbyElevator>[];

      for (final elevatorJson in response) {
        try {
          final elevator = Elevator.fromJson(elevatorJson);
          final statusJson = elevatorJson['elevator_status'] as Map<String, dynamic>?;
          final status = statusJson != null
              ? ElevatorStatus.fromJson(statusJson)
              : null;

          // Calculate distance using coordinates
          final distance = _calculateDistance(
            location.latitude,
            location.longitude,
            elevator.location.latitude,
            elevator.location.longitude,
          );

          // Only include elevators within radius
          if (distance <= radiusKm) {
            nearbyElevators.add(NearbyElevator(
              id: elevator.id,
              name: elevator.name,
              company: elevator.company,
              location: elevator.location,
              address: elevator.address,
              currentLineupCount: status?.currentLineup,
              estimatedWaitTime: status?.estimatedWaitTime,
              distance: distance,
              grainType: status?.currentGrainType,
              dockageRate: status?.dockageRate,
              availableGrains: elevator.acceptedGrains,
              isActive: elevator.isActive,
              lastUpdated: status?.lastUpdated ?? elevator.lastUpdated,
            ));
          }
        } catch (e) {
          print('Error processing elevator: $e');
        }
      }

      // Sort by distance
      nearbyElevators.sort((a, b) => 
        (a.distance ?? double.infinity).compareTo(b.distance ?? double.infinity)
      );

      return nearbyElevators;
    } catch (e, stackTrace) {
      state = state.copyWith(error: 'Failed to get nearby elevators: $e');
      print('Get nearby elevators error: $e\n$stackTrace');
      return [];
    }
  }

  /// Get elevator details by ID
  Future<Elevator?> getElevatorById(String elevatorId) async {
    try {
      final response = await Supabase.instance.client
          .from('elevators')
          .select('''
            *,
            elevator_status(*)
          ''')
          .eq('id', elevatorId)
          .single();

      return Elevator.fromJson(response);
    } catch (e) {
      print('Error getting elevator by ID: $e');
      return null;
    }
  }

  /// Get elevator status by ID
  Future<ElevatorStatus?> getElevatorStatus(String elevatorId) async {
    try {
      final response = await Supabase.instance.client
          .from('elevator_status')
          .select()
          .eq('elevator_id', elevatorId)
          .single();

      return ElevatorStatus.fromJson(response);
    } catch (e) {
      print('Error getting elevator status: $e');
      return null;
    }
  }

  /// Get wait time predictions for an elevator
  Future<List<WaitTimePrediction>> getWaitTimePredictions(
    String elevatorId,
  ) async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_elevator_predictions', {
            'elevator_id': elevatorId,
          });

      return (response as List)
          .map((json) => WaitTimePrediction.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting wait time predictions: $e');
      return [];
    }
  }

  /// Report current wait time (user feedback)
  Future<void> reportWaitTime(String elevatorId, int waitTime) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      await Supabase.instance.client.from('wait_time_reports').insert({
        'elevator_id': elevatorId,
        'user_id': user.id,
        'reported_wait_time': waitTime,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Refresh nearby elevators to update predictions
      // This would trigger real-time updates for other users
    } catch (e) {
      print('Error reporting wait time: $e');
    }
  }

  /// Search elevators by name, company, or grain type
  Future<List<Elevator>> searchElevators(String query) async {
    try {
      final response = await Supabase.instance.client
          .from('elevators')
          .select('''
            *,
            elevator_status(*)
          ''')
          .or('name.ilike.%$query%,company.ilike.%$query%')
          .eq('is_active', true)
          .order('name')
          .limit(20);

      return response.map((json) => Elevator.fromJson(json)).toList();
    } catch (e, stackTrace) {
      state = state.copyWith(error: 'Failed to search elevators: $e');
      print('Search elevators error: $e\n$stackTrace');
      return [];
    }
  }

  /// Get elevator statistics
  Future<Map<String, dynamic>> getElevatorStatistics() async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_elevator_statistics');

      return response as Map<String, dynamic>;
    } catch (e) {
      print('Error getting elevator statistics: $e');
      return {};
    }
  }

  /// Calculate distance between two points
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // km

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = (sin(dLat) * sin(dLat) +
            sin(dLon) * sin(dLon) * 
            cos(_toRadians(lat1)) * cos(_toRadians(lat2)));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    // Clean up realtime subscriptions
    Supabase.instance.client.channel('elevator_updates').unsubscribe();
    super.dispose();
  }
}

/// Elevator state model
@riverpod
class ElevatorState extends _$ElevatorState {
  @override
  ElevatorState build() {
    return const ElevatorState();
  }

  ElevatorState copyWith({
    List<Elevator> elevators = const [],
    Map<String, ElevatorStatus> elevatorStatuses = const {},
    Map<String, List<WaitTimePrediction>> predictions = const {},
    bool isLoading = false,
    bool isSearching = false,
    String? error,
    String? searchQuery,
    Location? searchCenter,
    double? searchRadius,
    List<String>? selectedGrainTypes,
  }) {
    return ElevatorState(
      elevators: elevators,
      elevatorStatuses: elevatorStatuses,
      predictions: predictions,
      isLoading: isLoading,
      isSearching: isSearching,
      error: error,
      searchQuery: searchQuery,
      searchCenter: searchCenter,
      searchRadius: searchRadius,
      selectedGrainTypes: selectedGrainTypes ?? this.selectedGrainTypes,
    );
  }

  const ElevatorState({
    this.elevators = const [],
    this.elevatorStatuses = const {},
    this.predictions = const {},
    this.isLoading = false,
    this.isSearching = false,
    this.error,
    this.searchQuery,
    this.searchCenter,
    this.searchRadius,
    this.selectedGrainTypes = const [],
  });

  final List<Elevator> elevators;
  final Map<String, ElevatorStatus> elevatorStatuses;
  final Map<String, List<WaitTimePrediction>> predictions;
  final bool isLoading;
  final bool isSearching;
  final String? error;
  final String? searchQuery;
  final Location? searchCenter;
  final double? searchRadius;
  final List<String> selectedGrainTypes;
}

/// Provider for list of elevators
@riverpod
List<Elevator> elevators(ElevatorsRef ref) {
  final elevatorState = ref.watch(elevatorNotifierProvider);
  return elevatorState.elevators;
}

/// Provider for elevator status by ID
@riverpod
ElevatorStatus? elevatorStatus(String elevatorId) {
  final elevatorState = ref.watch(elevatorNotifierProvider);
  return elevatorState.elevatorStatuses[elevatorId];
}

/// Provider for elevator loading state
@riverpod
bool isElevatorLoading(IsElevatorLoadingRef ref) {
  final elevatorState = ref.watch(elevatorNotifierProvider);
  return elevatorState.isLoading;
}

/// Provider for elevator error state
@riverpod
String? elevatorError(ElevatorErrorRef ref) {
  final elevatorState = ref.watch(elevatorNotifierProvider);
  return elevatorState.error;
}
