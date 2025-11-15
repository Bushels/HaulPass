import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import '../../data/models/location_models.dart' as models;
import 'auth_provider.dart';

part 'location_provider.g.dart';

// Type aliases to avoid conflicts
typedef GeoPlacemark = geo.Placemark;
typedef AppLocation = models.AppLocation;
typedef AppLocationHistory = models.AppLocationHistory;

/// Location permission status
enum LocationPermissionStatus {
  /// Location services are enabled
  enabled,
  /// Location services are disabled
  disabled,
  /// Permission denied by user
  denied,
  /// Permission denied permanently
  deniedForever,
  /// Permission granted while app is in use
  whileInUse,
  /// Permission granted for always location access
  always,
}

/// Location tracking state
@riverpod
class LocationTracker extends _$LocationTracker {
  @override
  LocationState build() {
    _initializeLocationService();
    return LocationState();
  }

  void _initializeLocationService() {
    // Initialize location service if needed
    _checkPermissions();
  }

  /// Check and request location permissions
  Future<LocationPermissionStatus> _checkPermissions() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          error: 'Location services are disabled',
          permissionStatus: LocationPermissionStatus.disabled,
        );
        return LocationPermissionStatus.disabled;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      LocationPermissionStatus status;
      switch (permission) {
        case LocationPermission.whileInUse:
          status = LocationPermissionStatus.whileInUse;
          break;
        case LocationPermission.always:
          status = LocationPermissionStatus.always;
          break;
        case LocationPermission.denied:
          status = LocationPermissionStatus.denied;
          break;
        case LocationPermission.deniedForever:
          status = LocationPermissionStatus.deniedForever;
          break;
        case LocationPermission.unableToDetermine:
          status = LocationPermissionStatus.denied;
          break;
      }

      state = state.copyWith(permissionStatus: status);
      return status;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to check location permissions: $e',
        permissionStatus: LocationPermissionStatus.denied,
      );
      return LocationPermissionStatus.denied;
    }
  }

  /// Get current location
  Future<AppLocation?> getCurrentLocation() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Check permissions first
      final permissionStatus = await _checkPermissions();
      if (permissionStatus == LocationPermissionStatus.denied ||
          permissionStatus == LocationPermissionStatus.deniedForever) {
        throw Exception('Location permission denied');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Get address from coordinates
      final placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final location = AppLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        timestamp: DateTime.now(),
        accuracy: position.accuracy,
      );

      state = state.copyWith(
        currentLocation: location,
        address: placemarks.isNotEmpty ? placemarks.first : null,
        isLoading: false,
      );

      return location;
    } catch (e, stackTrace) {
      state = state.copyWith(
        error: 'Failed to get current location: $e',
        isLoading: false,
      );
      print('Get current location error: $e\n$stackTrace');
      return null;
    }
  }

  /// Start location tracking
  Future<void> startTracking() async {
    try {
      // Check if already tracking
      if (state.isTracking) return;

      // Check permissions
      final permissionStatus = await _checkPermissions();
      if (permissionStatus != LocationPermissionStatus.whileInUse &&
          permissionStatus != LocationPermissionStatus.always) {
        throw Exception('Location permission required for tracking');
      }

      // Start position stream
      final positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        ),
      );

      // Listen to position updates
      final subscription = positionStream.listen(
        (Position position) {
          final newLocation = AppLocation(
            latitude: position.latitude,
            longitude: position.longitude,
            altitude: position.altitude,
            timestamp: DateTime.now(),
            accuracy: position.accuracy,
          );

          state = state.copyWith(
            currentLocation: newLocation,
            isTracking: true,
            lastUpdate: DateTime.now(),
          );

          // Store location in history if enabled
          _storeLocationInHistory(newLocation);
        },
        onError: (error) {
          state = state.copyWith(
            error: 'Location tracking error: $error',
            isTracking: false,
          );
        },
      );

      // Store subscription for later cancellation
      state = state.copyWith(
        isTracking: true,
        subscription: subscription,
        lastUpdate: DateTime.now(),
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        error: 'Failed to start location tracking: $e',
        isLoading: false,
      );
      print('Start tracking error: $e\n$stackTrace');
    }
  }

  /// Stop location tracking
  void stopTracking() {
    state.subscription?.cancel();
    state = state.copyWith(
      isTracking: false,
      subscription: null,
    );
  }

  /// Store location in history
  void _storeLocationInHistory(AppLocation location) {
    // Get user ID from auth provider
    final user = ref.read(currentUserProvider);
    if (user == null || !_shouldStoreLocation()) return;

    final historyEntry = AppLocationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      location: location,
      timestamp: DateTime.now(),
    );

    // Add to history
    state = state.copyWith(
      locationHistory: [...state.locationHistory, historyEntry],
    );

    // Store in Supabase if available
    _saveLocationToDatabase(historyEntry, user.id);
  }

  /// Check if location should be stored based on settings
  bool _shouldStoreLocation() {
    // This would check user settings
    // For now, assume it's enabled
    return true;
  }

  /// Save location to Supabase database
  Future<void> _saveLocationToDatabase(
    AppLocationHistory entry,
    String userId,
  ) async {
    try {
      // This would implement Supabase database saving
      // Implementation depends on database schema
      print('Saving location to database: ${entry.location}');
    } catch (e) {
      print('Failed to save location to database: $e');
    }
  }

  /// Get address from coordinates
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;

      final placemark = placemarks.first;
      return '${placemark.street ?? ''} ${placemark.locality ?? ''} ${placemark.administrativeArea ?? ''} ${placemark.country ?? ''}'
          .trim();
    } catch (e) {
      print('Failed to get address: $e');
      return null;
    }
  }

  /// Calculate distance between two locations
  double calculateDistance(AppLocation location1, AppLocation location2) {
    return Geolocator.distanceBetween(
      location1.latitude,
      location1.longitude,
      location2.latitude,
      location2.longitude,
    );
  }

  /// Get locations within radius
  List<AppLocation> getLocationsWithinRadius(
    List<AppLocation> locations,
    AppLocation center,
    double radiusMeters,
  ) {
    return locations.where((location) {
      final distance = calculateDistance(center, location);
      return distance <= radiusMeters;
    }).toList();
  }

  /// Request location permission
  Future<LocationPermissionStatus> requestPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      LocationPermissionStatus status;

      switch (permission) {
        case LocationPermission.whileInUse:
          status = LocationPermissionStatus.whileInUse;
          break;
        case LocationPermission.always:
          status = LocationPermissionStatus.always;
          break;
        default:
          status = LocationPermissionStatus.denied;
      }

      state = state.copyWith(permissionStatus: status);
      return status;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to request location permission: $e',
        permissionStatus: LocationPermissionStatus.denied,
      );
      return LocationPermissionStatus.denied;
    }
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

}

/// Location state model
@riverpod
class LocationState extends _$LocationState {
  @override
  LocationState build() {
    return LocationState();
  }

  LocationState copyWith({
    AppLocation? currentLocation,
    geo.Placemark? address,
    List<AppLocationHistory> locationHistory = const [],
    bool? isLoading,
    bool? isTracking,
    StreamSubscription<Position>? subscription,
    String? error,
    LocationPermissionStatus? permissionStatus,
    DateTime? lastUpdate,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      address: address ?? this.address,
      locationHistory: locationHistory.isNotEmpty ? locationHistory : this.locationHistory,
      isLoading: isLoading ?? this.isLoading,
      isTracking: isTracking ?? this.isTracking,
      subscription: subscription ?? this.subscription,
      error: error ?? this.error,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  LocationState({
    this.currentLocation,
    this.address,
    this.locationHistory = const [],
    this.isLoading = false,
    this.isTracking = false,
    this.subscription,
    this.error,
    this.permissionStatus = LocationPermissionStatus.denied,
    this.lastUpdate,
  });

  final AppLocation? currentLocation;
  final geo.Placemark? address;
  final List<AppLocationHistory> locationHistory;
  final bool isLoading;
  final bool isTracking;
  final StreamSubscription<Position>? subscription;
  final String? error;
  final LocationPermissionStatus permissionStatus;
  final DateTime? lastUpdate;
}

/// Provider for current location
@riverpod
AppLocation? currentLocation(CurrentLocationRef ref) {
  final locationState = ref.watch(locationTrackerProvider);
  return locationState.currentLocation;
}

/// Provider for location tracking status
@riverpod
bool isLocationTracking(IsLocationTrackingRef ref) {
  final locationState = ref.watch(locationTrackerProvider);
  return locationState.isTracking;
}

/// Provider for location permission status
@riverpod
LocationPermissionStatus locationPermission(LocationPermissionRef ref) {
  final locationState = ref.watch(locationTrackerProvider);
  return locationState.permissionStatus;
}

/// Provider for location history
@riverpod
List<AppLocationHistory> locationHistory(LocationHistoryRef ref) {
  final locationState = ref.watch(locationTrackerProvider);
  return locationState.locationHistory;
}
