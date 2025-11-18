import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/user_models.dart';
import '../../core/services/supabase_config.dart';
import '../../core/config/demo_config.dart';

// Import Supabase types with alias to avoid conflicts
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'auth_provider.g.dart';

/// Authentication provider using modern Riverpod patterns
/// NOTE: We use Notifier (not AutoDisposeNotifier) because auth state
/// must persist throughout the app lifecycle. AutoDispose would create
/// new instances with fresh state, causing sign-in issues.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthenticationState build() {
    _initialize();
    return const AuthenticationState();
  }

  void _initialize() {
    // Listen to Supabase auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      _handleAuthStateChange(data);
    });
  }

  void _handleAuthStateChange(AuthState data) {
    switch (data.event) {
      case AuthChangeEvent.signedIn:
        _handleSignedIn(data.session);
        break;
      case AuthChangeEvent.signedOut:
        state = const AuthenticationState();
        break;
      case AuthChangeEvent.tokenRefreshed:
        _handleTokenRefresh(data.session);
        break;
      case AuthChangeEvent.userUpdated:
        _handleUserUpdated(data.session);
        break;
      default:
        break;
    }
  }

  void _handleSignedIn(supabase.Session? session) {
    if (session != null) {
      final user = session.user;
      // Create user profile from Supabase user
      final userProfile = UserProfile(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'] as String?,
        firstName: user.userMetadata?['first_name'] as String?,
        lastName: user.userMetadata?['last_name'] as String?,
        company: user.userMetadata?['company'] as String?,
        truckNumber: user.userMetadata?['truck_number'] as String?,
        farmName: user.userMetadata?['farm_name'] as String?,
        binyardName: user.userMetadata?['binyard_name'] as String?,
        grainTruckName: user.userMetadata?['grain_truck_name'] as String?,
        grainCapacityKg: user.userMetadata?['grain_capacity_kg'] as double?,
        preferredUnit: (user.userMetadata?['preferred_unit'] as String?) ?? 'kg',
        favoriteElevatorId: user.userMetadata?['favorite_elevator_id'] as String?,
        settings: const UserSettings(),
        createdAt: DateTime.now(), // Supabase user.createdAt type varies, use current time for now
        lastLogin: DateTime.now(),
      );

      state = AuthenticationState(
        isAuthenticated: true,
        user: userProfile,
        accessToken: session.accessToken,
        tokenExpiry: session.expiresAt != null
            ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
            : null,
        refreshToken: session.refreshToken,
      );
        }
  }

  void _handleTokenRefresh(supabase.Session? session) {
    if (session != null) {
      state = state.copyWith(
        accessToken: session.accessToken,
        tokenExpiry: session.expiresAt != null
            ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
            : null,
        refreshToken: session.refreshToken,
      );
    }
  }

  void _handleUserUpdated(supabase.Session? session) {
    // Handle user profile updates
    if (session?.user != null && state.isAuthenticated) {
      final user = session!.user;
      final updatedProfile = state.user?.copyWith(
        displayName: user.userMetadata?['display_name'] as String?,
        firstName: user.userMetadata?['first_name'] as String?,
        lastName: user.userMetadata?['last_name'] as String?,
        lastLogin: DateTime.now(),
      );

      state = state.copyWith(user: updatedProfile);
    }
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    print('🔐 Sign in called with email: $email');
    try {
      state = state.copyWith(error: null);

      print('📡 Attempting Supabase authentication...');

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('✅ Supabase signInWithPassword completed');
      print('📦 Response user: ${response.user?.id}');
      print('📦 Response session: ${response.session != null ? "present" : "null"}');

      if (response.user == null) {
        throw Exception('Sign in failed: No user data received');
      }

      // Check email confirmation status
      if (response.user!.emailConfirmedAt == null && !DemoConfig.shouldSkipEmailConfirmation) {
        print('❌ Production mode: Email not confirmed');
        // Production mode: require email confirmation
        await Supabase.instance.client.auth.signOut();
        state = state.copyWith(
          error: AuthError(
            code: 'email_not_confirmed',
            message: 'Please confirm your email address before signing in. Check your inbox for the confirmation link.',
            timestamp: DateTime.now(),
          ),
        );
        return;
      }

      if (response.user!.emailConfirmedAt == null && DemoConfig.shouldSkipEmailConfirmation) {
        print('⚠️ Development mode: Allowing sign in without email confirmation');
        print('⚠️ WARNING: Set isDevelopmentMode = false in production!');
      }

      // Explicitly handle signed in state to ensure immediate state update
      // This prevents race conditions with the auth state listener
      if (response.session != null) {
        print('📝 Calling _handleSignedIn with session...');
        _handleSignedIn(response.session);
        print('✅ _handleSignedIn completed');

        // Force a small delay to allow state propagation
        // This is necessary because Riverpod AutoDisposeNotifier state updates
        // may not be immediately visible to other parts of the app
        await Future.delayed(const Duration(milliseconds: 100));

        // Verify session was stored correctly
        final currentSession = Supabase.instance.client.auth.currentSession;
        print('🔍 Verification - Current session after sign-in: ${currentSession != null ? "present" : "null"}');
        print('🔍 Verification - isAuthenticated state: ${state.isAuthenticated}');
        print('🔍 Verification - User in state: ${state.user?.email}');

        if (!state.isAuthenticated) {
          print('⚠️ State not updated after delay, waiting for listener...');
          // Wait a bit more for the auth state listener to fire
          await Future.delayed(const Duration(milliseconds: 200));
          print('🔍 Re-check - isAuthenticated state: ${state.isAuthenticated}');
          print('🔍 Re-check - User in state: ${state.user?.email}');
        }
      } else {
        print('❌ No session in response!');
        throw Exception('Sign in succeeded but no session returned');
      }
    } catch (e, stackTrace) {
      state = state.copyWith(
        error: AuthError(
          code: 'sign_in_failed',
          message: e.toString(),
          timestamp: DateTime.now(),
        ),
      );
      // Log error for debugging
      print('❌ Sign in error: $e\n$stackTrace');
    }
  }


  /// Sign up with email and password
  Future<void> signUp(RegisterRequest request) async {
    try {
      state = state.copyWith(error: null);

      // Validate request
      if (!request.isPasswordConfirmed) {
        throw Exception('Passwords do not match');
      }

      if (!request.acceptTerms) {
        throw Exception('You must accept the terms and conditions');
      }

      final response = await Supabase.instance.client.auth.signUp(
        email: request.email,
        password: request.password,
        data: {
          'first_name': request.firstName,
          'last_name': request.lastName,
          'company': request.company,
          'truck_number': request.truckNumber,
          'farm_name': request.farmName,
          'binyard_name': request.binyardName,
          'grain_truck_name': request.grainTruckName,
          'grain_capacity_kg': request.grainCapacityKg,
          'preferred_unit': request.preferredUnit ?? 'kg',
          'favorite_elevator_id': request.favoriteElevatorId,
        },
      );

      // Note: Email confirmation may be required depending on Supabase settings
      if (response.user != null) {
        if (response.user!.emailConfirmedAt != null) {
          // User is immediately confirmed
          _handleSignedIn(response.session);
        } else if (DemoConfig.shouldSkipEmailConfirmation) {
          // Development mode: skip email confirmation requirement
          print('⚠️ Development mode: Skipping email confirmation check');
          print('⚠️ WARNING: Set isDevelopmentMode = false in production!');
          _handleSignedIn(response.session);
        } else {
          // Production mode: User needs to confirm email
          state = state.copyWith(
            error: AuthError(
              code: 'email_confirmation_required',
              message: 'Please check your email to confirm your account',
              timestamp: DateTime.now(),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      state = state.copyWith(
        error: AuthError(
          code: 'sign_up_failed',
          message: e.toString(),
          timestamp: DateTime.now(),
        ),
      );
      print('Sign up error: $e\n$stackTrace');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      // Even if sign out fails locally, clear the state
      state = const AuthenticationState();
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      state = state.copyWith(error: null);
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'haulpass://reset-password',
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        error: AuthError(
          code: 'password_reset_failed',
          message: e.toString(),
          timestamp: DateTime.now(),
        ),
      );
      print('Password reset error: $e\n$stackTrace');
    }
  }

  /// Update user profile
  Future<void> updateProfile(UserProfile updatedProfile) async {
    try {
      state = state.copyWith(error: null);

      // Update in Supabase
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'display_name': updatedProfile.displayName,
            'first_name': updatedProfile.firstName,
            'last_name': updatedProfile.lastName,
            'phone_number': updatedProfile.phoneNumber,
            'company': updatedProfile.company,
            'truck_number': updatedProfile.truckNumber,
          },
        ),
      );

      // Update local state
      state = state.copyWith(user: updatedProfile);
    } catch (e, stackTrace) {
      state = state.copyWith(
        error: AuthError(
          code: 'profile_update_failed',
          message: e.toString(),
          timestamp: DateTime.now(),
        ),
      );
      print('Profile update error: $e\n$stackTrace');
    }
  }

  /// Clear error state
  void clearError() {
    state = state.clearError();
  }

  /// Check if user needs to refresh token
  bool needsTokenRefresh() {
    if (state.tokenExpiry == null) return true;
    
    const buffer = SupabaseConfig.tokenRefreshBuffer;
    return DateTime.now().isAfter(
      state.tokenExpiry!.subtract(buffer),
    );
  }

  /// Refresh access token
  Future<void> refreshToken() async {
    try {
      if (state.refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await Supabase.instance.client.auth.refreshSession();
      _handleTokenRefresh(response.session);
    } catch (e) {
      print('Token refresh failed: $e');
      // Sign out if refresh fails
      state = const AuthenticationState();
    }
  }
}

/// Provider for current user
@Riverpod(keepAlive: true)
UserProfile? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
}

/// Provider for authentication status
@Riverpod(keepAlive: true)
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isAuthenticated;
}

/// Provider for authentication errors
@Riverpod(keepAlive: true)
AuthError? authError(AuthErrorRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.error;
}

/// Provider for access token
@Riverpod(keepAlive: true)
String? accessToken(AccessTokenRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.accessToken;
}

/// Provider for user settings
@Riverpod(keepAlive: true)
UserSettings? userSettings(UserSettingsRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user?.settings;
}
