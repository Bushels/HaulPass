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

typedef ElevatorsRef = AutoDisposeProviderRef<List<Elevator>>;
String _$elevatorStatusHash() => r'd9f23ce2cab5117b845d49e2c1b9d8046c43f478';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for elevator status by ID
///
/// Copied from [elevatorStatus].
@ProviderFor(elevatorStatus)
const elevatorStatusProvider = ElevatorStatusFamily();

/// Provider for elevator status by ID
///
/// Copied from [elevatorStatus].
class ElevatorStatusFamily extends Family<ElevatorStatus?> {
  /// Provider for elevator status by ID
  ///
  /// Copied from [elevatorStatus].
  const ElevatorStatusFamily();

  /// Provider for elevator status by ID
  ///
  /// Copied from [elevatorStatus].
  ElevatorStatusProvider call(
    String elevatorId,
  ) {
    return ElevatorStatusProvider(
      elevatorId,
    );
  }

  @override
  ElevatorStatusProvider getProviderOverride(
    covariant ElevatorStatusProvider provider,
  ) {
    return call(
      provider.elevatorId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'elevatorStatusProvider';
}

/// Provider for elevator status by ID
///
/// Copied from [elevatorStatus].
class ElevatorStatusProvider extends AutoDisposeProvider<ElevatorStatus?> {
  /// Provider for elevator status by ID
  ///
  /// Copied from [elevatorStatus].
  ElevatorStatusProvider(
    String elevatorId,
  ) : this._internal(
          (ref) => elevatorStatus(
            ref as ElevatorStatusRef,
            elevatorId,
          ),
          from: elevatorStatusProvider,
          name: r'elevatorStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$elevatorStatusHash,
          dependencies: ElevatorStatusFamily._dependencies,
          allTransitiveDependencies:
              ElevatorStatusFamily._allTransitiveDependencies,
          elevatorId: elevatorId,
        );

  ElevatorStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.elevatorId,
  }) : super.internal();

  final String elevatorId;

  @override
  Override overrideWith(
    ElevatorStatus? Function(ElevatorStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ElevatorStatusProvider._internal(
        (ref) => create(ref as ElevatorStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        elevatorId: elevatorId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ElevatorStatus?> createElement() {
    return _ElevatorStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ElevatorStatusProvider && other.elevatorId == elevatorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, elevatorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ElevatorStatusRef on AutoDisposeProviderRef<ElevatorStatus?> {
  /// The parameter `elevatorId` of this provider.
  String get elevatorId;
}

class _ElevatorStatusProviderElement
    extends AutoDisposeProviderElement<ElevatorStatus?> with ElevatorStatusRef {
  _ElevatorStatusProviderElement(super.provider);

  @override
  String get elevatorId => (origin as ElevatorStatusProvider).elevatorId;
}

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

typedef ElevatorErrorRef = AutoDisposeProviderRef<String?>;
String _$elevatorNotifierHash() => r'1c0e34ce8de6cbcc8d40afef606e981ab0c7e87e';

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
String _$elevatorStateHash() => r'dc8f055696497ac2d82978523da39a34d2f600e3';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
