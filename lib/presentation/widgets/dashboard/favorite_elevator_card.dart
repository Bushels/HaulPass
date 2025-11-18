import 'package:flutter/material.dart';
import '../../../data/models/elevator_insights.dart';

/// Hero card showing favorite elevator with live wait time and insights
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
    // Determine colors based on status/wait time
    // Green (<20min), Amber (20-40min), Red (>40min)
    final waitMinutes = insights.currentWaitMinutes;
    Color primaryColor;
    Color secondaryColor;
    Color shadowColor;
    String statusText;
    IconData statusIcon;

    if (waitMinutes < 20) {
      primaryColor = const Color(0xFF10B981); // Green
      secondaryColor = const Color(0xFF059669);
      shadowColor = const Color(0xFF10B981);
      statusText = 'Good time to haul';
      statusIcon = Icons.check_circle_outline;
    } else if (waitMinutes < 40) {
      primaryColor = const Color(0xFFF59E0B); // Amber
      secondaryColor = const Color(0xFFD97706);
      shadowColor = const Color(0xFFF59E0B);
      statusText = 'Moderate wait';
      statusIcon = Icons.warning_amber_rounded;
    } else {
      primaryColor = const Color(0xFFEF4444); // Red
      secondaryColor = const Color(0xFFDC2626);
      shadowColor = const Color(0xFFEF4444);
      statusText = 'Long wait expected';
      statusIcon = Icons.error_outline;
    }

    return Hero(
      tag: 'favorite-elevator-${insights.elevatorId}',
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.4),
                blurRadius: 25,
                offset: const Offset(0, 12),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: onTap,
              child: Stack(
                children: [
                  // Decorative background elements
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'YOUR ELEVATOR',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    insights.elevatorName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Wait Time Display
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              insights.waitTimeDisplay,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                height: 1,
                                letterSpacing: -2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black12,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'wait time',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Status Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                statusText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        // Queue Info
                        Row(
                          children: [
                            _buildInfoChip(
                              Icons.local_shipping_outlined,
                              '${insights.currentLineup} trucks in line',
                            ),
                            const SizedBox(width: 12),
                            _buildInfoChip(
                              Icons.update,
                              'Updated 2m ago',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.9),
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
