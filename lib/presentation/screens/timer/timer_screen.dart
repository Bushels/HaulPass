import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/elevator_models.dart';
import '../../../data/models/location_models.dart';
import '../../providers/timer_provider.dart';
import '../../providers/location_provider.dart' hide AppLocation, AppLocationHistory;
import '../../providers/auth_provider.dart';

/// Timer screen for tracking unloading activities
class TimerScreen extends ConsumerStatefulWidget {
  final Elevator? selectedElevator;

  const TimerScreen({super.key, this.selectedElevator});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  final _notesController = TextEditingController();
  final _grainTypeController = TextEditingController();
  Timer? _displayTimer;

  @override
  void initState() {
    super.initState();
    
    // Start periodic UI updates
    _displayTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {}); // Trigger UI update for timer display
      },
    );
  }

  @override
  void dispose() {
    _displayTimer?.cancel();
    _notesController.dispose();
    _grainTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTimer = ref.watch(activeTimerProvider);
    final completedTimers = ref.watch(completedTimersProvider);
    final timerState = ref.watch(timerNotifierProvider);
    final currentLocation = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        actions: [
          if (activeTimer != null)
            IconButton(
              onPressed: _showTimerHistoryDialog,
              icon: const Icon(Icons.history),
              tooltip: 'View timer history',
            ),
        ],
      ),
      body: activeTimer != null
          ? _buildActiveTimerView(activeTimer)
          : _buildTimerSetupView(timerState, currentLocation),
    );
  }

  Widget _buildActiveTimerView(TimerSession activeTimer) {
    final elapsedTime = activeTimer.activeDuration;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimerDisplay(elapsedTime),
          const SizedBox(height: 24),
          _buildTimerInfoCard(activeTimer),
          const SizedBox(height: 16),
          _buildTimerControls(activeTimer),
          const SizedBox(height: 16),
          _buildEventLog(activeTimer),
        ],
      ),
    );
  }

  Widget _buildTimerDisplay(Duration elapsedTime) {
    final hours = elapsedTime.inHours;
    final minutes = elapsedTime.inMinutes % 60;
    final seconds = elapsedTime.inSeconds % 60;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Text(
              'Active Timer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeUnit(hours.toString().padLeft(2, '0'), 'Hours'),
                const SizedBox(width: 8),
                const Text(':', style: TextStyle(fontSize: 48)),
                const SizedBox(width: 8),
                _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'Minutes'),
                const SizedBox(width: 8),
                const Text(':', style: TextStyle(fontSize: 48)),
                const SizedBox(width: 8),
                _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'Seconds'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerInfoCard(TimerSession timer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timer Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Elevator', timer.elevatorName),
            const SizedBox(height: 8),
            _buildInfoRow('Started', timer.startTime.toString().split(' ')[1].split('.')[0]),
            const SizedBox(height: 8),
            if (timer.grainType != null)
              _buildInfoRow('Grain Type', timer.grainType!),
            const SizedBox(height: 8),
            _buildInfoRow('Location', '${timer.location.latitude.toStringAsFixed(4)}, ${timer.location.longitude.toStringAsFixed(4)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerControls(TimerSession timer) {
    final isPaused = timer.status == TimerStatus.paused;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: isPaused
                        ? () => ref.read(timerNotifierProvider.notifier).resumeTimer()
                        : () => ref.read(timerNotifierProvider.notifier).pauseTimer(),
                    child: Text(isPaused ? 'Resume' : 'Pause'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: _showStopTimerDialog,
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    child: const Text('Stop'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _showAddEventDialog,
                child: const Text('Add Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventLog(TimerSession timer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Log',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (timer.events.isEmpty)
              Text(
                'No events recorded',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            else
              Column(
                children: timer.events.map((event) {
                  return _buildEventItem(event);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(TimerEvent event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${event.typeDisplay} • ${event.formattedTime}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSetupView(TimerState timerState, AppLocation? currentLocation) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.timer,
                    size: 64,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start Timer',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your unloading time at grain elevators',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (widget.selectedElevator != null) ...[
            _buildSelectedElevatorCard(widget.selectedElevator!),
            const SizedBox(height: 16),
          ],
          _buildStartTimerForm(currentLocation),
          const SizedBox(height: 24),
          if (timerState.completedSessions.isNotEmpty) ...[
            Text(
              'Recent Sessions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...timerState.completedSessions.take(3).map((session) {
              return _buildCompletedTimerCard(session);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedElevatorCard(Elevator elevator) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Elevator',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              elevator.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              elevator.company,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartTimerForm(AppLocation? currentLocation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timer Setup',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (currentLocation == null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_off,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Current location required to start timer',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () async {
                  await ref.read(locationTrackerProvider.notifier).getCurrentLocation();
                },
                child: const Text('Get Current Location'),
              ),
            ] else ...[
              TextFormField(
                controller: _grainTypeController,
                decoration: const InputDecoration(
                  labelText: 'Grain Type (Optional)',
                  hintText: 'e.g., Wheat, Canola',
                  prefixIcon: Icon(Icons.agriculture),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Any additional notes about this session',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _startTimer,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Timer'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedTimerCard(TimerSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            Icons.timer,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(session.elevatorName),
        subtitle: Text(session.formattedDuration),
        trailing: Text(
          session.startTime.toString().split(' ')[0],
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  void _startTimer() {
    final elevator = widget.selectedElevator;
    if (elevator == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an elevator first'),
        ),
      );
      return;
    }

    final currentLocation = ref.read(currentLocationProvider);
    if (currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current location is required'),
        ),
      );
      return;
    }

    ref.read(timerNotifierProvider.notifier).startTimer(
      elevatorId: elevator.id,
      elevatorName: elevator.name,
      location: currentLocation,
      grainType: _grainTypeController.text.trim().isEmpty
          ? null
          : _grainTypeController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
  }

  void _showStopTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Timer'),
        content: const Text('Are you sure you want to stop the current timer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(timerNotifierProvider.notifier).stopTimer();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Stop Timer'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Timer Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Event Description',
                hintText: 'Describe what happened',
                border: OutlineInputBorder(),
              ),
              controller: _notesController,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TimerEventType>(
              decoration: const InputDecoration(
                labelText: 'Event Type',
                border: OutlineInputBorder(),
              ),
              items: TimerEventType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getEventTypeDisplayName(type)),
                );
              }).toList(),
              onChanged: (value) {
                // Handle event type selection
              },
            ),
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
              // Add the event
            },
            child: const Text('Add Event'),
          ),
        ],
      ),
    );
  }

  String _getEventTypeDisplayName(TimerEventType type) {
    switch (type) {
      case TimerEventType.start:
        return 'Start';
      case TimerEventType.arrive:
        return 'Arrive';
      case TimerEventType.queue:
        return 'Queue';
      case TimerEventType.unload:
        return 'Unload';
      case TimerEventType.complete:
        return 'Complete';
      case TimerEventType.pause:
        return 'Pause';
      case TimerEventType.resume:
        return 'Resume';
      case TimerEventType.custom:
        return 'Custom';
    }
  }

  void _showTimerHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Timer History'),
        content: const Text('Timer history view coming soon'),
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
