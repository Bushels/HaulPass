import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/elevator_models.dart';
import '../../../data/models/location_models.dart';
import '../../providers/location_provider.dart' hide AppLocation, AppLocationHistory;
import '../../providers/elevator_provider.dart';
import '../../widgets/loading/shimmer_loading.dart';

/// Elevator search and listing screen
class ElevatorScreen extends ConsumerStatefulWidget {
  const ElevatorScreen({super.key});

  @override
  ConsumerState<ElevatorScreen> createState() => _ElevatorScreenState();
}

class _ElevatorScreenState extends ConsumerState<ElevatorScreen> {
  final _searchController = TextEditingController();
  // double _distanceFilter = 50.0; // Default 50km radius - TODO: implement distance filtering
  String _selectedGrainType = 'All Grains';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(currentUserProvider); // TODO: use for personalization
    final currentLocation = ref.watch(currentLocationProvider);
    final elevatorState = ref.watch(elevatorNotifierProvider);
    final nearbyElevatorsAsync = ref.watch(elevatorNotifierProvider.notifier);

    // Listen to search changes
    ref.listen(textEditingControllerProvider(_searchController), (previous, next) {
      // Trigger search when text changes
      ref.read(elevatorNotifierProvider.notifier).loadElevators();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elevators'),
        actions: [
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter elevators',
          ),
          IconButton(
            onPressed: () => _showMapView(),
            icon: const Icon(Icons.map),
            tooltip: 'Map view',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildLocationHeader(currentLocation),
          _buildGrainTypeFilter(),
          Expanded(
            child: _buildElevatorList(elevatorState, nearbyElevatorsAsync),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddElevatorDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Report Elevator'),
        tooltip: 'Report a new elevator',
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search elevators...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    ref.read(elevatorNotifierProvider.notifier).loadElevators();
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.length >= 3) {
            ref.read(elevatorNotifierProvider.notifier).loadElevators();
          }
        },
      ),
    );
  }

  Widget _buildLocationHeader(AppLocation? location) {
    if (location == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_off, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Enable location services to find nearby elevators',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(locationTrackerProvider.notifier).getCurrentLocation();
              },
              child: const Text('Enable'),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.my_location,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Searching within 50km of your location',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(locationTrackerProvider.notifier).startTracking();
            },
            child: Text(
              'Update Location',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrainTypeFilter() {
    final grainTypes = [
      'All Grains',
      'Wheat',
      'Canola',
      'Barley',
      'Oats',
      'Corn',
      'Soybeans',
      'Lentils',
      'Peas',
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: grainTypes.length,
        itemBuilder: (context, index) {
          final grain = grainTypes[index];
          final isSelected = _selectedGrainType == grain;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(grain),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedGrainType = grain;
                });
                ref.read(elevatorNotifierProvider.notifier).loadElevators();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildElevatorList(
    ElevatorState elevatorState,
    dynamic nearbyElevatorsAsync,
  ) {
    if (elevatorState.isLoading) {
      return const ElevatorListShimmer(itemCount: 5);
    }

    if (elevatorState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading elevators',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              elevatorState.error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ref.read(elevatorNotifierProvider.notifier).clearError();
                ref.read(elevatorNotifierProvider.notifier).loadElevators();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (elevatorState.elevators.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No elevators found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ref.read(elevatorNotifierProvider.notifier).loadElevators();
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(elevatorNotifierProvider.notifier).loadElevators();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: elevatorState.elevators.length,
        itemBuilder: (context, index) {
          final elevator = elevatorState.elevators[index];
          return _buildElevatorCard(context, elevator);
        },
      ),
    );
  }

  Widget _buildElevatorCard(BuildContext context, Elevator elevator) {
    final status = ref.watch(elevatorStatusProvider(elevator.id));
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showElevatorDetails(elevator),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        Text(
                          elevator.company,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusIndicator(context, status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                elevator.formattedAddress,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              if (elevator.acceptedGrains.isNotEmpty) ...[
                Text(
                  'Accepted Grains:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: elevator.acceptedGrains.map((grain) {
                    return Chip(
                      label: Text(grain),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      backgroundColor: _getGrainChipColor(grain),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  if (status != null) ...[
                    Icon(
                      Icons.people,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${status.currentLineup} trucks',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                  ],
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status?.waitTimeDisplay ?? 'Unknown wait',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  FilledButton.tonal(
                    onPressed: () => _showActionMenu(elevator),
                    child: const Text('Actions'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context, ElevatorStatus? status) {
    if (status == null) return const SizedBox.shrink();

    Color indicatorColor;
    String statusText;

    switch (status.status) {
      case 'open':
        indicatorColor = Colors.green;
        statusText = 'Open';
        break;
      case 'busy':
        indicatorColor = Colors.orange;
        statusText = 'Busy';
        break;
      case 'closed':
        indicatorColor = Colors.red;
        statusText = 'Closed';
        break;
      case 'maintenance':
        indicatorColor = Colors.blue;
        statusText = 'Maintenance';
        break;
      default:
        indicatorColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: indicatorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: indicatorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: indicatorColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGrainChipColor(String grain) {
    final colorMap = {
      'Wheat': Colors.amber,
      'Canola': Colors.yellow,
      'Barley': Colors.brown,
      'Oats': Colors.lightBlue,
      'Corn': Colors.orange,
      'Soybeans': Colors.green,
      'Lentils': Colors.purple,
      'Peas': Colors.lightGreen,
    };
    return (colorMap[grain] ?? Colors.grey).withOpacity(0.2);
  }

  void _showElevatorDetails(Elevator elevator) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ElevatorDetailsSheet(elevator: elevator),
    );
  }

  void _showActionMenu(Elevator elevator) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.navigation),
              title: const Text('Get Directions'),
              subtitle: Text('Navigate to ${elevator.name}'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Open navigation app
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Start Timer'),
              subtitle: Text('Track unloading at ${elevator.name}'),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/timer', extra: elevator);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call Elevator'),
              subtitle: Text(elevator.phoneNumber ?? 'No phone number'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Make phone call
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem),
              title: const Text('Report Issue'),
              subtitle: const Text('Report wait times or issues'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Show report dialog
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Elevators'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add filter options here
            Text('Filter options coming soon...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(elevatorNotifierProvider.notifier).loadElevators();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showMapView() {
    // TODO: Implement map view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Map view coming soon'),
      ),
    );
  }

  void _showAddElevatorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report New Elevator'),
        content: const Text(
          'Help us improve our elevator database by reporting new locations. '
          'This feature will be available soon.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Provider for text editing controller to enable Riverpod listening
final textEditingControllerProvider = 
    Provider.family<TextEditingController, TextEditingController>((ref, controller) => controller);

/// Bottom sheet showing elevator details
class ElevatorDetailsSheet extends StatelessWidget {
  final Elevator elevator;

  const ElevatorDetailsSheet({super.key, required this.elevator});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                elevator.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                elevator.company,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildDetailCard(
                context,
                icon: Icons.location_on,
                title: 'Address',
                content: elevator.formattedAddress,
              ),
              const SizedBox(height: 8),
              if (elevator.phoneNumber != null)
                _buildDetailCard(
                  context,
                  icon: Icons.phone,
                  title: 'Phone',
                  content: elevator.phoneNumber!,
                  onTap: () {
                    // TODO: Make phone call
                  },
                ),
              const SizedBox(height: 8),
              if (elevator.email != null)
                _buildDetailCard(
                  context,
                  icon: Icons.email,
                  title: 'Email',
                  content: elevator.email!,
                  onTap: () {
                    // TODO: Send email
                  },
                ),
              const SizedBox(height: 16),
              Text(
                'Accepted Grains',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: elevator.acceptedGrains.map((grain) {
                  return Chip(
                    label: Text(grain),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Start navigation
                },
                child: const Text('Get Directions'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(content),
        trailing: onTap != null ? const Icon(Icons.arrow_forward_ios) : null,
        onTap: onTap,
      ),
    );
  }
}
