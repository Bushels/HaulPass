import '../models/elevator_models.dart';
import '../models/location_models.dart';

/// Mock data service for beautiful marketing screenshots
/// Provides realistic, visually appealing data
class MockDataService {
  // Mock elevators with diverse, realistic data
  static final List<Elevator> mockElevators = [
    Elevator(
      id: '1',
      name: 'Saskatoon Hub',
      company: 'Richardson International',
      location: AppLocation(
        latitude: 52.1579,
        longitude: -106.6702,
        timestamp: DateTime.now(),
      ),
      address: '123 Railway Ave, Saskatoon, SK',
      railway: 'CN',
      elevatorType: 'Primary',
      capacity: 45000,
      carSpots: '100+',
      acceptedGrains: const ['Wheat', 'Barley', 'Canola'],
      isActive: true,
    ),
    Elevator(
      id: '2',
      name: 'Regina Terminal',
      company: 'Cargill Limited',
      location: AppLocation(
        latitude: 50.4452,
        longitude: -104.6189,
        timestamp: DateTime.now(),
      ),
      address: '456 Terminal Rd, Regina, SK',
      railway: 'CP',
      elevatorType: 'Terminal',
      capacity: 78000,
      carSpots: '100+',
      acceptedGrains: const ['Wheat', 'Canola', 'Oats'],
      isActive: true,
    ),
    Elevator(
      id: '3',
      name: 'Moose Jaw',
      company: 'Parrish & Heimbecker',
      location: AppLocation(
        latitude: 50.3933,
        longitude: -105.5519,
        timestamp: DateTime.now(),
      ),
      address: '789 Grain St, Moose Jaw, SK',
      railway: 'CN',
      elevatorType: 'Primary',
      capacity: 32500,
      carSpots: '50-100',
      acceptedGrains: const ['Wheat', 'Barley'],
      isActive: true,
    ),
    Elevator(
      id: '4',
      name: 'Yorkton',
      company: 'Viterra Inc',
      location: AppLocation(
        latitude: 51.2139,
        longitude: -102.4628,
        timestamp: DateTime.now(),
      ),
      address: '321 Elevator Lane, Yorkton, SK',
      railway: 'CN',
      elevatorType: 'Primary',
      capacity: 28000,
      carSpots: '25-50',
      acceptedGrains: const ['Durum', 'Canola'],
      isActive: true,
    ),
    Elevator(
      id: '5',
      name: 'Swift Current',
      company: 'AGT Foods',
      location: AppLocation(
        latitude: 50.2881,
        longitude: -107.7939,
        timestamp: DateTime.now(),
      ),
      address: '654 Station Blvd, Swift Current, SK',
      railway: 'CP',
      elevatorType: 'Primary',
      capacity: 18500,
      carSpots: '< 25',
      acceptedGrains: const ['Wheat', 'Peas'],
      isActive: true,
    ),
  ];

  // Mock queue data for elevators
  static Map<String, QueueData> mockQueues = {
    '1': QueueData(
      elevatorId: '1',
      currentQueueLength: 3,
      estimatedWaitMinutes: 25,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
      trend: QueueTrend.stable,
    ),
    '2': QueueData(
      elevatorId: '2',
      currentQueueLength: 7,
      estimatedWaitMinutes: 45,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      trend: QueueTrend.increasing,
    ),
    '3': QueueData(
      elevatorId: '3',
      currentQueueLength: 1,
      estimatedWaitMinutes: 10,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 1)),
      trend: QueueTrend.decreasing,
    ),
    '4': QueueData(
      elevatorId: '4',
      currentQueueLength: 5,
      estimatedWaitMinutes: 35,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 3)),
      trend: QueueTrend.stable,
    ),
    '5': QueueData(
      elevatorId: '5',
      currentQueueLength: 0,
      estimatedWaitMinutes: 0,
      lastUpdated: DateTime.now(),
      trend: QueueTrend.decreasing,
    ),
  };

  // Mock user stats for dashboard
  static final UserStats mockUserStats = UserStats(
    totalHauls: 47,
    totalTonnesHauled: 1247.5,
    averageWaitTime: 22,
    favoriteElevatorId: '1',
    currentStreak: 5,
    weeklyHauls: 12,
    timeSavedHours: 8.5,
  );

  // Mock active haul for marketing screenshots
  static final ActiveHaul mockActiveHaul = ActiveHaul(
    sessionId: 'mock-session-1',
    elevatorId: '1',
    elevatorName: 'Saskatoon Hub',
    phase: HaulPhase.inQueue,
    startTime: DateTime.now().subtract(const Duration(minutes: 18)),
    queuePosition: 2,
    estimatedWaitMinutes: 12,
    grainType: 'Hard Red Spring Wheat',
    truckCapacity: 42.5,
  );

  // Mock recent hauls for history
  static final List<CompletedHaul> mockRecentHauls = [
    CompletedHaul(
      sessionId: 'completed-1',
      elevatorName: 'Saskatoon Hub',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      totalDuration: const Duration(minutes: 45),
      waitTime: const Duration(minutes: 18),
      tonnes: 42.5,
      grainType: 'Hard Red Spring Wheat',
    ),
    CompletedHaul(
      sessionId: 'completed-2',
      elevatorName: 'Regina Terminal',
      date: DateTime.now().subtract(const Duration(days: 1)),
      totalDuration: const Duration(minutes: 67),
      waitTime: const Duration(minutes: 32),
      tonnes: 41.0,
      grainType: 'Canola',
    ),
    CompletedHaul(
      sessionId: 'completed-3',
      elevatorName: 'Moose Jaw',
      date: DateTime.now().subtract(const Duration(days: 2)),
      totalDuration: const Duration(minutes: 38),
      waitTime: const Duration(minutes: 12),
      tonnes: 43.0,
      grainType: 'Durum Wheat',
    ),
  ];
}

// Supporting data models
class QueueData {
  final String elevatorId;
  final int currentQueueLength;
  final int estimatedWaitMinutes;
  final DateTime lastUpdated;
  final QueueTrend trend;

  QueueData({
    required this.elevatorId,
    required this.currentQueueLength,
    required this.estimatedWaitMinutes,
    required this.lastUpdated,
    required this.trend,
  });
}

enum QueueTrend { increasing, stable, decreasing }

class UserStats {
  final int totalHauls;
  final double totalTonnesHauled;
  final int averageWaitTime;
  final String? favoriteElevatorId;
  final int currentStreak;
  final int weeklyHauls;
  final double timeSavedHours;

  UserStats({
    required this.totalHauls,
    required this.totalTonnesHauled,
    required this.averageWaitTime,
    this.favoriteElevatorId,
    required this.currentStreak,
    required this.weeklyHauls,
    required this.timeSavedHours,
  });
}

class ActiveHaul {
  final String sessionId;
  final String elevatorId;
  final String elevatorName;
  final HaulPhase phase;
  final DateTime startTime;
  final int? queuePosition;
  final int? estimatedWaitMinutes;
  final String grainType;
  final double truckCapacity;

  ActiveHaul({
    required this.sessionId,
    required this.elevatorId,
    required this.elevatorName,
    required this.phase,
    required this.startTime,
    this.queuePosition,
    this.estimatedWaitMinutes,
    required this.grainType,
    required this.truckCapacity,
  });

  Duration get elapsedTime => DateTime.now().difference(startTime);
}

enum HaulPhase {
  loading,
  driving,
  inQueue,
  unloading,
  returning,
}

class CompletedHaul {
  final String sessionId;
  final String elevatorName;
  final DateTime date;
  final Duration totalDuration;
  final Duration waitTime;
  final double tonnes;
  final String grainType;

  CompletedHaul({
    required this.sessionId,
    required this.elevatorName,
    required this.date,
    required this.totalDuration,
    required this.waitTime,
    required this.tonnes,
    required this.grainType,
  });
}
