import 'package:flutter/material.dart';

/// Visual status bar showing queue busyness relative to normal
///
/// Displays a gradient bar with a marker showing how busy the elevator is
/// compared to typical times. -100% (slower) to +100% (busier).
class BusynessBar extends StatelessWidget {
  final int busynessPercent;
  final int typicalWaitMinutes;
  final double height;
  final bool showLabels;

  const BusynessBar({
    super.key,
    required this.busynessPercent,
    required this.typicalWaitMinutes,
    this.height = 12,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    // Normalize -100 to +100 → 0 to 1 for positioning
    final normalized = (busynessPercent + 100) / 200;
    final clampedNormalized = normalized.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // The gradient bar
        Stack(
          children: [
            // Background container with gradient
            Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade600,    // -100% (much slower)
                    Colors.green.shade400,    // -50%
                    Colors.grey.shade400,     // 0% (normal)
                    Colors.orange.shade400,   // +50%
                    Colors.red.shade600,      // +100% (much busier)
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),

            // Baseline marker (normal - 50% position)
            Positioned(
              left: MediaQuery.of(context).size.width * 0.4 - 2,
              child: Container(
                width: 3,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ),

            // Current position indicator
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: (MediaQuery.of(context).size.width * 0.8 * clampedNormalized) - 8,
              top: -4,
              child: Container(
                width: 16,
                height: height + 8,
                decoration: BoxDecoration(
                  color: _getIndicatorColor(),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        if (showLabels) ...[
          const SizedBox(height: 6),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Slower',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Normal',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Busier',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Color _getIndicatorColor() {
    if (busynessPercent < -25) return Colors.green.shade700;
    if (busynessPercent < 0) return Colors.green.shade500;
    if (busynessPercent == 0) return Colors.grey.shade600;
    if (busynessPercent < 25) return Colors.orange.shade500;
    if (busynessPercent < 50) return Colors.orange.shade700;
    return Colors.red.shade700;
  }
}

/// Compact version of the busyness bar (no labels)
class CompactBusynessBar extends StatelessWidget {
  final int busynessPercent;

  const CompactBusynessBar({
    super.key,
    required this.busynessPercent,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = (busynessPercent + 100) / 200;
    final clampedNormalized = normalized.clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade500,
                  Colors.grey.shade400,
                  Colors.orange.shade500,
                  Colors.red.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: clampedNormalized,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _getText(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: _getColor(),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColor() {
    if (busynessPercent < 0) return Colors.green;
    if (busynessPercent < 25) return Colors.orange;
    return Colors.red;
  }

  String _getText() {
    if (busynessPercent == 0) return 'Normal';
    if (busynessPercent > 0) return '+${busynessPercent}%';
    return '${busynessPercent}%';
  }
}
