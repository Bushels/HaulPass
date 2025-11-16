// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isOnlineHash() => r'5f8c6e4a3b2d1e0f9a8b7c6d5e4f3a2b1c0d9e8f';

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
String _$connectionTypeHash() => r'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0';

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
    r'b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9';

/// See also [ConnectivityNotifier].
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
