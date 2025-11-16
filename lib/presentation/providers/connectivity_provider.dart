import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// Connectivity status
enum ConnectivityStatus {
  online,
  offline,
  unknown,
}

/// Connectivity state
class ConnectivityState {
  final ConnectivityStatus status;
  final DateTime lastChecked;
  final List<ConnectivityResult> connectionTypes;

  const ConnectivityState({
    required this.status,
    required this.lastChecked,
    required this.connectionTypes,
  });

  bool get isOnline => status == ConnectivityStatus.online;
  bool get isOffline => status == ConnectivityStatus.offline;

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    DateTime? lastChecked,
    List<ConnectivityResult>? connectionTypes,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      lastChecked: lastChecked ?? this.lastChecked,
      connectionTypes: connectionTypes ?? this.connectionTypes,
    );
  }
}

/// Connectivity notifier
@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  final _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  ConnectivityState build() {
    // Initialize connectivity monitoring
    _initializeConnectivity();

    // Clean up subscription on dispose
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return const ConnectivityState(
      status: ConnectivityStatus.unknown,
      lastChecked: null,
      connectionTypes: [],
    );
  }

  /// Initialize connectivity monitoring
  Future<void> _initializeConnectivity() async {
    try {
      // Get initial connectivity status
      final results = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(results);

      // Listen to connectivity changes
      _subscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectivityStatus,
        onError: (error) {
          if (kDebugMode) {
            debugPrint('❌ Connectivity error: $error');
          }
        },
      );

      if (kDebugMode) {
        debugPrint('✅ Connectivity monitoring initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Connectivity initialization error: $e');
      }
    }
  }

  /// Update connectivity status
  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);

    final newStatus = hasConnection
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;

    // Only update if status changed
    if (state.status != newStatus) {
      state = ConnectivityState(
        status: newStatus,
        lastChecked: DateTime.now(),
        connectionTypes: results,
      );

      if (kDebugMode) {
        debugPrint('📶 Connectivity: ${newStatus.name} (${results.join(', ')})');
      }

      // Trigger sync when coming back online
      if (newStatus == ConnectivityStatus.online && state.status == ConnectivityStatus.offline) {
        _onConnectivityRestored();
      }
    }
  }

  /// Handle connectivity restored
  void _onConnectivityRestored() {
    if (kDebugMode) {
      debugPrint('🔄 Connectivity restored - triggering sync');
    }

    // TODO: Trigger data sync when connectivity is restored
    // ref.read(elevatorNotifierProvider.notifier).syncData();
  }

  /// Manually check connectivity
  Future<void> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(results);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Check connectivity error: $e');
      }
    }
  }

  /// Get connection type string
  String getConnectionTypeString() {
    if (state.connectionTypes.isEmpty) {
      return 'No connection';
    }

    if (state.connectionTypes.contains(ConnectivityResult.wifi)) {
      return 'Wi-Fi';
    } else if (state.connectionTypes.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (state.connectionTypes.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else {
      return 'Unknown';
    }
  }
}

/// Provider for connectivity status
@riverpod
bool isOnline(IsOnlineRef ref) {
  final connectivityState = ref.watch(connectivityNotifierProvider);
  return connectivityState.isOnline;
}

/// Provider for connectivity status string
@riverpod
String connectionType(ConnectionTypeRef ref) {
  final notifier = ref.watch(connectivityNotifierProvider.notifier);
  return notifier.getConnectionTypeString();
}
