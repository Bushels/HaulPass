// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_alert_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$queueAlertManagerHash() => r'b9de44e1e0ae6670d42c7925635eb180e9de48b6';

/// See also [queueAlertManager].
@ProviderFor(queueAlertManager)
final queueAlertManagerProvider =
    AutoDisposeProvider<QueueAlertManager>.internal(
  queueAlertManager,
  name: r'queueAlertManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$queueAlertManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef QueueAlertManagerRef = AutoDisposeProviderRef<QueueAlertManager>;
String _$elevatorAlertsHash() => r'6ce8a2588054f1c35e7006c4ed5636ef73511f20';

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

/// See also [elevatorAlerts].
@ProviderFor(elevatorAlerts)
const elevatorAlertsProvider = ElevatorAlertsFamily();

/// See also [elevatorAlerts].
class ElevatorAlertsFamily extends Family<AsyncValue<QueueAlert>> {
  /// See also [elevatorAlerts].
  const ElevatorAlertsFamily();

  /// See also [elevatorAlerts].
  ElevatorAlertsProvider call(
    String elevatorId,
    String elevatorName,
  ) {
    return ElevatorAlertsProvider(
      elevatorId,
      elevatorName,
    );
  }

  @override
  ElevatorAlertsProvider getProviderOverride(
    covariant ElevatorAlertsProvider provider,
  ) {
    return call(
      provider.elevatorId,
      provider.elevatorName,
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
  String? get name => r'elevatorAlertsProvider';
}

/// See also [elevatorAlerts].
class ElevatorAlertsProvider extends AutoDisposeStreamProvider<QueueAlert> {
  /// See also [elevatorAlerts].
  ElevatorAlertsProvider(
    String elevatorId,
    String elevatorName,
  ) : this._internal(
          (ref) => elevatorAlerts(
            ref as ElevatorAlertsRef,
            elevatorId,
            elevatorName,
          ),
          from: elevatorAlertsProvider,
          name: r'elevatorAlertsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$elevatorAlertsHash,
          dependencies: ElevatorAlertsFamily._dependencies,
          allTransitiveDependencies:
              ElevatorAlertsFamily._allTransitiveDependencies,
          elevatorId: elevatorId,
          elevatorName: elevatorName,
        );

  ElevatorAlertsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.elevatorId,
    required this.elevatorName,
  }) : super.internal();

  final String elevatorId;
  final String elevatorName;

  @override
  Override overrideWith(
    Stream<QueueAlert> Function(ElevatorAlertsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ElevatorAlertsProvider._internal(
        (ref) => create(ref as ElevatorAlertsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        elevatorId: elevatorId,
        elevatorName: elevatorName,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<QueueAlert> createElement() {
    return _ElevatorAlertsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ElevatorAlertsProvider &&
        other.elevatorId == elevatorId &&
        other.elevatorName == elevatorName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, elevatorId.hashCode);
    hash = _SystemHash.combine(hash, elevatorName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ElevatorAlertsRef on AutoDisposeStreamProviderRef<QueueAlert> {
  /// The parameter `elevatorId` of this provider.
  String get elevatorId;

  /// The parameter `elevatorName` of this provider.
  String get elevatorName;
}

class _ElevatorAlertsProviderElement
    extends AutoDisposeStreamProviderElement<QueueAlert>
    with ElevatorAlertsRef {
  _ElevatorAlertsProviderElement(super.provider);

  @override
  String get elevatorId => (origin as ElevatorAlertsProvider).elevatorId;
  @override
  String get elevatorName => (origin as ElevatorAlertsProvider).elevatorName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
