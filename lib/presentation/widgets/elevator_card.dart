import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/queue_models.dart';
import 'busyness_bar.dart';

/// Enhanced elevator card showing real-time queue predictions
///
/// This is the main UI component displaying:
/// - Elevator name and company
/// - Current truck count
/// - Estimated wait time (LARGE and visible)
/// - Busyness comparison to normal times
/// - Distance and ETA
class ElevatorCard extends StatelessWidget {
  final ElevatorWithQueue data;
  final VoidCallback? onTap;

  const ElevatorCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final queue = data.queueState;
    final elevator = data.elevator;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and status badge
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          elevator.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          elevator.company,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(status: queue.status),
                ],
              ),

              const SizedBox(height: 16),

              // MAIN PREDICTION SECTION - The key feature!
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getStatusColor(queue.queueColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(queue.queueColor).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    // Truck count
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${queue.currentTrucksInLine} trucks waiting',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (queue.appUsersEnRoute > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+${queue.appUsersEnRoute} en route',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    // LARGE WAIT TIME - Most important info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 32,
                          color: _getStatusColor(queue.queueColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Est wait time',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatWaitTime(queue.estimatedWaitMinutes),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(queue.queueColor),
                                  height: 1.1,
                                ),
                              ).animate().fadeIn(duration: 300.ms).scale(
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1.0, 1.0),
                                duration: 300.ms,
                                curve: Curves.easeOut,
                              ),
                            ],
                          ),
                        ),
                        // Busyness indicator
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              queue.shortBusynessText,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _getBusynessColor(queue.busynessPercent),
                              ),
                            ),
                            Text(
                              queue.busynessPercent == 0 ? '' :
                              (queue.busynessPercent > 0 ? 'busier' : 'slower'),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Visual busyness bar
                    BusynessBar(
                      busynessPercent: queue.busynessPercent,
                      typicalWaitMinutes: queue.typicalWaitMinutes,
                      showLabels: true,
                    ),

                    const SizedBox(height: 12),

                    // Comparison text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Typical: ${_formatWaitTime(queue.typicalWaitMinutes)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          queue.confidenceText,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Distance and ETA
              Row(
                children: [
                  Icon(Icons.place, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    data.formattedDistance,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'ETA: ${data.formattedArrivalTime}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Grain types (if available)
              if (elevator.acceptedGrains.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: elevator.acceptedGrains.take(4).map((grain) {
                    return Chip(
                      label: Text(
                        grain,
                        style: const TextStyle(fontSize: 11),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      side: BorderSide(color: Colors.grey.shade300),
                      backgroundColor: Colors.grey.shade50,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(QueueColor color) {
    switch (color) {
      case QueueColor.fast:
        return Colors.green;
      case QueueColor.medium:
        return Colors.orange;
      case QueueColor.slow:
        return Colors.red;
    }
  }

  Color _getBusynessColor(int percent) {
    if (percent < 0) return Colors.green.shade700;
    if (percent == 0) return Colors.grey.shade700;
    if (percent < 25) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  String _formatWaitTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '${hours}h';
    }
    return '${hours}h ${mins}m';
  }
}

/// Status badge showing elevator operational status
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String text;

    switch (status.toLowerCase()) {
      case 'open':
        color = Colors.green;
        text = 'Open';
        break;
      case 'busy':
        color = Colors.orange;
        text = 'Busy';
        break;
      case 'closed':
        color = Colors.red;
        text = 'Closed';
        break;
      case 'maintenance':
        color = Colors.grey;
        text = 'Maintenance';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color.shade700,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact version of elevator card for list views
class CompactElevatorCard extends StatelessWidget {
  final ElevatorWithQueue data;
  final VoidCallback? onTap;

  const CompactElevatorCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final queue = data.queueState;
    final elevator = data.elevator;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          elevator.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${queue.currentTrucksInLine} trucks • ${queue.formattedWaitTime}'),
            const SizedBox(height: 6),
            CompactBusynessBar(busynessPercent: queue.busynessPercent),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              data.formattedDistance,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              data.formattedArrivalTime,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
