// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elevator_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Elevator _$ElevatorFromJson(Map<String, dynamic> json) => Elevator(
      id: json['id'] as String,
      name: json['name'] as String,
      company: json['company'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      acceptedGrains: (json['acceptedGrains'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      capacity: (json['capacity'] as num?)?.toDouble(),
      dockageRate: (json['dockageRate'] as num?)?.toDouble(),
      testWeight: (json['testWeight'] as num?)?.toDouble(),
      hours: json['hours'] == null
          ? null
          : OperatingHours.fromJson(json['hours'] as Map<String, dynamic>),
      contacts: (json['contacts'] as List<dynamic>?)
              ?.map((e) => ContactInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      amenities: json['amenities'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$ElevatorToJson(Elevator instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'company': instance.company,
      'location': instance.location,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'acceptedGrains': instance.acceptedGrains,
      'capacity': instance.capacity,
      'dockageRate': instance.dockageRate,
      'testWeight': instance.testWeight,
      'hours': instance.hours,
      'contacts': instance.contacts,
      'amenities': instance.amenities,
      'isActive': instance.isActive,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

OperatingHours _$OperatingHoursFromJson(Map<String, dynamic> json) =>
    OperatingHours(
      monday: json['monday'] as String?,
      tuesday: json['tuesday'] as String?,
      wednesday: json['wednesday'] as String?,
      thursday: json['thursday'] as String?,
      friday: json['friday'] as String?,
      saturday: json['saturday'] as String?,
      sunday: json['sunday'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$OperatingHoursToJson(OperatingHours instance) =>
    <String, dynamic>{
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
      'notes': instance.notes,
    };

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => ContactInfo(
      name: json['name'] as String,
      title: json['title'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'title': instance.title,
      'phone': instance.phone,
      'email': instance.email,
      'role': instance.role,
    };

ElevatorStatus _$ElevatorStatusFromJson(Map<String, dynamic> json) =>
    ElevatorStatus(
      elevatorId: json['elevatorId'] as String,
      currentLineup: (json['currentLineup'] as num).toInt(),
      estimatedWaitTime: (json['estimatedWaitTime'] as num).toInt(),
      averageUnloadTime: (json['averageUnloadTime'] as num).toDouble(),
      currentGrainType: json['currentGrainType'] as String?,
      dockageRate: (json['dockageRate'] as num?)?.toDouble(),
      testWeight: (json['testWeight'] as num?)?.toDouble(),
      dailyCapacity: (json['dailyCapacity'] as num).toInt(),
      dailyProcessed: (json['dailyProcessed'] as num).toInt(),
      status: json['status'] as String?,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      predictions: (json['predictions'] as List<dynamic>?)
              ?.map(
                  (e) => WaitTimePrediction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ElevatorStatusToJson(ElevatorStatus instance) =>
    <String, dynamic>{
      'elevatorId': instance.elevatorId,
      'currentLineup': instance.currentLineup,
      'estimatedWaitTime': instance.estimatedWaitTime,
      'averageUnloadTime': instance.averageUnloadTime,
      'currentGrainType': instance.currentGrainType,
      'dockageRate': instance.dockageRate,
      'testWeight': instance.testWeight,
      'dailyCapacity': instance.dailyCapacity,
      'dailyProcessed': instance.dailyProcessed,
      'status': instance.status,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'predictions': instance.predictions,
    };

WaitTimePrediction _$WaitTimePredictionFromJson(Map<String, dynamic> json) =>
    WaitTimePrediction(
      time: DateTime.parse(json['time'] as String),
      predictedWaitTime: (json['predictedWaitTime'] as num).toInt(),
      confidence: (json['confidence'] as num).toDouble(),
      factors: json['factors'] as String?,
    );

Map<String, dynamic> _$WaitTimePredictionToJson(WaitTimePrediction instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'predictedWaitTime': instance.predictedWaitTime,
      'confidence': instance.confidence,
      'factors': instance.factors,
    };

TimerSession _$TimerSessionFromJson(Map<String, dynamic> json) => TimerSession(
      id: json['id'] as String,
      elevatorId: json['elevatorId'] as String,
      elevatorName: json['elevatorName'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      grainType: json['grainType'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      totalDuration: json['totalDuration'] == null
          ? null
          : Duration(microseconds: (json['totalDuration'] as num).toInt()),
      status: $enumDecodeNullable(_$TimerStatusEnumMap, json['status']) ??
          TimerStatus.active,
      metadata: json['metadata'] as Map<String, dynamic>?,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => TimerEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$TimerSessionToJson(TimerSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'elevatorId': instance.elevatorId,
      'elevatorName': instance.elevatorName,
      'location': instance.location,
      'grainType': instance.grainType,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'totalDuration': instance.totalDuration?.inMicroseconds,
      'status': _$TimerStatusEnumMap[instance.status]!,
      'metadata': instance.metadata,
      'events': instance.events,
      'notes': instance.notes,
    };

const _$TimerStatusEnumMap = {
  TimerStatus.active: 'active',
  TimerStatus.paused: 'paused',
  TimerStatus.completed: 'completed',
  TimerStatus.cancelled: 'cancelled',
};

TimerEvent _$TimerEventFromJson(Map<String, dynamic> json) => TimerEvent(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      type: $enumDecode(_$TimerEventTypeEnumMap, json['type']),
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: (json['duration'] as num).toInt()),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TimerEventToJson(TimerEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'type': _$TimerEventTypeEnumMap[instance.type]!,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'duration': instance.duration?.inMicroseconds,
      'metadata': instance.metadata,
    };

const _$TimerEventTypeEnumMap = {
  TimerEventType.start: 'start',
  TimerEventType.arrive: 'arrive',
  TimerEventType.queue: 'queue',
  TimerEventType.unload: 'unload',
  TimerEventType.complete: 'complete',
  TimerEventType.pause: 'pause',
  TimerEventType.resume: 'resume',
  TimerEventType.custom: 'custom',
};

TimerStats _$TimerStatsFromJson(Map<String, dynamic> json) => TimerStats(
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
      totalSessions: (json['totalSessions'] as num).toInt(),
      totalDuration:
          Duration(microseconds: (json['totalDuration'] as num).toInt()),
      averageDuration: (json['averageDuration'] as num).toDouble(),
      totalElevators: (json['totalElevators'] as num).toInt(),
      shortestSession:
          Duration(microseconds: (json['shortestSession'] as num).toInt()),
      longestSession:
          Duration(microseconds: (json['longestSession'] as num).toInt()),
      sessionsByElevator:
          (json['sessionsByElevator'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      sessionsByGrain: (json['sessionsByGrain'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$TimerStatsToJson(TimerStats instance) =>
    <String, dynamic>{
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
      'totalSessions': instance.totalSessions,
      'totalDuration': instance.totalDuration.inMicroseconds,
      'averageDuration': instance.averageDuration,
      'totalElevators': instance.totalElevators,
      'shortestSession': instance.shortestSession.inMicroseconds,
      'longestSession': instance.longestSession.inMicroseconds,
      'sessionsByElevator': instance.sessionsByElevator,
      'sessionsByGrain': instance.sessionsByGrain,
    };
