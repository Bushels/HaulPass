// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'elevator_insights.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ElevatorInsights _$ElevatorInsightsFromJson(Map<String, dynamic> json) {
  return _ElevatorInsights.fromJson(json);
}

/// @nodoc
mixin _$ElevatorInsights {
  String get elevatorId => throw _privateConstructorUsedError;
  String get elevatorName => throw _privateConstructorUsedError;
  int get currentWaitMinutes => throw _privateConstructorUsedError;
  int get averageWaitMinutes => throw _privateConstructorUsedError;
  int get yesterdayWaitMinutes => throw _privateConstructorUsedError;
  int get lastWeekSameDayWaitMinutes => throw _privateConstructorUsedError;
  int get currentLineup => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ElevatorInsightsCopyWith<ElevatorInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ElevatorInsightsCopyWith<$Res> {
  factory $ElevatorInsightsCopyWith(
          ElevatorInsights value, $Res Function(ElevatorInsights) then) =
      _$ElevatorInsightsCopyWithImpl<$Res, ElevatorInsights>;
  @useResult
  $Res call(
      {String elevatorId,
      String elevatorName,
      int currentWaitMinutes,
      int averageWaitMinutes,
      int yesterdayWaitMinutes,
      int lastWeekSameDayWaitMinutes,
      int currentLineup,
      DateTime lastUpdated,
      String? status,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$ElevatorInsightsCopyWithImpl<$Res, $Val extends ElevatorInsights>
    implements $ElevatorInsightsCopyWith<$Res> {
  _$ElevatorInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elevatorId = null,
    Object? elevatorName = null,
    Object? currentWaitMinutes = null,
    Object? averageWaitMinutes = null,
    Object? yesterdayWaitMinutes = null,
    Object? lastWeekSameDayWaitMinutes = null,
    Object? currentLineup = null,
    Object? lastUpdated = null,
    Object? status = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      elevatorId: null == elevatorId
          ? _value.elevatorId
          : elevatorId // ignore: cast_nullable_to_non_nullable
              as String,
      elevatorName: null == elevatorName
          ? _value.elevatorName
          : elevatorName // ignore: cast_nullable_to_non_nullable
              as String,
      currentWaitMinutes: null == currentWaitMinutes
          ? _value.currentWaitMinutes
          : currentWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      averageWaitMinutes: null == averageWaitMinutes
          ? _value.averageWaitMinutes
          : averageWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      yesterdayWaitMinutes: null == yesterdayWaitMinutes
          ? _value.yesterdayWaitMinutes
          : yesterdayWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lastWeekSameDayWaitMinutes: null == lastWeekSameDayWaitMinutes
          ? _value.lastWeekSameDayWaitMinutes
          : lastWeekSameDayWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      currentLineup: null == currentLineup
          ? _value.currentLineup
          : currentLineup // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ElevatorInsightsImplCopyWith<$Res>
    implements $ElevatorInsightsCopyWith<$Res> {
  factory _$$ElevatorInsightsImplCopyWith(_$ElevatorInsightsImpl value,
          $Res Function(_$ElevatorInsightsImpl) then) =
      __$$ElevatorInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String elevatorId,
      String elevatorName,
      int currentWaitMinutes,
      int averageWaitMinutes,
      int yesterdayWaitMinutes,
      int lastWeekSameDayWaitMinutes,
      int currentLineup,
      DateTime lastUpdated,
      String? status,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$ElevatorInsightsImplCopyWithImpl<$Res>
    extends _$ElevatorInsightsCopyWithImpl<$Res, _$ElevatorInsightsImpl>
    implements _$$ElevatorInsightsImplCopyWith<$Res> {
  __$$ElevatorInsightsImplCopyWithImpl(_$ElevatorInsightsImpl _value,
      $Res Function(_$ElevatorInsightsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? elevatorId = null,
    Object? elevatorName = null,
    Object? currentWaitMinutes = null,
    Object? averageWaitMinutes = null,
    Object? yesterdayWaitMinutes = null,
    Object? lastWeekSameDayWaitMinutes = null,
    Object? currentLineup = null,
    Object? lastUpdated = null,
    Object? status = freezed,
    Object? metadata = null,
  }) {
    return _then(_$ElevatorInsightsImpl(
      elevatorId: null == elevatorId
          ? _value.elevatorId
          : elevatorId // ignore: cast_nullable_to_non_nullable
              as String,
      elevatorName: null == elevatorName
          ? _value.elevatorName
          : elevatorName // ignore: cast_nullable_to_non_nullable
              as String,
      currentWaitMinutes: null == currentWaitMinutes
          ? _value.currentWaitMinutes
          : currentWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      averageWaitMinutes: null == averageWaitMinutes
          ? _value.averageWaitMinutes
          : averageWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      yesterdayWaitMinutes: null == yesterdayWaitMinutes
          ? _value.yesterdayWaitMinutes
          : yesterdayWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      lastWeekSameDayWaitMinutes: null == lastWeekSameDayWaitMinutes
          ? _value.lastWeekSameDayWaitMinutes
          : lastWeekSameDayWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      currentLineup: null == currentLineup
          ? _value.currentLineup
          : currentLineup // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ElevatorInsightsImpl extends _ElevatorInsights {
  const _$ElevatorInsightsImpl(
      {required this.elevatorId,
      required this.elevatorName,
      required this.currentWaitMinutes,
      this.averageWaitMinutes = 0,
      this.yesterdayWaitMinutes = 0,
      this.lastWeekSameDayWaitMinutes = 0,
      this.currentLineup = 0,
      required this.lastUpdated,
      this.status,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata,
        super._();

  factory _$ElevatorInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ElevatorInsightsImplFromJson(json);

  @override
  final String elevatorId;
  @override
  final String elevatorName;
  @override
  final int currentWaitMinutes;
  @override
  @JsonKey()
  final int averageWaitMinutes;
  @override
  @JsonKey()
  final int yesterdayWaitMinutes;
  @override
  @JsonKey()
  final int lastWeekSameDayWaitMinutes;
  @override
  @JsonKey()
  final int currentLineup;
  @override
  final DateTime lastUpdated;
  @override
  final String? status;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'ElevatorInsights(elevatorId: $elevatorId, elevatorName: $elevatorName, currentWaitMinutes: $currentWaitMinutes, averageWaitMinutes: $averageWaitMinutes, yesterdayWaitMinutes: $yesterdayWaitMinutes, lastWeekSameDayWaitMinutes: $lastWeekSameDayWaitMinutes, currentLineup: $currentLineup, lastUpdated: $lastUpdated, status: $status, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ElevatorInsightsImpl &&
            (identical(other.elevatorId, elevatorId) ||
                other.elevatorId == elevatorId) &&
            (identical(other.elevatorName, elevatorName) ||
                other.elevatorName == elevatorName) &&
            (identical(other.currentWaitMinutes, currentWaitMinutes) ||
                other.currentWaitMinutes == currentWaitMinutes) &&
            (identical(other.averageWaitMinutes, averageWaitMinutes) ||
                other.averageWaitMinutes == averageWaitMinutes) &&
            (identical(other.yesterdayWaitMinutes, yesterdayWaitMinutes) ||
                other.yesterdayWaitMinutes == yesterdayWaitMinutes) &&
            (identical(other.lastWeekSameDayWaitMinutes,
                    lastWeekSameDayWaitMinutes) ||
                other.lastWeekSameDayWaitMinutes ==
                    lastWeekSameDayWaitMinutes) &&
            (identical(other.currentLineup, currentLineup) ||
                other.currentLineup == currentLineup) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      elevatorId,
      elevatorName,
      currentWaitMinutes,
      averageWaitMinutes,
      yesterdayWaitMinutes,
      lastWeekSameDayWaitMinutes,
      currentLineup,
      lastUpdated,
      status,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ElevatorInsightsImplCopyWith<_$ElevatorInsightsImpl> get copyWith =>
      __$$ElevatorInsightsImplCopyWithImpl<_$ElevatorInsightsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ElevatorInsightsImplToJson(
      this,
    );
  }
}

abstract class _ElevatorInsights extends ElevatorInsights {
  const factory _ElevatorInsights(
      {required final String elevatorId,
      required final String elevatorName,
      required final int currentWaitMinutes,
      final int averageWaitMinutes,
      final int yesterdayWaitMinutes,
      final int lastWeekSameDayWaitMinutes,
      final int currentLineup,
      required final DateTime lastUpdated,
      final String? status,
      final Map<String, dynamic> metadata}) = _$ElevatorInsightsImpl;
  const _ElevatorInsights._() : super._();

  factory _ElevatorInsights.fromJson(Map<String, dynamic> json) =
      _$ElevatorInsightsImpl.fromJson;

  @override
  String get elevatorId;
  @override
  String get elevatorName;
  @override
  int get currentWaitMinutes;
  @override
  int get averageWaitMinutes;
  @override
  int get yesterdayWaitMinutes;
  @override
  int get lastWeekSameDayWaitMinutes;
  @override
  int get currentLineup;
  @override
  DateTime get lastUpdated;
  @override
  String? get status;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ElevatorInsightsImplCopyWith<_$ElevatorInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStatistics _$UserStatisticsFromJson(Map<String, dynamic> json) {
  return _UserStatistics.fromJson(json);
}

/// @nodoc
mixin _$UserStatistics {
  String get userId => throw _privateConstructorUsedError;
  int get totalHauls => throw _privateConstructorUsedError;
  double get totalWeightKg => throw _privateConstructorUsedError;
  int get averageWaitMinutes => throw _privateConstructorUsedError;
  double get averageMoisture => throw _privateConstructorUsedError;
  double get averageDockagePercent => throw _privateConstructorUsedError;
  Map<String, int> get grainTypeBreakdown => throw _privateConstructorUsedError;
  Map<String, int> get elevatorBreakdown => throw _privateConstructorUsedError;
  Map<String, double> get avgWaitByElevator =>
      throw _privateConstructorUsedError;
  DateTime? get lastHaulDate => throw _privateConstructorUsedError;
  int get last24HoursHauls => throw _privateConstructorUsedError;
  double get last24HoursWeightKg => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserStatisticsCopyWith<UserStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatisticsCopyWith<$Res> {
  factory $UserStatisticsCopyWith(
          UserStatistics value, $Res Function(UserStatistics) then) =
      _$UserStatisticsCopyWithImpl<$Res, UserStatistics>;
  @useResult
  $Res call(
      {String userId,
      int totalHauls,
      double totalWeightKg,
      int averageWaitMinutes,
      double averageMoisture,
      double averageDockagePercent,
      Map<String, int> grainTypeBreakdown,
      Map<String, int> elevatorBreakdown,
      Map<String, double> avgWaitByElevator,
      DateTime? lastHaulDate,
      int last24HoursHauls,
      double last24HoursWeightKg,
      DateTime lastUpdated});
}

/// @nodoc
class _$UserStatisticsCopyWithImpl<$Res, $Val extends UserStatistics>
    implements $UserStatisticsCopyWith<$Res> {
  _$UserStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalHauls = null,
    Object? totalWeightKg = null,
    Object? averageWaitMinutes = null,
    Object? averageMoisture = null,
    Object? averageDockagePercent = null,
    Object? grainTypeBreakdown = null,
    Object? elevatorBreakdown = null,
    Object? avgWaitByElevator = null,
    Object? lastHaulDate = freezed,
    Object? last24HoursHauls = null,
    Object? last24HoursWeightKg = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalHauls: null == totalHauls
          ? _value.totalHauls
          : totalHauls // ignore: cast_nullable_to_non_nullable
              as int,
      totalWeightKg: null == totalWeightKg
          ? _value.totalWeightKg
          : totalWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      averageWaitMinutes: null == averageWaitMinutes
          ? _value.averageWaitMinutes
          : averageWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      averageMoisture: null == averageMoisture
          ? _value.averageMoisture
          : averageMoisture // ignore: cast_nullable_to_non_nullable
              as double,
      averageDockagePercent: null == averageDockagePercent
          ? _value.averageDockagePercent
          : averageDockagePercent // ignore: cast_nullable_to_non_nullable
              as double,
      grainTypeBreakdown: null == grainTypeBreakdown
          ? _value.grainTypeBreakdown
          : grainTypeBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      elevatorBreakdown: null == elevatorBreakdown
          ? _value.elevatorBreakdown
          : elevatorBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      avgWaitByElevator: null == avgWaitByElevator
          ? _value.avgWaitByElevator
          : avgWaitByElevator // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      lastHaulDate: freezed == lastHaulDate
          ? _value.lastHaulDate
          : lastHaulDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      last24HoursHauls: null == last24HoursHauls
          ? _value.last24HoursHauls
          : last24HoursHauls // ignore: cast_nullable_to_non_nullable
              as int,
      last24HoursWeightKg: null == last24HoursWeightKg
          ? _value.last24HoursWeightKg
          : last24HoursWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatisticsImplCopyWith<$Res>
    implements $UserStatisticsCopyWith<$Res> {
  factory _$$UserStatisticsImplCopyWith(_$UserStatisticsImpl value,
          $Res Function(_$UserStatisticsImpl) then) =
      __$$UserStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int totalHauls,
      double totalWeightKg,
      int averageWaitMinutes,
      double averageMoisture,
      double averageDockagePercent,
      Map<String, int> grainTypeBreakdown,
      Map<String, int> elevatorBreakdown,
      Map<String, double> avgWaitByElevator,
      DateTime? lastHaulDate,
      int last24HoursHauls,
      double last24HoursWeightKg,
      DateTime lastUpdated});
}

/// @nodoc
class __$$UserStatisticsImplCopyWithImpl<$Res>
    extends _$UserStatisticsCopyWithImpl<$Res, _$UserStatisticsImpl>
    implements _$$UserStatisticsImplCopyWith<$Res> {
  __$$UserStatisticsImplCopyWithImpl(
      _$UserStatisticsImpl _value, $Res Function(_$UserStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalHauls = null,
    Object? totalWeightKg = null,
    Object? averageWaitMinutes = null,
    Object? averageMoisture = null,
    Object? averageDockagePercent = null,
    Object? grainTypeBreakdown = null,
    Object? elevatorBreakdown = null,
    Object? avgWaitByElevator = null,
    Object? lastHaulDate = freezed,
    Object? last24HoursHauls = null,
    Object? last24HoursWeightKg = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$UserStatisticsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalHauls: null == totalHauls
          ? _value.totalHauls
          : totalHauls // ignore: cast_nullable_to_non_nullable
              as int,
      totalWeightKg: null == totalWeightKg
          ? _value.totalWeightKg
          : totalWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      averageWaitMinutes: null == averageWaitMinutes
          ? _value.averageWaitMinutes
          : averageWaitMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      averageMoisture: null == averageMoisture
          ? _value.averageMoisture
          : averageMoisture // ignore: cast_nullable_to_non_nullable
              as double,
      averageDockagePercent: null == averageDockagePercent
          ? _value.averageDockagePercent
          : averageDockagePercent // ignore: cast_nullable_to_non_nullable
              as double,
      grainTypeBreakdown: null == grainTypeBreakdown
          ? _value._grainTypeBreakdown
          : grainTypeBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      elevatorBreakdown: null == elevatorBreakdown
          ? _value._elevatorBreakdown
          : elevatorBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      avgWaitByElevator: null == avgWaitByElevator
          ? _value._avgWaitByElevator
          : avgWaitByElevator // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      lastHaulDate: freezed == lastHaulDate
          ? _value.lastHaulDate
          : lastHaulDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      last24HoursHauls: null == last24HoursHauls
          ? _value.last24HoursHauls
          : last24HoursHauls // ignore: cast_nullable_to_non_nullable
              as int,
      last24HoursWeightKg: null == last24HoursWeightKg
          ? _value.last24HoursWeightKg
          : last24HoursWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatisticsImpl extends _UserStatistics {
  const _$UserStatisticsImpl(
      {required this.userId,
      this.totalHauls = 0,
      this.totalWeightKg = 0.0,
      this.averageWaitMinutes = 0,
      this.averageMoisture = 0.0,
      this.averageDockagePercent = 0.0,
      final Map<String, int> grainTypeBreakdown = const {},
      final Map<String, int> elevatorBreakdown = const {},
      final Map<String, double> avgWaitByElevator = const {},
      this.lastHaulDate,
      this.last24HoursHauls = 0,
      this.last24HoursWeightKg = 0.0,
      required this.lastUpdated})
      : _grainTypeBreakdown = grainTypeBreakdown,
        _elevatorBreakdown = elevatorBreakdown,
        _avgWaitByElevator = avgWaitByElevator,
        super._();

  factory _$UserStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatisticsImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final int totalHauls;
  @override
  @JsonKey()
  final double totalWeightKg;
  @override
  @JsonKey()
  final int averageWaitMinutes;
  @override
  @JsonKey()
  final double averageMoisture;
  @override
  @JsonKey()
  final double averageDockagePercent;
  final Map<String, int> _grainTypeBreakdown;
  @override
  @JsonKey()
  Map<String, int> get grainTypeBreakdown {
    if (_grainTypeBreakdown is EqualUnmodifiableMapView)
      return _grainTypeBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_grainTypeBreakdown);
  }

  final Map<String, int> _elevatorBreakdown;
  @override
  @JsonKey()
  Map<String, int> get elevatorBreakdown {
    if (_elevatorBreakdown is EqualUnmodifiableMapView)
      return _elevatorBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_elevatorBreakdown);
  }

  final Map<String, double> _avgWaitByElevator;
  @override
  @JsonKey()
  Map<String, double> get avgWaitByElevator {
    if (_avgWaitByElevator is EqualUnmodifiableMapView)
      return _avgWaitByElevator;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_avgWaitByElevator);
  }

  @override
  final DateTime? lastHaulDate;
  @override
  @JsonKey()
  final int last24HoursHauls;
  @override
  @JsonKey()
  final double last24HoursWeightKg;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'UserStatistics(userId: $userId, totalHauls: $totalHauls, totalWeightKg: $totalWeightKg, averageWaitMinutes: $averageWaitMinutes, averageMoisture: $averageMoisture, averageDockagePercent: $averageDockagePercent, grainTypeBreakdown: $grainTypeBreakdown, elevatorBreakdown: $elevatorBreakdown, avgWaitByElevator: $avgWaitByElevator, lastHaulDate: $lastHaulDate, last24HoursHauls: $last24HoursHauls, last24HoursWeightKg: $last24HoursWeightKg, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatisticsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalHauls, totalHauls) ||
                other.totalHauls == totalHauls) &&
            (identical(other.totalWeightKg, totalWeightKg) ||
                other.totalWeightKg == totalWeightKg) &&
            (identical(other.averageWaitMinutes, averageWaitMinutes) ||
                other.averageWaitMinutes == averageWaitMinutes) &&
            (identical(other.averageMoisture, averageMoisture) ||
                other.averageMoisture == averageMoisture) &&
            (identical(other.averageDockagePercent, averageDockagePercent) ||
                other.averageDockagePercent == averageDockagePercent) &&
            const DeepCollectionEquality()
                .equals(other._grainTypeBreakdown, _grainTypeBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._elevatorBreakdown, _elevatorBreakdown) &&
            const DeepCollectionEquality()
                .equals(other._avgWaitByElevator, _avgWaitByElevator) &&
            (identical(other.lastHaulDate, lastHaulDate) ||
                other.lastHaulDate == lastHaulDate) &&
            (identical(other.last24HoursHauls, last24HoursHauls) ||
                other.last24HoursHauls == last24HoursHauls) &&
            (identical(other.last24HoursWeightKg, last24HoursWeightKg) ||
                other.last24HoursWeightKg == last24HoursWeightKg) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      totalHauls,
      totalWeightKg,
      averageWaitMinutes,
      averageMoisture,
      averageDockagePercent,
      const DeepCollectionEquality().hash(_grainTypeBreakdown),
      const DeepCollectionEquality().hash(_elevatorBreakdown),
      const DeepCollectionEquality().hash(_avgWaitByElevator),
      lastHaulDate,
      last24HoursHauls,
      last24HoursWeightKg,
      lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatisticsImplCopyWith<_$UserStatisticsImpl> get copyWith =>
      __$$UserStatisticsImplCopyWithImpl<_$UserStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatisticsImplToJson(
      this,
    );
  }
}

abstract class _UserStatistics extends UserStatistics {
  const factory _UserStatistics(
      {required final String userId,
      final int totalHauls,
      final double totalWeightKg,
      final int averageWaitMinutes,
      final double averageMoisture,
      final double averageDockagePercent,
      final Map<String, int> grainTypeBreakdown,
      final Map<String, int> elevatorBreakdown,
      final Map<String, double> avgWaitByElevator,
      final DateTime? lastHaulDate,
      final int last24HoursHauls,
      final double last24HoursWeightKg,
      required final DateTime lastUpdated}) = _$UserStatisticsImpl;
  const _UserStatistics._() : super._();

  factory _UserStatistics.fromJson(Map<String, dynamic> json) =
      _$UserStatisticsImpl.fromJson;

  @override
  String get userId;
  @override
  int get totalHauls;
  @override
  double get totalWeightKg;
  @override
  int get averageWaitMinutes;
  @override
  double get averageMoisture;
  @override
  double get averageDockagePercent;
  @override
  Map<String, int> get grainTypeBreakdown;
  @override
  Map<String, int> get elevatorBreakdown;
  @override
  Map<String, double> get avgWaitByElevator;
  @override
  DateTime? get lastHaulDate;
  @override
  int get last24HoursHauls;
  @override
  double get last24HoursWeightKg;
  @override
  DateTime get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$UserStatisticsImplCopyWith<_$UserStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HaulSession _$HaulSessionFromJson(Map<String, dynamic> json) {
  return _HaulSession.fromJson(json);
}

/// @nodoc
mixin _$HaulSession {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get elevatorId => throw _privateConstructorUsedError;
  String get elevatorName => throw _privateConstructorUsedError;
  String? get truckId => throw _privateConstructorUsedError;
  String? get truckName => throw _privateConstructorUsedError;
  String? get grainType => throw _privateConstructorUsedError;
  double? get weightKg => throw _privateConstructorUsedError;
  double? get moisturePercent => throw _privateConstructorUsedError;
  double? get dockagePercent => throw _privateConstructorUsedError;
  String? get moistureSource =>
      throw _privateConstructorUsedError; // 'bin' or 'elevator'
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get loadStartTime => throw _privateConstructorUsedError;
  DateTime? get loadEndTime => throw _privateConstructorUsedError;
  DateTime? get driveStartTime => throw _privateConstructorUsedError;
  DateTime? get arrivalTime => throw _privateConstructorUsedError;
  DateTime? get queueStartTime => throw _privateConstructorUsedError;
  DateTime? get unloadStartTime => throw _privateConstructorUsedError;
  DateTime? get unloadEndTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HaulSessionCopyWith<HaulSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HaulSessionCopyWith<$Res> {
  factory $HaulSessionCopyWith(
          HaulSession value, $Res Function(HaulSession) then) =
      _$HaulSessionCopyWithImpl<$Res, HaulSession>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String elevatorId,
      String elevatorName,
      String? truckId,
      String? truckName,
      String? grainType,
      double? weightKg,
      double? moisturePercent,
      double? dockagePercent,
      String? moistureSource,
      DateTime startTime,
      DateTime? loadStartTime,
      DateTime? loadEndTime,
      DateTime? driveStartTime,
      DateTime? arrivalTime,
      DateTime? queueStartTime,
      DateTime? unloadStartTime,
      DateTime? unloadEndTime,
      DateTime? endTime,
      String status,
      String? notes,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$HaulSessionCopyWithImpl<$Res, $Val extends HaulSession>
    implements $HaulSessionCopyWith<$Res> {
  _$HaulSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? elevatorId = null,
    Object? elevatorName = null,
    Object? truckId = freezed,
    Object? truckName = freezed,
    Object? grainType = freezed,
    Object? weightKg = freezed,
    Object? moisturePercent = freezed,
    Object? dockagePercent = freezed,
    Object? moistureSource = freezed,
    Object? startTime = null,
    Object? loadStartTime = freezed,
    Object? loadEndTime = freezed,
    Object? driveStartTime = freezed,
    Object? arrivalTime = freezed,
    Object? queueStartTime = freezed,
    Object? unloadStartTime = freezed,
    Object? unloadEndTime = freezed,
    Object? endTime = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      elevatorId: null == elevatorId
          ? _value.elevatorId
          : elevatorId // ignore: cast_nullable_to_non_nullable
              as String,
      elevatorName: null == elevatorName
          ? _value.elevatorName
          : elevatorName // ignore: cast_nullable_to_non_nullable
              as String,
      truckId: freezed == truckId
          ? _value.truckId
          : truckId // ignore: cast_nullable_to_non_nullable
              as String?,
      truckName: freezed == truckName
          ? _value.truckName
          : truckName // ignore: cast_nullable_to_non_nullable
              as String?,
      grainType: freezed == grainType
          ? _value.grainType
          : grainType // ignore: cast_nullable_to_non_nullable
              as String?,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      moisturePercent: freezed == moisturePercent
          ? _value.moisturePercent
          : moisturePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      dockagePercent: freezed == dockagePercent
          ? _value.dockagePercent
          : dockagePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      moistureSource: freezed == moistureSource
          ? _value.moistureSource
          : moistureSource // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      loadStartTime: freezed == loadStartTime
          ? _value.loadStartTime
          : loadStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      loadEndTime: freezed == loadEndTime
          ? _value.loadEndTime
          : loadEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      driveStartTime: freezed == driveStartTime
          ? _value.driveStartTime
          : driveStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivalTime: freezed == arrivalTime
          ? _value.arrivalTime
          : arrivalTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      queueStartTime: freezed == queueStartTime
          ? _value.queueStartTime
          : queueStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unloadStartTime: freezed == unloadStartTime
          ? _value.unloadStartTime
          : unloadStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unloadEndTime: freezed == unloadEndTime
          ? _value.unloadEndTime
          : unloadEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HaulSessionImplCopyWith<$Res>
    implements $HaulSessionCopyWith<$Res> {
  factory _$$HaulSessionImplCopyWith(
          _$HaulSessionImpl value, $Res Function(_$HaulSessionImpl) then) =
      __$$HaulSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String elevatorId,
      String elevatorName,
      String? truckId,
      String? truckName,
      String? grainType,
      double? weightKg,
      double? moisturePercent,
      double? dockagePercent,
      String? moistureSource,
      DateTime startTime,
      DateTime? loadStartTime,
      DateTime? loadEndTime,
      DateTime? driveStartTime,
      DateTime? arrivalTime,
      DateTime? queueStartTime,
      DateTime? unloadStartTime,
      DateTime? unloadEndTime,
      DateTime? endTime,
      String status,
      String? notes,
      Map<String, dynamic> metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$HaulSessionImplCopyWithImpl<$Res>
    extends _$HaulSessionCopyWithImpl<$Res, _$HaulSessionImpl>
    implements _$$HaulSessionImplCopyWith<$Res> {
  __$$HaulSessionImplCopyWithImpl(
      _$HaulSessionImpl _value, $Res Function(_$HaulSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? elevatorId = null,
    Object? elevatorName = null,
    Object? truckId = freezed,
    Object? truckName = freezed,
    Object? grainType = freezed,
    Object? weightKg = freezed,
    Object? moisturePercent = freezed,
    Object? dockagePercent = freezed,
    Object? moistureSource = freezed,
    Object? startTime = null,
    Object? loadStartTime = freezed,
    Object? loadEndTime = freezed,
    Object? driveStartTime = freezed,
    Object? arrivalTime = freezed,
    Object? queueStartTime = freezed,
    Object? unloadStartTime = freezed,
    Object? unloadEndTime = freezed,
    Object? endTime = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$HaulSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      elevatorId: null == elevatorId
          ? _value.elevatorId
          : elevatorId // ignore: cast_nullable_to_non_nullable
              as String,
      elevatorName: null == elevatorName
          ? _value.elevatorName
          : elevatorName // ignore: cast_nullable_to_non_nullable
              as String,
      truckId: freezed == truckId
          ? _value.truckId
          : truckId // ignore: cast_nullable_to_non_nullable
              as String?,
      truckName: freezed == truckName
          ? _value.truckName
          : truckName // ignore: cast_nullable_to_non_nullable
              as String?,
      grainType: freezed == grainType
          ? _value.grainType
          : grainType // ignore: cast_nullable_to_non_nullable
              as String?,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      moisturePercent: freezed == moisturePercent
          ? _value.moisturePercent
          : moisturePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      dockagePercent: freezed == dockagePercent
          ? _value.dockagePercent
          : dockagePercent // ignore: cast_nullable_to_non_nullable
              as double?,
      moistureSource: freezed == moistureSource
          ? _value.moistureSource
          : moistureSource // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      loadStartTime: freezed == loadStartTime
          ? _value.loadStartTime
          : loadStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      loadEndTime: freezed == loadEndTime
          ? _value.loadEndTime
          : loadEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      driveStartTime: freezed == driveStartTime
          ? _value.driveStartTime
          : driveStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      arrivalTime: freezed == arrivalTime
          ? _value.arrivalTime
          : arrivalTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      queueStartTime: freezed == queueStartTime
          ? _value.queueStartTime
          : queueStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unloadStartTime: freezed == unloadStartTime
          ? _value.unloadStartTime
          : unloadStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unloadEndTime: freezed == unloadEndTime
          ? _value.unloadEndTime
          : unloadEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HaulSessionImpl extends _HaulSession {
  const _$HaulSessionImpl(
      {required this.id,
      required this.userId,
      required this.elevatorId,
      required this.elevatorName,
      this.truckId,
      this.truckName,
      this.grainType,
      this.weightKg,
      this.moisturePercent,
      this.dockagePercent,
      this.moistureSource,
      required this.startTime,
      this.loadStartTime,
      this.loadEndTime,
      this.driveStartTime,
      this.arrivalTime,
      this.queueStartTime,
      this.unloadStartTime,
      this.unloadEndTime,
      this.endTime,
      this.status = 'in_progress',
      this.notes,
      final Map<String, dynamic> metadata = const {},
      required this.createdAt,
      this.updatedAt})
      : _metadata = metadata,
        super._();

  factory _$HaulSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$HaulSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String elevatorId;
  @override
  final String elevatorName;
  @override
  final String? truckId;
  @override
  final String? truckName;
  @override
  final String? grainType;
  @override
  final double? weightKg;
  @override
  final double? moisturePercent;
  @override
  final double? dockagePercent;
  @override
  final String? moistureSource;
// 'bin' or 'elevator'
  @override
  final DateTime startTime;
  @override
  final DateTime? loadStartTime;
  @override
  final DateTime? loadEndTime;
  @override
  final DateTime? driveStartTime;
  @override
  final DateTime? arrivalTime;
  @override
  final DateTime? queueStartTime;
  @override
  final DateTime? unloadStartTime;
  @override
  final DateTime? unloadEndTime;
  @override
  final DateTime? endTime;
  @override
  @JsonKey()
  final String status;
  @override
  final String? notes;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'HaulSession(id: $id, userId: $userId, elevatorId: $elevatorId, elevatorName: $elevatorName, truckId: $truckId, truckName: $truckName, grainType: $grainType, weightKg: $weightKg, moisturePercent: $moisturePercent, dockagePercent: $dockagePercent, moistureSource: $moistureSource, startTime: $startTime, loadStartTime: $loadStartTime, loadEndTime: $loadEndTime, driveStartTime: $driveStartTime, arrivalTime: $arrivalTime, queueStartTime: $queueStartTime, unloadStartTime: $unloadStartTime, unloadEndTime: $unloadEndTime, endTime: $endTime, status: $status, notes: $notes, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HaulSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.elevatorId, elevatorId) ||
                other.elevatorId == elevatorId) &&
            (identical(other.elevatorName, elevatorName) ||
                other.elevatorName == elevatorName) &&
            (identical(other.truckId, truckId) || other.truckId == truckId) &&
            (identical(other.truckName, truckName) ||
                other.truckName == truckName) &&
            (identical(other.grainType, grainType) ||
                other.grainType == grainType) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.moisturePercent, moisturePercent) ||
                other.moisturePercent == moisturePercent) &&
            (identical(other.dockagePercent, dockagePercent) ||
                other.dockagePercent == dockagePercent) &&
            (identical(other.moistureSource, moistureSource) ||
                other.moistureSource == moistureSource) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.loadStartTime, loadStartTime) ||
                other.loadStartTime == loadStartTime) &&
            (identical(other.loadEndTime, loadEndTime) ||
                other.loadEndTime == loadEndTime) &&
            (identical(other.driveStartTime, driveStartTime) ||
                other.driveStartTime == driveStartTime) &&
            (identical(other.arrivalTime, arrivalTime) ||
                other.arrivalTime == arrivalTime) &&
            (identical(other.queueStartTime, queueStartTime) ||
                other.queueStartTime == queueStartTime) &&
            (identical(other.unloadStartTime, unloadStartTime) ||
                other.unloadStartTime == unloadStartTime) &&
            (identical(other.unloadEndTime, unloadEndTime) ||
                other.unloadEndTime == unloadEndTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        elevatorId,
        elevatorName,
        truckId,
        truckName,
        grainType,
        weightKg,
        moisturePercent,
        dockagePercent,
        moistureSource,
        startTime,
        loadStartTime,
        loadEndTime,
        driveStartTime,
        arrivalTime,
        queueStartTime,
        unloadStartTime,
        unloadEndTime,
        endTime,
        status,
        notes,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HaulSessionImplCopyWith<_$HaulSessionImpl> get copyWith =>
      __$$HaulSessionImplCopyWithImpl<_$HaulSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HaulSessionImplToJson(
      this,
    );
  }
}

abstract class _HaulSession extends HaulSession {
  const factory _HaulSession(
      {required final String id,
      required final String userId,
      required final String elevatorId,
      required final String elevatorName,
      final String? truckId,
      final String? truckName,
      final String? grainType,
      final double? weightKg,
      final double? moisturePercent,
      final double? dockagePercent,
      final String? moistureSource,
      required final DateTime startTime,
      final DateTime? loadStartTime,
      final DateTime? loadEndTime,
      final DateTime? driveStartTime,
      final DateTime? arrivalTime,
      final DateTime? queueStartTime,
      final DateTime? unloadStartTime,
      final DateTime? unloadEndTime,
      final DateTime? endTime,
      final String status,
      final String? notes,
      final Map<String, dynamic> metadata,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$HaulSessionImpl;
  const _HaulSession._() : super._();

  factory _HaulSession.fromJson(Map<String, dynamic> json) =
      _$HaulSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get elevatorId;
  @override
  String get elevatorName;
  @override
  String? get truckId;
  @override
  String? get truckName;
  @override
  String? get grainType;
  @override
  double? get weightKg;
  @override
  double? get moisturePercent;
  @override
  double? get dockagePercent;
  @override
  String? get moistureSource;
  @override // 'bin' or 'elevator'
  DateTime get startTime;
  @override
  DateTime? get loadStartTime;
  @override
  DateTime? get loadEndTime;
  @override
  DateTime? get driveStartTime;
  @override
  DateTime? get arrivalTime;
  @override
  DateTime? get queueStartTime;
  @override
  DateTime? get unloadStartTime;
  @override
  DateTime? get unloadEndTime;
  @override
  DateTime? get endTime;
  @override
  String get status;
  @override
  String? get notes;
  @override
  Map<String, dynamic> get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$HaulSessionImplCopyWith<_$HaulSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
