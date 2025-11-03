// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      company: json['company'] as String?,
      truckNumber: json['truckNumber'] as String?,
      preferredGrains: (json['preferredGrains'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      settings: UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
      subscription: json['subscription'] == null
          ? null
          : UserSubscription.fromJson(
              json['subscription'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      isActive: json['isActive'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'company': instance.company,
      'truckNumber': instance.truckNumber,
      'preferredGrains': instance.preferredGrains,
      'settings': instance.settings,
      'subscription': instance.subscription,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLogin': instance.lastLogin.toIso8601String(),
      'isActive': instance.isActive,
      'metadata': instance.metadata,
    };

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enablePushNotifications: json['enablePushNotifications'] as bool? ?? true,
      enableEmailNotifications:
          json['enableEmailNotifications'] as bool? ?? true,
      enableSmsNotifications: json['enableSmsNotifications'] as bool? ?? false,
      enableLocationServices: json['enableLocationServices'] as bool? ?? true,
      enableAutoRefresh: json['enableAutoRefresh'] as bool? ?? true,
      refreshInterval: (json['refreshInterval'] as num?)?.toDouble() ?? 60.0,
      theme: json['theme'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      enableAnalytics: json['enableAnalytics'] as bool? ?? true,
      customPreferences: json['customPreferences'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'enableNotifications': instance.enableNotifications,
      'enablePushNotifications': instance.enablePushNotifications,
      'enableEmailNotifications': instance.enableEmailNotifications,
      'enableSmsNotifications': instance.enableSmsNotifications,
      'enableLocationServices': instance.enableLocationServices,
      'enableAutoRefresh': instance.enableAutoRefresh,
      'refreshInterval': instance.refreshInterval,
      'theme': instance.theme,
      'language': instance.language,
      'enableAnalytics': instance.enableAnalytics,
      'customPreferences': instance.customPreferences,
    };

UserSubscription _$UserSubscriptionFromJson(Map<String, dynamic> json) =>
    UserSubscription(
      id: json['id'] as String,
      planId: json['planId'] as String,
      planName: json['planName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      isValid: json['isValid'] as bool? ?? true,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      planDetails: json['planDetails'] as Map<String, dynamic>?,
      lastRenewal: json['lastRenewal'] == null
          ? null
          : DateTime.parse(json['lastRenewal'] as String),
      nextBilling: json['nextBilling'] == null
          ? null
          : DateTime.parse(json['nextBilling'] as String),
    );

Map<String, dynamic> _$UserSubscriptionToJson(UserSubscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'planId': instance.planId,
      'planName': instance.planName,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isActive': instance.isActive,
      'isValid': instance.isValid,
      'features': instance.features,
      'planDetails': instance.planDetails,
      'lastRenewal': instance.lastRenewal?.toIso8601String(),
      'nextBilling': instance.nextBilling?.toIso8601String(),
    };

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState(
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      user: json['user'] == null
          ? null
          : UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String?,
      tokenExpiry: json['tokenExpiry'] == null
          ? null
          : DateTime.parse(json['tokenExpiry'] as String),
      refreshToken: json['refreshToken'] as String?,
      error: json['error'] == null
          ? null
          : AuthError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
      'isAuthenticated': instance.isAuthenticated,
      'user': instance.user,
      'accessToken': instance.accessToken,
      'tokenExpiry': instance.tokenExpiry?.toIso8601String(),
      'refreshToken': instance.refreshToken,
      'error': instance.error,
    };

AuthError _$AuthErrorFromJson(Map<String, dynamic> json) => AuthError(
      code: json['code'] as String,
      message: json['message'] as String,
      details: json['details'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$AuthErrorToJson(AuthError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'timestamp': instance.timestamp.toIso8601String(),
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      rememberMe: json['rememberMe'] as bool? ?? false,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'rememberMe': instance.rememberMe,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      company: json['company'] as String?,
      truckNumber: json['truckNumber'] as String?,
      acceptTerms: json['acceptTerms'] as bool? ?? false,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'company': instance.company,
      'truckNumber': instance.truckNumber,
      'acceptTerms': instance.acceptTerms,
    };
