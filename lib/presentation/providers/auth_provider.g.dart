// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'ce1a174b42033af8a48c20ba5e934ea2a4a5fc69';

/// Provider for current user
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = Provider<UserProfile?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserRef = ProviderRef<UserProfile?>;
String _$isAuthenticatedHash() => r'7fb0c32f05965e237dac2f3640a3995f50649cde';

/// Provider for authentication status
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = Provider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAuthenticatedRef = ProviderRef<bool>;
String _$authErrorHash() => r'c92805d583c38a1fdffadeaf12b96b2d0d8feaad';

/// Provider for authentication errors
///
/// Copied from [authError].
@ProviderFor(authError)
final authErrorProvider = Provider<AuthError?>.internal(
  authError,
  name: r'authErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthErrorRef = ProviderRef<AuthError?>;
String _$accessTokenHash() => r'336af4ca36610063d29db5dd186212a74b0f2dc7';

/// Provider for access token
///
/// Copied from [accessToken].
@ProviderFor(accessToken)
final accessTokenProvider = Provider<String?>.internal(
  accessToken,
  name: r'accessTokenProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accessTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AccessTokenRef = ProviderRef<String?>;
String _$userSettingsHash() => r'8a6bca06bc4a07f6583b4c364403f601111b6b3f';

/// Provider for user settings
///
/// Copied from [userSettings].
@ProviderFor(userSettings)
final userSettingsProvider = Provider<UserSettings?>.internal(
  userSettings,
  name: r'userSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserSettingsRef = ProviderRef<UserSettings?>;
String _$authNotifierHash() => r'ec14aaa463430508cea9f61b92e240a49742fd05';

/// Authentication provider using modern Riverpod patterns
/// NOTE: We use Notifier (not AutoDisposeNotifier) because auth state
/// must persist throughout the app lifecycle. AutoDispose would create
/// new instances with fresh state, causing sign-in issues.
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthenticationState>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = Notifier<AuthenticationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
