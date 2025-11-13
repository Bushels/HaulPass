import 'package:json_annotation/json_annotation.dart';

part 'user_models.g.dart';

/// User profile information
@JsonSerializable()
class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? company;
  final String? truckNumber;
  final List<String> preferredGrains;
  final UserSettings settings;
  final UserSubscription? subscription;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  const UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.company,
    this.truckNumber,
    this.preferredGrains = const [],
    required this.settings,
    this.subscription,
    required this.createdAt,
    required this.lastLogin,
    this.isActive = true,
    this.metadata,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  /// Full name combining first and last name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return displayName ?? email.split('@')[0];
  }

  /// Display name with fallback
  String get displayNameWithFallback {
    return displayName ?? fullName;
  }

  /// Whether user has premium features
  bool get hasPremiumAccess {
    return subscription?.isActive == true && 
           subscription?.isValid == true;
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? company,
    String? truckNumber,
    List<String>? preferredGrains,
    UserSettings? settings,
    UserSubscription? subscription,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      company: company ?? this.company,
      truckNumber: truckNumber ?? this.truckNumber,
      preferredGrains: preferredGrains ?? this.preferredGrains,
      settings: settings ?? this.settings,
      subscription: subscription ?? this.subscription,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// User settings and preferences
@JsonSerializable()
class UserSettings {
  final bool enableNotifications;
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final bool enableSmsNotifications;
  final bool enableLocationServices;
  final bool enableAutoRefresh;
  final double refreshInterval; // in seconds
  final String theme; // 'light', 'dark', 'system'
  final String language; // ISO 639-1 language code
  final bool enableAnalytics;
  final Map<String, dynamic>? customPreferences;

  const UserSettings({
    this.enableNotifications = true,
    this.enablePushNotifications = true,
    this.enableEmailNotifications = true,
    this.enableSmsNotifications = false,
    this.enableLocationServices = true,
    this.enableAutoRefresh = true,
    this.refreshInterval = 60.0,
    this.theme = 'system',
    this.language = 'en',
    this.enableAnalytics = true,
    this.customPreferences,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  UserSettings copyWith({
    bool? enableNotifications,
    bool? enablePushNotifications,
    bool? enableEmailNotifications,
    bool? enableSmsNotifications,
    bool? enableLocationServices,
    bool? enableAutoRefresh,
    double? refreshInterval,
    String? theme,
    String? language,
    bool? enableAnalytics,
    Map<String, dynamic>? customPreferences,
  }) {
    return UserSettings(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enablePushNotifications: enablePushNotifications ?? this.enablePushNotifications,
      enableEmailNotifications: enableEmailNotifications ?? this.enableEmailNotifications,
      enableSmsNotifications: enableSmsNotifications ?? this.enableSmsNotifications,
      enableLocationServices: enableLocationServices ?? this.enableLocationServices,
      enableAutoRefresh: enableAutoRefresh ?? this.enableAutoRefresh,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      customPreferences: customPreferences ?? this.customPreferences,
    );
  }
}

/// User subscription and premium features
@JsonSerializable()
class UserSubscription {
  final String id;
  final String planId;
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isValid;
  final List<String> features;
  final Map<String, dynamic>? planDetails;
  final DateTime? lastRenewal;
  final DateTime? nextBilling;

  const UserSubscription({
    required this.id,
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.isValid = true,
    this.features = const [],
    this.planDetails,
    this.lastRenewal,
    this.nextBilling,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) => _$UserSubscriptionFromJson(json);
  Map<String, dynamic> toJson() => _$UserSubscriptionToJson(this);

  /// Check if subscription is currently active
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return isActive && isValid && now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Days remaining until expiration
  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserSubscription && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Authentication state and session info
@JsonSerializable()
class AuthenticationState {
  final bool isAuthenticated;
  final UserProfile? user;
  final String? accessToken;
  final DateTime? tokenExpiry;
  final String? refreshToken;
  final AuthError? error;

  const AuthenticationState({
    this.isAuthenticated = false,
    this.user,
    this.accessToken,
    this.tokenExpiry,
    this.refreshToken,
    this.error,
  });

  factory AuthenticationState.fromJson(Map<String, dynamic> json) => _$AuthenticationStateFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationStateToJson(this);

  /// Whether token is expired
  bool get isTokenExpired {
    if (tokenExpiry == null) return true;
    return DateTime.now().isAfter(tokenExpiry!);
  }

  /// Minutes until token expiry
  int get minutesUntilExpiry {
    if (tokenExpiry == null) return 0;
    final remaining = tokenExpiry!.difference(DateTime.now());
    return remaining.inMinutes;
  }

  AuthenticationState copyWith({
    bool? isAuthenticated,
    UserProfile? user,
    String? accessToken,
    DateTime? tokenExpiry,
    String? refreshToken,
    AuthError? error,
  }) {
    return AuthenticationState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
      refreshToken: refreshToken ?? this.refreshToken,
      error: error ?? this.error,
    );
  }

  AuthenticationState clearError() {
    return copyWith(error: null);
  }
}

/// Authentication error information
@JsonSerializable()
class AuthError {
  final String code;
  final String message;
  final String? details;
  final DateTime timestamp;

  const AuthError({
    required this.code,
    required this.message,
    this.details,
    required this.timestamp,
  });

  factory AuthError.fromJson(Map<String, dynamic> json) => _$AuthErrorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthErrorToJson(this);

  @override
  String toString() {
    return 'AuthError(code: $code, message: $message)';
  }
}

/// Login request model
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// Registration request model
@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String confirmPassword;
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? truckNumber;
  final bool acceptTerms;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.firstName,
    this.lastName,
    this.company,
    this.truckNumber,
    this.acceptTerms = false,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  /// Validate password confirmation
  bool get isPasswordConfirmed => password == confirmPassword;
}
