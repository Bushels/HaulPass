# HaulPass - Flutter Implementation Guide

## 🎯 Implementation Strategy

### Phase Approach
- **Alpha (Web)**: Fast iteration, quick testing, easy updates
- **Beta (iOS/Android)**: Native features, offline support, push notifications
- **Release (All Platforms)**: Production-ready, optimized, full feature set

## 📦 Recommended Packages (Latest 2024/2025)

### Essential Additions

```yaml
dependencies:
  # Current packages (keep these)
  flutter_riverpod: ^2.5.1  # Updated
  hooks_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  supabase_flutter: ^2.5.6  # Latest with real-time improvements
  geolocator: ^12.0.0
  go_router: ^14.2.3

  # UI/UX Enhancements
  animations: ^2.0.11  # Smooth transitions
  flutter_animate: ^4.5.0  # Easy animations
  shimmer: ^3.0.0  # Loading skeletons
  flutter_slidable: ^3.1.0  # Swipe actions
  pull_to_refresh: ^2.0.0  # Better refresh

  # Charts & Visualizations
  fl_chart: ^0.68.0  # Beautiful charts for daily summaries
  percent_indicator: ^4.2.3  # Progress bars/circles

  # Maps & Location
  google_maps_flutter: ^2.7.0  # For route visualization
  flutter_map: ^7.0.2  # Alternative: OSM-based maps
  latlong2: ^0.9.1  # Lat/long calculations

  # Forms & Input
  flutter_form_builder: ^9.3.0  # Easy form handling
  form_builder_validators: ^10.0.1  # Validation
  flutter_typeahead: ^5.2.0  # Autocomplete

  # Data & Storage
  hive: ^2.2.3  # Fast local storage (offline data)
  hive_flutter: ^1.1.0
  connectivity_plus: ^6.0.3  # Network status

  # Time & Date
  timeago: ^3.6.1  # "2 hours ago" format
  duration: ^3.0.13  # Duration formatting

  # UI Components
  badges: ^3.1.2  # Notification badges
  dotted_border: ^2.1.0  # Dotted containers
  flutter_staggered_grid_view: ^0.7.0  # Masonry layouts

  # Feedback & Haptics
  vibration: ^1.8.4  # Haptic feedback
  flutter_local_notifications: ^17.2.1  # Local notifications

  # Utils
  cached_network_image: ^3.3.1  # Image caching
  image_picker: ^1.1.2  # Camera/gallery
  share_plus: ^9.0.0  # Share functionality
  package_info_plus: ^8.0.0  # App version info

dev_dependencies:
  # Code generation (keep these)
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.0
  json_serializable: ^6.8.0

  # Additional dev tools
  hive_generator: ^2.0.1  # For Hive type adapters
  flutter_launcher_icons: ^0.13.1  # App icons
  flutter_native_splash: ^2.4.0  # Splash screen
```

## 🎨 UI/UX Design Principles for Farmers

### 1. Large Touch Targets (Gloved Hands)
```dart
// Minimum touch target: 56x56 dp (Material 3 standard)
// For farmers: 64x64 dp recommended

class FarmerButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,  // Large enough for gloved fingers
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: child,
      ),
    );
  }
}
```

### 2. High Contrast (Outdoor Visibility)
```dart
// Enhanced theme for outdoor use
class OutdoorTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: Color(0xFF0D47A1),  // Deep blue (high contrast)
        secondary: Color(0xFF1B5E20),  // Deep green
        surface: Colors.white,
        background: Colors.white,
        error: Color(0xFFB71C1C),  // Deep red
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onBackground: Colors.black87,
      ),
      // High contrast text
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          shadows: [Shadow(color: Colors.white30, blurRadius: 2)],
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
    );
  }
}
```

### 3. Quick Data Entry
```dart
// Number pad for quick weight entry
class QuickNumberPad extends StatelessWidget {
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 1.5,
      children: [
        for (var i = 1; i <= 9; i++)
          _NumberButton(number: i, controller: controller),
        _ActionButton(icon: Icons.backspace, controller: controller),
        _NumberButton(number: 0, controller: controller),
        _ActionButton(icon: Icons.check, controller: controller),
      ],
    );
  }
}
```

## 📱 Key Screen Implementations

### 1. Home Screen - Elevator List with Real-Time Status

```dart
class EnhancedHomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elevators = ref.watch(nearbyElevatorsWithQueueProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern app bar with status
          SliverAppBar.large(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HaulPass'),
                Text(
                  'Find the fastest elevator',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            actions: [
              _buildConnectionStatus(ref),
              _buildUserMenu(),
            ],
          ),

          // Quick stats card
          SliverToBoxAdapter(
            child: _QuickStatsCard(),
          ),

          // Elevator list with real-time queue data
          elevators.when(
            data: (elevatorList) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ElevatorCard(
                  elevator: elevatorList[index],
                  onTap: () => _showElevatorDetails(context, elevatorList[index]),
                ),
                childCount: elevatorList.length,
              ),
            ),
            loading: () => SliverFillRemaining(
              child: _LoadingSkeleton(),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: _ErrorState(error: err),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/new-load'),
        icon: Icon(Icons.add),
        label: Text('New Load', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
```

### 2. Elevator Card - Real-Time Queue Status

```dart
class _ElevatorCard extends StatelessWidget {
  final ElevatorWithQueue elevator;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          elevator.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          elevator.company,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  _buildQueueStatus(elevator.queueState),
                ],
              ),

              SizedBox(height: 16),

              // Queue prediction - THE KEY FEATURE
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getStatusColor(elevator.queueState).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(elevator.queueState).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    // Current lineup count
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${elevator.currentTrucksInLine} trucks waiting',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Predicted wait time - LARGE AND VISIBLE
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 28,
                          color: _getStatusColor(elevator.queueState),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Est wait time',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              _formatDuration(elevator.estimatedWaitMinutes),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(elevator.queueState),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        // Status bar
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${elevator.busynessPercent}%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              elevator.busynessPercent > 0 ? 'busier' : 'slower',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Visual status bar
                    _BusynessBar(
                      percent: elevator.busynessPercent,
                      baselineMinutes: elevator.typicalWaitMinutes,
                    ),

                    SizedBox(height: 8),

                    // Comparison text
                    Text(
                      'Typical: ${_formatDuration(elevator.typicalWaitMinutes)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Distance
              Row(
                children: [
                  Icon(Icons.place, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${elevator.distanceKm.toStringAsFixed(1)} km away',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Text(
                    'ETA: ${elevator.estimatedArrivalTime}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(QueueState state) {
    if (state.estimatedWaitMinutes < 30) return Colors.green;
    if (state.estimatedWaitMinutes < 120) return Colors.orange;
    return Colors.red;
  }
}
```

### 3. Busyness Status Bar Widget

```dart
class _BusynessBar extends StatelessWidget {
  final int percent;
  final int baselineMinutes;

  @override
  Widget build(BuildContext context) {
    final normalized = (percent + 100) / 200;  // -100 to +100 → 0 to 1

    return Column(
      children: [
        Stack(
          children: [
            // Background bar
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            // Filled portion
            FractionallySizedBox(
              widthFactor: normalized,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green,
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            // Baseline marker (normal)
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 2,
              child: Container(
                width: 4,
                height: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Slower',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            Text(
              'Normal',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            Text(
              'Busier',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }
}
```

### 4. New Load Screen - Quick Data Entry

```dart
class NewLoadScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grainType = useState<String?>('corn');
    final moisture = useState<double?>(null);
    final weight = useState<int?>(null);
    final selectedElevator = useState<Elevator?>(null);

    return Scaffold(
      appBar: AppBar(
        title: Text('New Load'),
        actions: [
          TextButton(
            onPressed: () => _saveLoad(context, ref),
            child: Text('START', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Step indicator
            _StepIndicator(currentStep: 1, totalSteps: 4),

            SizedBox(height: 24),

            // Grain type selector - Large buttons
            Text(
              'Grain Type',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                'Corn',
                'Soybeans',
                'Wheat',
                'Canola',
                'Oats',
              ].map((grain) => _GrainChip(
                label: grain,
                selected: grainType.value?.toLowerCase() == grain.toLowerCase(),
                onTap: () => grainType.value = grain.toLowerCase(),
              )).toList(),
            ),

            SizedBox(height: 24),

            // Moisture (optional) - Slider for quick input
            Text(
              'Moisture % (optional)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: moisture.value ?? 15.0,
                    min: 10.0,
                    max: 25.0,
                    divisions: 30,
                    label: '${moisture.value?.toStringAsFixed(1) ?? 15.0}%',
                    onChanged: (value) => moisture.value = value,
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${moisture.value?.toStringAsFixed(1) ?? 15.0}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Weight (optional) - Large number pad
            Text(
              'Weight (lbs) - optional',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            if (weight.value != null)
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${weight.value!} lbs',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => weight.value = null,
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              )
            else
              OutlinedButton(
                onPressed: () => _showWeightPad(context, weight),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                ),
                child: Text(
                  'Enter Weight',
                  style: TextStyle(fontSize: 18),
                ),
              ),

            SizedBox(height: 24),

            // Elevator selector
            Text(
              'Select Destination',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            _ElevatorSelector(
              selected: selectedElevator.value,
              onSelect: (elevator) => selectedElevator.value = elevator,
            ),

            SizedBox(height: 32),

            // Prediction preview (if elevator selected)
            if (selectedElevator.value != null)
              _PredictionPreviewCard(
                elevator: selectedElevator.value!,
                weight: weight.value,
              ),

            SizedBox(height: 32),

            // Start trip button - LARGE
            SizedBox(
              height: 64,
              child: FilledButton(
                onPressed: selectedElevator.value != null
                    ? () => _startTrip(context, ref)
                    : null,
                style: FilledButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                child: Text('START TRIP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 5. Arrival Confirmation - Quick Taps

```dart
class ArrivalConfirmationDialog extends StatelessWidget {
  final Elevator elevator;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.place,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Have you arrived?',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              elevator.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Text('Not Yet', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Text('Yes', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 6. Truck Count Selector - Large Buttons

```dart
class TruckCountSelector extends StatelessWidget {
  final Function(int) onCountSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'How many trucks ahead?',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        Text(
          '(not counting the one unloading)',
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            for (var i = 0; i <= 5; i++)
              _TruckCountButton(
                count: i,
                onTap: () => onCountSelected(i),
              ),
            _TruckCountButton(
              count: null,
              label: '6+',
              onTap: () => _showManualEntry(context, onCountSelected),
            ),
          ],
        ),
      ],
    );
  }
}

class _TruckCountButton extends StatelessWidget {
  final int? count;
  final String? label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping, size: 32),
          SizedBox(height: 8),
          Text(
            label ?? count.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
```

## 📊 Daily Summary Screen

```dart
class DailySummaryScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dailySummaryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Summary'),
                Text(
                  DateFormat('EEEE, MMMM d').format(DateTime.now()),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => _shareReport(summary),
                icon: Icon(Icons.share),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Big stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_shipping,
                          title: 'Loads',
                          value: '${summary.totalLoads}',
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.scale,
                          title: 'Total Weight',
                          value: '${summary.totalBushels.toStringAsFixed(0)}',
                          subtitle: 'bushels',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.route,
                          title: 'Distance',
                          value: '${summary.totalDistanceKm.toStringAsFixed(0)}',
                          subtitle: 'km',
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.attach_money,
                          title: 'Revenue',
                          value: '\$${summary.totalRevenue.toStringAsFixed(0)}',
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Time breakdown chart
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time Breakdown',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          _TimeBreakdownChart(
                            driveTime: summary.driveTimeMinutes,
                            lineupTime: summary.lineupTimeMinutes,
                            unloadTime: summary.unloadTimeMinutes,
                          ),
                          SizedBox(height: 16),
                          _TimeLegend(
                            driving: summary.driveTimeMinutes,
                            lineup: summary.lineupTimeMinutes,
                            unloading: summary.unloadTimeMinutes,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Efficiency card
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Efficiency',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _EfficiencyStat(
                                label: 'Loads/Hour',
                                value: summary.loadsPerHour.toStringAsFixed(1),
                              ),
                              Container(width: 1, height: 40, color: Colors.grey[300]),
                              _EfficiencyStat(
                                label: 'Time Saved',
                                value: '${summary.timeSavedMinutes} min',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Elevator breakdown
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Elevators Visited',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          for (var elevator in summary.elevatorBreakdown)
                            _ElevatorBreakdownRow(elevator),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _markDoneForToday(ref),
        icon: Icon(Icons.check_circle),
        label: Text('Done for Today'),
      ),
    );
  }
}
```

## 🎬 Animations & Transitions

```dart
// Smooth page transitions
class SlidePageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      )),
      child: builder(context),
    );
  }
}

// Shimmer loading state
class LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          for (var i = 0; i < 3; i++)
            Container(
              margin: EdgeInsets.all(16),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
        ],
      ),
    );
  }
}

// Count-up animation for stats
class AnimatedCounter extends HookWidget {
  final int value;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: duration,
    );

    final animation = useAnimation(
      Tween<double>(begin: 0, end: value.toDouble())
          .animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      )),
    );

    useEffect(() {
      animationController.forward();
      return null;
    }, [value]);

    return Text(
      animation.toInt().toString(),
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}
```

## 🔔 Notifications & Feedback

```dart
// Haptic feedback for important actions
class HapticFeedback {
  static void light() => HapticFeedback.lightImpact();
  static void medium() => HapticFeedback.mediumImpact();
  static void heavy() => HapticFeedback.heavyImpact();

  static void onArrival() => heavy();
  static void onComplete() => medium();
  static void onTap() => light();
}

// Toast notifications
class HaulPassToast {
  static void show(BuildContext context, String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}

// Local notification for arrival
Future<void> showArrivalNotification(Elevator elevator) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.show(
    0,
    'Arrived at ${elevator.name}',
    'Tap to confirm your arrival',
    NotificationDetails(
      android: AndroidNotificationDetails(
        'arrival',
        'Arrival Notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
  );
}
```

## 🗺️ Maps Integration

```dart
// Route visualization
class RouteMapWidget extends StatelessWidget {
  final LatLng origin;
  final LatLng destination;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: origin,
        zoom: 12,
      ),
      markers: {
        Marker(
          markerId: MarkerId('origin'),
          position: origin,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
        Marker(
          markerId: MarkerId('destination'),
          position: destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      },
      polylines: {
        Polyline(
          polylineId: PolylineId('route'),
          points: [origin, destination],  // Simplified - use real routing API
          color: Theme.of(context).colorScheme.primary,
          width: 4,
        ),
      },
    );
  }
}
```

## 📱 Offline Support with Hive

```dart
// Hive setup for offline data
@HiveType(typeId: 0)
class CachedLoad extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String grainType;

  @HiveField(2)
  final int? weightLbs;

  @HiveField(3)
  final String elevatorId;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  bool isSynced;

  CachedLoad({
    required this.id,
    required this.grainType,
    this.weightLbs,
    required this.elevatorId,
    required this.createdAt,
    this.isSynced = false,
  });
}

// Offline-first repository pattern
class LoadRepository {
  final Box<CachedLoad> _cacheBox;
  final SupabaseClient _supabase;

  Future<void> saveLoad(Load load) async {
    // Save to local cache first
    await _cacheBox.put(load.id, CachedLoad.fromLoad(load));

    // Try to sync with server
    try {
      await _supabase.from('loads').insert(load.toJson());
      final cached = _cacheBox.get(load.id);
      cached?.isSynced = true;
      await cached?.save();
    } catch (e) {
      // Will sync later when connection is restored
      print('Failed to sync load: $e');
    }
  }

  Future<void> syncPendingLoads() async {
    final unsyncedLoads = _cacheBox.values.where((l) => !l.isSynced);

    for (final cached in unsyncedLoads) {
      try {
        await _supabase.from('loads').insert(cached.toJson());
        cached.isSynced = true;
        await cached.save();
      } catch (e) {
        print('Failed to sync load ${cached.id}: $e');
      }
    }
  }
}
```

## 🎯 Next Steps for Implementation

### Week 1-2: Core UI
1. Implement enhanced home screen with elevator cards
2. Add real-time queue status visualization
3. Create new load flow with quick data entry
4. Implement busyness status bars

### Week 3-4: Load Tracking
1. GPS tracking with background support
2. Arrival detection and confirmation
3. Truck count selector
4. Position tracking in lineup

### Week 5-6: Daily Summaries
1. Daily summary screen with charts
2. Time breakdown visualization
3. Efficiency metrics
4. Export/share functionality

### Week 7-8: Polish & Testing
1. Animations and transitions
2. Offline support with Hive
3. Push notifications
4. Performance optimization
5. Alpha testing on web

Would you like me to start implementing any specific screen or feature in detail?
