import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/queue_models.dart';
import '../../../data/models/elevator_models.dart';
import '../../widgets/elevator_card.dart';
import '../../widgets/loading_skeleton.dart';
import '../../providers/auth_provider.dart';

// TODO: Create this provider to fetch elevator data with queue states
final elevatorsWithQueueProvider = FutureProvider<List<ElevatorWithQueue>>((ref) async {
  // This will be implemented with actual Supabase data
  // For now, return sample data for UI development
  await Future.delayed(const Duration(seconds: 1));

  return _getSampleData();
});

/// Enhanced home screen with real-time elevator queue predictions
class EnhancedHomeScreen extends ConsumerWidget {
  const EnhancedHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elevatorsAsync = ref.watch(elevatorsWithQueueProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(elevatorsWithQueueProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Modern app bar
            SliverAppBar.large(
              floating: true,
              snap: true,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'HaulPass',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Find the fastest elevator',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              actions: [
                // Connection indicator
                _ConnectionIndicator(),
                const SizedBox(width: 8),
                // User menu
                PopupMenuButton<String>(
                  icon: CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      user?.displayNameWithFallback.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'profile':
                        context.push('/profile');
                        break;
                      case 'settings':
                        // TODO: Navigate to settings
                        break;
                      case 'logout':
                        ref.read(authNotifierProvider.notifier).signOut();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: const [
                          Icon(Icons.person_outline, size: 20),
                          SizedBox(width: 12),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: const [
                          Icon(Icons.settings_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('Settings'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: const [
                          Icon(Icons.logout, size: 20),
                          SizedBox(width: 12),
                          Text('Sign Out'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Quick stats card (if we have data)
            elevatorsAsync.when(
              data: (elevators) => SliverToBoxAdapter(
                child: _QuickStatsCard(elevators: elevators)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.2, end: 0, duration: 400.ms),
              ),
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            // Elevator list
            elevatorsAsync.when(
              data: (elevators) {
                if (elevators.isEmpty) {
                  return SliverFillRemaining(
                    child: _EmptyState(),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ElevatorCard(
                        data: elevators[index],
                        onTap: () => _showElevatorDetails(context, elevators[index]),
                      )
                          .animate()
                          .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                          .slideX(begin: 0.2, end: 0, duration: 400.ms);
                    },
                    childCount: elevators.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: ElevatorCardSkeleton(count: 3),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: _ErrorState(error: error.toString()),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to new load screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New Load feature coming soon!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'New Load',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showElevatorDetails(BuildContext context, ElevatorWithQueue data) {
    // TODO: Show bottom sheet or navigate to details
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ElevatorDetailsSheet(data: data),
    );
  }
}

/// Quick stats card showing summary
class _QuickStatsCard extends StatelessWidget {
  final List<ElevatorWithQueue> elevators;

  const _QuickStatsCard({required this.elevators});

  @override
  Widget build(BuildContext context) {
    final avgWait = elevators.isEmpty
        ? 0
        : elevators.map((e) => e.queueState.estimatedWaitMinutes).reduce((a, b) => a + b) ~/ elevators.length;

    final fastestElevator = elevators.isNotEmpty
        ? elevators.reduce((a, b) =>
            a.queueState.estimatedWaitMinutes < b.queueState.estimatedWaitMinutes ? a : b)
        : null;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Right Now',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Avg Wait',
                    value: '${avgWait}m',
                    icon: Icons.schedule,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Elevators',
                    value: '${elevators.length}',
                    icon: Icons.store,
                  ),
                ),
                if (fastestElevator != null)
                  Expanded(
                    child: _StatItem(
                      label: 'Fastest',
                      value: fastestElevator.elevator.name.split(' ')[0],
                      icon: Icons.bolt,
                      isHighlight: true,
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isHighlight;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isHighlight
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isHighlight
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}

/// Connection status indicator
class _ConnectionIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement actual connection status checking
    final isConnected = true;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isConnected ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms),
          const SizedBox(width: 6),
          Text(
            isConnected ? 'Live' : 'Offline',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isConnected ? Colors.green.shade800 : Colors.red.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state when no elevators found
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No elevators found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Enable location services to find nearby grain elevators',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                // TODO: Request location permission
              },
              icon: const Icon(Icons.my_location),
              label: const Text('Enable Location'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state
class _ErrorState extends StatelessWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Elevator details bottom sheet
class _ElevatorDetailsSheet extends StatelessWidget {
  final ElevatorWithQueue data;

  const _ElevatorDetailsSheet({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.elevator.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.elevator.company,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                // TODO: Add more details, map, directions button, etc.
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Start new load to this elevator
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text(
                    'Start Load Here',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Open in maps
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text(
                    'Open in Maps',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Sample data for UI development
List<ElevatorWithQueue> _getSampleData() {
  return [
    ElevatorWithQueue(
      elevator: Elevator(
        id: '1',
        name: 'Richardson Pioneer',
        company: 'Richardson International',
        location: const Location(latitude: 49.8951, longitude: -97.1384, accuracy: 10, timestamp: null),
        address: '123 Main St, Winnipeg, MB',
        acceptedGrains: const ['Corn', 'Wheat', 'Soybeans', 'Canola'],
        isActive: true,
        lastUpdated: DateTime.now(),
      ),
      queueState: QueueState.sample(trucksInLine: 4, waitMinutes: 198, typical: 165),
      distanceKm: 12.3,
      estimatedDriveMinutes: 15,
    ),
    ElevatorWithQueue(
      elevator: Elevator(
        id: '2',
        name: 'Prairie Co-op',
        company: 'Prairie Co-operative',
        location: const Location(latitude: 49.8851, longitude: -97.1484, accuracy: 10, timestamp: null),
        address: '456 Grain Rd, Winnipeg, MB',
        acceptedGrains: const ['Corn', 'Wheat', 'Oats'],
        isActive: true,
        lastUpdated: DateTime.now(),
      ),
      queueState: QueueState.sample(trucksInLine: 2, waitMinutes: 18, typical: 15),
      distanceKm: 8.7,
      estimatedDriveMinutes: 10,
    ),
    ElevatorWithQueue(
      elevator: Elevator(
        id: '3',
        name: 'Cargill Grain',
        company: 'Cargill Limited',
        location: const Location(latitude: 49.9051, longitude: -97.1284, accuracy: 10, timestamp: null),
        address: '789 Agri Blvd, Winnipeg, MB',
        acceptedGrains: const ['Corn', 'Wheat', 'Soybeans'],
        isActive: true,
        lastUpdated: DateTime.now(),
      ),
      queueState: QueueState.sample(trucksInLine: 1, waitMinutes: 8, typical: 20),
      distanceKm: 15.2,
      estimatedDriveMinutes: 18,
    ),
  ];
}
