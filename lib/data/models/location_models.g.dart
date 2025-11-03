// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'timestamp': instance.timestamp.toIso8601String(),
      'accuracy': instance.accuracy,
    };

NearbyElevator _$NearbyElevatorFromJson(Map<String, dynamic> json) =>
    NearbyElevator(
      id: json['id'] as String,
      name: json['name'] as String,
      company: json['company'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      address: json['address'] as String?,
      currentLineupCount: (json['currentLineupCount'] as num?)?.toInt(),
      estimatedWaitTime: (json['estimatedWaitTime'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toDouble(),
      grainType: json['grainType'] as String?,
      dockageRate: (json['dockageRate'] as num?)?.toDouble(),
      availableGrains: (json['availableGrains'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isActive: json['isActive'] as bool? ?? true,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$NearbyElevatorToJson(NearbyElevator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'company': instance.company,
      'location': instance.location,
      'address': instance.address,
      'currentLineupCount': instance.currentLineupCount,
      'estimatedWaitTime': instance.estimatedWaitTime,
      'distance': instance.distance,
      'grainType': instance.grainType,
      'dockageRate': instance.dockageRate,
      'availableGrains': instance.availableGrains,
      'isActive': instance.isActive,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

LocationHistory _$LocationHistoryFromJson(Map<String, dynamic> json) =>
    LocationHistory(
      id: json['id'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      description: json['description'] as String?,
      activity: json['activity'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$LocationHistoryToJson(LocationHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'description': instance.description,
      'activity': instance.activity,
      'timestamp': instance.timestamp.toIso8601String(),
      'duration': instance.duration?.inMicroseconds,
      'metadata': instance.metadata,
    };

RouteInfo _$RouteInfoFromJson(Map<String, dynamic> json) => RouteInfo(
      id: json['id'] as String,
      startLocation:
          Location.fromJson(json['startLocation'] as Map<String, dynamic>),
      endLocation:
          Location.fromJson(json['endLocation'] as Map<String, dynamic>),
      waypoints: (json['waypoints'] as List<dynamic>?)
              ?.map((e) => Location.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalDistance: (json['totalDistance'] as num).toDouble(),
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      routeName: json['routeName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsed: json['lastUsed'] == null
          ? null
          : DateTime.parse(json['lastUsed'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$RouteInfoToJson(RouteInfo instance) => <String, dynamic>{
      'id': instance.id,
      'startLocation': instance.startLocation,
      'endLocation': instance.endLocation,
      'waypoints': instance.waypoints,
      'totalDistance': instance.totalDistance,
      'estimatedDuration': instance.estimatedDuration,
      'routeName': instance.routeName,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUsed': instance.lastUsed?.toIso8601String(),
      'isActive': instance.isActive,
    };

RouteStep _$RouteStepFromJson(Map<String, dynamic> json) => RouteStep(
      stepNumber: (json['stepNumber'] as num).toInt(),
      instruction: json['instruction'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      distance: (json['distance'] as num).toDouble(),
      duration: (json['duration'] as num).toInt(),
      roadName: json['roadName'] as String?,
      maneuverType: json['maneuverType'] as String?,
    );

Map<String, dynamic> _$RouteStepToJson(RouteStep instance) => <String, dynamic>{
      'stepNumber': instance.stepNumber,
      'instruction': instance.instruction,
      'location': instance.location,
      'distance': instance.distance,
      'duration': instance.duration,
      'roadName': instance.roadName,
      'maneuverType': instance.maneuverType,
    };

LocationSettings _$LocationSettingsFromJson(Map<String, dynamic> json) =>
    LocationSettings(
      enableGpsTracking: json['enableGpsTracking'] as bool? ?? true,
      enableLocationHistory: json['enableLocationHistory'] as bool? ?? true,
      locationUpdateInterval:
          (json['locationUpdateInterval'] as num?)?.toDouble() ?? 30.0,
      locationAccuracy: (json['locationAccuracy'] as num?)?.toDouble() ?? 10.0,
      allowedActivities: (json['allowedActivities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['driving', 'idle'],
      enableAutoRouteCalculation:
          json['enableAutoRouteCalculation'] as bool? ?? true,
      maxRouteDistance: (json['maxRouteDistance'] as num?)?.toDouble() ?? 500.0,
    );

Map<String, dynamic> _$LocationSettingsToJson(LocationSettings instance) =>
    <String, dynamic>{
      'enableGpsTracking': instance.enableGpsTracking,
      'enableLocationHistory': instance.enableLocationHistory,
      'locationUpdateInterval': instance.locationUpdateInterval,
      'locationAccuracy': instance.locationAccuracy,
      'allowedActivities': instance.allowedActivities,
      'enableAutoRouteCalculation': instance.enableAutoRouteCalculation,
      'maxRouteDistance': instance.maxRouteDistance,
    };
