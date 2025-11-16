import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

/// Share service for sharing haul summaries and stats
class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  static ShareService get instance => _instance;

  /// Share haul summary
  Future<void> shareHaulSummary({
    required String elevatorName,
    required String duration,
    String? grainType,
    double? weight,
    String? notes,
  }) async {
    try {
      final summary = _buildHaulSummary(
        elevatorName: elevatorName,
        duration: duration,
        grainType: grainType,
        weight: weight,
        notes: notes,
      );

      await Share.share(
        summary,
        subject: 'Haul Summary - $elevatorName',
      );

      if (kDebugMode) {
        debugPrint('📤 Haul summary shared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Share haul error: $e');
      }
    }
  }

  /// Share daily summary
  Future<void> shareDailySummary({
    required int haulCount,
    required double totalWeight,
    required int totalMinutes,
    required int avgWaitMinutes,
    DateTime? date,
  }) async {
    try {
      final summary = _buildDailySummary(
        haulCount: haulCount,
        totalWeight: totalWeight,
        totalMinutes: totalMinutes,
        avgWaitMinutes: avgWaitMinutes,
        date: date ?? DateTime.now(),
      );

      await Share.share(
        summary,
        subject: 'Daily Haul Summary',
      );

      if (kDebugMode) {
        debugPrint('📤 Daily summary shared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Share daily summary error: $e');
      }
    }
  }

  /// Share weekly summary
  Future<void> shareWeeklySummary({
    required int haulCount,
    required double totalWeight,
    required int totalHours,
    required int avgWaitMinutes,
    required int timeSavedMinutes,
  }) async {
    try {
      final summary = _buildWeeklySummary(
        haulCount: haulCount,
        totalWeight: totalWeight,
        totalHours: totalHours,
        avgWaitMinutes: avgWaitMinutes,
        timeSavedMinutes: timeSavedMinutes,
      );

      await Share.share(
        summary,
        subject: 'Weekly Haul Summary',
      );

      if (kDebugMode) {
        debugPrint('📤 Weekly summary shared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Share weekly summary error: $e');
      }
    }
  }

  /// Share elevator queue status
  Future<void> shareQueueStatus({
    required String elevatorName,
    required int queueLength,
    required int estimatedWaitMinutes,
  }) async {
    try {
      final status = _buildQueueStatus(
        elevatorName: elevatorName,
        queueLength: queueLength,
        estimatedWaitMinutes: estimatedWaitMinutes,
      );

      await Share.share(
        status,
        subject: 'Queue Status - $elevatorName',
      );

      if (kDebugMode) {
        debugPrint('📤 Queue status shared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Share queue status error: $e');
      }
    }
  }

  /// Build haul summary text
  String _buildHaulSummary({
    required String elevatorName,
    required String duration,
    String? grainType,
    double? weight,
    String? notes,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('🚜 Haul Complete!');
    buffer.writeln('');
    buffer.writeln('📍 $elevatorName');
    buffer.writeln('⏱️ Duration: $duration');

    if (grainType != null) {
      buffer.writeln('🌾 Grain: $grainType');
    }

    if (weight != null) {
      buffer.writeln('⚖️ Weight: ${_formatWeight(weight)}');
    }

    if (notes != null && notes.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('📝 Notes:');
      buffer.writeln(notes);
    }

    buffer.writeln('');
    buffer.writeln('Tracked with HaulPass 📱');

    return buffer.toString();
  }

  /// Build daily summary text
  String _buildDailySummary({
    required int haulCount,
    required double totalWeight,
    required int totalMinutes,
    required int avgWaitMinutes,
    required DateTime date,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('📊 Daily Haul Summary');
    buffer.writeln('${_formatDate(date)}');
    buffer.writeln('');
    buffer.writeln('🚜 Hauls: $haulCount completed');
    buffer.writeln('⚖️ Total: ${_formatWeight(totalWeight)}');
    buffer.writeln('⏱️ Total Time: ${_formatDuration(totalMinutes)}');
    buffer.writeln('⏳ Avg Wait: ${avgWaitMinutes}min');

    final timeSaved = _calculateTimeSaved(haulCount, avgWaitMinutes);
    if (timeSaved > 0) {
      buffer.writeln('💡 Time Saved: ${timeSaved}min with HaulPass!');
    }

    buffer.writeln('');
    buffer.writeln('Tracked with HaulPass 📱');

    return buffer.toString();
  }

  /// Build weekly summary text
  String _buildWeeklySummary({
    required int haulCount,
    required double totalWeight,
    required int totalHours,
    required int avgWaitMinutes,
    required int timeSavedMinutes,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('📊 Weekly Haul Summary');
    buffer.writeln('');
    buffer.writeln('🚜 Hauls: $haulCount completed');
    buffer.writeln('⚖️ Total: ${_formatWeight(totalWeight)}');
    buffer.writeln('⏱️ Total Hours: ${totalHours}hrs');
    buffer.writeln('⏳ Avg Wait: ${avgWaitMinutes}min');
    buffer.writeln('💡 Time Saved: ${_formatDuration(timeSavedMinutes)}!');
    buffer.writeln('');
    buffer.writeln('Keep crushing it! 💪');
    buffer.writeln('');
    buffer.writeln('Tracked with HaulPass 📱');

    return buffer.toString();
  }

  /// Build queue status text
  String _buildQueueStatus({
    required String elevatorName,
    required int queueLength,
    required int estimatedWaitMinutes,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('📍 Queue Status');
    buffer.writeln('');
    buffer.writeln('🏭 $elevatorName');
    buffer.writeln('🚜 Queue: $queueLength trucks');
    buffer.writeln('⏳ Est. Wait: ${estimatedWaitMinutes}min');
    buffer.writeln('');

    if (queueLength == 0) {
      buffer.writeln('✅ No queue! Perfect time to haul!');
    } else if (queueLength <= 3) {
      buffer.writeln('✅ Short queue - good time to go!');
    } else if (queueLength <= 6) {
      buffer.writeln('⚠️ Moderate queue');
    } else {
      buffer.writeln('🔴 Long queue - might want to wait');
    }

    buffer.writeln('');
    buffer.writeln('Updated via HaulPass 📱');

    return buffer.toString();
  }

  /// Format weight
  String _formatWeight(double kg) {
    if (kg >= 1000) {
      return '${(kg / 1000).toStringAsFixed(1)} tonnes';
    }
    return '${kg.toStringAsFixed(0)} kg';
  }

  /// Format duration in minutes
  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}min';
    }

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (mins == 0) {
      return '${hours}hr';
    }

    return '${hours}hr ${mins}min';
  }

  /// Format date
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Calculate time saved (rough estimate)
  int _calculateTimeSaved(int haulCount, int avgWaitMinutes) {
    // Assume average queue without HaulPass is 45min
    const avgQueueWithoutApp = 45;
    final timeSaved = haulCount * (avgQueueWithoutApp - avgWaitMinutes);
    return timeSaved > 0 ? timeSaved : 0;
  }
}
