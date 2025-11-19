import 'package:flutter/material.dart';
import '../../../data/models/elevator_insights.dart';
import '../../../core/theme/app_colors.dart';

/// Hero card showing favorite elevator with live wait time and insights
/// Redesigned to match the "South Terminal" industrial aesthetic
class FavoriteElevatorCard extends StatelessWidget {
  final ElevatorInsights insights;
  final VoidCallback onTap;

  const FavoriteElevatorCard({
    super.key,
    required this.insights,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status colors and text based on wait time
    final int waitMinutes = insights.currentWaitMinutes;

    Color statusColor;
    String trendText;
    IconData trendIcon;

    if (waitMinutes < 20) {
      statusColor = AppColors.green600;
      trendText = 'Fast';
      trendIcon = Icons.trending_down;
    } else if (waitMinutes < 45) {
      statusColor = AppColors.amber500;
      trendText = 'Moderate';
      trendIcon = Icons.remove; // Flat trend
    } else {
      statusColor = AppColors.red500;
      trendText = 'Heavy';
      trendIcon = Icons.trending_up;
    }

    return Hero(
      tag: 'favorite-elevator-${insights.elevatorId}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              // Industrial Slate Border
              border: Border.all(color: AppColors.slate800, width: 3),
              boxShadow: AppColors.elevatedShadow,
            ),
            child: Column(
              children: [
                // --- Header ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.slate800,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title Area
                      Row(
                        children: [
                          const Icon(Icons.grain, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            insights.elevatorName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      // Status Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              waitMinutes > 60 ? 'Busy' : 'Open Now',
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Body ---
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "CURRENT QUEUE ESTIMATE",
                        style: TextStyle(
                          color: AppColors.slate500,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Big Metrics Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Time Display
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                "$waitMinutes",
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.slate900,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "mins",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.slate500,
                                ),
                              ),
                            ],
                          ),

                          // Trend Indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(trendIcon, color: statusColor, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  trendText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // --- Visualization Bars (Simulated Graph) ---
                      // Uses the actual wait time to determine the height of the "Current" bar
                      SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBar(0.4, false), // Past
                            const SizedBox(width: 4),
                            _buildBar(0.6, false), // Past
                            const SizedBox(width: 4),
                            _buildBar(0.3, false), // Past
                            const SizedBox(width: 4),
                            // Current Bar (Dynamic Height based on wait time cap of 60m)
                            _buildBar((waitMinutes / 60).clamp(0.2, 1.0), true, color: statusColor),
                            const SizedBox(width: 4),
                            _buildBar(0.3, false, isFuture: true),
                            const SizedBox(width: 4),
                            _buildBar(0.2, false, isFuture: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // X-Axis Labels
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("-2h", style: TextStyle(fontSize: 10, color: AppColors.slate400)),
                          Text("Now", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.slate500)),
                          Text("+2h", style: TextStyle(fontSize: 10, color: AppColors.slate400)),
                        ],
                      ),

                      // Info Footer
                      const SizedBox(height: 12),
                      Divider(height: 1, color: AppColors.slate200),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.local_shipping_outlined, size: 12, color: AppColors.slate500),
                          const SizedBox(width: 4),
                          Text(
                            '${insights.currentLineup} trucks in line',
                            style: const TextStyle(fontSize: 11, color: AppColors.slate500),
                          ),
                          const SizedBox(width: 8),
                          const Text("•", style: TextStyle(fontSize: 11, color: AppColors.slate400)),
                          const SizedBox(width: 8),
                          const Icon(Icons.update, size: 12, color: AppColors.slate500),
                          const SizedBox(width: 4),
                          Text(
                            _getUpdateTimeText(insights.lastUpdated),
                            style: const TextStyle(fontSize: 11, color: AppColors.slate500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBar(double heightFactor, bool isActive, {bool isFuture = false, Color? color}) {
    Color barColor = AppColors.slate200; // Slate 200 default

    if (isActive) {
      barColor = color ?? AppColors.amber500;
    }

    return Expanded(
      child: Container(
        height: 40 * heightFactor,
        decoration: BoxDecoration(
          color: isFuture ? Colors.transparent : barColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          border: isFuture
            ? Border.all(color: AppColors.slate300, style: BorderStyle.solid, width: 1.5)
            : null,
        ),
      ),
    );
  }

  /// Get human-readable update time
  static String _getUpdateTimeText(DateTime lastUpdated) {
    final diff = DateTime.now().difference(lastUpdated);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
