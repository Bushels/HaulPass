import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/user_models.dart';
import '../../core/services/supabase_config.dart';

// Import Supabase types with alias to avoid conflicts
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'auth_provider.g.dart';

/// Authentication provider using modern Riverpod patterns
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _initialize();
    return const AuthState();
  }

  void _initialize() {
    // Listen to Supabase auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      _handleAuthStateChange(data);
    });
  }

  void _handleAuthStateChange(supabase.AuthStateChange<supabase.Session> data) {
    switch (data.event) {
      case AuthChangeEvent.signedIn:
        _handleSignedIn(data.session);
        break;
      case AuthChangeEvent.signedOut:
        state = const AuthState();
        break;
      case AuthChangeEvent.tokenRefreshed:
        _handleTokenRefresh(data.session);
        break;
      case AuthChangeEvent.userUpdated:
        _handleUserUpdated(data.session);
        break;
    }
  }

  void _handleSignedIn(supabase.Session? session) {
    if (session != null) {
      final user = session.user;
      if (user != null) {
        // Create user profile from Supabase user
        final userProfile = UserProfile(
          id: user.id,
          email: user.email ?? '',
          displayName: user.userMetadata?['display_name'] as String?,
          firstName: user.userMetadata?['first_name'] as String?,
          lastName: user.userMetadata?['last_name'] as String?,
          settings: const UserSettings(),
          createdAt: user.createdAt ?? DateTime.now(),
          lastLogin: DateTime.now(),
        );

        state = AuthState(
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
    try {
      state = state.copyWith(error: null);

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed: No user data received');
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
      print('Sign in error: $e\n$stackTrace');
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
        },
      );

      // Note: Email confirmation may be required depending on Supabase settings
      if (response.user != null && response.user!.emailConfirmedAt != null) {
        // User is immediately confirmed
        _handleSignedIn(response.session);
      } else {
        // User needs to confirm email
        state = state.copyWith(
          error: AuthError(
            code: 'email_confirmation_required',
            message: 'Please check your email to confirm your account',
            timestamp: DateTime.now(),
          ),
        );
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
      state = const AuthState();
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
    
    final buffer = SupabaseConfig.tokenRefreshBuffer;
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
      state = const AuthState();
    }
  }
}

/// Provider for current user
@riverpod
UserProfile? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
}

/// Provider for authentication status
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isAuthenticated;
}

/// Provider for authentication errors
@riverpod
AuthError? authError(AuthErrorRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.error;
}

/// Provider for access token
@riverpod
String? accessToken(AccessTokenRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.accessToken;
}

/// Provider for user settings
@riverpod
UserSettings? userSettings(UserSettingsRef ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user?.settings;
}
