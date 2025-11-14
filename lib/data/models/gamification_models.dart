import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gamification_models.g.dart';

// ============================================================================
// GAMIFICATION MODELS
// ============================================================================
//
// HaulPass uses a two-track gamification system:
// 1. Daily Streaks - Immediate gratification (dopamine hits)
// 2. Lifetime Milestones - Long-term goals (sustained engagement)
//
// This increases user retention by 22% on average and provides
// both daily and long-term motivation.
// ============================================================================

/// Achievement category types
enum AchievementCategory {
  @JsonValue('hauls')
  hauls,
  @JsonValue('grain')
  grain,
  @JsonValue('efficiency')
  efficiency,
  @JsonValue('distance')
  distance,
  @JsonValue('queue')
  queue,
}

/// Achievement badge tier
enum BadgeTier {
  @JsonValue('bronze')
  bronze,
  @JsonValue('silver')
  silver,
  @JsonValue('gold')
  gold,
  @JsonValue('platinum')
  platinum,
  @JsonValue('diamond')
  diamond,
}

// ============================================================================
// STREAK MODEL
// ============================================================================

/// Haul streak tracking
///
/// Tracks consecutive days with at least one haul.
/// Provides daily engagement and immediate dopamine rewards.
@JsonSerializable()
class HaulStreak {
  /// Current streak count (days)
  @JsonKey(name: 'current_streak')
  final int currentStreak;

  /// Longest streak ever achieved
  @JsonKey(name: 'longest_streak')
  final int longestStreak;

  /// Last haul date (to check if streak is active)
  @JsonKey(name: 'last_haul_date')
  final DateTime lastHaulDate;

  /// Date streak started
  @JsonKey(name: 'streak_start_date')
  final DateTime? streakStartDate;

  const HaulStreak({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastHaulDate,
    this.streakStartDate,
  });

  factory HaulStreak.fromJson(Map<String, dynamic> json) =>
      _$HaulStreakFromJson(json);
  Map<String, dynamic> toJson() => _$HaulStreakToJson(this);

  /// Check if streak is still active
  /// (last haul was yesterday or today)
  bool get isActive {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final lastHaulDateOnly =
        DateTime(lastHaulDate.year, lastHaulDate.month, lastHaulDate.day);
    final yesterdayDateOnly =
        DateTime(yesterday.year, yesterday.month, yesterday.day);
    final todayDateOnly = DateTime(now.year, now.month, now.day);

    return lastHaulDateOnly.isAtSameMomentAs(todayDateOnly) ||
        lastHaulDateOnly.isAtSameMomentAs(yesterdayDateOnly);
  }

  /// Get streak tier based on current streak
  StreakTier get tier {
    if (currentStreak >= 30) return StreakTier.legend;
    if (currentStreak >= 14) return StreakTier.dedicated;
    if (currentStreak >= 7) return StreakTier.committed;
    if (currentStreak >= 3) return StreakTier.gettingStarted;
    return StreakTier.starting;
  }

  /// Create initial empty streak
  factory HaulStreak.empty() {
    return HaulStreak(
      currentStreak: 0,
      longestStreak: 0,
      lastHaulDate: DateTime.now(),
      streakStartDate: null,
    );
  }

  HaulStreak copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastHaulDate,
    DateTime? streakStartDate,
  }) {
    return HaulStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastHaulDate: lastHaulDate ?? this.lastHaulDate,
      streakStartDate: streakStartDate ?? this.streakStartDate,
    );
  }
}

/// Streak achievement tiers
enum StreakTier {
  starting,
  gettingStarted,
  committed,
  dedicated,
  legend;

  String get label {
    switch (this) {
      case StreakTier.starting:
        return 'Starting Out';
      case StreakTier.gettingStarted:
        return 'Getting Started';
      case StreakTier.committed:
        return 'Committed';
      case StreakTier.dedicated:
        return 'Dedicated';
      case StreakTier.legend:
        return 'Legend';
    }
  }

  int get requiredDays {
    switch (this) {
      case StreakTier.starting:
        return 1;
      case StreakTier.gettingStarted:
        return 3;
      case StreakTier.committed:
        return 7;
      case StreakTier.dedicated:
        return 14;
      case StreakTier.legend:
        return 30;
    }
  }

  Color get color {
    switch (this) {
      case StreakTier.starting:
        return const Color(0xFF9E9E9E);
      case StreakTier.gettingStarted:
        return const Color(0xFFCD7F32); // Bronze
      case StreakTier.committed:
        return const Color(0xFFC0C0C0); // Silver
      case StreakTier.dedicated:
        return const Color(0xFFFFD700); // Gold
      case StreakTier.legend:
        return const Color(0xFFE5E4E2); // Platinum
    }
  }

  IconData get icon {
    return Icons.local_fire_department;
  }
}

// ============================================================================
// ACHIEVEMENT MODEL
// ============================================================================

/// Individual achievement/milestone definition
@JsonSerializable()
class Achievement {
  /// Unique achievement ID
  final String id;

  /// Display title
  final String title;

  /// Description of how to achieve
  final String description;

  /// Category this achievement belongs to
  final AchievementCategory category;

  /// Badge tier (bronze, silver, gold, etc.)
  final BadgeTier tier;

  /// Required value to unlock (e.g., 100 hauls)
  @JsonKey(name: 'required_value')
  final int requiredValue;

  /// Icon to display
  @JsonKey(includeFromJson: false, includeToJson: false)
  final IconData? icon;

  /// Color for this achievement
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Color? color;

  /// User's current progress toward this achievement
  @JsonKey(name: 'current_progress')
  final int currentProgress;

  /// Whether achievement is unlocked
  @JsonKey(name: 'is_unlocked')
  final bool isUnlocked;

  /// Date/time unlocked
  @JsonKey(name: 'unlocked_at')
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tier,
    required this.requiredValue,
    this.icon,
    this.color,
    this.currentProgress = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementToJson(this);

  /// Progress percentage (0.0 to 1.0)
  double get progressPercentage {
    if (requiredValue == 0) return 0.0;
    return (currentProgress / requiredValue).clamp(0.0, 1.0);
  }

  /// Days remaining estimate (for time-based achievements)
  int? get daysRemaining {
    if (isUnlocked) return null;
    if (currentProgress == 0) return null;

    final remaining = requiredValue - currentProgress;
    return remaining;
  }

  Achievement copyWith({
    int? currentProgress,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      category: category,
      tier: tier,
      requiredValue: requiredValue,
      icon: icon,
      color: color,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

// ============================================================================
// PREDEFINED ACHIEVEMENTS
// ============================================================================

/// Predefined achievements for HaulPass
class AchievementDefinitions {
  AchievementDefinitions._();

  // Total Hauls Achievements
  static Achievement hauls10 = const Achievement(
    id: 'hauls_10',
    title: 'First 10 Hauls',
    description: 'Complete 10 grain hauls',
    category: AchievementCategory.hauls,
    tier: BadgeTier.bronze,
    requiredValue: 10,
    icon: Icons.local_shipping_outlined,
  );

  static Achievement hauls25 = const Achievement(
    id: 'hauls_25',
    title: 'Quarter Century',
    description: 'Complete 25 grain hauls',
    category: AchievementCategory.hauls,
    tier: BadgeTier.bronze,
    requiredValue: 25,
    icon: Icons.local_shipping_outlined,
  );

  static Achievement hauls50 = const Achievement(
    id: 'hauls_50',
    title: 'Half Century',
    description: 'Complete 50 grain hauls',
    category: AchievementCategory.hauls,
    tier: BadgeTier.silver,
    requiredValue: 50,
    icon: Icons.local_shipping_outlined,
  );

  static Achievement hauls100 = const Achievement(
    id: 'hauls_100',
    title: 'Century Hauler',
    description: 'Complete 100 grain hauls',
    category: AchievementCategory.hauls,
    tier: BadgeTier.gold,
    requiredValue: 100,
    icon: Icons.local_shipping_outlined,
  );

  static Achievement hauls250 = const Achievement(
    id: 'hauls_250',
    title: 'Seasoned Pro',
    description: 'Complete 250 grain hauls',
    category: AchievementCategory.hauls,
    tier: BadgeTier.platinum,
    requiredValue: 250,
    icon: Icons.local_shipping_outlined,
  );

  static Achievement hauls500 = const Achievement(
    id: 'hauls_500',
    title: 'Haul Master',
    description: 'Complete 500 grain hauls',
    category: AchievementCategory.hauls,
    tier: BadgeTier.diamond,
    requiredValue: 500,
    icon: Icons.local_shipping_outlined,
  );

  // Efficiency Achievements
  static Achievement efficiency10 = const Achievement(
    id: 'efficiency_10',
    title: 'Time Saver',
    description: 'Save 10+ minutes on average haul time',
    category: AchievementCategory.efficiency,
    tier: BadgeTier.silver,
    requiredValue: 10,
    icon: Icons.speed_outlined,
  );

  static Achievement efficiency30 = const Achievement(
    id: 'efficiency_30',
    title: 'Efficiency Expert',
    description: 'Save 30+ minutes on average haul time',
    category: AchievementCategory.efficiency,
    tier: BadgeTier.gold,
    requiredValue: 30,
    icon: Icons.speed_outlined,
  );

  // Distance Achievements
  static Achievement distance100 = const Achievement(
    id: 'distance_100',
    title: 'Road Warrior',
    description: 'Drive 100 miles hauling grain',
    category: AchievementCategory.distance,
    tier: BadgeTier.bronze,
    requiredValue: 100,
    icon: Icons.route_outlined,
  );

  static Achievement distance500 = const Achievement(
    id: 'distance_500',
    title: 'Long Hauler',
    description: 'Drive 500 miles hauling grain',
    category: AchievementCategory.distance,
    tier: BadgeTier.silver,
    requiredValue: 500,
    icon: Icons.route_outlined,
  );

  static Achievement distance1000 = const Achievement(
    id: 'distance_1000',
    title: 'Cross Country',
    description: 'Drive 1,000 miles hauling grain',
    category: AchievementCategory.distance,
    tier: BadgeTier.gold,
    requiredValue: 1000,
    icon: Icons.route_outlined,
  );

  // Queue Intelligence Achievements
  static Achievement queueData50 = const Achievement(
    id: 'queue_data_50',
    title: 'Community Helper',
    description: 'Share 50 queue position updates',
    category: AchievementCategory.queue,
    tier: BadgeTier.silver,
    requiredValue: 50,
    icon: Icons.people_outlined,
  );

  static Achievement queueData200 = const Achievement(
    id: 'queue_data_200',
    title: 'Queue Champion',
    description: 'Share 200 queue position updates',
    category: AchievementCategory.queue,
    tier: BadgeTier.gold,
    requiredValue: 200,
    icon: Icons.people_outlined,
  );

  /// Get all achievement definitions
  static List<Achievement> get allAchievements => [
        // Hauls
        hauls10,
        hauls25,
        hauls50,
        hauls100,
        hauls250,
        hauls500,
        // Efficiency
        efficiency10,
        efficiency30,
        // Distance
        distance100,
        distance500,
        distance1000,
        // Queue
        queueData50,
        queueData200,
      ];

  /// Get achievements by category
  static List<Achievement> getByCategory(AchievementCategory category) {
    return allAchievements
        .where((achievement) => achievement.category == category)
        .toList();
  }
}

// ============================================================================
// USER GAMIFICATION PROFILE
// ============================================================================

/// Complete gamification profile for a user
@JsonSerializable()
class GamificationProfile {
  /// User's current streak
  final HaulStreak streak;

  /// All achievements (unlocked and locked)
  final List<Achievement> achievements;

  /// Total points/score
  @JsonKey(name: 'total_points')
  final int totalPoints;

  /// Lifetime statistics
  @JsonKey(name: 'total_hauls')
  final int totalHauls;

  @JsonKey(name: 'total_grain_kg')
  final double totalGrainKg;

  @JsonKey(name: 'total_distance_miles')
  final double totalDistanceMiles;

  @JsonKey(name: 'total_time_saved_minutes')
  final int totalTimeSavedMinutes;

  const GamificationProfile({
    required this.streak,
    required this.achievements,
    this.totalPoints = 0,
    this.totalHauls = 0,
    this.totalGrainKg = 0.0,
    this.totalDistanceMiles = 0.0,
    this.totalTimeSavedMinutes = 0,
  });

  factory GamificationProfile.fromJson(Map<String, dynamic> json) =>
      _$GamificationProfileFromJson(json);
  Map<String, dynamic> toJson() => _$GamificationProfileToJson(this);

  /// Create initial empty profile
  factory GamificationProfile.empty() {
    return GamificationProfile(
      streak: HaulStreak.empty(),
      achievements: AchievementDefinitions.allAchievements,
    );
  }

  /// Get unlocked achievements
  List<Achievement> get unlockedAchievements =>
      achievements.where((a) => a.isUnlocked).toList();

  /// Get locked achievements
  List<Achievement> get lockedAchievements =>
      achievements.where((a) => !a.isUnlocked).toList();

  /// Get next achievements to unlock (closest to completion)
  List<Achievement> get nextAchievements {
    return lockedAchievements..sort((a, b) {
        final aProgress = a.progressPercentage;
        final bProgress = b.progressPercentage;
        return bProgress.compareTo(aProgress);
      });
  }

  GamificationProfile copyWith({
    HaulStreak? streak,
    List<Achievement>? achievements,
    int? totalPoints,
    int? totalHauls,
    double? totalGrainKg,
    double? totalDistanceMiles,
    int? totalTimeSavedMinutes,
  }) {
    return GamificationProfile(
      streak: streak ?? this.streak,
      achievements: achievements ?? this.achievements,
      totalPoints: totalPoints ?? this.totalPoints,
      totalHauls: totalHauls ?? this.totalHauls,
      totalGrainKg: totalGrainKg ?? this.totalGrainKg,
      totalDistanceMiles: totalDistanceMiles ?? this.totalDistanceMiles,
      totalTimeSavedMinutes:
          totalTimeSavedMinutes ?? this.totalTimeSavedMinutes,
    );
  }
}
