// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentLocationHash() => r'6595d3881c445aa6514c076cdf0dc5eba71ecccf';

/// Provider for current location
///
/// Copied from [currentLocation].
@ProviderFor(currentLocation)
final currentLocationProvider = AutoDisposeProvider<AppLocation?>.internal(
  currentLocation,
  name: r'currentLocationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentLocationRef = AutoDisposeProviderRef<AppLocation?>;
String _$isLocationTrackingHash() =>
    r'cc96e568dcd3b56cd5f13a9a2c387d41266a78b5';

/// Provider for location tracking status
///
/// Copied from [isLocationTracking].
@ProviderFor(isLocationTracking)
final isLocationTrackingProvider = AutoDisposeProvider<bool>.internal(
  isLocationTracking,
  name: r'isLocationTrackingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isLocationTrackingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsLocationTrackingRef = AutoDisposeProviderRef<bool>;
String _$locationPermissionHash() =>
    r'409640a6c7f3f5220e1a53423b7eec5680f97942';

/// Provider for location permission status
///
/// Copied from [locationPermission].
@ProviderFor(locationPermission)
final locationPermissionProvider =
    AutoDisposeProvider<LocationPermissionStatus>.internal(
  locationPermission,
  name: r'locationPermissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationPermissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocationPermissionRef
    = AutoDisposeProviderRef<LocationPermissionStatus>;
String _$locationHistoryHash() => r'157bbdeaa20aabc994fc75bf1bc765cb47f430d0';

/// Provider for location history
///
/// Copied from [locationHistory].
@ProviderFor(locationHistory)
final locationHistoryProvider =
    AutoDisposeProvider<List<AppLocationHistory>>.internal(
  locationHistory,
  name: r'locationHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocationHistoryRef = AutoDisposeProviderRef<List<AppLocationHistory>>;
String _$locationTrackerHash() => r'a1637e12be080eb3807ed4ac0538ca7b6e51d44e';

/// Location tracking state
///
/// Copied from [LocationTracker].
@ProviderFor(LocationTracker)
final locationTrackerProvider =
    AutoDisposeNotifierProvider<LocationTracker, LocationState>.internal(
  LocationTracker.new,
  name: r'locationTrackerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationTrackerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocationTracker = AutoDisposeNotifier<LocationState>;
String _$locationStateHash() => r'87b6781a03f152db832a62002ccf74c469984388';

/// Location state model
///
/// Copied from [LocationState].
@ProviderFor(LocationState)
final locationStateProvider =
    AutoDisposeNotifierProvider<LocationState, LocationState>.internal(
  LocationState.new,
  name: r'locationStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocationState = AutoDisposeNotifier<LocationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
