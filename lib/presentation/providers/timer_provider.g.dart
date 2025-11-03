// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeTimerHash() => r'd55ea386aba775382d39441ff547f75d177fd265';

/// Provider for active timer session
///
/// Copied from [activeTimer].
@ProviderFor(activeTimer)
final activeTimerProvider = AutoDisposeProvider<TimerSession?>.internal(
  activeTimer,
  name: r'activeTimerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeTimerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveTimerRef = AutoDisposeProviderRef<TimerSession?>;
String _$completedTimersHash() => r'bcc497f55d153feda19344daa75edc9a0bc6c394';

/// Provider for completed timer sessions
///
/// Copied from [completedTimers].
@ProviderFor(completedTimers)
final completedTimersProvider =
    AutoDisposeProvider<List<TimerSession>>.internal(
  completedTimers,
  name: r'completedTimersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedTimersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedTimersRef = AutoDisposeProviderRef<List<TimerSession>>;
String _$isTimerLoadingHash() => r'e05474d87aabdcb562f2252b3d0755c568e71da4';

/// Provider for timer loading state
///
/// Copied from [isTimerLoading].
@ProviderFor(isTimerLoading)
final isTimerLoadingProvider = AutoDisposeProvider<bool>.internal(
  isTimerLoading,
  name: r'isTimerLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isTimerLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsTimerLoadingRef = AutoDisposeProviderRef<bool>;
String _$timerErrorHash() => r'8e421221af80c8af2a990a68219f6893ff7634da';

/// Provider for timer error state
///
/// Copied from [timerError].
@ProviderFor(timerError)
final timerErrorProvider = AutoDisposeProvider<String?>.internal(
  timerError,
  name: r'timerErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$timerErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TimerErrorRef = AutoDisposeProviderRef<String?>;
String _$timerNotifierHash() => r'3ca6b007213d8c3e5571707952eae5d896614a66';

/// Timer session provider using modern Riverpod patterns
///
/// Copied from [TimerNotifier].
@ProviderFor(TimerNotifier)
final timerNotifierProvider =
    AutoDisposeNotifierProvider<TimerNotifier, TimerState>.internal(
  TimerNotifier.new,
  name: r'timerNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimerNotifier = AutoDisposeNotifier<TimerState>;
String _$timerStateHash() => r'a2ffdd88275cef3e08c1bb70718b96922e14a54e';

/// Timer state model
///
/// Copied from [TimerState].
@ProviderFor(TimerState)
final timerStateProvider =
    AutoDisposeNotifierProvider<TimerState, TimerState>.internal(
  TimerState.new,
  name: r'timerStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$timerStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TimerState = AutoDisposeNotifier<TimerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
