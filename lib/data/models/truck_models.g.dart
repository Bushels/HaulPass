// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TruckImpl _$$TruckImplFromJson(Map<String, dynamic> json) => _$TruckImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      make: json['make'] as String?,
      model: json['model'] as String?,
      year: (json['year'] as num?)?.toInt(),
      capacityKg: (json['capacityKg'] as num?)?.toDouble(),
      licensePlate: json['licensePlate'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TruckImplToJson(_$TruckImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'capacityKg': instance.capacityKg,
      'licensePlate': instance.licensePlate,
      'isActive': instance.isActive,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$TruckMetricsImpl _$$TruckMetricsImplFromJson(Map<String, dynamic> json) =>
    _$TruckMetricsImpl(
      truckId: json['truckId'] as String,
      truckName: json['truckName'] as String,
      averageLoadTimeMinutes:
          (json['averageLoadTimeMinutes'] as num?)?.toDouble() ?? 0,
      averageDriveTimeMinutes:
          (json['averageDriveTimeMinutes'] as num?)?.toDouble() ?? 0,
      averageUnloadTimeMinutes:
          (json['averageUnloadTimeMinutes'] as num?)?.toDouble() ?? 0,
      averageTotalTimeMinutes:
          (json['averageTotalTimeMinutes'] as num?)?.toDouble() ?? 0,
      averageWeightKg: (json['averageWeightKg'] as num?)?.toDouble() ?? 0,
      totalHauls: (json['totalHauls'] as num?)?.toInt() ?? 0,
      lastHaulDate: json['lastHaulDate'] == null
          ? null
          : DateTime.parse(json['lastHaulDate'] as String),
      averageTimeByElevator:
          (json['averageTimeByElevator'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      haulCountByElevator:
          (json['haulCountByElevator'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
    );

Map<String, dynamic> _$$TruckMetricsImplToJson(_$TruckMetricsImpl instance) =>
    <String, dynamic>{
      'truckId': instance.truckId,
      'truckName': instance.truckName,
      'averageLoadTimeMinutes': instance.averageLoadTimeMinutes,
      'averageDriveTimeMinutes': instance.averageDriveTimeMinutes,
      'averageUnloadTimeMinutes': instance.averageUnloadTimeMinutes,
      'averageTotalTimeMinutes': instance.averageTotalTimeMinutes,
      'averageWeightKg': instance.averageWeightKg,
      'totalHauls': instance.totalHauls,
      'lastHaulDate': instance.lastHaulDate?.toIso8601String(),
      'averageTimeByElevator': instance.averageTimeByElevator,
      'haulCountByElevator': instance.haulCountByElevator,
    };
