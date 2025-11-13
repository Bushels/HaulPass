import 'models/elevator_models.dart';
import 'models/location_models.dart';

/// Mock data for demonstration and testing
class MockData {
  // Regina, SK coordinates
  static const reginaLat = 50.4452;
  static const reginaLon = -104.6189;

  static List<Elevator> get mockElevators => [
    Elevator(
      id: '1',
      name: 'Regina Downtown Elevator',
      company: 'Richardson Pioneer Limited',
      location: AppLocation(
        latitude: 50.4452,
        longitude: -104.6189,
        accuracy: 10.0,
        timestamp: DateTime.now(),
      ),
      address: '123 Main Street, Regina, SK S4P 3Y2',
      phoneNumber: '(306) 525-1234',
      email: 'regina@richardson.ca',
      acceptedGrains: ['Wheat', 'Canola', 'Barley'],
      capacity: 45000,
      isActive: true,
      lastUpdated: DateTime.now(),
      railway: 'CN',
      elevatorType: 'Primary',
      carSpots: '100+',
    ),
    Elevator(
      id: '2',
      name: 'Moose Jaw Terminal',
      company: 'Viterra Canada Inc.',
      location: AppLocation(
        latitude: 50.3933,
        longitude: -105.5519,
        accuracy: 10.0,
        timestamp: DateTime.now(),
      ),
      address: '456 Railway Ave, Moose Jaw, SK S6H 4P9',
      phoneNumber: '(306) 692-5678',
      email: 'moosejaw@viterra.com',
      acceptedGrains: ['Wheat', 'Canola', 'Barley', 'Oats'],
      capacity: 52000,
      isActive: true,
      lastUpdated: DateTime.now(),
      railway: 'CP',
      elevatorType: 'Primary',
      carSpots: '100+',
    ),
    Elevator(
      id: '3',
      name: 'Qu\'Appelle Valley Grain',
      company: 'Parrish & Heimbecker Limited',
      location: AppLocation(
        latitude: 50.6539,
        longitude: -103.7772,
        accuracy: 10.0,
        timestamp: DateTime.now(),
      ),
      address: '789 Valley Road, Balcarres, SK S0G 0C0',
      phoneNumber: '(306) 334-2345',
      acceptedGrains: ['Wheat', 'Canola'],
      capacity: 32000,
      isActive: true,
      lastUpdated: DateTime.now(),
      railway: 'CN',
      elevatorType: 'Primary',
      carSpots: '50+',
    ),
    Elevator(
      id: '4',
      name: 'Pilot Butte Grain Terminal',
      company: 'Cargill Limited',
      location: AppLocation(
        latitude: 50.4694,
        longitude: -104.4131,
        accuracy: 10.0,
        timestamp: DateTime.now(),
      ),
      address: '321 Grain Street, Pilot Butte, SK S0G 3Z0',
      phoneNumber: '(306) 781-4567',
      acceptedGrains: ['Wheat', 'Canola', 'Barley', 'Peas'],
      capacity: 38000,
      isActive: true,
      lastUpdated: DateTime.now(),
      railway: 'CP',
      elevatorType: 'Primary',
      carSpots: '100+',
    ),
    Elevator(
      id: '5',
      name: 'Southey Pulse Processor',
      company: 'Alliance Pulse Processors Inc.',
      location: AppLocation(
        latitude: 51.2164,
        longitude: -104.7439,
        accuracy: 10.0,
        timestamp: DateTime.now(),
      ),
      address: '555 Industrial Park, Southey, SK S0G 4P0',
      phoneNumber: '(306) 726-2222',
      acceptedGrains: ['Peas', 'Lentils', 'Chickpeas'],
      capacity: 15000,
      isActive: true,
      lastUpdated: DateTime.now(),
      railway: 'NO',
      elevatorType: 'Process',
      carSpots: '25+',
    ),
  ];

  static Map<String, ElevatorStatus> get mockElevatorStatuses => {
    '1': ElevatorStatus(
      elevatorId: '1',
      currentLineup: 3,
      estimatedWaitTime: 45,
      averageUnloadTime: 15.0,
      currentGrainType: 'Wheat',
      dockageRate: 2.5,
      dailyCapacity: 1200,
      dailyProcessed: 850,
      status: 'open',
      lastUpdated: DateTime.now(),
    ),
    '2': ElevatorStatus(
      elevatorId: '2',
      currentLineup: 8,
      estimatedWaitTime: 120,
      averageUnloadTime: 18.0,
      currentGrainType: 'Canola',
      dockageRate: 1.8,
      dailyCapacity: 1500,
      dailyProcessed: 1350,
      status: 'busy',
      lastUpdated: DateTime.now(),
    ),
    '3': ElevatorStatus(
      elevatorId: '3',
      currentLineup: 1,
      estimatedWaitTime: 15,
      averageUnloadTime: 12.0,
      currentGrainType: 'Wheat',
      dockageRate: 2.2,
      dailyCapacity: 1000,
      dailyProcessed: 450,
      status: 'open',
      lastUpdated: DateTime.now(),
    ),
    '4': ElevatorStatus(
      elevatorId: '4',
      currentLineup: 5,
      estimatedWaitTime: 75,
      averageUnloadTime: 16.0,
      currentGrainType: 'Barley',
      dockageRate: 3.1,
      dailyCapacity: 1300,
      dailyProcessed: 980,
      status: 'open',
      lastUpdated: DateTime.now(),
    ),
    '5': ElevatorStatus(
      elevatorId: '5',
      currentLineup: 0,
      estimatedWaitTime: 0,
      averageUnloadTime: 20.0,
      currentGrainType: 'Peas',
      dockageRate: 1.5,
      dailyCapacity: 600,
      dailyProcessed: 200,
      status: 'open',
      lastUpdated: DateTime.now(),
    ),
  };

  static List<NearbyElevator> get mockNearbyElevators {
    final elevators = mockElevators;
    final statuses = mockElevatorStatuses;
    
    return elevators.map((elevator) {
      final status = statuses[elevator.id];
      final distance = _calculateDistance(
        reginaLat,
        reginaLon,
        elevator.location.latitude,
        elevator.location.longitude,
      );
      
      return NearbyElevator(
        id: elevator.id,
        name: elevator.name,
        company: elevator.company,
        location: elevator.location,
        address: elevator.address,
        currentLineupCount: status?.currentLineup,
        estimatedWaitTime: status?.estimatedWaitTime,
        distance: distance,
        grainType: status?.currentGrainType,
        dockageRate: status?.dockageRate,
        availableGrains: elevator.acceptedGrains,
        isActive: elevator.isActive,
        lastUpdated: status?.lastUpdated ?? elevator.lastUpdated ?? DateTime.now(),
      );
    }).toList()..sort((a, b) => 
      (a.distance ?? double.infinity).compareTo(b.distance ?? double.infinity)
    );
  }

  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    
    final a = (sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2));
    
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (3.141592653589793 / 180);
  }

  static double sin(double x) => x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  static double cos(double x) => 1 - (x * x) / 2 + (x * x * x * x) / 24;
  static double sqrt(double x) {
    if (x < 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }
  static double atan2(double y, double x) {
    if (x > 0) return atan(y / x);
    if (x < 0 && y >= 0) return atan(y / x) + 3.141592653589793;
    if (x < 0 && y < 0) return atan(y / x) - 3.141592653589793;
    if (x == 0 && y > 0) return 3.141592653589793 / 2;
    if (x == 0 && y < 0) return -3.141592653589793 / 2;
    return 0;
  }
  static double atan(double x) {
    return x - (x * x * x) / 3 + (x * x * x * x * x) / 5;
  }
}
