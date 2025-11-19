import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import '../home/smart_dashboard_screen.dart';
import '../elevator/elevator_screen.dart';
import '../timer/timer_screen.dart';
import '../profile/profile_screen.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/timer_provider.dart';

/// Main navigation screen with bottom navigation bar
class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SmartDashboardScreen(),
    ElevatorScreen(),
    TimerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      body: Column(
        children: [
          // Offline banner
          if (!isOnline)
            _buildOfflineBanner(context),
          // Main content
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildOfflineBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              Icons.cloud_off,
              color: Theme.of(context).colorScheme.onErrorContainer,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'You\'re offline. Using cached data.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(connectivityNotifierProvider.notifier).checkConnectivity();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeTimer = ref.watch(activeTimerProvider);
    final hasActiveTimer = activeTimer != null;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 0,
        backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
        indicatorColor: theme.colorScheme.primaryContainer,
        animationDuration: const Duration(milliseconds: 300),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: theme.colorScheme.primary,
            ),
            label: 'Home',
            tooltip: 'Home - Dashboard and quick actions',
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_city_outlined),
            selectedIcon: Icon(
              Icons.location_city,
              color: theme.colorScheme.primary,
            ),
            label: 'Elevators',
            tooltip: 'Grain Elevators - Find and track queues',
          ),
          NavigationDestination(
            icon: badges.Badge(
              showBadge: hasActiveTimer,
              badgeContent: const Text(
                '●',
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
              badgeStyle: badges.BadgeStyle(
                badgeColor: theme.colorScheme.error,
                padding: const EdgeInsets.all(4),
              ),
              child: const Icon(Icons.timer_outlined),
            ),
            selectedIcon: Icon(
              Icons.timer,
              color: theme.colorScheme.primary,
            ),
            label: 'Haul Timer',
            tooltip: hasActiveTimer
                ? 'Haul Timer - Active timer running'
                : 'Haul Timer - Track your current haul',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person,
              color: theme.colorScheme.primary,
            ),
            label: 'Profile',
            tooltip: 'Profile - Settings and stats',
          ),
        ],
      ),
    );
  }
}
