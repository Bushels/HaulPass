import 'package:freezed_annotation/freezed_annotation.dart';

part 'truck_models.freezed.dart';
part 'truck_models.g.dart';

/// Truck model representing a farmer's vehicle
@freezed
class Truck with _$Truck {
  const factory Truck({
    required String id,
    required String userId,
    required String name,
    String? make,
    String? model,
    int? year,
    double? capacityKg,
    String? licensePlate,
    @Default(true) bool isActive,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Truck;

  factory Truck.fromJson(Map<String, dynamic> json) => _$TruckFromJson(json);
}

/// Truck performance metrics calculated from historical data
@freezed
class TruckMetrics with _$TruckMetrics {
  const TruckMetrics._();

  const factory TruckMetrics({
    required String truckId,
    required String truckName,
    @Default(0) double averageLoadTimeMinutes,
    @Default(0) double averageDriveTimeMinutes,
    @Default(0) double averageUnloadTimeMinutes,
    @Default(0) double averageTotalTimeMinutes,
    @Default(0) double averageWeightKg,
    @Default(0) int totalHauls,
    DateTime? lastHaulDate,
    @Default({}) Map<String, double> averageTimeByElevator,
    @Default({}) Map<String, int> haulCountByElevator,
  }) = _TruckMetrics;

  factory TruckMetrics.fromJson(Map<String, dynamic> json) =>
      _$TruckMetricsFromJson(json);

  /// Get formatted load time
  String get loadTimeDisplay =>
      '~${averageLoadTimeMinutes.toStringAsFixed(0)} min';

  /// Get formatted drive time
  String get driveTimeDisplay =>
      '~${averageDriveTimeMinutes.toStringAsFixed(0)} min';

  /// Get formatted total time estimate
  String get totalTimeEstimate =>
      '${averageTotalTimeMinutes.toStringAsFixed(0)} minutes';
}
