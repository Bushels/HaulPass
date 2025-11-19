import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/dashboard_providers.dart';
import '../../widgets/dashboard/favorite_elevator_card.dart';
import '../../widgets/dashboard/haul_performance_card.dart';
import '../../widgets/dashboard/recent_activity_card.dart';

/// Smart Dashboard - Facelift Version
/// Matches the "Slate & Amber" aesthetic of the HaulPass Landing Page
class SmartDashboardScreen extends ConsumerStatefulWidget {
  const SmartDashboardScreen({super.key});

  @override
  ConsumerState<SmartDashboardScreen> createState() =>
      _SmartDashboardScreenState();
}

class _SmartDashboardScreenState extends ConsumerState<SmartDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch live elevator insights
    final favoriteElevatorId = ref.watch(favoriteElevatorIdProvider);
    final elevatorInsightsAsync =
        ref.watch(liveElevatorInsightsProvider(favoriteElevatorId));
    final userStats = ref.watch(userStatisticsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(liveElevatorInsightsProvider);
            ref.invalidate(userStatisticsProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // 1. Favorite Elevator Card with null handling
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: elevatorInsightsAsync.when(
                          data: (insights) => FavoriteElevatorCard(
                            insights: insights,
                            onTap: () =>
                                context.push('/elevators/${insights.elevatorId}'),
                          ),
                          loading: () => _buildLoadingCard(),
                          error: (e, s) => _buildErrorCard(e),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Metrics Grid with real userStats data
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricTile(
                                  "Total Hauls",
                                  "${userStats.totalHauls}",
                                  userStats.totalWeightDisplay,
                                  AppColors.green600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildMetricTile(
                                  "Avg Moisture",
                                  "${userStats.averageMoisture.toStringAsFixed(1)}%",
                                  "Wait: ${userStats.avgWaitDisplay}",
                                  AppColors.slate500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Haul Performance (with hardcoded data for now)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const HaulPerformanceCard(
                        averageLoadTime: Duration(minutes: 23),
                        weightDifference: 150.0,
                        averageMoisture: 14.2,
                        averageDockage: 1.8,
                        binMoisture: 13.8,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Recent Activity
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: RecentActivityCard(
                        onViewAll: () => context.push('/history'),
                      ),
                    ),
                    const SizedBox(height: 100), // Space for bottom nav
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleStartLoad,
        backgroundColor: AppColors.amber600,
        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
        label: const Text(
          'Start Load',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMetricTile(
      String label, String value, String subtext, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtext,
              style: TextStyle(
                  fontSize: 12, color: subTextColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: AppColors.slate200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.amber600),
      ),
    );
  }

  Widget _buildErrorCard(Object error) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.red500, width: 2),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.red500),
          const SizedBox(height: 16),
          const Text(
            'Failed to Load Elevator',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(liveElevatorInsightsProvider),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Retry', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.amber600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.slate900,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HaulPass',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            color: AppColors.slate900,
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.agriculture,
                  size: 150,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.push('/notifications'),
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.amber600,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(width: 4, height: 4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _handleStartLoad() {
    context.push('/haul/start');
  }
}
