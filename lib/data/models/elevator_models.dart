import 'package:json_annotation/json_annotation.dart';
import 'location_models.dart';

part 'elevator_models.g.dart';

/// Grain elevator with detailed information
@JsonSerializable()
class Elevator {
  final String id;
  final String name;
  final String company;
  final AppLocation location;
  final String? address;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? email;
  @JsonKey(name: 'grain_types')
  final List<String> acceptedGrains;
  @JsonKey(name: 'capacity_tonnes')
  final double? capacity; // in tonnes
  @JsonKey(name: 'dockage_rate')
  final double? dockageRate;
  @JsonKey(name: 'test_weight')
  final double? testWeight;
  final OperatingHours? hours;
  final List<ContactInfo> contacts;
  final Map<String, dynamic>? amenities;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime? lastUpdated;
  final String? railway;
  @JsonKey(name: 'elevator_type')
  final String? elevatorType;
  @JsonKey(name: 'car_spots')
  final String? carSpots;

  const Elevator({
    required this.id,
    required this.name,
    required this.company,
    required this.location,
    this.address,
    this.phoneNumber,
    this.email,
    this.acceptedGrains = const [],
    this.capacity,
    this.dockageRate,
    this.testWeight,
    this.hours,
    this.contacts = const [],
    this.amenities,
    this.isActive = true,
    this.lastUpdated,
    this.railway,
    this.elevatorType,
    this.carSpots,
  });

  factory Elevator.fromJson(Map<String, dynamic> json) {
    // Convert BIGINT ID to String if needed
    if (json['id'] is int) {
      json['id'] = json['id'].toString();
    }

    // Handle PostGIS geography/geometry location format
    if (json['location'] is String) {
      // Parse PostGIS point format: "POINT(longitude latitude)"
      final locationStr = json['location'] as String;
      final match = RegExp(r'POINT\(([-\d.]+)\s+([-\d.]+)\)').firstMatch(locationStr);
      if (match != null) {
        json['location'] = {
          'longitude': double.parse(match.group(1)!),
          'latitude': double.parse(match.group(2)!),
        };
      }
    } else if (json['location'] is Map) {
      // Handle GeoJSON format from Supabase
      final loc = json['location'] as Map<String, dynamic>;
      if (loc['type'] == 'Point' && loc['coordinates'] is List) {
        final coords = loc['coordinates'] as List;
        json['location'] = {
          'longitude': coords[0],
          'latitude': coords[1],
        };
      }
    }

    // Ensure lastUpdated has a value
    if (json['created_at'] == null && json['lastUpdated'] == null) {
      json['created_at'] = DateTime.now().toIso8601String();
    }

    return _$ElevatorFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ElevatorToJson(this);

  /// Formatted address
  String get formattedAddress {
    if (address != null) return address!;
    return 'Address not available';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Elevator && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Operating hours for elevator
@JsonSerializable()
class OperatingHours {
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;
  final String? sunday;
  final String? notes;

  const OperatingHours({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.notes,
  });

  factory OperatingHours.fromJson(Map<String, dynamic> json) => _$OperatingHoursFromJson(json);
  Map<String, dynamic> toJson() => _$OperatingHoursToJson(this);

  /// Get operating hours for specific day
  String? getHoursForDay(String dayName) {
    switch (dayName.toLowerCase()) {
      case 'monday':
        return monday;
      case 'tuesday':
        return tuesday;
      case 'wednesday':
        return wednesday;
      case 'thursday':
        return thursday;
      case 'friday':
        return friday;
      case 'saturday':
        return saturday;
      case 'sunday':
        return sunday;
      default:
        return null;
    }
  }
}

/// Contact information
@JsonSerializable()
class ContactInfo {
  final String name;
  final String? title;
  final String? phone;
  final String? email;
  final String? role;

  const ContactInfo({
    required this.name,
    this.title,
    this.phone,
    this.email,
    this.role,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) => _$ContactInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);
}

/// Current elevator status and metrics
@JsonSerializable()
class ElevatorStatus {
  final String elevatorId;
  final int currentLineup;
  final int estimatedWaitTime; // in minutes
  final double averageUnloadTime; // in minutes
  final String? currentGrainType;
  final double? dockageRate;
  final double? testWeight;
  final int dailyCapacity; // in bushels
  final int dailyProcessed; // in bushels
  final String? status; // 'open', 'busy', 'closed', 'maintenance'
  final DateTime lastUpdated;
  final List<WaitTimePrediction> predictions;

  const ElevatorStatus({
    required this.elevatorId,
    required this.currentLineup,
    required this.estimatedWaitTime,
    required this.averageUnloadTime,
    this.currentGrainType,
    this.dockageRate,
    this.testWeight,
    required this.dailyCapacity,
    required this.dailyProcessed,
    this.status,
    required this.lastUpdated,
    this.predictions = const [],
  });

  factory ElevatorStatus.fromJson(Map<String, dynamic> json) => _$ElevatorStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ElevatorStatusToJson(this);

  /// Capacity utilization percentage
  double get capacityUtilization {
    if (dailyCapacity == 0) return 0.0;
    return (dailyProcessed / dailyCapacity) * 100;
  }

  /// Status display text
  String get statusDisplay {
    switch (status) {
      case 'open':
        return 'Open';
      case 'busy':
        return 'Busy';
      case 'closed':
        return 'Closed';
      case 'maintenance':
        return 'Maintenance';
      default:
        return 'Unknown';
    }
  }

  /// Whether elevator is currently operational
  bool get isOperational {
    return status == 'open' || status == 'busy';
  }

  /// Formatted wait time
  String get waitTimeDisplay {
    if (estimatedWaitTime < 60) {
      return '${estimatedWaitTime}m';
    }
    final hours = estimatedWaitTime ~/ 60;
    final minutes = estimatedWaitTime % 60;
    return '${hours}h ${minutes}m';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ElevatorStatus && other.elevatorId == elevatorId;
  }

  @override
  int get hashCode => elevatorId.hashCode;
}

/// Wait time prediction with confidence levels
@JsonSerializable()
class WaitTimePrediction {
  final DateTime time;
  final int predictedWaitTime; // in minutes
  final double confidence; // 0.0 to 1.0
  final String? factors;

  const WaitTimePrediction({
    required this.time,
    required this.predictedWaitTime,
    required this.confidence,
    this.factors,
  });

  factory WaitTimePrediction.fromJson(Map<String, dynamic> json) => _$WaitTimePredictionFromJson(json);
  Map<String, dynamic> toJson() => _$WaitTimePredictionToJson(this);

  /// Formatted prediction time
  String get formattedTime {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Confidence level text
  String get confidenceText {
    if (confidence >= 0.8) return 'High';
    if (confidence >= 0.6) return 'Medium';
    return 'Low';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WaitTimePrediction && other.time == time;
  }

  @override
  int get hashCode => time.hashCode;
}

/// Timer session for tracking unloading activities
@JsonSerializable()
class TimerSession {
  final String id;
  final String elevatorId;
  final String elevatorName;
  final AppLocation location;
  final String? grainType;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration? totalDuration;
  final TimerStatus status;
  final Map<String, dynamic>? metadata;
  final List<TimerEvent> events;
  final String? notes;

  const TimerSession({
    required this.id,
    required this.elevatorId,
    required this.elevatorName,
    required this.location,
    this.grainType,
    required this.startTime,
    this.endTime,
    this.totalDuration,
    this.status = TimerStatus.active,
    this.metadata,
    this.events = const [],
    this.notes,
  });

  factory TimerSession.fromJson(Map<String, dynamic> json) => _$TimerSessionFromJson(json);
  Map<String, dynamic> toJson() => _$TimerSessionToJson(this);

  /// Active duration calculation
  Duration get activeDuration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Whether timer is currently running
  bool get isRunning {
    return status == TimerStatus.active;
  }

  /// Formatted duration
  String get formattedDuration {
    if (totalDuration != null) {
      return _formatDuration(totalDuration!);
    }
    if (isRunning) {
      return _formatDuration(activeDuration);
    }
    return 'No duration';
  }

  /// End the timer session
  TimerSession endSession() {
    final now = DateTime.now();
    return TimerSession(
      id: id,
      elevatorId: elevatorId,
      elevatorName: elevatorName,
      location: location,
      grainType: grainType,
      startTime: startTime,
      endTime: now,
      totalDuration: now.difference(startTime),
      status: TimerStatus.completed,
      metadata: metadata,
      events: events,
      notes: notes,
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Create a copy of this TimerSession with updated fields
  TimerSession copyWith({
    String? id,
    String? elevatorId,
    String? elevatorName,
    AppLocation? location,
    String? grainType,
    DateTime? startTime,
    DateTime? endTime,
    Duration? totalDuration,
    TimerStatus? status,
    Map<String, dynamic>? metadata,
    List<TimerEvent>? events,
    String? notes,
  }) {
    return TimerSession(
      id: id ?? this.id,
      elevatorId: elevatorId ?? this.elevatorId,
      elevatorName: elevatorName ?? this.elevatorName,
      location: location ?? this.location,
      grainType: grainType ?? this.grainType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDuration: totalDuration ?? this.totalDuration,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      events: events ?? this.events,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerSession && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Timer session status
enum TimerStatus {
  @JsonValue('active')
  active,
  @JsonValue('paused')
  paused,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

/// Timer event for tracking activities within a session
@JsonSerializable()
class TimerEvent {
  final String id;
  final String sessionId;
  final TimerEventType type;
  final String description;
  final DateTime timestamp;
  final Duration? duration;
  final Map<String, dynamic>? metadata;

  const TimerEvent({
    required this.id,
    required this.sessionId,
    required this.type,
    required this.description,
    required this.timestamp,
    this.duration,
    this.metadata,
  });

  factory TimerEvent.fromJson(Map<String, dynamic> json) => _$TimerEventFromJson(json);
  Map<String, dynamic> toJson() => _$TimerEventToJson(this);

  /// Formatted timestamp
  String get formattedTime {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }

  /// Display name for event type
  String get typeDisplay {
    switch (type) {
      case TimerEventType.start:
        return 'Start';
      case TimerEventType.arrive:
        return 'Arrive';
      case TimerEventType.queue:
        return 'Queue';
      case TimerEventType.unload:
        return 'Unload';
      case TimerEventType.complete:
        return 'Complete';
      case TimerEventType.pause:
        return 'Pause';
      case TimerEventType.resume:
        return 'Resume';
      case TimerEventType.custom:
        return 'Custom';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Timer event types
enum TimerEventType {
  @JsonValue('start')
  start,
  @JsonValue('arrive')
  arrive,
  @JsonValue('queue')
  queue,
  @JsonValue('unload')
  unload,
  @JsonValue('complete')
  complete,
  @JsonValue('pause')
  pause,
  @JsonValue('resume')
  resume,
  @JsonValue('custom')
  custom,
}

/// Summary statistics for timer sessions
@JsonSerializable()
class TimerStats {
  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalSessions;
  final Duration totalDuration;
  final double averageDuration;
  final int totalElevators;
  final Duration shortestSession;
  final Duration longestSession;
  final Map<String, int> sessionsByElevator;
  final Map<String, int> sessionsByGrain;

  const TimerStats({
    required this.periodStart,
    required this.periodEnd,
    required this.totalSessions,
    required this.totalDuration,
    required this.averageDuration,
    required this.totalElevators,
    required this.shortestSession,
    required this.longestSession,
    this.sessionsByElevator = const {},
    this.sessionsByGrain = const {},
  });

  factory TimerStats.fromJson(Map<String, dynamic> json) => _$TimerStatsFromJson(json);
  Map<String, dynamic> toJson() => _$TimerStatsToJson(this);

  /// Formatted total duration
  String get formattedTotalDuration {
    return _formatDuration(totalDuration);
  }

  /// Formatted average duration
  String get formattedAverageDuration {
    return _formatDuration(Duration(seconds: averageDuration.round()));
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
