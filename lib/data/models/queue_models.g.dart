// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueState _$QueueStateFromJson(Map<String, dynamic> json) => QueueState(
      currentTrucksInLine: (json['currentTrucksInLine'] as num).toInt(),
      appUsersEnRoute: (json['appUsersEnRoute'] as num).toInt(),
      estimatedWaitMinutes: (json['estimatedWaitMinutes'] as num).toInt(),
      typicalWaitMinutes: (json['typicalWaitMinutes'] as num).toInt(),
      avgUnloadMinutes: (json['avgUnloadMinutes'] as num).toInt(),
      busynessPercent: (json['busynessPercent'] as num).toInt(),
      status: json['status'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$QueueStateToJson(QueueState instance) =>
    <String, dynamic>{
      'currentTrucksInLine': instance.currentTrucksInLine,
      'appUsersEnRoute': instance.appUsersEnRoute,
      'estimatedWaitMinutes': instance.estimatedWaitMinutes,
      'typicalWaitMinutes': instance.typicalWaitMinutes,
      'avgUnloadMinutes': instance.avgUnloadMinutes,
      'busynessPercent': instance.busynessPercent,
      'status': instance.status,
      'confidence': instance.confidence,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
