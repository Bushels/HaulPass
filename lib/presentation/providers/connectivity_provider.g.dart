// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isOnlineHash() => r'a0cb9ee48c40f7fdac3ec44c3d1c277e30cf8d18';

/// Provider for connectivity status
///
/// Copied from [isOnline].
@ProviderFor(isOnline)
final isOnlineProvider = AutoDisposeProvider<bool>.internal(
  isOnline,
  name: r'isOnlineProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isOnlineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsOnlineRef = AutoDisposeProviderRef<bool>;
String _$connectionTypeHash() => r'ca6606c54754e6a9026c254f35cc118eb0349ffc';

/// Provider for connectivity status string
///
/// Copied from [connectionType].
@ProviderFor(connectionType)
final connectionTypeProvider = AutoDisposeProvider<String>.internal(
  connectionType,
  name: r'connectionTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectionTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConnectionTypeRef = AutoDisposeProviderRef<String>;
String _$connectivityNotifierHash() =>
    r'f05b5b9925f0588ea86be27e643ffb5264dbe159';

/// Connectivity notifier
///
/// Copied from [ConnectivityNotifier].
@ProviderFor(ConnectivityNotifier)
final connectivityNotifierProvider = AutoDisposeNotifierProvider<
    ConnectivityNotifier, ConnectivityState>.internal(
  ConnectivityNotifier.new,
  name: r'connectivityNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectivityNotifier = AutoDisposeNotifier<ConnectivityState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
