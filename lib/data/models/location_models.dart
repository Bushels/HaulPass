import 'package:json_annotation/json_annotation.dart';

part 'location_models.g.dart';

/// Core location model for GPS coordinates
@JsonSerializable()
class Location {
  final double latitude;
  final double longitude;
  final double? altitude;
  final DateTime timestamp;
  final double? accuracy;

  const Location({
    required this.latitude,
    required this.longitude,
    this.altitude,
    required this.timestamp,
    this.accuracy,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  Location copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    DateTime? timestamp,
    double? accuracy,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
    );
  }

  @override
  String toString() {
    return 'Location(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}

/// Nearby elevator with current status and wait times
@JsonSerializable()
class NearbyElevator {
  final String id;
  final String name;
  final String company;
  final Location location;
  final String? address;
  final int? currentLineupCount;
  final int? estimatedWaitTime;
  final double? distance;
  final String? grainType;
  final double? dockageRate;
  final List<String> availableGrains;
  final bool isActive;
  final DateTime lastUpdated;

  const NearbyElevator({
    required this.id,
    required this.name,
    required this.company,
    required this.location,
    this.address,
    this.currentLineupCount,
    this.estimatedWaitTime,
    this.distance,
    this.grainType,
    this.dockageRate,
    required this.availableGrains,
    this.isActive = true,
    required this.lastUpdated,
  });

  factory NearbyElevator.fromJson(Map<String, dynamic> json) => _$NearbyElevatorFromJson(json);
  Map<String, dynamic> toJson() => _$NearbyElevatorToJson(this);

  /// Formatted wait time display
  String get waitTimeDisplay {
    if (estimatedWaitTime == null) return 'N/A';
    if (estimatedWaitTime! < 60) return '${estimatedWaitTime}m';
    final hours = estimatedWaitTime! ~/ 60;
    final minutes = estimatedWaitTime! % 60;
    return '${hours}h ${minutes}m';
  }

  /// Formatted lineup display
  String get lineupDisplay {
    if (currentLineupCount == null) return 'Unknown';
    return '$currentLineupCount trucks';
  }

  /// Distance display with appropriate units
  String get distanceDisplay {
    if (distance == null) return 'Distance unknown';
    if (distance! < 1.0) {
      return '${(distance! * 1000).toInt()}m';
    }
    return '${distance!.toStringAsFixed(1)}km';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NearbyElevator && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Location history for tracking user movements
@JsonSerializable()
class LocationHistory {
  final String id;
  final Location location;
  final String? description;
  final String? activity;
  final DateTime timestamp;
  final Duration? duration;
  final Map<String, dynamic>? metadata;

  const LocationHistory({
    required this.id,
    required this.location,
    this.description,
    this.activity,
    required this.timestamp,
    this.duration,
    this.metadata,
  });

  factory LocationHistory.fromJson(Map<String, dynamic> json) => _$LocationHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$LocationHistoryToJson(this);

  /// Formatted timestamp
  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationHistory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Route information for navigation
@JsonSerializable()
class RouteInfo {
  final String id;
  final Location startLocation;
  final Location endLocation;
  final List<Location> waypoints;
  final double totalDistance;
  final int estimatedDuration; // in minutes
  final String? routeName;
  final DateTime createdAt;
  final DateTime? lastUsed;
  final bool isActive;

  const RouteInfo({
    required this.id,
    required this.startLocation,
    required this.endLocation,
    this.waypoints = const [],
    required this.totalDistance,
    required this.estimatedDuration,
    this.routeName,
    required this.createdAt,
    this.lastUsed,
    this.isActive = true,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) => _$RouteInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RouteInfoToJson(this);

  /// Formatted duration display
  String get durationDisplay {
    if (estimatedDuration < 60) return '${estimatedDuration}m';
    final hours = estimatedDuration ~/ 60;
    final minutes = estimatedDuration % 60;
    return '${hours}h ${minutes}m';
  }

  /// Distance display with units
  String get distanceDisplay {
    return '${totalDistance.toStringAsFixed(1)}km';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RouteInfo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Individual route step for turn-by-turn navigation
@JsonSerializable()
class RouteStep {
  final int stepNumber;
  final String instruction;
  final Location location;
  final double distance;
  final int duration; // in seconds
  final String? roadName;
  final String? maneuverType;

  const RouteStep({
    required this.stepNumber,
    required this.instruction,
    required this.location,
    required this.distance,
    required this.duration,
    this.roadName,
    this.maneuverType,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) => _$RouteStepFromJson(json);
  Map<String, dynamic> toJson() => _$RouteStepToJson(this);

  /// Distance display
  String get distanceDisplay {
    if (distance < 1.0) {
      return '${(distance * 1000).toInt()}m';
    }
    return '${distance.toStringAsFixed(1)}km';
  }

  /// Duration display
  String get durationDisplay {
    if (duration < 60) return '${duration}s';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RouteStep && other.stepNumber == stepNumber;
  }

  @override
  int get hashCode => stepNumber.hashCode;
}

/// User location preferences and settings
@JsonSerializable()
class LocationSettings {
  final bool enableGpsTracking;
  final bool enableLocationHistory;
  final double locationUpdateInterval; // in seconds
  final double locationAccuracy; // in meters
  final List<String> allowedActivities;
  final bool enableAutoRouteCalculation;
  final double maxRouteDistance; // in km

  const LocationSettings({
    this.enableGpsTracking = true,
    this.enableLocationHistory = true,
    this.locationUpdateInterval = 30.0,
    this.locationAccuracy = 10.0,
    this.allowedActivities = const ['driving', 'idle'],
    this.enableAutoRouteCalculation = true,
    this.maxRouteDistance = 500.0,
  });

  factory LocationSettings.fromJson(Map<String, dynamic> json) => _$LocationSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationSettingsToJson(this);

  LocationSettings copyWith({
    bool? enableGpsTracking,
    bool? enableLocationHistory,
    double? locationUpdateInterval,
    double? locationAccuracy,
    List<String>? allowedActivities,
    bool? enableAutoRouteCalculation,
    double? maxRouteDistance,
  }) {
    return LocationSettings(
      enableGpsTracking: enableGpsTracking ?? this.enableGpsTracking,
      enableLocationHistory: enableLocationHistory ?? this.enableLocationHistory,
      locationUpdateInterval: locationUpdateInterval ?? this.locationUpdateInterval,
      locationAccuracy: locationAccuracy ?? this.locationAccuracy,
      allowedActivities: allowedActivities ?? this.allowedActivities,
      enableAutoRouteCalculation: enableAutoRouteCalculation ?? this.enableAutoRouteCalculation,
      maxRouteDistance: maxRouteDistance ?? this.maxRouteDistance,
    );
  }
}
