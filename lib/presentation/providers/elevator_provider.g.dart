// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elevator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$elevatorsHash() => r'6da66a6cc20bc5db837ea4bf5a91c0b374c68b35';

/// Provider for list of elevators
///
/// Copied from [elevators].
@ProviderFor(elevators)
final elevatorsProvider = AutoDisposeProvider<List<Elevator>>.internal(
  elevators,
  name: r'elevatorsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$elevatorsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ElevatorsRef = AutoDisposeProviderRef<List<Elevator>>;
String _$elevatorStatusHash() => r'6992f4d9d006089c1225485f98db910acbd01992';

/// Provider for elevator status by ID
///
/// Copied from [elevatorStatus].
@ProviderFor(elevatorStatus)
final elevatorStatusProvider = AutoDisposeProvider<ElevatorStatus?>.internal(
  elevatorStatus,
  name: r'elevatorStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$elevatorStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ElevatorStatusRef = AutoDisposeProviderRef<ElevatorStatus?>;
String _$isElevatorLoadingHash() => r'e4ba450e8b8fe1ce88dfa3fa20603c84443d396b';

/// Provider for elevator loading state
///
/// Copied from [isElevatorLoading].
@ProviderFor(isElevatorLoading)
final isElevatorLoadingProvider = AutoDisposeProvider<bool>.internal(
  isElevatorLoading,
  name: r'isElevatorLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isElevatorLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsElevatorLoadingRef = AutoDisposeProviderRef<bool>;
String _$elevatorErrorHash() => r'ae6bc8ab0e89c27bdab0ea09ea1cb40b11bf3d5c';

/// Provider for elevator error state
///
/// Copied from [elevatorError].
@ProviderFor(elevatorError)
final elevatorErrorProvider = AutoDisposeProvider<String?>.internal(
  elevatorError,
  name: r'elevatorErrorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$elevatorErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ElevatorErrorRef = AutoDisposeProviderRef<String?>;
String _$elevatorNotifierHash() => r'ea9a05463c85cd78f581057c4fc56883b23a05f7';

/// Elevator data provider using modern Riverpod patterns
///
/// Copied from [ElevatorNotifier].
@ProviderFor(ElevatorNotifier)
final elevatorNotifierProvider =
    AutoDisposeNotifierProvider<ElevatorNotifier, ElevatorState>.internal(
  ElevatorNotifier.new,
  name: r'elevatorNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$elevatorNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ElevatorNotifier = AutoDisposeNotifier<ElevatorState>;
String _$elevatorStateHash() => r'e017edebee40e899e06e2ba2621fa51ae5d11bfa';

/// Elevator state model
///
/// Copied from [ElevatorState].
@ProviderFor(ElevatorState)
final elevatorStateProvider =
    AutoDisposeNotifierProvider<ElevatorState, ElevatorState>.internal(
  ElevatorState.new,
  name: r'elevatorStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$elevatorStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ElevatorState = AutoDisposeNotifier<ElevatorState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
