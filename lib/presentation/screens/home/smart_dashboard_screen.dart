import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/elevator_insights.dart';
import '../../../data/models/truck_models.dart';
import '../../../core/services/queue_alert_manager.dart';
import '../../providers/dashboard_providers.dart';
import '../../widgets/dashboard/favorite_elevator_card.dart';
import '../../widgets/dashboard/haul_performance_card.dart';
import '../../widgets/dashboard/analytics_summary_card.dart';
import '../../widgets/dashboard/quick_stats_card.dart';
import '../../widgets/dashboard/recent_activity_card.dart';

/// Smart Dashboard - Primary screen optimized for farmers
/// Shows favorite elevator insights, truck metrics, and quick actions
class SmartDashboardScreen extends ConsumerStatefulWidget {
  const SmartDashboardScreen({super.key});

  @override
  ConsumerState<SmartDashboardScreen> createState() => _SmartDashboardScreenState();
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
    final elevatorInsightsAsync = ref.watch(
      liveElevatorInsightsProvider(ref.watch(favoriteElevatorIdProvider)),
    );
    final userStats = ref.watch(userStatisticsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Invalidate providers to trigger refresh
            ref.invalidate(liveElevatorInsightsProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: elevatorInsightsAsync.when(
            data: (insights) => CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(context),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Favorite Elevator Card - Primary Focus
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FavoriteElevatorCard(
                            insights: insights,
                            onTap: () => context.push('/elevators'),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Haul Performance - New Metrics
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
                    const SizedBox(height: 20),

                    // Analytics Summary - Graphs
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const AnalyticsSummaryCard(),
                    ),
                    const SizedBox(height: 20),

                    // Quick Stats Row
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        children: [
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Total Hauls',
                              value: userStats.totalHauls.toString(),
                              subtitle: 'Last 24h: ${userStats.last24HoursHauls}',
                              icon: Icons.local_shipping,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Avg Wait',
                              value: userStats.avgWaitDisplay,
                              subtitle: insights.waitTimeDisplay,
                              icon: Icons.timer,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        children: [
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Hauls/Day',
                              value: '4.2',
                              subtitle: 'This week avg',
                              icon: Icons.analytics,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Avg Price',
                              value: '\$6.48',
                              subtitle: 'per bushel',
                              icon: Icons.attach_money,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        children: [
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Total Weight',
                              value: userStats.totalWeightLbsDisplay,
                              subtitle: userStats.totalWeightDisplay,
                              icon: Icons.scale,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Top Grain',
                              value: userStats.topGrainType,
                              subtitle: '${userStats.grainTypeBreakdown[userStats.topGrainType] ?? 0} hauls',
                              icon: Icons.agriculture,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recent Activity
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: RecentActivityCard(
                        onViewAll: () => context.push('/history'),
                      ),
                    ),
                    const SizedBox(height: 100), // Space for bottom navigation
                  ]),
                ),
              ),
            ],
          ),
            loading: _buildLoadingState,
            error: (error, stack) => _buildErrorState(error),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleStartLoad,
        backgroundColor: const Color(0xFF667EEA),
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text(
          'Start Load',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140, // Increased height to fix overflow
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)], // Soft glow gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative glow
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 50,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.dashboard_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _handleStartLoad() {
    context.push('/haul/start');
  }

  IconData _getAlertIcon(QueueAlertType type) {
    switch (type) {
      case QueueAlertType.queueGrowing:
        return Icons.trending_up;
      case QueueAlertType.queueShrinking:
        return Icons.trending_down;
      case QueueAlertType.waitTimeIncreased:
        return Icons.schedule;
      case QueueAlertType.waitTimeDecreased:
        return Icons.speed;
      case QueueAlertType.elevatorStatusChanged:
        return Icons.info_outline;
    }
  }

  Color _getAlertColor(QueueAlertType type) {
    switch (type) {
      case QueueAlertType.queueGrowing:
      case QueueAlertType.waitTimeIncreased:
        return const Color(0xFFF59E0B); // Amber - warning
      case QueueAlertType.queueShrinking:
      case QueueAlertType.waitTimeDecreased:
        return const Color(0xFF10B981); // Green - good news
      case QueueAlertType.elevatorStatusChanged:
        return const Color(0xFF667EEA); // Purple - info
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading elevator data...',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load elevator data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(liveElevatorInsightsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
