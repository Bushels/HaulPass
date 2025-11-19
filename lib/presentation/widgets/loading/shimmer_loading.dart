import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Base shimmer widget for creating loading skeletons
class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// Shimmer loading for elevator cards
class ElevatorCardShimmer extends StatelessWidget {
  const ElevatorCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                      _ShimmerBox(
                        width: 200,
                        height: 24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      _ShimmerBox(
                        width: 150,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                _ShimmerBox(
                  width: 60,
                  height: 24,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ShimmerBox(
              width: double.infinity,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ShimmerBox(
                  width: 60,
                  height: 28,
                  borderRadius: BorderRadius.circular(14),
                ),
                const SizedBox(width: 4),
                _ShimmerBox(
                  width: 60,
                  height: 28,
                  borderRadius: BorderRadius.circular(14),
                ),
                const SizedBox(width: 4),
                _ShimmerBox(
                  width: 60,
                  height: 28,
                  borderRadius: BorderRadius.circular(14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ShimmerBox(
                  width: 80,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(width: 16),
                _ShimmerBox(
                  width: 80,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const Spacer(),
                _ShimmerBox(
                  width: 80,
                  height: 36,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading for stat cards on home screen
class StatCardShimmer extends StatelessWidget {
  const StatCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(12),
                ),
                _ShimmerBox(
                  width: 20,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            const Spacer(),
            _ShimmerBox(
              width: 80,
              height: 32,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            _ShimmerBox(
              width: 60,
              height: 13,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 2),
            _ShimmerBox(
              width: 50,
              height: 11,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading for active haul card
class ActiveHaulCardShimmer extends StatelessWidget {
  const ActiveHaulCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBox(
                width: 100,
                height: 20,
                borderRadius: BorderRadius.circular(4),
              ),
              _ShimmerBox(
                width: 60,
                height: 28,
                borderRadius: BorderRadius.circular(14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ShimmerBox(
            width: double.infinity,
            height: 24,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          _ShimmerBox(
            width: 150,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ShimmerBox(
                  height: 48,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShimmerBox(
                  height: 48,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Basic shimmer box component
class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  const _ShimmerBox({
    this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Shimmer loading list for elevators
class ElevatorListShimmer extends StatelessWidget {
  final int itemCount;

  const ElevatorListShimmer({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ElevatorCardShimmer(),
    );
  }
}

/// Shimmer loading grid for stats
class StatsGridShimmer extends StatelessWidget {
  const StatsGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.15,
      children: const [
        StatCardShimmer(),
        StatCardShimmer(),
        StatCardShimmer(),
        StatCardShimmer(),
      ],
    );
  }
}
