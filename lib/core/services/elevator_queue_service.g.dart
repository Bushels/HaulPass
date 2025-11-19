// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elevator_queue_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$elevatorQueueServiceHash() =>
    r'a2dd0ab33e3ab568ad764cbeb238447b92652392';

/// See also [elevatorQueueService].
@ProviderFor(elevatorQueueService)
final elevatorQueueServiceProvider =
    AutoDisposeProvider<ElevatorQueueService>.internal(
  elevatorQueueService,
  name: r'elevatorQueueServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$elevatorQueueServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ElevatorQueueServiceRef = AutoDisposeProviderRef<ElevatorQueueService>;
String _$liveElevatorStatusHash() =>
    r'638ac978363e8cb6b782875f86afea05166fc072';

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

/// See also [liveElevatorStatus].
@ProviderFor(liveElevatorStatus)
const liveElevatorStatusProvider = LiveElevatorStatusFamily();

/// See also [liveElevatorStatus].
class LiveElevatorStatusFamily extends Family<AsyncValue<ElevatorStatus>> {
  /// See also [liveElevatorStatus].
  const LiveElevatorStatusFamily();

  /// See also [liveElevatorStatus].
  LiveElevatorStatusProvider call(
    String elevatorId,
  ) {
    return LiveElevatorStatusProvider(
      elevatorId,
    );
  }

  @override
  LiveElevatorStatusProvider getProviderOverride(
    covariant LiveElevatorStatusProvider provider,
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
  String? get name => r'liveElevatorStatusProvider';
}

/// See also [liveElevatorStatus].
class LiveElevatorStatusProvider
    extends AutoDisposeStreamProvider<ElevatorStatus> {
  /// See also [liveElevatorStatus].
  LiveElevatorStatusProvider(
    String elevatorId,
  ) : this._internal(
          (ref) => liveElevatorStatus(
            ref as LiveElevatorStatusRef,
            elevatorId,
          ),
          from: liveElevatorStatusProvider,
          name: r'liveElevatorStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$liveElevatorStatusHash,
          dependencies: LiveElevatorStatusFamily._dependencies,
          allTransitiveDependencies:
              LiveElevatorStatusFamily._allTransitiveDependencies,
          elevatorId: elevatorId,
        );

  LiveElevatorStatusProvider._internal(
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
    Stream<ElevatorStatus> Function(LiveElevatorStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LiveElevatorStatusProvider._internal(
        (ref) => create(ref as LiveElevatorStatusRef),
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
  AutoDisposeStreamProviderElement<ElevatorStatus> createElement() {
    return _LiveElevatorStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LiveElevatorStatusProvider &&
        other.elevatorId == elevatorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, elevatorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LiveElevatorStatusRef on AutoDisposeStreamProviderRef<ElevatorStatus> {
  /// The parameter `elevatorId` of this provider.
  String get elevatorId;
}

class _LiveElevatorStatusProviderElement
    extends AutoDisposeStreamProviderElement<ElevatorStatus>
    with LiveElevatorStatusRef {
  _LiveElevatorStatusProviderElement(super.provider);

  @override
  String get elevatorId => (origin as LiveElevatorStatusProvider).elevatorId;
}

String _$userQueueStatusHash() => r'e54ef851776b2ae3e4cb55eef99ebdc1f24e77f5';

/// See also [userQueueStatus].
@ProviderFor(userQueueStatus)
final userQueueStatusProvider =
    AutoDisposeFutureProvider<UserQueueStatus?>.internal(
  userQueueStatus,
  name: r'userQueueStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userQueueStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserQueueStatusRef = AutoDisposeFutureProviderRef<UserQueueStatus?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
