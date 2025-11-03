// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentLocationHash() => r'a0b1e15536e48093de2c06dafec80b7344db4b69';

/// Provider for current location
///
/// Copied from [currentLocation].
@ProviderFor(currentLocation)
final currentLocationProvider = AutoDisposeProvider<Location?>.internal(
  currentLocation,
  name: r'currentLocationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLocationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentLocationRef = AutoDisposeProviderRef<Location?>;
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationPermissionRef
    = AutoDisposeProviderRef<LocationPermissionStatus>;
String _$locationHistoryHash() => r'8b3fdf4e7aaf924cea39da56e66aa78bdfcc3c1c';

/// Provider for location history
///
/// Copied from [locationHistory].
@ProviderFor(locationHistory)
final locationHistoryProvider =
    AutoDisposeProvider<List<LocationHistory>>.internal(
  locationHistory,
  name: r'locationHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationHistoryRef = AutoDisposeProviderRef<List<LocationHistory>>;
String _$locationTrackerHash() => r'0cbd24cc7224d12087e4379b349a321398589c6b';

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
String _$locationStateHash() => r'f6503da16aaddf128a448d3d7fa05067d445a1f7';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
