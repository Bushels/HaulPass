// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HaulStreak _$HaulStreakFromJson(Map<String, dynamic> json) => HaulStreak(
      currentStreak: (json['current_streak'] as num).toInt(),
      longestStreak: (json['longest_streak'] as num).toInt(),
      lastHaulDate: DateTime.parse(json['last_haul_date'] as String),
      streakStartDate: json['streak_start_date'] == null
          ? null
          : DateTime.parse(json['streak_start_date'] as String),
    );

Map<String, dynamic> _$HaulStreakToJson(HaulStreak instance) =>
    <String, dynamic>{
      'current_streak': instance.currentStreak,
      'longest_streak': instance.longestStreak,
      'last_haul_date': instance.lastHaulDate.toIso8601String(),
      'streak_start_date': instance.streakStartDate?.toIso8601String(),
    };

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$AchievementCategoryEnumMap, json['category']),
      tier: $enumDecode(_$BadgeTierEnumMap, json['tier']),
      requiredValue: (json['required_value'] as num).toInt(),
      currentProgress: (json['current_progress'] as num?)?.toInt() ?? 0,
      isUnlocked: json['is_unlocked'] as bool? ?? false,
      unlockedAt: json['unlocked_at'] == null
          ? null
          : DateTime.parse(json['unlocked_at'] as String),
    );

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$AchievementCategoryEnumMap[instance.category]!,
      'tier': _$BadgeTierEnumMap[instance.tier]!,
      'required_value': instance.requiredValue,
      'current_progress': instance.currentProgress,
      'is_unlocked': instance.isUnlocked,
      'unlocked_at': instance.unlockedAt?.toIso8601String(),
    };

const _$AchievementCategoryEnumMap = {
  AchievementCategory.hauls: 'hauls',
  AchievementCategory.grain: 'grain',
  AchievementCategory.efficiency: 'efficiency',
  AchievementCategory.distance: 'distance',
  AchievementCategory.queue: 'queue',
};

const _$BadgeTierEnumMap = {
  BadgeTier.bronze: 'bronze',
  BadgeTier.silver: 'silver',
  BadgeTier.gold: 'gold',
  BadgeTier.platinum: 'platinum',
  BadgeTier.diamond: 'diamond',
};

GamificationProfile _$GamificationProfileFromJson(Map<String, dynamic> json) =>
    GamificationProfile(
      streak: HaulStreak.fromJson(json['streak'] as Map<String, dynamic>),
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPoints: (json['total_points'] as num?)?.toInt() ?? 0,
      totalHauls: (json['total_hauls'] as num?)?.toInt() ?? 0,
      totalGrainKg: (json['total_grain_kg'] as num?)?.toDouble() ?? 0.0,
      totalDistanceMiles:
          (json['total_distance_miles'] as num?)?.toDouble() ?? 0.0,
      totalTimeSavedMinutes:
          (json['total_time_saved_minutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GamificationProfileToJson(
        GamificationProfile instance) =>
    <String, dynamic>{
      'streak': instance.streak,
      'achievements': instance.achievements,
      'total_points': instance.totalPoints,
      'total_hauls': instance.totalHauls,
      'total_grain_kg': instance.totalGrainKg,
      'total_distance_miles': instance.totalDistanceMiles,
      'total_time_saved_minutes': instance.totalTimeSavedMinutes,
    };
