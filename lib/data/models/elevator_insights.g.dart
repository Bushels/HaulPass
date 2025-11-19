// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elevator_insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ElevatorInsightsImpl _$$ElevatorInsightsImplFromJson(
        Map<String, dynamic> json) =>
    _$ElevatorInsightsImpl(
      elevatorId: json['elevatorId'] as String,
      elevatorName: json['elevatorName'] as String,
      currentWaitMinutes: (json['currentWaitMinutes'] as num).toInt(),
      averageWaitMinutes: (json['averageWaitMinutes'] as num?)?.toInt() ?? 0,
      yesterdayWaitMinutes:
          (json['yesterdayWaitMinutes'] as num?)?.toInt() ?? 0,
      lastWeekSameDayWaitMinutes:
          (json['lastWeekSameDayWaitMinutes'] as num?)?.toInt() ?? 0,
      currentLineup: (json['currentLineup'] as num?)?.toInt() ?? 0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      status: json['status'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ElevatorInsightsImplToJson(
        _$ElevatorInsightsImpl instance) =>
    <String, dynamic>{
      'elevatorId': instance.elevatorId,
      'elevatorName': instance.elevatorName,
      'currentWaitMinutes': instance.currentWaitMinutes,
      'averageWaitMinutes': instance.averageWaitMinutes,
      'yesterdayWaitMinutes': instance.yesterdayWaitMinutes,
      'lastWeekSameDayWaitMinutes': instance.lastWeekSameDayWaitMinutes,
      'currentLineup': instance.currentLineup,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'status': instance.status,
      'metadata': instance.metadata,
    };

_$UserStatisticsImpl _$$UserStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatisticsImpl(
      userId: json['userId'] as String,
      totalHauls: (json['totalHauls'] as num?)?.toInt() ?? 0,
      totalWeightKg: (json['totalWeightKg'] as num?)?.toDouble() ?? 0.0,
      averageWaitMinutes: (json['averageWaitMinutes'] as num?)?.toInt() ?? 0,
      averageMoisture: (json['averageMoisture'] as num?)?.toDouble() ?? 0.0,
      averageDockagePercent:
          (json['averageDockagePercent'] as num?)?.toDouble() ?? 0.0,
      grainTypeBreakdown:
          (json['grainTypeBreakdown'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      elevatorBreakdown:
          (json['elevatorBreakdown'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      avgWaitByElevator:
          (json['avgWaitByElevator'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      lastHaulDate: json['lastHaulDate'] == null
          ? null
          : DateTime.parse(json['lastHaulDate'] as String),
      last24HoursHauls: (json['last24HoursHauls'] as num?)?.toInt() ?? 0,
      last24HoursWeightKg:
          (json['last24HoursWeightKg'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$UserStatisticsImplToJson(
        _$UserStatisticsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalHauls': instance.totalHauls,
      'totalWeightKg': instance.totalWeightKg,
      'averageWaitMinutes': instance.averageWaitMinutes,
      'averageMoisture': instance.averageMoisture,
      'averageDockagePercent': instance.averageDockagePercent,
      'grainTypeBreakdown': instance.grainTypeBreakdown,
      'elevatorBreakdown': instance.elevatorBreakdown,
      'avgWaitByElevator': instance.avgWaitByElevator,
      'lastHaulDate': instance.lastHaulDate?.toIso8601String(),
      'last24HoursHauls': instance.last24HoursHauls,
      'last24HoursWeightKg': instance.last24HoursWeightKg,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_$HaulSessionImpl _$$HaulSessionImplFromJson(Map<String, dynamic> json) =>
    _$HaulSessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      elevatorId: json['elevatorId'] as String,
      elevatorName: json['elevatorName'] as String,
      truckId: json['truckId'] as String?,
      truckName: json['truckName'] as String?,
      grainType: json['grainType'] as String?,
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      moisturePercent: (json['moisturePercent'] as num?)?.toDouble(),
      dockagePercent: (json['dockagePercent'] as num?)?.toDouble(),
      moistureSource: json['moistureSource'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      loadStartTime: json['loadStartTime'] == null
          ? null
          : DateTime.parse(json['loadStartTime'] as String),
      loadEndTime: json['loadEndTime'] == null
          ? null
          : DateTime.parse(json['loadEndTime'] as String),
      driveStartTime: json['driveStartTime'] == null
          ? null
          : DateTime.parse(json['driveStartTime'] as String),
      arrivalTime: json['arrivalTime'] == null
          ? null
          : DateTime.parse(json['arrivalTime'] as String),
      queueStartTime: json['queueStartTime'] == null
          ? null
          : DateTime.parse(json['queueStartTime'] as String),
      unloadStartTime: json['unloadStartTime'] == null
          ? null
          : DateTime.parse(json['unloadStartTime'] as String),
      unloadEndTime: json['unloadEndTime'] == null
          ? null
          : DateTime.parse(json['unloadEndTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      status: json['status'] as String? ?? 'in_progress',
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$HaulSessionImplToJson(_$HaulSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'elevatorId': instance.elevatorId,
      'elevatorName': instance.elevatorName,
      'truckId': instance.truckId,
      'truckName': instance.truckName,
      'grainType': instance.grainType,
      'weightKg': instance.weightKg,
      'moisturePercent': instance.moisturePercent,
      'dockagePercent': instance.dockagePercent,
      'moistureSource': instance.moistureSource,
      'startTime': instance.startTime.toIso8601String(),
      'loadStartTime': instance.loadStartTime?.toIso8601String(),
      'loadEndTime': instance.loadEndTime?.toIso8601String(),
      'driveStartTime': instance.driveStartTime?.toIso8601String(),
      'arrivalTime': instance.arrivalTime?.toIso8601String(),
      'queueStartTime': instance.queueStartTime?.toIso8601String(),
      'unloadStartTime': instance.unloadStartTime?.toIso8601String(),
      'unloadEndTime': instance.unloadEndTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'status': instance.status,
      'notes': instance.notes,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
