// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteElevatorIdHash() =>
    r'1b0fee82ecdc0bc7fada99519010fd317c4df6e6';

/// Provider for favorite elevator ID
/// TODO: Replace with user preferences from database
///
/// Copied from [favoriteElevatorId].
@ProviderFor(favoriteElevatorId)
final favoriteElevatorIdProvider = AutoDisposeProvider<String>.internal(
  favoriteElevatorId,
  name: r'favoriteElevatorIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteElevatorIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoriteElevatorIdRef = AutoDisposeProviderRef<String>;
String _$favoriteElevatorNameHash() =>
    r'8a260e10195d60a794d0b45f862807ac85c58234';

/// Provider for favorite elevator name
/// TODO: Fetch from elevators_import table
///
/// Copied from [favoriteElevatorName].
@ProviderFor(favoriteElevatorName)
final favoriteElevatorNameProvider = AutoDisposeProvider<String>.internal(
  favoriteElevatorName,
  name: r'favoriteElevatorNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteElevatorNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoriteElevatorNameRef = AutoDisposeProviderRef<String>;
String _$liveElevatorInsightsHash() =>
    r'956f0a9b9939615737d531460f67d824d7e81401';

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

/// Provider for live elevator insights (combines status with historical data)
///
/// Copied from [liveElevatorInsights].
@ProviderFor(liveElevatorInsights)
const liveElevatorInsightsProvider = LiveElevatorInsightsFamily();

/// Provider for live elevator insights (combines status with historical data)
///
/// Copied from [liveElevatorInsights].
class LiveElevatorInsightsFamily extends Family<AsyncValue<ElevatorInsights>> {
  /// Provider for live elevator insights (combines status with historical data)
  ///
  /// Copied from [liveElevatorInsights].
  const LiveElevatorInsightsFamily();

  /// Provider for live elevator insights (combines status with historical data)
  ///
  /// Copied from [liveElevatorInsights].
  LiveElevatorInsightsProvider call(
    String elevatorId,
  ) {
    return LiveElevatorInsightsProvider(
      elevatorId,
    );
  }

  @override
  LiveElevatorInsightsProvider getProviderOverride(
    covariant LiveElevatorInsightsProvider provider,
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
  String? get name => r'liveElevatorInsightsProvider';
}

/// Provider for live elevator insights (combines status with historical data)
///
/// Copied from [liveElevatorInsights].
class LiveElevatorInsightsProvider
    extends AutoDisposeStreamProvider<ElevatorInsights> {
  /// Provider for live elevator insights (combines status with historical data)
  ///
  /// Copied from [liveElevatorInsights].
  LiveElevatorInsightsProvider(
    String elevatorId,
  ) : this._internal(
          (ref) => liveElevatorInsights(
            ref as LiveElevatorInsightsRef,
            elevatorId,
          ),
          from: liveElevatorInsightsProvider,
          name: r'liveElevatorInsightsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$liveElevatorInsightsHash,
          dependencies: LiveElevatorInsightsFamily._dependencies,
          allTransitiveDependencies:
              LiveElevatorInsightsFamily._allTransitiveDependencies,
          elevatorId: elevatorId,
        );

  LiveElevatorInsightsProvider._internal(
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
    Stream<ElevatorInsights> Function(LiveElevatorInsightsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LiveElevatorInsightsProvider._internal(
        (ref) => create(ref as LiveElevatorInsightsRef),
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
  AutoDisposeStreamProviderElement<ElevatorInsights> createElement() {
    return _LiveElevatorInsightsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LiveElevatorInsightsProvider &&
        other.elevatorId == elevatorId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, elevatorId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LiveElevatorInsightsRef
    on AutoDisposeStreamProviderRef<ElevatorInsights> {
  /// The parameter `elevatorId` of this provider.
  String get elevatorId;
}

class _LiveElevatorInsightsProviderElement
    extends AutoDisposeStreamProviderElement<ElevatorInsights>
    with LiveElevatorInsightsRef {
  _LiveElevatorInsightsProviderElement(super.provider);

  @override
  String get elevatorId => (origin as LiveElevatorInsightsProvider).elevatorId;
}

String _$userStatisticsHash() => r'31d05993d651eb366571c2db239c46e482efce85';

/// Provider for mock user statistics
/// TODO: Replace with actual database queries
///
/// Copied from [userStatistics].
@ProviderFor(userStatistics)
final userStatisticsProvider = AutoDisposeProvider<UserStatistics>.internal(
  userStatistics,
  name: r'userStatisticsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userStatisticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserStatisticsRef = AutoDisposeProviderRef<UserStatistics>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
