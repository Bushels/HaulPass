import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../../../core/theme/app_colors.dart';
import '../../../data/models/elevator_models.dart';
import '../../../data/services/mock_data_service.dart';

/// Stunning elevator card with live status and queue info
class ElevatorCard extends StatelessWidget {
  final Elevator elevator;
  final QueueData? queueData;
  final double? distance;
  final VoidCallback? onTap;

  const ElevatorCard({
    super.key,
    required this.elevator,
    this.queueData,
    this.distance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Status indicator
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor().withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Elevator name
                    Expanded(
                      child: Text(
                        elevator.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray900,
                        ),
                      ),
                    ),
                    // Queue count badge (priority) or distance badge
                    if (queueData != null)
                      badges.Badge(
                        badgeContent: Text(
                          '${queueData!.currentQueueLength}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: _getQueueColor(),
                          padding: const EdgeInsets.all(8),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getQueueColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.groups,
                                size: 14,
                                color: _getQueueColor(),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Queue',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getQueueColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (distance != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${distance!.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Company and type
                Row(
                  children: [
                    Icon(
                      Icons.business,
                      size: 16,
                      color: AppColors.gray600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        elevator.company,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.factory,
                      size: 16,
                      color: AppColors.gray600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${elevator.elevatorType ?? "Elevator"} • ${_formatCapacity(elevator.capacity ?? 0)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray700,
                      ),
                    ),
                  ],
                ),
                if (queueData != null) ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  // Queue info
                  Row(
                    children: [
                      Expanded(
                        child: _buildQueueStat(
                          icon: Icons.groups,
                          label: 'In Queue',
                          value: '${queueData!.currentQueueLength}',
                          color: _getQueueColor(),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.gray200,
                      ),
                      Expanded(
                        child: _buildQueueStat(
                          icon: Icons.schedule,
                          label: 'Est. Wait',
                          value: '${queueData!.estimatedWaitMinutes} min',
                          color: _getWaitColor(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQueueStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    if (queueData == null) return AppColors.gray400;

    if (queueData!.currentQueueLength == 0) {
      return AppColors.success;
    } else if (queueData!.currentQueueLength <= 3) {
      return AppColors.info;
    } else if (queueData!.currentQueueLength <= 6) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  Color _getQueueColor() {
    if (queueData == null) return AppColors.gray600;

    if (queueData!.currentQueueLength == 0) {
      return AppColors.success;
    } else if (queueData!.currentQueueLength <= 3) {
      return AppColors.info;
    } else if (queueData!.currentQueueLength <= 6) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  Color _getWaitColor() {
    if (queueData == null) return AppColors.gray600;

    if (queueData!.estimatedWaitMinutes == 0) {
      return AppColors.success;
    } else if (queueData!.estimatedWaitMinutes <= 20) {
      return AppColors.info;
    } else if (queueData!.estimatedWaitMinutes <= 40) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  String _formatCapacity(double tonnes) {
    if (tonnes >= 1000) {
      return '${(tonnes / 1000).toStringAsFixed(1)}k T';
    }
    return '${tonnes.toInt()} T';
  }
}
