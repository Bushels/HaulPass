/// Demo configuration for marketing and screenshots
class DemoConfig {
  // Enable demo mode to bypass authentication
  static const bool isDemoMode = false;

  // Demo user credentials
  static const String demoEmail = 'buperac@gmail.com';
  static const String demoPassword = 'demo123'; // For demo purposes only

  // Demo user profile data
  static const String demoUserId = 'demo-user-bushels';
  static const String demoFirstName = 'Bushels';
  static const String demoLastName = 'Grain Co';
  static const String demoDisplayName = 'Bushels';
  static const String demoFarmName = 'Bushels Farms';
  static const String demoBinyardName = 'North Binyard';
  static const String demoTruckName = 'Kenworth T800';
  static const double demoTruckCapacity = 42.5; // tonnes
  static const String demoPreferredUnit = 'tonnes';

  // Quick access for demo mode
  static bool get shouldBypassAuth => isDemoMode;
}
