import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import '../home/enhanced_home_screen.dart';
import '../elevator/elevator_screen.dart';
import '../timer/timer_screen.dart';
import '../profile/profile_screen.dart';

/// Main navigation screen with bottom navigation bar
class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    EnhancedHomeScreen(),
    ElevatorScreen(),
    TimerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
              showBadge: false, // TODO: Show when active haul is running
              badgeContent: const Text(
                '!',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              badgeStyle: badges.BadgeStyle(
                badgeColor: theme.colorScheme.error,
              ),
              child: const Icon(Icons.timer_outlined),
            ),
            selectedIcon: Icon(
              Icons.timer,
              color: theme.colorScheme.primary,
            ),
            label: 'Haul Timer',
            tooltip: 'Haul Timer - Track your current haul',
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
